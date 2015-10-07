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
}
@property (weak, nonatomic) IBOutlet UIButton *barChartButton;
@property (weak, nonatomic) IBOutlet UIButton *pieChartButton;
@property (weak, nonatomic) IBOutlet UIButton *lineChartButton;
@property (weak, nonatomic) IBOutlet UIButton *doughChartButton;
@property (weak, nonatomic) IBOutlet UIButton *numberButton;

- (IBAction)doughnetChartBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *selectedTitle;
- (IBAction)lineChartBtnClick:(id)sender;
- (IBAction)numberBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *chartImageView;
@property NSInteger storyIndex;
@property (weak, nonatomic) IBOutlet UIView *tableOuterView;
- (IBAction)pieChartBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *storyTitle;
@property (weak, nonatomic) IBOutlet UITableView *monitoringOutletTableView;
@property (weak, nonatomic) IBOutlet UITableView *monitoringInfluencerTableView;
- (IBAction)barChartBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *storyTableView;
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIWebView *detailsWebview;
@property NSMutableArray *selectedItemArray;
@end
