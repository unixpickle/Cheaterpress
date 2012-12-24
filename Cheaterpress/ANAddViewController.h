//
//  ANAddViewController.h
//  Cheaterpress
//
//  Created by Alex Nichol on 12/23/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ANAddViewController;

@protocol ANAddViewControllerDelegate

- (void)addViewController:(ANAddViewController *)vc addedWithOpponent:(NSString *)opponent;

@end

@interface ANAddViewController : UIViewController {
    UITextField * opponentField;
    UIBarButtonItem * doneButton;
    __weak id<ANAddViewControllerDelegate> delegate;
}

@property (nonatomic, weak) id<ANAddViewControllerDelegate> delegate;

- (void)donePressed:(id)sender;

@end
