//
//  ANGameCellView.h
//  Cheaterpress
//
//  Created by Alex Nichol on 12/24/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ANImageBitmapRep.h"
#import "ANGameColors.h"

#import "Game.h"
#import "Box.h"

#define kANGameCellViewHeight 120
#define kANGameCellViewPadding 10

@interface ANGameCellView : UIView {
    Game * game;
    UIImageView * previewImage;
    UILabel * opponentLabel;
    UILabel * dateAdded;
}

- (id)initWithScreenWidth;
- (Game *)game;
- (void)setGame:(Game *)aGame;

- (UIImage *)generateGameImage;

@end
