//
//  ChartReportDownloadView.m
//  FullIntel
//
//  Created by CapeStart Apple on 4/25/16.
//  Copyright © 2016 CapeStart. All rights reserved.
//

#import "ChartReportDownloadView.h"

@implementation ChartReportDownloadView

- (void)viewDidLoad {

    NSString *companyId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"customerId"]];
    NSString *securityToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"]];
    
    reportDownloadUrlString = [NSString stringWithFormat:@"http://fullintel.com/1.4.1/api/v1/companies/%@/analysis/report/%@/export/ppt?security_token=%@",companyId,self.reportId,securityToken];
    
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
    
    NSString *pathFloder = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@",@"new.ppt"]];
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


@end
