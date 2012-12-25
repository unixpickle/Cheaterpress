//
//  ANEditorViewController.m
//  Cheaterpress
//
//  Created by Alex Nichol on 12/24/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANEditorViewController.h"

@interface ANEditorViewController ()

- (CGRect)keyboardNotificationFrame:(NSNotification *)notification;

@end

@implementation ANEditorViewController

- (id)initWithGame:(Game *)aGame {
    if ((self = [super init])) {
        self.view.backgroundColor = [UIColor colorWithWhite:240.0/255.0 alpha:1];
        game = aGame;
        context = game.managedObjectContext;
        boardView = [[ANGameBoardView alloc] initWithGame:aGame];
        boardView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
        boardView.delegate = self;
        [self.view addSubview:boardView];
        
        textField = [[UITextField alloc] initWithFrame:CGRectMake(0, -100, 10, 24)];
        textField.delegate = self;
        [self.view addSubview:textField];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Keyboard -

- (void)beginKeyboardInput {
    [textField becomeFirstResponder];
}

- (void)endKeyboardInput {
    [textField resignFirstResponder];
    [boardView selectBox:nil];
    [context save:nil];
}

- (void)handleCharacterTyped:(NSString *)character {
    char c = (char)[[character lowercaseString] characterAtIndex:0];
    if (isalnum(c)) {
        Box * sel = [boardView selectedBox];
        sel.letter = [character uppercaseString];
        int nextColumn = sel.column + 1;
        int nextRow = sel.row;
        if (nextColumn == 5) {
            nextRow += 1;
            nextColumn = 0;
            if (nextRow == 5)
                nextRow = 0;
        }
        for (Box * b in game.boxes) {
            if (b.column == nextColumn && b.row == nextRow) {
                [boardView selectBox:b];
            }
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [self handleCharacterTyped:string];
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endKeyboardInput];
    return NO;
}

#pragma mark Notifications

- (void)keyboardWillShow:(NSNotification *)notification {
    isShowingKeyboard = YES;
    CGRect frame = [self keyboardNotificationFrame:notification];
    CGRect viewFrame = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat viewHeight = frame.origin.y - viewFrame.origin.y;
    CGRect boardRect;
    if (viewHeight < self.view.frame.size.width) {
        CGFloat boardSize = viewHeight - 20;
        while (((int)boardSize % 5) != 0) {
            boardSize -= 1;
        }
        boardRect = CGRectMake(round((self.view.frame.size.width - boardSize) / 2),
                               10, boardSize, boardSize);
    } else {
        CGFloat boardSize = self.view.frame.size.width - 20;
        boardRect = CGRectMake(10, round((viewHeight - boardSize) / 2),
                               boardSize, boardSize);
    }
    [UIView animateWithDuration:0.35 animations:^{
        boardView.frame = boardRect;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    isShowingKeyboard = NO;
    [UIView animateWithDuration:0.35 animations:^{
        boardView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
    }];
}

- (CGRect)keyboardNotificationFrame:(NSNotification *)notification {
    NSValue * value = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame;
    [value getValue:&frame];
    return frame;
}

#pragma mark - Game Board View -

- (void)gameBoardView:(ANGameBoardView *)view boxSelected:(Box *)aBox {
    if (aBox == view.selectedBox) {
        // increment the color
        if (aBox.owner == BoxOwnerTypeUnowned) {
            aBox.owner = BoxOwnerTypeFriendly;
        } else if (aBox.owner == BoxOwnerTypeFriendly) {
            aBox.owner = BoxOwnerTypeEnemy;
        } else {
            aBox.owner = BoxOwnerTypeUnowned;
        }
        [view setNeedsDisplay];
    } else {
        [view selectBox:aBox];
    }
    if (!isShowingKeyboard) [self beginKeyboardInput];
}

@end
