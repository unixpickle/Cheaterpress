//
//  ANGameTheme.m
//  Cheaterpress
//
//  Created by Alex Nichol on 12/26/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANGameTheme.h"

@implementation ANGameTheme

@synthesize bgColor;
@synthesize friendlyColor;
@synthesize enemyColor;

+ (ANGameTheme *)gameThemeFromScreenshot:(ANImageBitmapRep *)gameScreenshot {
    // standard theme recognition method
    struct {
        BMPixel backgroundColor;
        BMPixel signatureFriendly;
        BMPixel signatureEnemy;
    } knownThemes[] = {
        {{0.192157, 0.192157, 0.192157, 1.000000}, {0.490196, 0.984314, 0.003922, 1.000000}, {0.984314, 0.003922, 0.764706, 1.000000}}, // IMG_0257.PNG
        {{0.984314, 0.925490, 0.772549, 1.000000}, {0.556863, 0.160784, 0.996078, 1.000000}, {0.929412, 0.392157, 0.286275, 1.000000}}, // IMG_0258.PNG
        {{0.878431, 0.901961, 0.847059, 1.000000}, {0.996078, 0.619608, 0.015686, 1.000000}, {0.098039, 0.400000, 0.243137, 1.000000}}, // IMG_0261.PNG
        {{0.192157, 0.192157, 0.192157, 1.000000}, {0.376471, 0.984314, 0.733333, 1.000000}, {0.901961, 0.003922, 0.407843, 1.000000}}, // IMG_0262.PNG
        {{1.000000, 0.878431, 0.929412, 1.000000}, {1.000000, 0.015686, 0.898039, 1.000000}, {0.352941, 0.231373, 0.200000, 1.000000}}, // IMG_0263.PNG
        {{0.941176, 0.937255, 0.925490, 1.000000}, {0.019608, 0.643137, 1.000000, 1.000000}, {1.000000, 0.278431, 0.200000, 1.000000}} // IMG_0264.PNG
    };
    
    BMPoint samplePoint = BMPointMake(0, gameScreenshot.bitmapSize.y - gameScreenshot.bitmapSize.x - 2);
    BMPixel bgColor = [gameScreenshot getPixelAtPoint:samplePoint];
    
    // calculate (because it's different for each device) the y value
    // of the circle containing the users' gamecenter icons
    CGFloat topRegionSize = gameScreenshot.bitmapSize.y - gameScreenshot.bitmapSize.x;
    CGFloat yValue = topRegionSize - ((topRegionSize / 2.0) - 24 + 140);
    
    // left circle sample
    CGFloat leftXValue = gameScreenshot.bitmapSize.x / 2 - 24 - 140 / 2;
    BMPixel leftSignatureColor = [gameScreenshot getPixelAtPoint:BMPointMake(leftXValue, yValue + 4)];
    
    // right circle sample
    CGFloat rightXValue = gameScreenshot.bitmapSize.x / 2 + 24 + 140 / 2;
    BMPixel rightSignatureColor = [gameScreenshot getPixelAtPoint:BMPointMake(rightXValue, yValue + 4)];
    
    // determine whether the right or left circle is friendly
    BOOL rightIsFriendly = YES;
    float lastFriendlyDifference = 3;
    float lastEnemyDifference = 3;
    for (int i = 0; i < sizeof(knownThemes) / (sizeof(BMPixel) * 3); i++) {
        float backgroundDifference = pixelDifference(bgColor, knownThemes[i].backgroundColor);
        if (backgroundDifference > 0.5) continue;
        
        float leftToFriendly = pixelDifference(leftSignatureColor, knownThemes[i].signatureFriendly);
        float leftToEnemy = pixelDifference(leftSignatureColor, knownThemes[i].signatureEnemy);
        if (leftToEnemy < leftToFriendly) {
            // left is enemy
            float friendlyDifference = pixelDifference(rightSignatureColor, knownThemes[i].signatureFriendly);
            if (leftToEnemy < lastEnemyDifference && friendlyDifference < lastFriendlyDifference) {
                lastEnemyDifference = leftToEnemy;
                lastFriendlyDifference = friendlyDifference;
                rightIsFriendly = YES;
            }
        } else {
            // left is friendly
            float enemyDifference = pixelDifference(rightSignatureColor, knownThemes[i].signatureEnemy);
            if (leftToFriendly < lastFriendlyDifference && enemyDifference < lastEnemyDifference) {
                lastEnemyDifference = enemyDifference;
                lastFriendlyDifference = leftToFriendly;
                rightIsFriendly = NO;
            }
        }
    }
    
    ANGameTheme * theme = [[ANGameTheme alloc] init];
    if (rightIsFriendly) {
        theme.friendlyColor = rightSignatureColor;
        theme.enemyColor = leftSignatureColor;
    } else {
        theme.friendlyColor = leftSignatureColor;
        theme.enemyColor = rightSignatureColor;
    }
    theme.bgColor = bgColor;
    return theme;
}

- (BoxOwnerType)boxOwnerForColor:(BMPixel)boxColor {
    float backgroundDiff = pixelDifference(boxColor, bgColor);
    float friendlyDiff = pixelDifference(boxColor, friendlyColor);
    float enemyDiff = pixelDifference(boxColor, enemyColor);
    if (backgroundDiff < friendlyDiff && backgroundDiff < enemyDiff) {
        return BoxOwnerTypeUnowned;
    }
    if (friendlyDiff < enemyDiff) {
        return BoxOwnerTypeFriendly;
    }
    return BoxOwnerTypeEnemy;
}

@end

float pixelDifference(BMPixel p1, BMPixel p2) {
    return fabsf(p1.red - p2.red) + fabsf(p1.green - p2.green) + fabsf(p1.blue - p2.blue);
}
