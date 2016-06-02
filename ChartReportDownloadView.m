//
//  ChartReportDownloadView.m
//  FullIntel
//
//  Created by CapeStart Apple on 4/25/16.
//  Copyright © 2016 CapeStart. All rights reserved.
//

#import "ChartReportDownloadView.h"
#import "FIWebService.h"
#import "UILabel+CustomHeaderLabel.h"


@implementation ChartReportDownloadView

- (void)viewDidLoad {

//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
//    label.backgroundColor = [UIColor clearColor];
//    label.font = [UIFont fontWithName:@"Open Sans" size:16];
//    // label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
//    label.text = self.reportTitle;
//    label.textAlignment = NSTextAlignmentCenter;
//    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = [UILabel setCustomHeaderLabelFromText:self.reportTitle];
    
    
    
    NSString *companyId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"customerId"]];
    NSString *securityToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"]];
    
    reportDownloadUrlString = [NSString stringWithFormat:@"%@/api/v1/companies/%@/analysis/report/%@/export/ppt?security_token=%@&exportas=ppt",[FIWebService getServerURL],companyId,self.reportId,securityToken];
    NSLog(@"server url:%@",[FIWebService getServerURL]);
    NSLog(@"report download url:%@",reportDownloadUrlString);
    self.reportWebView.scalesPageToFit = YES;

    [self.reportWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:reportDownloadUrlString]]];
    
    
    UIView *reportDownloadBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIButton *reportDownloadButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [reportDownloadButton setImage:[UIImage imageNamed:@"share_selected"] forState:UIControlStateSelected];
    [reportDownloadButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    //[rssButton setImageEdgeInsets:UIEdgeInsetsMake(0,62,0,0)];
//    [reportDownloadButton setTitle:@"Download" forState:UIControlStateNormal];
//    [reportDownloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    reportDownloadButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:14];
//    [reportDownloadButton setTitleEdgeInsets: UIEdgeInsetsMake(0,0,0,20)];
    [reportDownloadButton addTarget:self action:@selector(downloadReport:) forControlEvents:UIControlEventTouchUpInside];
    [reportDownloadBtnView addSubview:reportDownloadButton];
    UIBarButtonItem *downloadButton = [[UIBarButtonItem alloc] initWithCustomView:reportDownloadBtnView];
    
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:downloadButton, nil]];
}

-(void)downloadReport:(UIButton *)button {
    [button setSelected:YES];
    NSURL *theRessourcesURL = [NSURL URLWithString:reportDownloadUrlString];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"%@",paths);
    
    NSString *pathFloder = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@.ppt",@"Analysis_Report"]];
    NSString *defaultDBPath = [documentsDirectory stringByAppendingPathComponent:pathFloder];
    NSLog(@"default path:%@",defaultDBPath);
    NSData *tmp = [NSData dataWithContentsOfURL:theRessourcesURL];
    
    [tmp writeToFile:defaultDBPath atomically:YES];
    
    filePathUrl = [NSString stringWithFormat:@"file://%@",defaultDBPath];
    NSLog(@"file path url:%@",filePathUrl);
    
    
    NSURL *URL = [NSURL URLWithString:filePathUrl];
    NSLog(@"url:%@",URL);
    
    
    self.documentInteractionController.delegate = self;
    //self.documentationInteractionController.UTI = @"net.whatsapp.image";
    self.documentInteractionController = [self setupControllerWithURL:URL usingDelegate:self];
    //[self.documentInteractionController presentOpenInMenuFromRect:CGRectMake(self.view.frame.size.width-30, 44, button.frame.size.width, button.frame.size.height) inView:self.view animated:YES];
    [self.documentInteractionController presentOpenInMenuFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
    
    
    
    
    
//    if (URL) {
//        // Initialize Document Interaction Controller
//        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:URL];
//        
//        // Configure Document Interaction Controller
//        [self.documentInteractionController setDelegate:self];
//        
//        // Present Open In Menu
//        [self.documentInteractionController presentPreviewAnimated:YES];
//    }
}

- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL

                                               usingDelegate: (id ) interactionDelegate {
    self.documentInteractionController =
    
    [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    
    self.documentInteractionController.delegate = interactionDelegate;
    return self.documentInteractionController;
    
}



- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    return self;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    myProgressView.progress = 0;
    theBool = false;
    //0.01667 is roughly 1/60, so it will update at 60 FPS
    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.1667 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    theBool = true;
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
        myProgressView.progress += 0.02;
        if (myProgressView.progress >= 0.95) {
            myProgressView.progress = 0.95;
        }
    }
}


@end
