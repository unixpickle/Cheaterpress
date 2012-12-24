//
//  ANViewController.h
//  Cheaterpress
//
//  Created by Alex Nichol on 12/23/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "ANAddViewController.h"
#import "ANGameCell.h"

#import "Game.h"
#import "Box.h"

@interface ANViewController : UITableViewController <ANAddViewControllerDelegate> {
    NSArray * games;
    NSManagedObjectContext * context;
    
    UIBarButtonItem * addButton;
}

- (void)loadGamesListWithContext:(NSManagedObjectContext *)context;

- (void)addButtonPressed:(id)sender;

@end
