//
//  ANGameColors.m
//  Cheaterpress
//
//  Created by Alex Nichol on 12/24/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANGameColors.h"

@implementation ANGameColors

+ (UIColor *)colorForNumber:(UInt32)color {
    BOOL isDark = NO;
    if ((color & ANGamePieceModifierDark) != 0) {
        isDark = YES;
        color ^= ANGamePieceModifierDark;
    }
    switch (color) {
        case ANGamePieceColorEnemy:
            if (isDark) {
                return [UIColor colorWithRed:0.98 green:0.16 blue:0.14 alpha:1];
            } else {
                return [UIColor colorWithRed:0.96 green:0.52 blue:0.49 alpha:1];
            }
            break;
        case ANGamePieceColorFriendly:
            if (isDark) {
                return [UIColor colorWithRed:0.07 green:0.56 blue:1 alpha:1];
            } else {
                return [UIColor colorWithRed:0.40 green:0.74 blue:0.95 alpha:1];
            }
            break;
        case ANGamePieceColorUntaken:
            if (isDark) {
                return [UIColor colorWithRed:0.885 green:0.885 blue:0.885 alpha:1];
            } else {
                return [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1];
            }
            break;
        default:
            break;
    }
    return nil;
}

+ (UIColor *)colorForBox:(Box *)box {
    UInt32 color = 0;
    if (box.owner == BoxOwnerTypeFriendly) {
        color = ANGamePieceColorFriendly;
    } else if (box.owner == BoxOwnerTypeEnemy) {
        color = ANGamePieceColorEnemy;
    } else {
        color = ANGamePieceColorUntaken;
    }
    if (box.owner == BoxOwnerTypeUnowned) {
        // figure out if it's checkered or not etc.
        int index = box.column + (box.row * 5);
        if (index % 2 == 0) {
            color |= ANGamePieceModifierDark;
        }
    } else {
        if ([box isBoxSurrounded]) {
            color |= ANGamePieceModifierDark;
        }
    }
    return [ANGameColors colorForNumber:color];
}

@end
