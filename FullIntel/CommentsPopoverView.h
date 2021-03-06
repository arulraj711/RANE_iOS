//
//  CommentsPopoverView.h
//  FullIntel
//
//  Created by Arul on 3/19/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsPopoverView : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *commentsArray;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,strong) IBOutlet UITableView *commentsTableView;
@property (nonatomic,strong) NSString *articleId;
@property (nonatomic,strong) IBOutlet UIView *textBackView;
@end
