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
    BOOL isFromChart;
    int switchForFilter;
    int isSearchingInteger;
    
    BOOL isSearching;
    UISearchBar *searchBar;
    NSMutableArray *articleIdToBePassed;
    
    UIView* accessoryView;
    UIImageView* accessoryViewImage;
    CGFloat currentOffset;
    NSMutableArray *selectedCells;
    NSMutableArray *articleIdArray;
    CGFloat yPostionOfTOolbar;
    int flagForToolbar;
}
-(void)showLoginPage;
-(void)loadCuratedNews;
@property BOOL isNewsLetterNav;
@property BOOL isStarting;
@property NSString *selectedNewsLetterArticleId;
@property (nonatomic,strong) UIPopoverController *popOver;
@property (weak, nonatomic) IBOutlet UILabel *mediaAnalysisArticleCountText;
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
@property NSNumber *mediaAnalysisArticleCount;
//get the report type from chart
@property (nonatomic,strong) NSNumber *reportTypeId;

//get the trend of coverage input from chart selection
@property (nonatomic,strong) NSString *clickedDate;
@property (nonatomic,strong) NSString *trendOfCoverageEndDateIn;
@property (nonatomic,strong) NSNumber *reportFromDate;
@property (nonatomic,strong) NSNumber *reportToDate;

//get key topics input from chart selection
@property (nonatomic,strong) NSString *keyTopicsBrandName;
@property (nonatomic,strong) NSString *mediaTypesBrandName;

//get sentiment and volume over time chart selection
@property (nonatomic,strong) NSString *sentimentChartTonalityValue;
@property (nonatomic,strong) NSString *sentimentChartSelectedName;

//get change over last quarter chart selection info
@property (nonatomic,strong) NSString *changeOverSelectedValue;

//get horizontal chart selction info
@property (nonatomic,strong) NSString *horizontalBarChartTonalityValue;
@property (nonatomic,strong) NSString *horizontalBarChartSelectedValue;
@end
