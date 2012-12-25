//
//  ANWordSearcherSolution.h
//  Cheaterpress
//
//  Created by Alex Nichol on 12/24/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Game.h"
#import "Box.h"

@interface ANWordSearcherSolution : NSObject {
    NSArray * indices;
}

- (id)initWithIndices:(NSArray *)theIndices;
- (NSInteger)numberOfIndices;

- (Box *)boxAtIndex:(NSInteger)index forGame:(Game *)game;
- (NSString *)solutionTextForGame:(Game *)game;

@end
