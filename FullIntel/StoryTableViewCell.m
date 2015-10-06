//
//  StoryTableViewCell.m
//  FullIntel
//
//  Created by CapeStart Apple on 10/6/15.
//  Copyright © 2015 CapeStart. All rights reserved.
//

#import "StoryTableViewCell.h"

@implementation StoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.numberLabel.layer.cornerRadius = 20.0f;
    self.numberLabel.layer.masksToBounds = YES;
    self.numberLabel.layer.borderWidth = 1.0f;
    self.numberLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
