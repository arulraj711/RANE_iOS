//
//  IssueListCell.m
//  FullIntel
//
//  Created by cape start on 24/09/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "IssueListCell.h"

@implementation IssueListCell

- (void)awakeFromNib {
    // Initialization code
    self.articleImage.layer.masksToBounds = YES;
    self.articleImage.layer.cornerRadius = 10.0f;
    self.articleImage.layer.borderColor = [UIColor colorWithRed:(237/255.0) green:(240/255.0) blue:(240/255.0) alpha:1].CGColor;
    self.articleImage.layer.borderWidth = 0.5f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
