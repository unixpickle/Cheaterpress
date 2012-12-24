//
//  ANGameTableViewCell.h
//  Cheaterpress
//
//  Created by Alex Nichol on 12/24/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANGameCellView.h"

@interface ANGameCell : UITableViewCell {
    ANGameCellView * cellView;
}

@property (readonly) ANGameCellView * cellView;

@end
