//
//  IssuesResultListPage.h
//  FullIntel
//
//  Created by cape start on 22/09/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IssuesResultListPage : UIViewController {
    NSArray *issueList;
    NSArray *articleList;
}
@property (weak, nonatomic) IBOutlet UITextView *issueDescription;
@property (weak, nonatomic) IBOutlet UILabel *issueTitle;
@property (weak, nonatomic) IBOutlet UITableView *issueListTableView;
- (IBAction)overviewButtonClick:(id)sender;
- (IBAction)monitoringReportButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *chartImage1;
@property (weak, nonatomic) IBOutlet UIImageView *chartImage2;
@property (weak, nonatomic) IBOutlet UIImageView *chartImage3;
@property (nonatomic,strong) NSMutableArray *mainChartImageArray;
@property (nonatomic,strong) NSMutableArray *subChartImageArray;
@property (nonatomic,strong) NSMutableArray *detailChartImageArray;
@property (nonatomic,strong) NSString *issueTitleString;
@property (nonatomic,strong) NSString *issueDescriptionString;
@property (nonatomic,strong) NSString *articleListUrl;
@property (nonatomic,strong) NSString *topStoriesJSONUrl;
@property (nonatomic,strong) NSString *overviewImageUrl;
@end
