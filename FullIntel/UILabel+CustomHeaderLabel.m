//
//  UILabel+CustomHeaderLabel.m
//  RANE
//
//  Created by CapeStart Apple on 6/2/16.
//  Copyright © 2016 CapeStart. All rights reserved.
//

#import "UILabel+CustomHeaderLabel.h"
#import "UIColor+CustomColor.h"

@implementation UILabel (CustomHeaderLabel)
+(UILabel *)setCustomHeaderLabelFromText:(NSString *)textString {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Open Sans" size:16];
    // label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.text =textString;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor headerTextColor]; // change this color
    return label;
}
@end
