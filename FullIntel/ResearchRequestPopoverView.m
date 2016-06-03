//
//  ResearchRequestPopoverView.m
//  FullIntel
//
//  Created by Arul on 3/20/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "ResearchRequestPopoverView.h"
#import "FISharedResources.h"
#import "UIView+Toast.h"
#import "UIColor+CustomColor.h"
@interface ResearchRequestPopoverView ()

@end

@implementation ResearchRequestPopoverView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    //send button customization
    self.sendButton.backgroundColor = [UIColor buttonBackgroundColor];
    [self.sendButton setTitleColor:[UIColor buttonTextColor] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(researchSend) name:@"ResearchSend" object:nil];
    if([[FISharedResources sharedResourceManager]serviceIsReachable]) {
        
    } else {
        UIWindow *window = [[UIApplication sharedApplication]windows][0];
        NSArray *subViewArray = [window subviews];
        NSLog(@"subview array count:%d",subViewArray.count);
        if(subViewArray.count == 1) {
            [[FISharedResources sharedResourceManager] showBannerView];
        }
    }
    if ([UIDevice currentDevice].userInterfaceIdiom ==UIUserInterfaceIdiomPhone) {
        if(self.fromAddContent) {
            self.titleText.text = @"Request Change";
            self.articleDesc.text = [NSString stringWithFormat:@"Hi there,\n\nI would like to make the following changes to the topics\n\n"];
            
        }else {
            self.titleText.text = @"Research Request";
            if(self.articleId.length != 0) {
                self.articleDesc.text = [NSString stringWithFormat:@"\n\n\n\n\n\n\n\n\n\n--------\nArticleId : %@\nArticleTitle : %@\nArticleUrl : %@",self.articleId,self.articleTitle,self.articleUrl];
            }
            self.articleDesc.selectedRange = NSMakeRange(0, 0);
            [self.articleDesc becomeFirstResponder];
        }
        //    [self.articleDesc setReturnKeyType: UIReturnKeyDone];
    }
    else{
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
        //    [self.articleDesc setReturnKeyType: UIReturnKeyDone];
        
        self.backImgeView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapEvent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEvent)];
        [self.backImgeView addGestureRecognizer:tapEvent];
        
        

    }
    

}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
   
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
    
    if ([text isEqualToString:@"\n"]) {
        [self.articleDesc resignFirstResponder];
        return NO;
    }
    return YES;

}
- (void)keyboardDidShow:(NSNotification *)notification
{
   
   if ([UIDevice currentDevice].userInterfaceIdiom ==UIUserInterfaceIdiomPad) {
        // Assign new frame to your view
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4]; // to slide the view up
        
        NSDictionary *userInfo = [notification userInfo];
        
        CGRect keyboardEndFrame;
        [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
        
        // Use keyboardEndFrame
        
        
        CGRect rect = self.view.frame;
        
        NSLog(@"view frame height before keyboardDidShow:%f, %f",self.view.frame.size.height,rect.size.height);
        
        if(rect.size.height==768){
            
            rect.size.height=410;
        }else if(rect.size.height==1024) {
            rect.size.height=800;
        }else if(rect.size.height==568) {
            rect.size.height=320;
        }
        self.view.frame = rect;
        
        NSLog(@"view frame height after keyboardDidShow:%f",self.view.frame.size.height);
        
        [UIView commitAnimations];
        
        
    }
    
}
-(void)keyboardDidHide:(NSNotification *)notification
{
    if ([UIDevice currentDevice].userInterfaceIdiom ==UIUserInterfaceIdiomPad) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4]; // to slide the view up
        
        NSDictionary *userInfo = [notification userInfo];
        
        CGRect keyboardEndFrame;
        [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
        
        
        NSLog(@"view frame height before keyboardDidHide:%f",self.view.frame.size.height);
        
        
        CGRect rect = self.view.frame;
        
        if(rect.size.height==410){
            rect.size.height =768;
        }else if(rect.size.height==800){
            rect.size.height =1024;
        }else if(rect.size.height==320){
            rect.size.height =568;
        }
        
        self.view.frame = rect;
        
        
        //NSLog(@"view frame height after keyboardDidHide:%f",self.view.frame.size.height);
        
        [UIView commitAnimations];
    
    
    }
    
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.view endEditing:YES];
    return YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (void)updateViewConstraints {
//    if (self.view.superview != nil && [[self.view.superview constraints] count] == 0) {
//        NSDictionary* views = @{@"view" : self.view};
//        
//        [self.view.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:0 views:views]];
//        [self.view.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:0 views:views]];
//    }
//    [super updateViewConstraints];
//}
-(void)tapEvent {
    [self dismissViewControllerAnimated:NO completion:NULL];
}
- (IBAction)send:(id)sender {
    if(self.articleDesc.text.length != 0) {
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
            [gradedetails setObject:self.articleDesc.text forKey:@"description"];
            [gradedetails setObject:@"Sent from Menu Head Research Request" forKey:@"headLine"];
        }
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:gradedetails options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
        //NSLog(@"request input:%@",resultStr);
        [[FISharedResources sharedResourceManager]sendResearchRequestWithDetails:resultStr];
        [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"SendResearchRequest"];
    } else {
        UIWindow *window = [[UIApplication sharedApplication]windows][0];
        [window makeToast:@"Please enter a message to proceed." duration:1 position:CSToastPositionCenter];
    }
    
}

-(void)researchSend {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)closeAction:(id)sender {
    [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"CloseResearchRequestView"];
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
