//
//  ANEditorViewController.h
//  Cheaterpress
//
//  Created by Alex Nichol on 12/24/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANGameBoardView.h"

@interface ANEditorViewController : UIViewController <UITextFieldDelegate, ANGameBoardViewDelegate> {
    NSManagedObjectContext * context;
    Game * game;
    
    ANGameBoardView * boardView;
    
    UITextField * textField;
    BOOL isShowingKeyboard;
}

- (id)initWithGame:(Game *)aGame;

- (void)beginKeyboardInput;
- (void)endKeyboardInput;
- (void)handleCharacterTyped:(NSString *)character;

- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;

@end
