//
//  ExecutiveTimeLineCell.m
//  FullIntel
//
//  Created by cape start on 02/06/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "ExecutiveTimeLineCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FIUtils.h"
#import "FISharedResources.h"
@implementation ExecutiveTimeLineCell

- (void)awakeFromNib {
    // Initialization code
    
    
    [_firstImage sd_setImageWithURL:[NSURL URLWithString:@"https://media.licdn.com/media/p/1/000/1c0/2ef/2042035.png"] placeholderImage:[UIImage imageNamed:@"FI"]];
    
     [_secondImage sd_setImageWithURL:[NSURL URLWithString:@"https://media.licdn.com/media/p/5/005/081/3bf/3589883.png"] placeholderImage:[UIImage imageNamed:@"FI"]];
    
     [_thirdImage sd_setImageWithURL:[NSURL URLWithString:@"http://upload.wikimedia.org/wikipedia/commons/thumb/8/89/Macromedia.svg/175px-Macromedia.svg.png"] placeholderImage:[UIImage imageNamed:@"FI"]];
    
     [_forthImage sd_setImageWithURL:[NSURL URLWithString:@"https://media.licdn.com/media/p/3/000/01e/042/06da440.png"] placeholderImage:[UIImage imageNamed:@"FI"]];
    
    
    [FIUtils makeRoundedView:_firstImage];
    [FIUtils makeRoundedView:_secondImage];
    [FIUtils makeRoundedView:_thirdImage];
    [FIUtils makeRoundedView:_forthImage];
    
    
}

- (IBAction)requestUpgradeButtonPressed:(id)sender {
    
    
    [FIUtils callRequestionUpdateWithModuleId:5 withFeatureId:5];

}
@end
