//
//  StockCell.m
//  FullIntel
//
//  Created by cape start on 28/05/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "StockCell.h"

@implementation StockCell
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
}
@end
