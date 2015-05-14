//
//  ShowDetailView.h
//  FullIntel
//
//  Created by Capestart on 5/5/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowDetailView : UIViewController
@property (nonatomic,strong) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end
