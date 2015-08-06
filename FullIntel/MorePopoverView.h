//
//  MorePopoverView.h
//  FullIntel
//
//  Created by Arul on 3/20/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@interface MorePopoverView : UIViewController<FBSDKLoginButtonDelegate>
@property (weak, nonatomic) IBOutlet UITableView *moreTableView;
@property (nonatomic,strong) NSMutableArray *moreInforArray;
@property (nonatomic,strong) NSString *articleTitle;
- (IBAction)requestButtonClick:(id)sender;
@property (nonatomic,strong) NSString *articleImageUrl;
@property (nonatomic,strong) NSString *articleUrl;
@property (nonatomic,strong) NSString *articleDesc;
@end
