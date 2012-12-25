//
//  ANWordSearcher.m
//  Cheaterpress
//
//  Created by Alex Nichol on 12/24/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANWordSearcher.h"

@interface ANWordSearcher (Private)

- (void)backgroundThreadMethod:(NSDictionary *)information;
- (BOOL)generatePositionList:(ANWordSearcherPositionList **)listOut count:(uint32_t *)countInOut wordlist:(ANWordlist *)wl board:(ANWordSearcherBoard *)board;

@end

/**
 * Recursively finds all of the possible position lists that would allow you to produce a word given a board.
 * It is best to pass a *copy* of the original board into this method.
 */
static ANWordSearcherPositionList * _ANWordSearcherWordOptions(const char * word, int startLetter, ANWordSearcherBoard * board, uint32_t * countOut, ANWordSearcherPositionList followingList);

/**
 * If the newList yields a higher score than some existing stuff in the list, it will be inserted in the
 * approprate place.
 */
static BOOL _ANWordSearcherPositionListSqueezeIn(ANWordSearcherPositionList * list, uint32_t listAlloc, uint32_t * listCount,ANWordSearcherPositionList newList);

@implementation ANWordSearcher

@synthesize delegate;
@synthesize solutions;

- (void)startGame:(Game *)game wordlist:(ANWordlist *)wordlist {
    ANWordSearcherBoard * board = (ANWordSearcherBoard *)malloc(sizeof(ANWordSearcherBoard));
    board->letters = (char *)malloc(25);
    board->owners = (uint16_t *)malloc(25 * sizeof(uint16_t));
    board->count = 25;
    for (Box * b in game.boxes) {
        int index = b.column + (b.row * 5);
        board->letters[index] = tolower((char)[[b letter] characterAtIndex:0]);
        board->owners[index] = b.owner;
    }
    NSDictionary * info = @{@"board": [NSValue valueWithPointer:board],
                            @"wordlist": wordlist};
    [backgroundThread cancel];
    backgroundThread = [[NSThread alloc] initWithTarget:self
                                               selector:@selector(backgroundThreadMethod:)
                                                 object:info];
    [backgroundThread start];
}

- (void)stop {
    [backgroundThread cancel];
    backgroundThread = nil;
}

#pragma mark - Private Background -

- (void)backgroundThreadMethod:(NSDictionary *)information {
    @autoreleasepool {
        NSValue * boardPointer = [information objectForKey:@"board"];
        ANWordlist * wordlist = [information objectForKey:@"wordlist"];
        ANWordSearcherBoard * board = (ANWordSearcherBoard *)[boardPointer pointerValue];
        if ([[NSThread currentThread] isCancelled]) {
            ANWordSearcherBoardFree(board);
            return;
        }
        ANWordlist * filtered = [wordlist filteredWordlistUsingLetters:board->letters count:25];
        wordlist = nil;
        if (!filtered || [[NSThread currentThread] isCancelled]) {
            ANWordSearcherBoardFree(board);
            return;
        }
        ANWordSearcherPositionList * positionList = NULL;
        uint32_t count = 10;
        if (![self generatePositionList:&positionList count:&count wordlist:filtered board:board]) {
            ANWordSearcherBoardFree(board);
            return;
        }
        ANWordSearcherBoardFree(board);
        
        // reformat our data for the callback
        NSMutableArray * mSolutions = [[NSMutableArray alloc] init];
        for (uint32_t i = 0; i < count; i++) {
            NSMutableArray * indices = [NSMutableArray array];
            for (uint32_t j = 0; j < positionList[i].count; j++) {
                NSInteger index = positionList[i].positions[j].column + (positionList[i].positions[j].row * 5);
                [indices addObject:[NSNumber numberWithInteger:index]];
            }
            [mSolutions addObject:[[ANWordSearcherSolution alloc] initWithIndices:indices]];
        }
        
        // free the data
        for (uint32_t i = 0; i < count; i++) {
            free(positionList[i].positions);
        }
        free(positionList);
        
        // tell the delegate
        dispatch_async(dispatch_get_main_queue(), ^{
            solutions = mSolutions;
            if ([delegate respondsToSelector:@selector(wordSearcherListUpdated:)]) {
                [delegate wordSearcherListUpdated:self];
            }
        });
    }
}

- (BOOL)generatePositionList:(ANWordSearcherPositionList **)listOut count:(uint32_t *)countInOut wordlist:(ANWordlist *)wl board:(ANWordSearcherBoard *)board {
    uint32_t count = *countInOut;
    ANWordSearcherPositionList * list = (ANWordSearcherPositionList *)malloc(sizeof(ANWordSearcherPositionList) * count);
    if (listOut) *listOut = list;
    uint32_t filled = 0;
    
    ANWordSearcherBoard * newBoard = (ANWordSearcherBoard *)malloc(sizeof(ANWordSearcherBoard));
    newBoard->count = board->count;
    newBoard->letters = (char *)malloc(board->count);
    newBoard->owners = (uint16_t *)malloc(board->count * sizeof(uint16_t));
    
    // go through each word and try to squeeze in the options
    for (NSUInteger i = 0; i < [wl numberOfWords]; i++) {
        if (i % 1024 == 0) {
            if ([[NSThread currentThread] isCancelled]) {
                ANWordSearcherBoardFree(newBoard);
                for (int x = 0; x < filled; x++) {
                    free(list[x].positions);
                }
                free(list);
                return NO;
            }
        }
        const char * word = [wl cWordAtIndex:i];
        
        memcpy(newBoard->letters, board->letters, board->count);
        memcpy((char *)newBoard->owners, (char *)board->owners, board->count * sizeof(uint16_t));
        
        uint32_t newCount;
        ANWordSearcherPositionList emptyTrailing;
        emptyTrailing.positions = NULL;
        emptyTrailing.count = 0;
        ANWordSearcherPositionList * lists = _ANWordSearcherWordOptions(word, 0, newBoard, &newCount, emptyTrailing);
        NSAssert(lists != nil, @"This *should* result in at least one possibility! I bet this assert will fail :'( %s %d", word, i);
        
        // run the tally for all the lists
        int64_t bestTally = INT64_MIN;
        for (uint32_t listIndex = 0; listIndex < newCount; listIndex++) {
            ANWordSearcherPositionList testList = lists[listIndex];
            if (listIndex > 0) {
                memcpy(newBoard->letters, board->letters, board->count);
                memcpy((char *)newBoard->owners, (char *)board->owners, board->count * sizeof(uint16_t));
            }
            ANWordSearcherBoardTakePositions(newBoard, testList);
            testList.tally = ANWordSearcherBoardRunTally(newBoard, [wl occurances]);
            if (testList.tally > bestTally) bestTally = testList.tally;
            lists[listIndex] = testList;
        }
        
        // bump our best tally to the list if it fits
        for (uint32_t listIndex = 0; listIndex < newCount; listIndex++) {
            ANWordSearcherPositionList testList = lists[listIndex];
            if (testList.tally == bestTally) {
                if (!_ANWordSearcherPositionListSqueezeIn(list, count, &filled, testList)) {
                    free(testList.positions);
                }
                break;
            }
        }
        free(lists);
    }
    
    *countInOut = filled;
    ANWordSearcherBoardFree(newBoard);
    return YES;
}

@end

#pragma mark - Public C Methods -

void ANWordSearcherBoardFree(ANWordSearcherBoard * board) {
    free(board->letters);
    free(board->owners);
    free(board);
}

BOOL ANWordSearcherBoardIsLocked(ANWordSearcherBoard * board, int row, int column) {
    uint16_t myOwner = board->owners[column + (row * 5)];
    if (myOwner == BoxOwnerTypeUnowned) return NO;
    for (int x = MAX(0, column - 1); x <= MIN(column + 1, 4); x++) {
        for (int y = MAX(0, row - 1); y <= MIN(row + 1, 4); y++) {
            if (x != column && y != row) continue;
            if (x == column && y == column) continue;
            int index = x + (y * 5);
            if (board->owners[index] != myOwner) return NO;
        }
    }
    return YES;
}

void ANWordSearcherBoardTakePositions(ANWordSearcherBoard * board, ANWordSearcherPositionList list) {
    bool * lockedVector = (bool *)malloc(sizeof(bool) * list.count);
    for (uint32_t i = 0; i < list.count; i++) {
        lockedVector[i] = ANWordSearcherBoardIsLocked(board, list.positions[i].row, list.positions[i].column);
    }
    for (uint32_t i = 0; i < list.count; i++) {
        if (!lockedVector[i]) {
            board->owners[list.positions[i].column + (5 * list.positions[i].row)] = BoxOwnerTypeFriendly;
        }
    }
    free(lockedVector);
}

int64_t ANWordSearcherBoardRunTally(ANWordSearcherBoard * board, const uint32_t * occurances) {
    int64_t tally = 0;
    for (uint32_t i = 0; i < board->count; i++) {
        uint32_t value = occurances[tolower(board->letters[i]) - 'a'];
        int64_t coefficient = 0;
        if (board->owners[i] == BoxOwnerTypeFriendly) {
            coefficient = 1;
        } else if (board->owners[i] == BoxOwnerTypeEnemy) {
            coefficient = -1;
        }
        if (ANWordSearcherBoardIsLocked(board, i / 5, i % 5)) coefficient *= 2;
        tally += (int64_t)value * coefficient;
    }
    return tally;
}

#pragma mark - Intelligence -

static ANWordSearcherPositionList * _ANWordSearcherWordOptions(const char * word, int startLetter, ANWordSearcherBoard * board, uint32_t * countOut, ANWordSearcherPositionList followingList) {
    bool takenSpaces[25];
    bzero(takenSpaces, sizeof(takenSpaces));
    if (startLetter == strlen(word)) {
        // if we are at the end, just return the base list we've been passed
        ANWordSearcherPositionList * list = (ANWordSearcherPositionList *)malloc(sizeof(followingList));
        bzero(list, sizeof(ANWordSearcherPositionList));
        list->positions = (ANWordSearcherPosition *)malloc(sizeof(ANWordSearcherPosition) * followingList.count);
        memcpy(list->positions, followingList.positions, sizeof(ANWordSearcherPosition) * followingList.count);
        list->count = followingList.count;
        *countOut = 1;
        return list;
    }
    
    // create a dynamic array of options
    ANWordSearcherPositionList * listVector = (ANWordSearcherPositionList *)malloc(1);
    uint32_t listCount = 0;
    
    // iterate the available spaces on the board to find our next letter
    char thisLetter = word[startLetter];
    for (int i = 0; i < board->count; i++) {
        if (thisLetter == board->letters[i]) {
            // this is our letter, so we'll do all recursive outcomes using it
            ANWordSearcherPosition position;
            position.column = i % 5;
            position.row = i / 5;
            ANWordSearcherPositionList subList;
            subList.count = followingList.count + 1;
            subList.positions = (ANWordSearcherPosition *)malloc(subList.count * sizeof(ANWordSearcherPosition));
            if (followingList.count > 0) {
                memcpy(subList.positions, followingList.positions, sizeof(ANWordSearcherPosition) * followingList.count);
            }
            subList.positions[followingList.count] = position;
            
            // we set this to 0 so that a sub-call won't ever reuse this square (prevents overlap)
            board->letters[i] = 0;
            if (i < sizeof(takenSpaces)) takenSpaces[i] = YES;
            
            // call the recursive method and append its results to our dynamic array
            uint32_t subCount = 0;
            ANWordSearcherPositionList * subPositionList;
            subPositionList = _ANWordSearcherWordOptions(word, startLetter + 1, board, &subCount, subList);
            free(subList.positions);
            if (subPositionList) {
                listVector = (ANWordSearcherPositionList *)realloc(listVector, (listCount + subCount) * sizeof(ANWordSearcherPositionList));
                memcpy(&listVector[listCount], subPositionList, sizeof(ANWordSearcherPositionList) * subCount);
                listCount += subCount;
                free(subPositionList);
            }
        }
    }
    
    // reset the spaces we've NULL'd for the (potential) outer method's next iteration
    for (int i = 0; i < sizeof(takenSpaces); i++) {
        if (takenSpaces[i]) {
            if (board->letters[i] == 0) {
                board->letters[i] = thisLetter;
            }
        }
    }
    
    // this could happen if our only option is to overlap an already-tried possibility.
    if (listCount == 0) {
        free(listVector);
        return NULL;
    }
    
    *countOut = listCount;
    return listVector;
}

static BOOL _ANWordSearcherPositionListSqueezeIn(ANWordSearcherPositionList * list, uint32_t listAlloc, uint32_t * listCount, ANWordSearcherPositionList newList) {
    int insertIndex = -1;
    for (int i = 0; i < *listCount; i++) {
        if (newList.tally >= list[i].tally) {
            insertIndex = i;
            break;
        }
    }
    if (*listCount < listAlloc) {
        if (insertIndex == -1) {
            list[*listCount] = newList;
            *listCount += 1;
        } else {
            // just move everything down
            for (int i = *listCount - 1; i >= insertIndex; i--) {
                list[i + 1] = list[i];
            }
            list[insertIndex] = newList;
            *listCount += 1;
        }
        return YES;
    } else if (insertIndex >= 0) {
        free(list[listAlloc - 1].positions); // free the last thing which we're kicking off
        for (int i = listAlloc - 2; i >= insertIndex; i--) {
            list[i + 1] = list[i];
        }
        list[insertIndex] = newList;
        return YES;
    }
    return NO;
}
