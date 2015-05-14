//
//  ResearchRequestPopoverView.m
//  FullIntel
//
//  Created by Arul on 3/20/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "ResearchRequestPopoverView.h"
#import "FISharedResources.h"

@interface ResearchRequestPopoverView ()

@end

@implementation ResearchRequestPopoverView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)send:(id)sender {
    
    NSMutableDictionary *gradedetails = [[NSMutableDictionary alloc] init];
    [gradedetails setObject:@"3" forKey:@"userId"];
    [gradedetails setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
    [gradedetails setObject:@"1" forKey:@"customerId"];
    [gradedetails setObject:self.articleId forKey:@"articleId"];
    [gradedetails setObject:self.articleDesc.text forKey:@"description"];
    [gradedetails setObject:self.articleTitle forKey:@"headLine"];
    [gradedetails setObject:@"1" forKey:@"version"];
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:gradedetails options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
    //NSLog(@"request input:%@",resultStr);
    [[FISharedResources sharedResourceManager]sendResearchRequestWithDetails:resultStr];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
