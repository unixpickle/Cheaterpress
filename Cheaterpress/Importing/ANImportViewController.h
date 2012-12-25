//
//  ANImportViewController.h
//  Cheaterpress
//
//  Created by Alex Nichol on 12/25/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANSimplisticButton.h"
#import "ANBoardImport.h"

@class ANImportViewController;

@protocol ANImportViewControllerDelegate <NSObject>

@optional
- (void)importViewControllerDone:(ANImportViewController *)vc;

@end

@interface ANImportViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, ANBoardImportDelegate> {
    ANSimplisticButton * button;
    UIImagePickerController * imagePicker;
    ANBoardImport * import;
    Game * game;
    
    __weak id<ANImportViewControllerDelegate> delegate;
}

@property (nonatomic, weak) id<ANImportViewControllerDelegate> delegate;

- (id)initWithGame:(Game *)g;
- (void)pickButtonPressed:(id)sender;

@end
