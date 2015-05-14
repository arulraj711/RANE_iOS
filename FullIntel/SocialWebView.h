//
//  SocialWebView.h
//  FullIntel
//
//  Created by Capestart on 4/23/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCZProgressView.h"

@interface SocialWebView : UIViewController {
    UCZProgressView *progressView;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)closeAction:(id)sender;
@property (nonatomic,strong) NSString *urlString;


@end
