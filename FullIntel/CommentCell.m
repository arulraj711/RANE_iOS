//
//  CommentCell.m
//  FullIntel
//
//  Created by Capestart on 5/19/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (void)awakeFromNib {
    // Initialization code
    self.receiverImage.layer.masksToBounds = YES;
    self.receiverImage.layer.cornerRadius = 22.0f;
    [self.receiverImage setContentMode:UIViewContentModeScaleAspectFill];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
