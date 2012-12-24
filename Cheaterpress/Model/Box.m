//
//  Box.m
//  Cheaterpress
//
//  Created by Alex Nichol on 12/23/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "Box.h"
#import "Game.h"


@implementation Box

@dynamic column;
@dynamic letter;
@dynamic row;
@dynamic owner;
@dynamic game;

- (BOOL)isBoxSurrounded {
    if (self.owner == BoxOwnerTypeUnowned) return NO;
    for (int x = MAX(0, self.column - 1); x < MIN(5, self.column + 1); x++) {
        for (int y = MAX(0, self.row - 1); y < MIN(5, self.row + 1); y++) {
            Box * boxAtPoint = nil;
            for (Box * b in self.game.boxes) {
                if (b.row == y && b.column == x) {
                    boxAtPoint = b;
                    break;
                }
            }
            NSAssert(boxAtPoint != nil, @"No box found at a surrounding x/y pair");
            if (boxAtPoint.owner != self.owner) return NO;
        }
    }
    return YES;
}

@end
