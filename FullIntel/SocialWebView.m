//
//  SocialWebView.m
//  FullIntel
//
//  Created by Capestart on 4/23/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "SocialWebView.h"
#import "MZFormSheetController.h"
#import "FISharedResources.h"
#import "FIUtils.h"
#import "UIView+Toast.h"
@interface SocialWebView ()

@end

@implementation SocialWebView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
  //  NSString *fullURL = @"http://conecode.com";
    
   
   // NSLog(@"web view url:%@",self.urlString);
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Access to form sheet controller
    MZFormSheetController *controller = self.navigationController.formSheetController;
    controller.shouldDismissOnBackgroundViewTap = YES;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //    self.showStatusBar = YES;
    [UIView animateWithDuration:0.3 animations:^{
        [self.navigationController.formSheetController setNeedsStatusBarAppearanceUpdate];
    }];
    
}

-(void)viewDidDisappear:(BOOL)animated {
    [timer invalidate];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(cancelWeb) userInfo:nil repeats:NO];
    progressView = [[UCZProgressView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-50, self.view.frame.size.height/2-50, 100, 100)];
    progressView.translatesAutoresizingMaskIntoConstraints = NO;
    progressView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:progressView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [timer invalidate];
    [progressView removeFromSuperview];
}
- (void)cancelWeb
{
    [FIUtils showRequestTimeOutError];
   // UIWindow *window = [[UIApplication sharedApplication]windows][0];
   // [self.view makeToast:@"Request Time out" duration:1 position:CSToastPositionCenter];
   [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (IBAction)closeAction:(id)sender {
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
//    MZFormSheetController *controller = self.navigationController.formSheetController;
//    [controller dismissViewControllerAnimated:YES completion:nil];
}
@end
