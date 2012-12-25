//
//  ANWordlist.m
//  Cheaterpress
//
//  Created by Alex Nichol on 12/24/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANWordlist.h"

@implementation ANWordlist

- (id)initWithFile:(NSString *)path {
    if ((self = [super init])) {
        FILE * fp = fopen([path UTF8String], "r");
        char buff[512];
        NSInteger numAlloc = 1024;
        NSInteger numUsed = 0;
        list = (char **)malloc(sizeof(char *) * numAlloc);
        while (!feof(fp)) {
            fgets(buff, 512, fp);
            if (strlen(buff) > 0) {
                if (buff[strlen(buff) - 1] == '\n') {
                    buff[strlen(buff) - 1] = 0;
                }
            }
            if (strlen(buff) > 0) {
                if (buff[strlen(buff) - 1] == '\r') {
                    buff[strlen(buff) - 1] = 0;
                }
            }
            if (numUsed == numAlloc) {
                numAlloc += 1024;
                list = (char **)realloc(list, sizeof(char *) * numAlloc);
            }
            if (strlen(buff) == 0) continue;
            list[numUsed] = (char *)malloc(strlen(buff) + 1);
            strcpy(list[numUsed], buff);
            numUsed++;
        }
        fclose(fp);
        count = numUsed;
    }
    return self;
}

- (id)initWithList:(char **)theList count:(NSInteger)theCount {
    if ((self = [super init])) {
        list = theList;
        count = theCount;
    }
    return self;
}

- (NSInteger)numberOfWords {
    return count;
}

- (NSString *)wordAtIndex:(NSUInteger)index {
    NSAssert(index < count, @"Index exceeds list count");
    return [NSString stringWithUTF8String:list[index]];
}

- (const char *)cWordAtIndex:(NSUInteger)index {
    return list[index];
}

- (uint32_t *)occurances {
    return occurances;
}

#pragma mark - Filtering -

- (ANWordlist *)filteredWordlistUsingLetters:(const char *)letters count:(NSInteger)numLetter {
    char * letterCopy = (char *)malloc(numLetter);
    char ** newList = (char **)malloc(sizeof(char *) * 1024);
    NSInteger numUsed = 0;
    NSInteger numAlloc = 1024;
    uint32_t newTally[26];
    bzero((char *)newTally, sizeof(uint32_t) * 26);
    
    for (NSInteger i = 0; i < count; i++) {
        if (i % 1024 == 0) {
            if ([[NSThread currentThread] isCancelled]) {
                free(letterCopy);
                free(newList);
                return nil;
            }
        }
        memcpy(letterCopy, letters, numLetter);
        const char * word = list[i];
        BOOL valid = YES;
        for (int cIndex = 0; cIndex < strlen(word); cIndex++) {
            BOOL found = NO;
            for (int j = 0; j < numLetter; j++) {
                if (letterCopy[j] == word[cIndex]) {
                    letterCopy[j] = 0;
                    found = YES;
                    break;
                }
            }
            if (!found) {
                valid = NO;
                break;
            }
        }
        if (valid) {
            // add it to the greater list
            char * wordCopy = (char *)malloc(strlen(word) + 1);
            strcpy(wordCopy, word);
            if (numAlloc == numUsed) {
                numAlloc += 1024;
                newList = (char **)realloc(newList, sizeof(char *) * numAlloc);
            }
            newList[numUsed] = wordCopy;
            numUsed++;
            // add it to the occurances tally
            for (int j = 0; j < strlen(word); j++) {
                unsigned char c = (unsigned char)tolower(word[j]);
                if (c >= 'a' && c <= 'z') {
                    newTally[c - 'a'] += 1;
                }
            }
        }
    }
    free(letterCopy);
    ANWordlist * wl = [[ANWordlist alloc] initWithList:newList count:numUsed];
    memcpy((char *)wl.occurances, (char *)newTally, sizeof(uint32_t) * 26);
    return wl;
}

#pragma mark - Memory -

- (void)dealloc {
    for (NSInteger i = 0; i < count; i++) {
        free(list[i]);
    }
    free(list);
}

@end
