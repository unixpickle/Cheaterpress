//
//  ANEditorViewController.h
//  Cheaterpress
//
//  Created by Alex Nichol on 12/24/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ANGameBoardView.h"
#import "ANWordSearcher.h"
#import "ANImportViewController.h"

@interface ANEditorViewController : UIViewController <UITextFieldDelegate, ANGameBoardViewDelegate, ANWordSearcherDelegate, UITableViewDataSource, UITableViewDelegate, ANImportViewControllerDelegate> {
    NSManagedObjectContext * context;
    Game * game;
    
    UIBarButtonItem * importButton;
    ANGameBoardView * boardView;
    UITableView * suggestionTableView;
    NSIndexPath * lastIndexPath;
    
    UITextField * textField;
    BOOL isShowingKeyboard;
    
    ANWordSearcher * searcher;
    ANWordlist * wordlist;
}

- (id)initWithGame:(Game *)aGame;

- (void)beginKeyboardInput;
- (void)endKeyboardInput;
- (void)handleCharacterTyped:(NSString *)character;

- (void)importButtonPressed:(id)sender;

- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;

@end
