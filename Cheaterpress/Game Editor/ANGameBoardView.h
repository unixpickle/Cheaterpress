//
//  ANGameBoardView.h
//  Cheaterpress
//
//  Created by Alex Nichol on 12/24/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ANGameColors.h"

#import "Game.h"
#import "Box.h"

@class ANGameBoardView;

@protocol ANGameBoardViewDelegate <NSObject>

@optional
- (void)gameBoardView:(ANGameBoardView *)view boxSelected:(Box *)aBox;

@end

@interface ANGameBoardView : UIView {
    Game * game;
    NSSet * selectedBoxes;
    __weak id<ANGameBoardViewDelegate> delegate;
}

@property (nonatomic, weak) id<ANGameBoardViewDelegate> delegate;

- (id)initWithGame:(Game *)game;
- (void)selectBox:(Box *)box;
- (void)selectBoxes:(NSSet *)boxes;
- (NSSet *)selectedBoxes;

@end
