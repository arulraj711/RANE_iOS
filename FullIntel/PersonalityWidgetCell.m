//
//  PersonalityWidgetCell.m
//  FullIntel
//
//  Created by Arul on 3/11/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "PersonalityWidgetCell.h"

@implementation PersonalityWidgetCell

- (void)awakeFromNib {
    // Initialization code
    self.contentView.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
    self.contentView.layer.borderWidth = 1.0f;
}

@end
