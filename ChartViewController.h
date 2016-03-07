//
//  ChartViewController.h
//  FullIntel
//
//  Created by cape start on 24/02/16.
//  Copyright © 2016 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FullIntel-Bridging-Header.h"
#import "ChartIconCell.h"
#import "pop.h"
#import "TopStoriesViewController.h"
#import "CMPopTipView.h"
#import "UIView+Toast.h"
#import "ReportObject.h"
@interface ChartViewController : UIViewController<ChartViewDelegate,CMPopTipViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSArray *monthArray;
    NSArray *ValueArray;
    //int typeOfChart;
    CGFloat widthOfChartViewOutline;
    CGFloat heightOfChartViewOutline;
    NSArray *ValueArrayTwo;
    NSMutableArray *chartIcon,*selectedChatIcon;
    NSMutableArray *chartName;
    
    PieChartView *pieViews;
    BarChartView *barViews;
    LineChartView *lineChartView;
    
    CMPopTipView *popTipView;
    ReportObject *reportObject;
    NSArray *xInputForMonths;
    int oh;
    
    //for iPad
    NSArray *chartStoryList;
    BOOL isTopStoriesOpen;
    int selectedChartIndex;

}

@property (strong, nonatomic) IBOutlet UIView *chartViewOutline;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

//common methods
- (IBAction)savecharttodevice:(id)sender;
- (IBAction)infoButtonClick:(id)sender;

//iPad methods
- (IBAction)topStoriesButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topStoriesWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topStoriesButtonLabelWidthConstraint;
@property (weak, nonatomic) IBOutlet UICollectionView *chartIconCollectionView;
@property (weak, nonatomic) IBOutlet UIView *tableOuterView;
@property (weak, nonatomic) IBOutlet UILabel *chartNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *topStoriesButton;
@property (weak, nonatomic) IBOutlet UITableView *storyTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topStoriesViewLeadingConstraint;

@property (nonatomic,strong) NSNumber *reportId;

@end

