//
//  PersonalityWidgetCell.m
//  FullIntel
//
//  Created by Arul on 3/11/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "PersonalityWidgetCell.h"
#import "FISharedResources.h"

@implementation PersonalityWidgetCell

- (void)awakeFromNib {
    // Initialization code
    self.contentView.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
    self.contentView.layer.borderWidth = 1.0f;
}


- (IBAction)requestUpgradeButtonClick:(id)sender {
    NSMutableDictionary *gradedetails = [[NSMutableDictionary alloc] init];
    [gradedetails setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
    [gradedetails setObject:[NSNumber numberWithInt:1] forKey:@"moduleId"];
    [gradedetails setObject:[NSNumber numberWithInt:1] forKey:@"featureId"];
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:gradedetails options:NSJSONWritingPrettyPrinted error:nil];
    NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
    [[FISharedResources sharedResourceManager]featureAccessRequestWithDetails:resultStr];
}
@end
