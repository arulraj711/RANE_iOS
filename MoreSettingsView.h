//
//  MoreSettingsView.h
//  FullIntel
//
//  Created by Arul on 3/20/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MoreSettingsView : UIViewController<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *moreTableView;
@property (nonatomic,strong) NSMutableArray *moreInforArray;
@property (nonatomic,strong) NSString *articleTitle;
- (IBAction)requestButtonClick:(id)sender;
@property (nonatomic,strong) NSString *articleImageUrl;
@property (nonatomic,strong) NSString *articleUrl;
@property (nonatomic,strong) NSString *articleDesc;
@property (nonatomic,strong) NSString *articleId;
@property (nonatomic,strong) UIButton *buttonName;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableXConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableYConstraint;
@property CGFloat xPositions;
@property CGFloat yPositions;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableWidthConstraint;
@property CGFloat buttonWidth;
@property CGFloat buttonHeight;
@property (strong)  NSIndexPath* lastIndexPath;
@property (strong, nonatomic) IBOutlet UIView *droperView;

@property NSInteger dropDownValue;
@end
