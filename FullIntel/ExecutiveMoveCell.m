//
//  ExecutiveMoveCell.m
//  FullIntel
//
//  Created by Capestart on 6/1/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "ExecutiveMoveCell.h"

@implementation ExecutiveMoveCell

- (void)awakeFromNib {
    // Initialization code
    self.leftImage.layer.masksToBounds = YES;
    self.leftImage.layer.cornerRadius = 50.0f;
    self.rightImage.layer.masksToBounds = YES;
    self.rightImage.layer.cornerRadius = 50.0f;
    self.centerImage.layer.masksToBounds = YES;
    self.centerImage.layer.cornerRadius = 20.0f;
    self.leftImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.rightImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.leftImage.layer.borderWidth = 1.0f;
    self.rightImage.layer.borderWidth = 1.0f;
}

@end
