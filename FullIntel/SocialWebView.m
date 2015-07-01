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
#import <QuartzCore/QuartzCore.h>
@interface SocialWebView ()

@end

@implementation SocialWebView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
  //  NSString *fullURL = @"http://conecode.com";
    NSString *headerColor = [[NSUserDefaults standardUserDefaults]objectForKey:@"headerColor"];
    NSString *stringWithoutSpaces = [headerColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
    [self.outerView setBackgroundColor:[FIUtils colorWithHexString:stringWithoutSpaces]];
    self.outerView.layer.masksToBounds = YES;
    self.outerView.layer.cornerRadius = 10;
    
    
    
    CALayer *layer=[_shadowBoxView layer];
    layer.shadowColor=[[UIColor grayColor] CGColor];
    layer.shadowOpacity=1.0f;
    layer.shadowRadius=3.0f;
    layer.shadowOffset=CGSizeMake(0.0f,0.0f);
    

    UIScrollView *scrollView = [self.webView.subviews objectAtIndex:0];
    scrollView.delegate = self;//self must be UIScrollViewDelegate
   

    if([[FISharedResources sharedResourceManager]serviceIsReachable]){
        NSURL *url = [NSURL URLWithString:self.urlString];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
       // self.webView.scalesPageToFit = YES;
        
       // self.webView.scalesPageToFit = NO;
        [self.webView loadRequest:requestObj];
    } else {
        [FIUtils showNoNetworkToast];
    }

    
    _titleString.text=_titleStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Access to form sheet controller
//    MZFormSheetController *controller = self.navigationController.formSheetController;
//    controller.shouldDismissOnBackgroundViewTap = YES;
    
    
    self.navigationController.navigationBarHidden=YES;
    
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
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('footer').style.display = 'none'"];
//    timer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(cancelWeb) userInfo:nil repeats:NO];
//    progressView = [[UCZProgressView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-50, self.view.frame.size.height/2-50, 100, 100)];
//    progressView.translatesAutoresizingMaskIntoConstraints = NO;
//    progressView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:progressView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    //NSLog(@"webViewDidFinishLoad");
    
    [timer invalidate];
    [progressView removeFromSuperview];
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=%d;', false); ", (int)webView.frame.size.width]];
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('footer').style.display = 'none'"];
}




- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return nil;
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
