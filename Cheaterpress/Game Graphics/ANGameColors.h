//
//  ANGameColors.h
//  Cheaterpress
//
//  Created by Alex Nichol on 12/24/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ANGamePieceColorFriendly = 2,
    ANGamePieceColorEnemy = 4,
    ANGamePieceColorUntaken = 8
} ANGamePieceColor;

typedef enum {
    ANGamePieceModifierLight = 0,
    ANGamePieceModifierDark = 1
} ANGamePieceModifier;

@interface ANGameColors : NSObject

+ (UIColor *)colorForNumber:(UInt32)color;

@end
