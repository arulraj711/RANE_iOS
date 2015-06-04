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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(researchSend) name:@"ResearchSend" object:nil];
    
    self.outerView.layer.masksToBounds = YES;
    self.outerView.layer.cornerRadius = 10;
    if(self.fromAddContent) {
        self.titleText.text = @"Request Change";
        self.articleDesc.text = [NSString stringWithFormat:@"Hi there,\n\nI would like to make the following changes to the topics\n\n"];
        
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
    NSMutableDictionary *gradedetails = [[NSMutableDictionary alloc] init];
    [gradedetails setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"] forKey:@"userId"];
    [gradedetails setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
    [gradedetails setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"customerId"] forKey:@"customerId"];
    [gradedetails setObject:@"1" forKey:@"version"];
    if(self.articleId.length != 0) {
        [gradedetails setObject:self.articleId forKey:@"articleId"];
        [gradedetails setObject:self.articleDesc.text forKey:@"description"];
        [gradedetails setObject:self.articleTitle forKey:@"headLine"];
    } else {
        [gradedetails setObject:@"Sent from Menu Id Research Request" forKey:@"articleId"];
        [gradedetails setObject:@"Sent from Menu Desc Research Request" forKey:@"description"];
        [gradedetails setObject:@"Sent from Menu Head Research Request" forKey:@"headLine"];
    }
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:gradedetails options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
    //NSLog(@"request input:%@",resultStr);
    [[FISharedResources sharedResourceManager]sendResearchRequestWithDetails:resultStr];
    
}

-(void)researchSend {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
