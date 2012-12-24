//
//  Game.h
//  Cheaterpress
//
//  Created by Alex Nichol on 12/23/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Box;

@interface Game : NSManagedObject

@property (nonatomic, retain) NSString * opponent;
@property (nonatomic, retain) NSDate * creation;
@property (nonatomic, retain) NSSet * boxes;
@end

@interface Game (CoreDataGeneratedAccessors)

- (void)addBoxesObject:(Box *)value;
- (void)removeBoxesObject:(Box *)value;
- (void)addBoxes:(NSSet *)values;
- (void)removeBoxes:(NSSet *)values;

@end
