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
#import "UIColor+CustomColor.h"
#import "UILabel+CustomHeaderLabel.h"
#import "UIImage+CustomNavIconImage.h"

@interface SocialWebView ()

@end

@implementation SocialWebView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
  //  NSString *fullURL = @"http://conecode.com";
//    NSString *headerColor = [[NSUserDefaults standardUserDefaults]objectForKey:@"headerColor"];
//    NSString *stringWithoutSpaces = [headerColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
    [self.outerView setBackgroundColor:[UIColor headerBackgroundColor]];
   
    self.outerView.layer.masksToBounds = YES;
    self.outerView.layer.cornerRadius = 10;
    
    
    
    CALayer *layer=[_shadowBoxView layer];
    layer.shadowColor=[[UIColor grayColor] CGColor];
    layer.shadowOpacity=1.0f;
    layer.shadowRadius=3.0f;
    layer.shadowOffset=CGSizeMake(0.0f,0.0f);
    
    [self.closeButton setBackgroundImage:[UIImage createCustomNavIconFromImage:@"close"] forState:UIControlStateNormal];

    
//    UIScrollView *scrollView = [self.webView.subviews objectAtIndex:0];
//    scrollView.delegate = self;//self must be UIScrollViewDelegate
   
    NSLog(@"social view url string:%@",self.urlString);
    
    if([[FISharedResources sharedResourceManager]serviceIsReachable]){
        NSURL *url = [NSURL URLWithString:self.urlString];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
       // self.webView.scalesPageToFit = YES;
        
       // self.webView.scalesPageToFit = NO;
        [self.webView loadRequest:requestObj];
    } else {
        //[FIUtils showNoNetworkToast];
        UIWindow *window = [[UIApplication sharedApplication]windows][0];
        NSArray *subViewArray = [window subviews];
        //NSLog(@"subview array count:%d",subViewArray.count);
        if(subViewArray.count == 1) {
            [[FISharedResources sharedResourceManager] showBannerView];
        }
    }

    
    //[self.titleString addSubview:[UILabel setCustomHeaderLabelFromText:self.titleStr]];
    
    _titleString.backgroundColor = [UIColor clearColor];
    _titleString.font = [UIFont fontWithName:@"Open Sans" size:16];
    // label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    _titleString.text =_titleStr;
    _titleString.textAlignment = NSTextAlignmentCenter;
    _titleString.textColor = [UIColor headerTextColor];
    
    myProgressView.progress = 0;
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
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
    } else {
        self.navigationController.navigationBarHidden=YES;
    }
    
    
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
    
    myProgressView.progress = 0;
    theBool = false;
    //0.01667 is roughly 1/60, so it will update at 60 FPS
    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.1667 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('footer').style.display = 'none'"];
//    timer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(cancelWeb) userInfo:nil repeats:NO];
//    progressView = [[UCZProgressView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-50, self.view.frame.size.height/2-50, 100, 100)];
//    progressView.translatesAutoresizingMaskIntoConstraints = NO;
//    progressView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:progressView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    //NSLog(@"webViewDidFinishLoad");
    theBool = true;
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



-(void)timerCallback {
    if (theBool) {
        if (myProgressView.progress >= 1) {
            myProgressView.hidden = true;
            [myTimer invalidate];
        }
        else {
            myProgressView.progress += 0.1;
        }
    }
    else {
        myProgressView.progress += 0.01;
        if (myProgressView.progress >= 0.95) {
            myProgressView.progress = 0.95;
        }
    }
}

@end
