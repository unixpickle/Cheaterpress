//
//  ANGameCellView.m
//  Cheaterpress
//
//  Created by Alex Nichol on 12/24/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANGameCellView.h"

@implementation ANGameCellView

- (id)initWithScreenWidth {
    UIScreen * s = [UIScreen mainScreen];
    if ((self = [self initWithFrame:CGRectMake(0, 0, s.bounds.size.width, kANGameCellViewHeight)])) {
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        CGFloat thumbnailSize = (frame.size.height - kANGameCellViewPadding * 2);
        
        previewImage = [[UIImageView alloc] initWithFrame:CGRectMake(kANGameCellViewPadding, kANGameCellViewPadding,
                                                                     thumbnailSize, thumbnailSize)];
        previewImage.backgroundColor = [UIColor blackColor];
        
        opponentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kANGameCellViewPadding * 2 + thumbnailSize,
                                                                  kANGameCellViewPadding,
                                                                  frame.size.width - (kANGameCellViewPadding * 3 + thumbnailSize),
                                                                  30)];
        opponentLabel.textColor = [UIColor colorWithWhite:0.26 alpha:1];
        opponentLabel.font = [UIFont boldSystemFontOfSize:24];
        
        dateAdded = [[UILabel alloc] initWithFrame:CGRectMake(opponentLabel.frame.origin.x,
                                                              opponentLabel.frame.origin.y + 35,
                                                              opponentLabel.frame.size.width,
                                                              22)];
        dateAdded.textColor = [UIColor colorWithWhite:0.26 alpha:1];
        dateAdded.font = [UIFont systemFontOfSize:18];
        
        [self addSubview:previewImage];
        [self addSubview:opponentLabel];
        [self addSubview:dateAdded];
    }
    return self;
}

- (Game *)game {
    return game;
}

- (void)setGame:(Game *)aGame {
    game = aGame;
    opponentLabel.text = aGame.opponent;
    dateAdded.text = [NSString stringWithFormat:@"Date added: %@", game.creation];
    previewImage.image = [self generateGameImage];
}

- (UIImage *)generateGameImage {
    UIScreen * s = [UIScreen mainScreen];
    CGSize previewSize = CGSizeMake(previewImage.frame.size.width * s.scale,
                                    previewImage.frame.size.height * s.scale);
    ANImageBitmapRep * bitmap = [[ANImageBitmapRep alloc] initWithSize:BMPointFromSize(previewSize)];
    CGSize boxSize = CGSizeMake(previewSize.width / 5, previewSize.height / 5);
    CGContextRef context = [bitmap context];
    for (Box * b in game.boxes) {
        CGPoint boxPoint = CGPointMake(boxSize.width * b.column, boxSize.height * b.row);
        CGRect boxFrame = CGRectMake(boxPoint.x, boxPoint.y, boxSize.width, boxSize.height);
        UInt32 color = 0;
        if (b.owner == BoxOwnerTypeFriendly) {
            color = ANGamePieceColorFriendly;
        } else if (b.owner == BoxOwnerTypeEnemy) {
            color = ANGamePieceColorEnemy;
        } else {
            color = ANGamePieceColorFriendly;
        }
        if (b.owner == BoxOwnerTypeUnowned) {
            // figure out if it's checkered or not etc.
            int index = b.column + (b.row * 5);
            if (index % 2 == 0) {
                color |= ANGamePieceModifierDark;
            }
        } else {
            if ([b isBoxSurrounded]) {
                color |= ANGamePieceModifierDark;
            }
        }
        UIColor * drawColor = [ANGameColors colorForNumber:color];
        CGContextSetFillColorWithColor(context, [drawColor CGColor]);
        CGContextFillRect(context, boxFrame);
    }
    [bitmap setNeedsUpdate:YES];
    return bitmap.image;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
