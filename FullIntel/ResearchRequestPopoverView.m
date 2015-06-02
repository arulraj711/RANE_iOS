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
    
    self.outerView.layer.masksToBounds = YES;
    self.outerView.layer.cornerRadius = 10;
    if(self.fromAddContent) {
        self.titleText.text = @"Request Change";
        self.articleDesc.text = [NSString stringWithFormat:@"Hi There,\n\nI would like to add/ change topics that are currently monitored.\n\nPlease add the following topics:---\n\n\n\n%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"firstName"]];
        
    }else {
        self.titleText.text = @"Research Request/Feedback";
        if(self.articleId.length != 0) {
            self.articleDesc.text = [NSString stringWithFormat:@"\n\n\n\n\n\n\n\n\n\n--------\nArticleId : %@\nArticleTitle : %@\nArticleUrl : %@",self.articleId,self.articleTitle,self.articleUrl];
        }
        self.articleDesc.selectedRange = NSMakeRange(0, 0);
        [self.articleDesc becomeFirstResponder];
    }
    self.backImgeView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapEvent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEvent)];
    [self.backImgeView addGestureRecognizer:tapEvent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tapEvent {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (IBAction)send:(id)sender {
    if(self.articleId.length != 0) {
        NSMutableDictionary *gradedetails = [[NSMutableDictionary alloc] init];
        [gradedetails setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"] forKey:@"userId"];
        [gradedetails setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
        [gradedetails setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"customerId"] forKey:@"customerId"];
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
}
- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
