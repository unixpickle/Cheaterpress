//
//  ANBoardImport.h
//  Cheaterpress
//
//  Created by Alex Nichol on 12/25/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANLetterImageList.h"

#import "Box.h"
#import "Game.h"

@class ANBoardImport;

@protocol ANBoardImportDelegate <NSObject>

@optional
- (void)boardImportFinished:(ANBoardImport *)import;
- (void)boardImport:(ANBoardImport *)import failedWithError:(NSError *)error;

@end

@interface ANBoardImport : NSObject {
    NSThread * backgroundThread;
    ANImageBitmapRep * imageBitmap;
    
    uint16_t owners[25];
    char letters[25];
    
    __weak id<ANBoardImportDelegate> delegate;
}

@property (nonatomic, weak) id<ANBoardImportDelegate> delegate;

- (id)initWithImage:(UIImage *)theImage;
- (void)start;
- (void)cancel;

- (uint16_t)ownerAtIndex:(int)index;
- (char)letterAtIndex:(int)index;

@end
