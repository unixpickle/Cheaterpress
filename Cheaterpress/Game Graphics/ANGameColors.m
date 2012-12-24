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
                return [UIColor colorWithRed:0.88 green:0.87 blue:0.86 alpha:1];
            } else {
                return [UIColor colorWithRed:0.89 green:0.89 blue:0.87 alpha:1];
            }
            break;
        default:
            break;
    }
    return nil;
}

@end
