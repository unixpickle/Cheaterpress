//
//  ANViewController.m
//  Cheaterpress
//
//  Created by Alex Nichol on 12/23/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANViewController.h"

@interface ANViewController ()

@end

@implementation ANViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Home";
    
    addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                              target:self
                                                              action:@selector(addButtonPressed:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.rowHeight = kANGameCellViewHeight + 1;
}

- (void)loadGamesListWithContext:(NSManagedObjectContext *)aContext {
    context = aContext;
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Game"
                                               inManagedObjectContext:context];
    [fetchRequest setPredicate:[NSPredicate predicateWithValue:YES]];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"creation" ascending:YES]]];
    
    NSError * error = nil;
    games = [context executeFetchRequest:fetchRequest error:&error];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.tableView.indexPathForSelectedRow) {
        [self.tableView reloadRowsAtIndexPaths:@[self.tableView.indexPathForSelectedRow]
                              withRowAnimation:UITableViewRowAnimationNone];
    }
    [super viewWillAppear:animated];
}

#pragma mark - User Interaction -

- (void)addButtonPressed:(id)sender {
    ANAddViewController * addVC = [[ANAddViewController alloc] init];
    addVC.delegate = self;
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark - Adding -

- (void)addViewController:(ANAddViewController *)vc addedWithOpponent:(NSString *)opponent {
    [self.navigationController popViewControllerAnimated:YES];
    Game * g = [NSEntityDescription insertNewObjectForEntityForName:@"Game" inManagedObjectContext:context];
    // create the boxes
    g.creation = [NSDate date];
    g.opponent = opponent;
    for (int x = 0; x < 5; x++) {
        for (int y = 0; y < 5; y++) {
            Box * b = [NSEntityDescription insertNewObjectForEntityForName:@"Box" inManagedObjectContext:context];
            b.row = y;
            b.column = x;
            b.owner = BoxOwnerTypeUnowned;
            b.letter = @"A";
            [g addBoxesObject:b];
        }
    }
    [context save:nil];
    [self.tableView beginUpdates];
    games = [games arrayByAddingObject:g];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(games.count - 1) inSection:0]]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

#pragma mark - Table View -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return games.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ANGameCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GameCell"];
    if (!cell) {
        cell = [[ANGameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GameCell"];
    }
    
    cell.cellView.game = [games objectAtIndex:indexPath.row];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.tableView beginUpdates];
        Game * game = [games objectAtIndex:indexPath.row];
        for (Box * b in game.boxes) {
            [context deleteObject:b];
        }
        [context deleteObject:game];
        NSMutableArray * mGames = [games mutableCopy];
        [mGames removeObject:game];
        games = [mGames copy];
        [context save:nil];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Game * game = [games objectAtIndex:indexPath.row];
    ANEditorViewController * editor = [[ANEditorViewController alloc] initWithGame:game];
    [self.navigationController pushViewController:editor animated:YES];
}

@end
