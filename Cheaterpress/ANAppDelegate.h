//
//  ANAppDelegate.h
//  Cheaterpress
//
//  Created by Alex Nichol on 12/23/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ANViewController.h"

@class ANViewController;

@interface ANAppDelegate : UIResponder <UIApplicationDelegate> {
    NSPersistentStoreCoordinator * coordinator;
    NSManagedObjectContext * context;
}

@property (strong, nonatomic) UIWindow * window;
@property (strong, nonatomic) ANViewController * viewController;
@property (strong, nonatomic) UINavigationController * navController;

@end
