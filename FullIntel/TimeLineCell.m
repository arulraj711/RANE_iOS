//
//  TimeLineCell.m
//  FullIntel
//
//  Created by cape start on 01/06/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "TimeLineCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FIUtils.h"
@implementation TimeLineCell

- (void)awakeFromNib {
    // Initialization code
    
    
    [_firstImageView sd_setImageWithURL:[NSURL URLWithString:@"http://img4.wikia.nocookie.net/__cb20130101110037/logopedia/images/0/0c/1000px-AOL_logo.svg.png"] placeholderImage:[UIImage imageNamed:@"FI"]];
    
    [_secondImageView sd_setImageWithURL:[NSURL URLWithString:@"https://s3.amazonaws.com/image.infoarmy/1385640266893.jpg"] placeholderImage:[UIImage imageNamed:@"FI"]];
    
    [_thirdImageView sd_setImageWithURL:[NSURL URLWithString:@"https://s3.amazonaws.com/image.infoarmy/1387865887710.jpg"] placeholderImage:[UIImage imageNamed:@"FI"]];
    [_forthImageView sd_setImageWithURL:[NSURL URLWithString:@"https://s3.amazonaws.com/image.infoarmy/1387865976407.png"] placeholderImage:[UIImage imageNamed:@"FI"]];
    [_firstImageView sd_setImageWithURL:[NSURL URLWithString:@"https://s3.amazonaws.com/image.infoarmy/1373892638886.gif"] placeholderImage:[UIImage imageNamed:@"FI"]];
    
    
    [FIUtils makeRoundedView:_firstImageView];
    
       [FIUtils makeRoundedView:_secondImageView];
    
       [FIUtils makeRoundedView:_thirdImageView];
       [FIUtils makeRoundedView:_forthImageView];
       [FIUtils makeRoundedView:_fivethImageView];
    
    
    
}

@end
