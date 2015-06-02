//
//  CompetitorCell.m
//  FullIntel
//
//  Created by cape start on 01/06/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "CompetitorCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FIUtils.h"
@implementation CompetitorCell

- (void)awakeFromNib {
    // Initialization code
    
    [_firstImageView sd_setImageWithURL:[NSURL URLWithString:@"http://img4.wikia.nocookie.net/__cb20130101110037/logopedia/images/0/0c/1000px-AOL_logo.svg.png"] placeholderImage:[UIImage imageNamed:@"FI"]];
    [_firstImageView setContentMode:UIViewContentModeScaleAspectFit];
    [_secondImageView sd_setImageWithURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/193217140/Fullintel/May/18/ganett.png"] placeholderImage:[UIImage imageNamed:@"FI"]];
    [_secondImageView setContentMode:UIViewContentModeScaleAspectFit];

    [FIUtils makeRoundedView:_firstImageView];
    
     [FIUtils makeRoundedView:_secondImageView];
    
}

@end
