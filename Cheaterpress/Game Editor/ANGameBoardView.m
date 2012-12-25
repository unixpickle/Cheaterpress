//
//  ANGameBoardView.m
//  Cheaterpress
//
//  Created by Alex Nichol on 12/24/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANGameBoardView.h"

@implementation ANGameBoardView

@synthesize delegate;

- (id)initWithGame:(Game *)aGame {
    if ((self = [super init])) {
        game = aGame;
    }
    return self;
}

- (void)selectBox:(Box *)box {
    selectedBoxes = [NSSet setWithObject:box];
    [self setNeedsDisplay];
}

- (void)selectBoxes:(NSSet *)boxes {
    selectedBoxes = boxes;
    [self setNeedsDisplay];
}

- (NSSet *)selectedBoxes {
    return selectedBoxes;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGSize pieceSize = CGSizeMake(self.frame.size.width / 5, self.frame.size.height / 5);
    
    CGFloat fontSize = pieceSize.height / 2;
    UIFont * font = [UIFont fontWithName:@"Museo700-Regular" size:fontSize];
    
    CGContextSetGrayFillColor(context, 1, 1);
    CGContextFillRect(context, self.bounds);
    
    for (Box * b in game.boxes) {
        CGRect boxFrame = CGRectMake(b.column * pieceSize.width,
                                     b.row * pieceSize.height,
                                     pieceSize.width, pieceSize.height);
        UIColor * color = [ANGameColors colorForBox:b];
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, boxFrame);
        
        if ([selectedBoxes containsObject:b]) {
            CGContextSetRGBFillColor(context, 0, 0, 0, 0.1);
            CGContextFillRect(context, boxFrame);
        }
        
        CGSize textSize = [b.letter sizeWithFont:font];
        CGPoint p = CGPointMake(round((pieceSize.width - textSize.width) / 2.0) + boxFrame.origin.x,
                                round((pieceSize.height - textSize.height) / 2.0) + boxFrame.origin.y);
        CGContextSetRGBFillColor(context, 0, 0, 0, 1);
        CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
        [b.letter drawAtPoint:p withFont:font];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint p = [[touches anyObject] locationInView:self];
    int xValue = floor(p.x / (self.frame.size.width / 5));
    int yValue = floor(p.y / (self.frame.size.height / 5));
    Box * b = nil;
    for (Box * aBox in game.boxes) {
        if (aBox.row == yValue && aBox.column == xValue) {
            b = aBox;
            break;
        }
    }
    NSAssert(b != nil, @"Unknown box selected!");
    if ([delegate respondsToSelector:@selector(gameBoardView:boxSelected:)]) {
        [delegate gameBoardView:self boxSelected:b];
    }
}

@end
