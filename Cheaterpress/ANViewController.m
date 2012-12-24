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
    addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                              target:self
                                                              action:@selector(addButtonPressed:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)loadGamesListWithContext:(NSManagedObjectContext *)aContext {
    context = aContext;
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Game"
                                               inManagedObjectContext:context];
    [fetchRequest setPredicate:[NSPredicate predicateWithValue:YES]];
    [fetchRequest setEntity:entity];
    
    NSError * error = nil;
    games = [context executeFetchRequest:fetchRequest error:&error];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            [g addBoxesObject:b];
        }
    }
    [context save:nil];
    [self.tableView beginUpdates];
    games = [games arrayByAddingObject:g];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathWithIndex:games.count - 1]]
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
    
}

@end
