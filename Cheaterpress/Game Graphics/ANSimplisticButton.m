//
//  ANSimplisticButton.m
//  Cheaterpress
//
//  Created by Alex Nichol on 12/24/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANSimplisticButton.h"

@implementation ANSimplisticButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (NSString *)title {
    return title;
}

- (void)setTitle:(NSString *)aTitle {
    title = aTitle;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, 1.5, 1.5)
                                                byRoundingCorners:UIRectCornerAllCorners
                                                      cornerRadii:CGSizeMake(self.frame.size.height / 2 - 1.5,
                                                                             self.frame.size.height / 2 - 1.5)];
    
    CGContextSetLineWidth(context, 3);
    CGContextSetGrayStrokeColor(context, 0, 1);
    CGContextBeginPath(context);
    CGContextAddPath(context, [path CGPath]);
    CGContextStrokePath(context);
    
    if (highlighted) {
        UIBezierPath * innerPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, 6, 6)
                                                         byRoundingCorners:UIRectCornerAllCorners
                                                               cornerRadii:CGSizeMake(self.frame.size.height / 2 - 6,
                                                                                      self.frame.size.height / 2 - 6)];
        CGContextSetGrayFillColor(context, 0, 1);
        CGContextBeginPath(context);
        CGContextAddPath(context, [innerPath CGPath]);
        CGContextFillPath(context);
    }
    
    UIFont * font = [UIFont fontWithName:@"Museo500-Regular" size:21];
    CGSize size = [title sizeWithFont:font];
    CGPoint point = CGPointMake((self.frame.size.width - size.width) / 2,
                                (self.frame.size.height - size.height) / 2);
    if (highlighted) {
        CGContextSetGrayFillColor(context, 1, 1);
    } else {
        CGContextSetGrayFillColor(context, 0, 1);
    }
    [title drawAtPoint:point withFont:font];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    highlighted = YES;
    [self setNeedsDisplay];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    highlighted = NO;
    [self setNeedsDisplay];
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    highlighted = NO;
    [self setNeedsDisplay];
    [super touchesEnded:touches withEvent:event];
}

@end
