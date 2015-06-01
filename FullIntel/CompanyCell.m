//
//  CompanyCell.m
//  FullIntel
//
//  Created by cape start on 01/06/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "CompanyCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation CompanyCell

- (void)awakeFromNib {
    // Initialization code
    
    
        [_companyLogo sd_setImageWithURL:[NSURL URLWithString:@"http://archiveteam.org/images/thumb/b/bc/Verizon_Logo.png/800px-Verizon_Logo.png"] placeholderImage:[UIImage imageNamed:@"FI"]];
}

@end
