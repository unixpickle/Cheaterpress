//
//  ANGameTableViewCell.m
//  Cheaterpress
//
//  Created by Alex Nichol on 12/24/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANGameCell.h"

@implementation ANGameCell

@synthesize cellView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        cellView = [[ANGameCellView alloc] initWithScreenWidth];
        [self.contentView addSubview:cellView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
