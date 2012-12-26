//
//  ANGameTheme.h
//  Cheaterpress
//
//  Created by Alex Nichol on 12/26/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANImageBitmapRep.h"
#import "Box.h"

float pixelDifference(BMPixel p1, BMPixel p2);

@interface ANGameTheme : NSObject {
    BMPixel bgColor;
    BMPixel friendlyColor;
    BMPixel enemyColor;
}

@property (readwrite) BMPixel bgColor;
@property (readwrite) BMPixel friendlyColor;
@property (readwrite) BMPixel enemyColor;

+ (ANGameTheme *)gameThemeFromScreenshot:(ANImageBitmapRep *)gameScreenshot;

- (BoxOwnerType)boxOwnerForColor:(BMPixel)boxColor;

@end
