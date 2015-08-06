//
//  PersonalityExecutiveCell.m
//  FullIntel
//
//  Created by cape start on 01/06/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "PersonalityExecutiveCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FISharedResources.h"
#import "FIUtils.h"

@implementation PersonalityExecutiveCell

- (void)awakeFromNib {
    // Initialization code
    
    
        [_userImage sd_setImageWithURL:[NSURL URLWithString:@"https://media.licdn.com/mpr/mpr/shrink_200_200/p/7/005/00a/085/07d7e10.jpg"] placeholderImage:[UIImage imageNamed:@"FI"]];
    
}
- (IBAction)requestUpgradeButtonPressed:(id)sender {
    
    

    
}

@end
