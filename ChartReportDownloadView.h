//
//  ChartReportDownloadView.h
//  FullIntel
//
//  Created by CapeStart Apple on 4/25/16.
//  Copyright © 2016 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartReportDownloadView : UIViewController<UIDocumentInteractionControllerDelegate> {
    NSString *reportDownloadUrlString;
    NSString *filePathUrl;
}
@property UIDocumentInteractionController *documentInteractionController;
@property (weak, nonatomic) IBOutlet UIWebView *reportWebView;
@property NSNumber *reportId;
@end
