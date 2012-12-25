//
//  ANWordlist.h
//  Cheaterpress
//
//  Created by Alex Nichol on 12/24/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANWordlist : NSObject {
    char ** list;
    NSInteger count;
    uint32_t occurances[26];
}

- (id)initWithFile:(NSString *)path;
- (id)initWithList:(char **)theList count:(NSInteger)theCount;

- (NSInteger)numberOfWords;
- (NSString *)wordAtIndex:(NSUInteger)index;
- (const char *)cWordAtIndex:(NSUInteger)index;
- (uint32_t *)occurances;

- (ANWordlist *)filteredWordlistUsingLetters:(const char *)letters count:(NSInteger)numLetters;

@end
