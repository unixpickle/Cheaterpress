//
//  ANLetterImageList.m
//  Cheaterpress
//
//  Created by Alex Nichol on 12/25/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANLetterImageList.h"

@implementation ANLetterImageList

- (id)init {
    if ((self = [super init])) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        for (char a = 'a'; a <= 'z'; a++) {
            NSString * filename = [NSString stringWithFormat:@"letter_%c", a];
            NSString * path = [[NSBundle mainBundle] pathForResource:filename ofType:@"png"];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                UIImage * realImage = [[UIImage alloc] initWithContentsOfFile:path];
                ANImageBitmapRep * image = [[ANImageBitmapRep alloc] initWithImage:realImage];
                [dict setObject:image forKey:[[NSString stringWithFormat:@"%c", a] uppercaseString]];
            }
        }
        imagesForLetters = [dict copy];
    }
    return self;
}

- (ANImageBitmapRep *)imageForLetter:(NSString *)capitalLetter {
    return [imagesForLetters objectForKey:capitalLetter];
}

- (NSString *)letterMatching:(ANImageBitmapRep *)matchMe {
    NSString * letter = @"A";
    float percentage = 0;
    
    for (NSString * testLetter in imagesForLetters) {
        float pct = [self percentageBase:[imagesForLetters objectForKey:testLetter]
                               withImage:matchMe];
        if (pct > percentage) {
            letter = testLetter;
            percentage = pct;
        }
    }
    return letter;
}

- (float)percentageBase:(ANImageBitmapRep *)anImage withImage:(ANImageBitmapRep *)otherImage {
    if (otherImage.bitmapSize.x != anImage.bitmapSize.x || otherImage.bitmapSize.y != anImage.bitmapSize.y) {
        return 0;
    }
    int total = 0;
    int matched = 0;
    
    CGFloat sidePadding = anImage.bitmapSize.x / 6;
    
    // from anImage to otherImage
    for (int y = sidePadding; y < anImage.bitmapSize.y - sidePadding; y++) {
        for (int x = sidePadding; x < anImage.bitmapSize.x - sidePadding; x++) {
            BMPixel pixel = [anImage getPixelAtPoint:BMPointMake(x, y)];
            if (pixel.blue < 0.22 && pixel.red < 0.22 && pixel.green < 0.22) {
                total += 1;
                BMPixel checkPixel = [otherImage getPixelAtPoint:BMPointMake(x, y)];
                if (checkPixel.blue < 0.22 && checkPixel.red < 0.22 && checkPixel.green < 0.22) {
                    matched += 1;
                }
            }
        }
    }
    // from otherImage to anImage
    for (int y = sidePadding; y < otherImage.bitmapSize.y - sidePadding; y++) {
        for (int x = sidePadding; x < otherImage.bitmapSize.x - sidePadding; x++) {
            BMPixel pixel = [otherImage getPixelAtPoint:BMPointMake(x, y)];
            if (pixel.blue < 0.22 && pixel.red < 0.22 && pixel.green < 0.22) {
                total += 1;
                BMPixel checkPixel = [anImage getPixelAtPoint:BMPointMake(x, y)];
                if (checkPixel.blue < 0.22 && checkPixel.red < 0.22 && checkPixel.green < 0.22) {
                    matched += 1;
                }
            }
        }
    }
    if (total == 0) return 0;
    return (float)matched / (float)total;
}

@end
