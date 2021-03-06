//
//  MorePopoverView.h
//  FullIntel
//
//  Created by Arul on 3/20/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MorePopoverView : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *moreTableView;
@property (nonatomic,strong) NSMutableArray *moreInforArray;
@property (nonatomic,strong) NSString *articleTitle;
@property (nonatomic,strong) NSString *articleImageUrl;
@property (nonatomic,strong) NSString *articleUrl;
@end
