//
//  ANBoardImport.m
//  Cheaterpress
//
//  Created by Alex Nichol on 12/25/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANBoardImport.h"

@interface ANBoardImport (Private)

- (void)backgroundMethod;
- (void)triggerError:(NSString *)message code:(int)code domain:(NSString *)domain;

@end

@implementation ANBoardImport

@synthesize delegate;

- (id)initWithImage:(UIImage *)theImage {
    if ((self = [super init])) {
        memset(letters, 'A', 25);
        bzero(owners, sizeof(owners));
        imageBitmap = [[ANImageBitmapRep alloc] initWithImage:theImage];
    }
    return self;
}

- (void)start {
    backgroundThread = [[NSThread alloc] initWithTarget:self
                                               selector:@selector(backgroundMethod)
                                                 object:nil];
    [backgroundThread start];
}

- (void)cancel {
    [backgroundThread cancel];
    backgroundThread = nil;
}

- (uint16_t)ownerAtIndex:(int)index {
    return owners[index];
}

- (char)letterAtIndex:(int)index {
    return letters[index];
}

#pragma mark - Background Thread -

- (void)backgroundMethod {
    @autoreleasepool {
        if ([imageBitmap bitmapSize].y < [imageBitmap bitmapSize].x) {
            [self triggerError:@"Image dimensions are not compatible."
                          code:1 domain:@"ANBoardImport"];
            return;
        }
        
        ANGameTheme * theme = [ANGameTheme gameThemeFromScreenshot:imageBitmap];
        
        // grab colors (diff between red-blue must be > 0.3)
        CGFloat pieceWidth = [imageBitmap bitmapSize].x / 5;
        CGFloat topStart = [imageBitmap bitmapSize].y - [imageBitmap bitmapSize].x;
        for (int y = 0; y < 5; y++) {
            for (int x = 0; x < 5; x++) {
                int index = x + (y * 5);
                CGFloat sampleX = x * pieceWidth + 10;
                CGFloat sampleY = y * pieceWidth + 10 + topStart;
                BMPixel pixel = [imageBitmap getPixelAtPoint:BMPointMake((long)sampleX, (long)sampleY)];
                owners[index] = [theme boxOwnerForColor:pixel];
            }
        }
        
        if ([[NSThread currentThread] isCancelled]) return;
        
        ANLetterImageList * letterMatcher = [[ANLetterImageList alloc] init];
        for (int y = 0; y < 5; y++) {
            for (int x = 0; x < 5; x++) {
                int index = x + (y * 5);
                CGFloat sampleX = x * pieceWidth;
                CGFloat sampleY = (4 - y) * pieceWidth;
                CGRect frame = CGRectMake(sampleX, sampleY, pieceWidth, pieceWidth);
                CGImageRef img = [imageBitmap croppedImageWithFrame:frame];
                ANImageBitmapRep * imgRep = [[ANImageBitmapRep alloc] initWithImage:[UIImage imageWithCGImage:img]];
                NSString * letter = [letterMatcher letterMatching:imgRep];
                letters[index] = (char)[[letter lowercaseString] characterAtIndex:0];
            }
        }
        
        if ([[NSThread currentThread] isCancelled]) return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            backgroundThread = nil;
            if ([delegate respondsToSelector:@selector(boardImportFinished:)]) {
                [delegate boardImportFinished:self];
            }
        });
    }
}

- (void)triggerError:(NSString *)message code:(int)code domain:(NSString *)domain {
    dispatch_async(dispatch_get_main_queue(), ^{
        backgroundThread = nil;
        NSError * e = [NSError errorWithDomain:domain code:code userInfo:@{NSLocalizedDescriptionKey: message}];
        if ([delegate respondsToSelector:@selector(boardImportFailed:)]) {
            [delegate boardImport:self failedWithError:e];
        }
    });
}

@end
