//
//  ANWordSearcherSolution.m
//  Cheaterpress
//
//  Created by Alex Nichol on 12/24/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANWordSearcherSolution.h"

@implementation ANWordSearcherSolution

- (id)initWithIndices:(NSArray *)theIndices {
    if ((self = [super init])) {
        indices = theIndices;
    }
    return self;
}

- (NSInteger)numberOfIndices {
    return [indices count];
}

#pragma mark - Game Association -

- (Box *)boxAtIndex:(NSInteger)index forGame:(Game *)game {
    NSInteger indexValue = [[indices objectAtIndex:index] integerValue];
    NSInteger row = indexValue / 5;
    NSInteger column = indexValue % 5;
    for (Box * b in game.boxes) {
        if (b.row == row && b.column == column) {
            return b;
        }
    }
    return nil;
}

- (NSString *)solutionTextForGame:(Game *)game {
    NSMutableString * string = [NSMutableString string];
    for (NSInteger i = 0; i < [indices count]; i++) {
        Box * b = [self boxAtIndex:i forGame:game];
        NSAssert(b != nil, @"Box should always exist for coordinates");
        [string appendString:b.letter];
    }
    return string;
}

@end
