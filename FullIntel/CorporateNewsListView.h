//
//  CorporateNewsListView.h
//  FullIntel
//
//  Created by Arul on 3/18/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FISharedResources.h"
#import "MZFormSheetController.h"
#import <MessageUI/MessageUI.h>
#import "WSCoachMarksView.h"

@interface CorporateNewsListView : UIViewController<MZFormSheetBackgroundWindowDelegate,UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate,WSCoachMarksViewDelegate,UIGestureRecognizerDelegate, UISearchBarDelegate, UISearchControllerDelegate,UISearchDisplayDelegate> {
    WSCoachMarksView *coachMarksView;
    NSMutableArray *legendsList;
    NSManagedObject *author;
    UIRefreshControl *refreshControl;
    MZFormSheetController *formSheet;
    UIActivityIndicatorView *activityIndicator;
    NSInteger rowCount;
    NSString *messageString;
    MFMailComposeViewController *mailComposer;
    NSTimer *popAnimationTimerTwo,*popAnimationTimer;
    UIButton *Btns;
    UIButton *searchButtons;
    UIView *searchbarView;
    
    int switchForUnread;
    
    NSMutableArray *filteredContentList;
    BOOL isSearching;
    UISearchBar *searchBar;

}
-(void)showLoginPage;
-(void)loadCuratedNews;
@property BOOL isNewsLetterNav;
@property BOOL isStarting;
@property NSString *selectedNewsLetterArticleId;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *corporateListWidthConstraint;
@property(strong, nonatomic) UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *horizontalSpacing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpacing;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UITableView *articlesTableView;
@property (nonatomic,strong) NSNumber *categoryId;
@property (strong) NSMutableArray *devices;
@property BOOL isLeftClick;
@property (nonatomic,strong) NSString *titleName;
@end
