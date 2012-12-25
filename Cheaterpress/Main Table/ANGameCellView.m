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
                                                                  kANGameCellViewPadding + 4,
                                                                  frame.size.width - (kANGameCellViewPadding * 3 + thumbnailSize),
                                                                  26)];
        opponentLabel.textColor = [UIColor colorWithWhite:0.26 alpha:1];
        opponentLabel.font = [UIFont fontWithName:@"Museo300-Regular" size:20];
        
        dateAdded = [[UILabel alloc] initWithFrame:CGRectMake(opponentLabel.frame.origin.x,
                                                              opponentLabel.frame.origin.y + 35,
                                                              opponentLabel.frame.size.width,
                                                              22)];
        dateAdded.textColor = [UIColor colorWithWhite:0.26 alpha:1];
        dateAdded.font = [UIFont fontWithName:@"Museo100-Regular" size:18];
        
        [self addSubview:previewImage];
        [self addSubview:opponentLabel];
        [self addSubview:dateAdded];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    CGFloat thumbnailSize = (frame.size.height - kANGameCellViewPadding * 2);
    
    previewImage.frame = CGRectMake(kANGameCellViewPadding, kANGameCellViewPadding,
                                    thumbnailSize, thumbnailSize);
    opponentLabel.frame = CGRectMake(kANGameCellViewPadding * 2 + thumbnailSize,
                                     kANGameCellViewPadding,
                                     frame.size.width - (kANGameCellViewPadding * 3 + thumbnailSize), 30);
    dateAdded.frame = CGRectMake(opponentLabel.frame.origin.x,
                                 opponentLabel.frame.origin.y + 35,
                                 opponentLabel.frame.size.width, 22);
    previewImage.image = [self generateGameImage];
}

- (Game *)game {
    return game;
}

- (void)setGame:(Game *)aGame {
    game = aGame;
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    NSString * addedString = [formatter stringFromDate:game.creation];
    
    opponentLabel.text = aGame.opponent;
    dateAdded.text = [NSString stringWithFormat:@"Added: %@", addedString];
    previewImage.image = [self generateGameImage];
}

- (UIImage *)generateGameImage {
    if (!game) return nil;
    
    UIScreen * s = [UIScreen mainScreen];
    CGSize previewSize = CGSizeMake(previewImage.frame.size.width * s.scale,
                                    previewImage.frame.size.height * s.scale);
    ANImageBitmapRep * bitmap = [[ANImageBitmapRep alloc] initWithSize:BMPointFromSize(previewSize)];
    CGSize boxSize = CGSizeMake(previewSize.width / 5, previewSize.height / 5);
    CGContextRef context = [bitmap context];
    for (Box * b in game.boxes) {
        CGPoint boxPoint = CGPointMake(boxSize.width * b.column, boxSize.height * (4 - b.row));
        CGRect boxFrame = CGRectMake(boxPoint.x, boxPoint.y, boxSize.width, boxSize.height);
        UIColor * drawColor = [ANGameColors colorForBox:b];
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
