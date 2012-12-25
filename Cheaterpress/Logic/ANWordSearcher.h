//
//  ANWordSearcher.h
//  Cheaterpress
//
//  Created by Alex Nichol on 12/24/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANWordlist.h"
#import "ANWordSearcherSolution.h"

#import "Game.h"
#import "Box.h"

@class ANWordSearcher;

@protocol ANWordSearcherDelegate <NSObject>

- (void)wordSearcherListUpdated:(ANWordSearcher *)searcher;

@end

typedef struct {
    uint8_t row;
    uint8_t column;
} ANWordSearcherPosition;

typedef struct {
    ANWordSearcherPosition * positions;
    uint32_t count;
    int64_t tally;
} ANWordSearcherPositionList;

typedef struct {
    char * letters;
    uint16_t * owners;
    NSUInteger count;
} ANWordSearcherBoard;

void ANWordSearcherBoardFree(ANWordSearcherBoard * board);
BOOL ANWordSearcherBoardIsLocked(ANWordSearcherBoard * board, int row, int column);
void ANWordSearcherBoardTakePositions(ANWordSearcherBoard * board, ANWordSearcherPositionList list);
int64_t ANWordSearcherBoardRunTally(ANWordSearcherBoard * board, const uint32_t * occurances);

@interface ANWordSearcher : NSObject {
    NSThread * backgroundThread;
    NSArray * solutions;
    
    __weak id<ANWordSearcherDelegate> delegate;
}

@property (nonatomic, weak) id<ANWordSearcherDelegate> delegate;
@property (readonly) NSArray * solutions;

- (void)startGame:(Game *)game wordlist:(ANWordlist *)wordlist;
- (void)stop;

@end
