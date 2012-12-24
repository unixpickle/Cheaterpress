//
//  Box.h
//  Cheaterpress
//
//  Created by Alex Nichol on 12/23/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Game;

typedef enum {
    BoxOwnerTypeUnowned = 0,
    BoxOwnerTypeEnemy = 1,
    BoxOwnerTypeFriendly = 2
} BoxOwnerType;

@interface Box : NSManagedObject

@property (nonatomic) int16_t column;
@property (nonatomic, retain) NSString * letter;
@property (nonatomic) int16_t row;
@property (nonatomic) int16_t owner;
@property (nonatomic, retain) Game * game;

@end
