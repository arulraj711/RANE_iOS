//
//  TopStoriesCell.m
//  FullIntel
//
//  Created by cape start on 28/05/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "TopStoriesCell.h"

@implementation TopStoriesCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
}
@end
