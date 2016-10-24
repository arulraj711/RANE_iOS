//
//  IssueMonitoringReportPage.h
//  FullIntel
//
//  Created by cape start on 22/09/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IssueMonitoringReportPage : UIViewController<UICollectionViewDelegate,UITableViewDataSource> {
    NSArray *monitoringOutletList;
    NSArray *chartStoryList,*issueList;
    BOOL isTopStoriesOpen;
}
@property (weak, nonatomic) IBOutlet UILabel *issueTitle;
@property (weak, nonatomic) IBOutlet UIButton *trendOfCoverageChartButton;
@property (weak, nonatomic) IBOutlet UIButton *sentimentChartButton;
@property (weak, nonatomic) IBOutlet UIButton *mediaTypeChartButton;
@property (weak, nonatomic) IBOutlet UIButton *topSourcesChartButton;
@property (weak, nonatomic) IBOutlet UIButton *topAuthorsChartButton;
@property (weak, nonatomic) IBOutlet UIButton *topInfluencersChartButton;
@property (weak, nonatomic) IBOutlet UIButton *topStoriesButton;
@property (nonatomic,strong) NSString *issueTitleString;
@property (nonatomic,strong) NSString *topStoriesJSONUrl;
@property (weak, nonatomic) IBOutlet UILabel *selectedTitle;

@property (nonatomic,strong) NSMutableArray *detailChartImageArray;
@property (weak, nonatomic) IBOutlet UIImageView *chartImageView;
@property NSInteger storyIndex;
@property (weak, nonatomic) IBOutlet UIView *tableOuterView;

@property (weak, nonatomic) IBOutlet UILabel *storyTitle;
@property (weak, nonatomic) IBOutlet UITableView *monitoringOutletTableView;
@property (weak, nonatomic) IBOutlet UITableView *monitoringInfluencerTableView;
@property (weak, nonatomic) IBOutlet UITableView *storyTableView;
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIWebView *detailsWebview;
@property NSMutableArray *selectedItemArray;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topStoriesViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topStoriesWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topStoriesButtonLabelWidthConstraint;

- (IBAction)trendOfCoverageChartBtnClick:(id)sender;
- (IBAction)sentimentChartBtnClick:(id)sender;
- (IBAction)mediaTypeChartBtnClick:(id)sender;
- (IBAction)topSourcesChartBtnClick:(id)sender;
- (IBAction)topAuthorsChartBtnClick:(id)sender;
- (IBAction)topInfluencersChartBtnClick:(id)sender;
//iPad methods
- (IBAction)topStoriesButtonClick:(id)sender;

@end
