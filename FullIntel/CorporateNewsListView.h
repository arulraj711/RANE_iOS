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
#import "Localytics.h"
#import "NIDropDown.h"
@interface CorporateNewsListView : UIViewController<MZFormSheetBackgroundWindowDelegate,UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate,WSCoachMarksViewDelegate,UIViewControllerTransitioningDelegate,NIDropDownDelegate> {
    NSMutableArray *legendsList;
    NSManagedObject *author;
    UIRefreshControl *refreshControl;
     MZFormSheetController *formSheet;
    UIActivityIndicatorView *activityIndicator;
    NSInteger rowCount;
    NSString *messageString;
    MFMailComposeViewController *mailComposer;
    UIView *overlayView;
    NIDropDown *dropDown;
    WSCoachMarksView *coachMarksView;
    NSArray *coachMarks;
    NSTimer *popAnimationTimer;
}
@property (weak, nonatomic) IBOutlet UIButton *actionsButton;
- (IBAction)actionsButtonClick:(id)sender;
- (IBAction)showButtonClick:(id)sender;
@property BOOL isFilterSelected;
@property (weak, nonatomic) IBOutlet UIButton *showButton;
-(void)updateNewsTitle;
-(void)loadCuratedNews;
@property BOOL isStarting;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *corporateListWidthConstraint;
@property(strong, nonatomic) UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *horizontalSpacing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpacing;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UITableView *articlesTableView;
@property (nonatomic,strong) NSNumber *categoryId;
@property (strong) NSMutableArray *devices;
@property (nonatomic,strong) NSString *titleName;

-(void)fetchNewDataWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;
@end
