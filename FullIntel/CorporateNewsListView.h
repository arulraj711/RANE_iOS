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
#import "PKRevealController.h"
#import "FPPopoverController.h"
@interface CorporateNewsListView : UIViewController<MZFormSheetBackgroundWindowDelegate,UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate,WSCoachMarksViewDelegate,UIGestureRecognizerDelegate, UISearchBarDelegate, UISearchControllerDelegate,UISearchDisplayDelegate,PanDelegate,FPPopoverControllerDelegate> {
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
    FPPopoverController *popover;
    UIButton *Btns;
    UIButton *navBtn;
    UIButton *searchButtons;
    UIButton *CancelButton;
    UIButton *selectAll;
    UIBarButtonItem *markAsReadButton;
    UIBarButtonItem *addTofolder;
    UIToolbar *toolbar;
    BOOL longPressActive;
    BOOL tickImageStatus;

    int switchForFilter;
    int isSearchingInteger;
    
    BOOL isSearching;
    UISearchBar *searchBar;
    NSMutableArray *articleIdToBePassed;
    
    UIView* accessoryView;
    UIImageView* accessoryViewImage;

    NSMutableArray *selectedCells;
    NSMutableArray *articleIdArray;
    CGFloat yPostionOfTOolbar;
    int flagForToolbar;
}
-(void)showLoginPage;
-(void)loadCuratedNews;
@property BOOL isNewsLetterNav;
@property BOOL isStarting;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *articleTableViewHeightConstraint;
@property NSString *selectedNewsLetterArticleId;
@property (nonatomic,strong) UIPopoverController *popOver;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *corporateListWidthConstraint;
- (IBAction)filterButtonClick:(id)sender;
- (IBAction)actionsButtonClick:(id)sender;
@property(strong, nonatomic) UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *horizontalSpacing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpacing;
- (IBAction)segmentControlAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UITableView *articlesTableView;
@property (nonatomic,strong) NSNumber *categoryId;
@property (strong) NSMutableArray *devices;
@property BOOL isLeftClick;
@property (nonatomic,strong) NSString *titleName;
@property (nonatomic,strong) IBOutlet UIButton *actionButton;
@property (nonatomic,strong) IBOutlet UIButton *filterButton;
@property NSMutableArray *filterArray;
@property (weak, nonatomic) IBOutlet UIView *topView;
@end
