//
//  VideoWidgetCell.m
//  FullIntel
//
//  Created by Capestart on 5/29/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "VideoWidgetCell.h"
#import "FISharedResources.h"

@implementation VideoWidgetCell

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)requestUpgradeButtonClick:(id)sender {
    NSMutableDictionary *gradedetails = [[NSMutableDictionary alloc] init];
    [gradedetails setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
    [gradedetails setObject:[NSNumber numberWithInt:1] forKey:@"moduleId"];
    [gradedetails setObject:[NSNumber numberWithInt:7] forKey:@"featureId"];
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:gradedetails options:NSJSONWritingPrettyPrinted error:nil];
    NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
    [[FISharedResources sharedResourceManager]featureAccessRequestWithDetails:resultStr];
}

@end
