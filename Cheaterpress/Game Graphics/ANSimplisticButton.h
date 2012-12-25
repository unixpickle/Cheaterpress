//
//  ANSimplisticButton.h
//  Cheaterpress
//
//  Created by Alex Nichol on 12/24/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kANSimplisticButtonHeight 44

@interface ANSimplisticButton : UIControl {
    NSString * title;
    BOOL highlighted;
}

@property (nonatomic, retain) NSString * title;

@end
