//
//  NewsLetterViewController.h
//  FullIntel
//
//  Created by Prabhu on 30/06/1937 SAKA.
//  Copyright (c) 1937 SAKA CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKRevealController.h"
@interface NewsLetterViewController : UIViewController<UITableViewDelegate,PanDelegate,UIGestureRecognizerDelegate> {
    NSMutableArray *newsLetterArray;
    UIActivityIndicatorView *activityIndicator;
}
@property NSNumber *newsletterId;
@property NSString *newsletterArticleId;
@property (weak, nonatomic) IBOutlet UITableView *newsListTableView;
@end
