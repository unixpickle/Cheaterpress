//
//  ANAppDelegate.m
//  Cheaterpress
//
//  Created by Alex Nichol on 12/23/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANAppDelegate.h"

#import "ANViewController.h"

@implementation ANAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSURL * modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    NSManagedObjectModel * model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    context = [[NSManagedObjectContext alloc] init];
    
    coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    [context setPersistentStoreCoordinator:coordinator];
    
    NSString * storeType = NSSQLiteStoreType;
    NSString * storeFile = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/save.dat"];
    
    NSError * error = nil;
    NSURL * url = [NSURL fileURLWithPath:storeFile];
    
    NSPersistentStore * newStore = [coordinator addPersistentStoreWithType:storeType
                                                             configuration:nil
                                                                       URL:url
                                                                   options:nil
                                                                     error:&error];
    
    if (newStore == nil) {
        NSLog(@"Store Configuration Failure: %@",
              ([error localizedDescription] != nil) ?
              [error localizedDescription] : @"Unknown Error");
    }

    self.navController = [[UINavigationController alloc] init];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ANViewController alloc] init];
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    
    [self.navController pushViewController:self.viewController animated:NO];
    
    [self.viewController loadGamesListWithContext:context];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
