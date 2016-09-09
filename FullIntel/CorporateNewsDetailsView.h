//
//  CorporateNewsDetailsTest.h
//  FullIntel
//
//  Created by Capestart on 5/13/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FISharedResources.h"
#import <MessageUI/MessageUI.h>
#import "WSCoachMarksView.h"
#import "FPPopoverKeyboardResponsiveController.h"
#import "MZFormSheetController.h"

@interface CorporateNewsDetailsView : UIViewController<MFMailComposeViewControllerDelegate,UIViewControllerTransitioningDelegate,UICollectionViewDataSource,UICollectionViewDelegate,WSCoachMarksViewDelegate,UIWebViewDelegate,MZFormSheetBackgroundWindowDelegate> {
    NSTimer *oneSecondTicker;
    NSManagedObject *curatedNewsDetail;
    NSManagedObject *curatedNewsAuthorDetail;
    MFMailComposeViewController *mailComposer;
    UIView *innerWebView;
    UIActivityIndicatorView *activityIndicator;
    NSString *mailArticleId;
    NSString *mailTitle;
    NSString *mailBody;
    NSArray *coachMarks;
    WSCoachMarksView *coachMarksView;
    CGSize scrollViewSize;
    NSString *overallAuthorDetail;
    NSString *overallAuthorDetailOne;
    FPPopoverKeyboardResponsiveController *popover;
    MZFormSheetController *formSheet;


}
@property BOOL callAPIFromDrillIn;
@property NSNumber *companyIdInDetailPage;
@property (nonatomic,strong) NSString *articleTitle;
@property NSString *selectedNewsArticleId;
@property NSIndexPath *selectedIndexPath;
@property (nonatomic,strong) NSMutableArray *socialLinksArray;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *articleIdArray;
@property (nonatomic) int currentIndex;
@property (nonatomic) int isSearching;
@property (nonatomic) int switchForFilter;
@property (nonatomic) NSString * searchText;
@property (strong, nonatomic) NSNumber *forTopStories;
@property (nonatomic,strong) NSNumber *isFromChart;
@property (nonatomic, strong) NSMutableArray *articleIdFromSearchLst;

@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) int selectedIndex;
-(void)getArticleIdListFromDB;
@property (weak,nonatomic) IBOutlet UITextView *tutorialTextView;
@property (weak,nonatomic) IBOutlet UIView *tutorialTextBoxView;


//get the report type from chart
@property (nonatomic,strong) NSNumber *reportTypeId;
@property (nonatomic,strong) NSString *reportModules;
@property (nonatomic,strong) NSString *reportTags;

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
