//
//  SocialWebView.h
//  FullIntel
//
//  Created by Capestart on 4/23/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCZProgressView.h"

@interface SocialWebView : UIViewController<UIScrollViewDelegate> {
    UCZProgressView *progressView;
    NSTimer *timer;
    IBOutlet UIProgressView* myProgressView;
    BOOL theBool;
    NSTimer *myTimer;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)closeAction:(id)sender;
@property (nonatomic,strong) NSString *urlString;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;

@property (nonatomic,strong) NSString *titleStr;

@property (weak, nonatomic) IBOutlet UILabel *titleString;
@property (weak, nonatomic) IBOutlet UIView *outerView;


@property (weak, nonatomic) IBOutlet UIView *shadowBoxView;


@end
