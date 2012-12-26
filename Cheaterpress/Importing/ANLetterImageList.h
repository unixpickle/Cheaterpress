//
//  ANLetterImageList.h
//  Cheaterpress
//
//  Created by Alex Nichol on 12/25/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANImageBitmapRep.h"
#import "ANGameTheme.h"

@interface ANLetterImageList : NSObject {
    NSDictionary * imagesForLetters;
}

- (ANImageBitmapRep *)imageForLetter:(NSString *)capitalLetter;
- (NSString *)letterMatching:(ANImageBitmapRep *)matchMe;
- (float)percentageBase:(ANImageBitmapRep *)anImage withImage:(ANImageBitmapRep *)otherImage;

@end
