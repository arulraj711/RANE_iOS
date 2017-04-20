//
//  IssueMonitoringReportPage.m
//  FullIntel
//
//  Created by cape start on 22/09/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "IssueMonitoringReportPage.h"
#import "IssueMonitoringCell.h"
#import "IssueMonitoringOutletCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "IssueMonitoringInfluencerCell.h"
#import "IssueDrillInPage.h"
#import "StoryTableViewCell.h"
#define UIColorFromRGB(rgbValue)[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface IssueMonitoringReportPage ()

@end

@implementation IssueMonitoringReportPage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.resultsLabel.layer.masksToBounds = YES;
    self.resultsLabel.layer.cornerRadius = 40;
    self.resultsLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.resultsLabel.layer.borderWidth = 1;
    
    self.changeLabel.layer.masksToBounds = YES;
    self.changeLabel.layer.cornerRadius = 40;
    self.changeLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.changeLabel.layer.borderWidth = 1;
    
    self.issueTitle.text = self.issueTitleString;
    
    self.storyIndex = 0;
    self.selectedTitle.text = @"Trend of Coverage";
    [self.chartImageView sd_setImageWithURL:[NSURL URLWithString:[self.detailChartImageArray objectAtIndex:0]] placeholderImage:nil];
    self.collectionView.hidden = YES;
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.topStoriesJSONUrl]];
    NSError *error;
    chartStoryList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    [self.storyTableView reloadData];
    self.tableOuterView.layer.borderWidth = 1.0f;
    self.tableOuterView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Open Sans" size:16];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.text =@"Issue Reports";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    isTopStoriesOpen = NO;
    
    [self.trendOfCoverageChartButton setSelected:YES];
    [self.sentimentChartButton setSelected:NO];
    [self.mediaTypeChartButton setSelected:NO];
    [self.topSourcesChartButton setSelected:NO];
    [self.topAuthorsChartButton setSelected:NO];
    [self.topInfluencersChartButton setSelected:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return issueList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   // NSLog(@"collectionview cell for item");
    IssueMonitoringCell *cell = (IssueMonitoringCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.cellOuterView.layer.masksToBounds = YES;
    cell.cellOuterView.layer.cornerRadius = 75;
    cell.cellOuterView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.cellOuterView.layer.borderWidth = 1;
    NSDictionary *issueDic = [issueList objectAtIndex:indexPath.row];

        cell.title.text = [issueDic objectForKey:@"name"];
        cell.cntLabel.text = [issueDic objectForKey:@"count"];

    if([self.selectedItemArray containsObject:[issueDic objectForKey:@"name"]]) {
        cell.cellOuterView.backgroundColor = UIColorFromRGB(0Xebebeb);
        self.selectedTitle.text = [issueDic objectForKey:@"name"];
    } else {
        cell.cellOuterView.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"CI select row");
    [self.selectedItemArray removeAllObjects];
    NSDictionary *issueDic = [issueList objectAtIndex:indexPath.row];
    [self.selectedItemArray addObject:[issueDic objectForKey:@"name"]];
    [self.collectionView reloadData];
    if(indexPath.row == 0) {
        self.storyIndex = 1;
        self.storyTitle.text = @"Top Outlets";
        self.monitoringInfluencerTableView.hidden = YES;
        self.monitoringOutletTableView.hidden = NO;
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://s3.amazonaws.com/s3fullintel.com/fi/iPad_demo/json/outlets.json"]];
        NSError *error;
        monitoringOutletList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSLog(@"issue lis:%@",monitoringOutletList);
        [self.storyTableView reloadData];
    }else if(indexPath.row == 1) {
        self.storyIndex = 2;
        self.storyTitle.text = @"Top Authors";
        self.monitoringOutletTableView.hidden = YES;
        self.monitoringInfluencerTableView.hidden = NO;
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://s3.amazonaws.com/s3fullintel.com/fi/iPad_demo/json/authors.json"]];
        NSError *error;
        monitoringOutletList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSLog(@"issue lis:%@",monitoringOutletList);
        [self.storyTableView reloadData];
    } else if(indexPath.row == 2) {
        self.storyIndex = 2;
        self.storyTitle.text = @"Top Influencers";
        self.monitoringOutletTableView.hidden = YES;
        self.monitoringInfluencerTableView.hidden = NO;
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://s3.amazonaws.com/s3fullintel.com/fi/iPad_demo/json/influencers.json"]];
        NSError *error;
        monitoringOutletList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSLog(@"issue lis:%@",monitoringOutletList);
        [self.storyTableView reloadData];
    } else if(indexPath.row == 3) {
        self.storyIndex = 2;
        self.storyTitle.text = @"Top Friends";
        self.monitoringOutletTableView.hidden = YES;
        self.monitoringInfluencerTableView.hidden = NO;
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://s3.amazonaws.com/s3fullintel.com/fi/iPad_demo/json/friends.json"]];
        NSError *error;
        monitoringOutletList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSLog(@"issue lis:%@",monitoringOutletList);
        [self.storyTableView reloadData];
    } else if(indexPath.row == 4) {
        self.storyIndex = 2;
        self.storyTitle.text = @"Top Foes";
        self.monitoringOutletTableView.hidden = YES;
        self.monitoringInfluencerTableView.hidden = NO;
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://s3.amazonaws.com/s3fullintel.com/fi/iPad_demo/json/foes.json"]];
        NSError *error;
        monitoringOutletList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSLog(@"issue lis:%@",monitoringOutletList);
        [self.storyTableView reloadData];
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int rowCnt = 0;
    if(self.storyIndex == 0) {
        rowCnt = chartStoryList.count;
    } else if(self.storyIndex == 1) {
        rowCnt = monitoringOutletList.count;
    } else if(self.storyIndex == 2){
        rowCnt = monitoringOutletList.count;
    }
    return rowCnt;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoryTableViewCell *cell = (StoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    int cnt = indexPath.row+1;
    cell.numberLabel.text = [NSString stringWithFormat:@"%d",cnt];
    NSDictionary *dic;
    if(self.storyIndex == 0) {
        dic = [chartStoryList objectAtIndex:indexPath.row];
        cell.titleLabel.text = [dic objectForKey:@"title"];
        cell.outletLabel.text = [dic objectForKey:@"outlet"];
    } else if(self.storyIndex == 1) {
        dic = [monitoringOutletList objectAtIndex:indexPath.row];
        cell.titleLabel.text = [dic objectForKey:@"outlet"];
        cell.outletLabel.text = [dic objectForKey:@"articleImageUrl"];
    } else if(self.storyIndex == 2) {
        dic = [monitoringOutletList objectAtIndex:indexPath.row];
        cell.titleLabel.text = [dic objectForKey:@"author"];
        cell.outletLabel.text = [dic objectForKey:@"outlet"];
    }
    
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"CommunicationIssues" bundle:nil];
//    IssueDrillInPage *issuesList = [storyBoard instantiateViewControllerWithIdentifier:@"IssueDrillInPage"];
//    [self.navigationController pushViewController:issuesList animated:YES];
    
}


- (IBAction)trendOfCoverageChartBtnClick:(id)sender {
    [self.trendOfCoverageChartButton setSelected:YES];
    [self.sentimentChartButton setSelected:NO];
    [self.mediaTypeChartButton setSelected:NO];
    [self.topSourcesChartButton setSelected:NO];
    [self.topAuthorsChartButton setSelected:NO];
    [self.topInfluencersChartButton setSelected:NO];
    self.storyIndex = 0;
    self.selectedTitle.text = @"Trend of Coverage";
    self.storyTitle.text = @"Top Stories";
    self.collectionView.hidden = YES;
    [self.chartImageView sd_setImageWithURL:[NSURL URLWithString:[self.detailChartImageArray objectAtIndex:0]] placeholderImage:nil];
    //self.chartImageView.image = [UIImage imageNamed:@"bar_chart"];
//    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/276740356/FullIntel/CI/chart_story.json"]];
//    NSError *error;
//    chartStoryList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    [self.storyTableView reloadData];
}
- (IBAction)topSourcesChartBtnClick:(id)sender {
    [self.trendOfCoverageChartButton setSelected:NO];
    [self.sentimentChartButton setSelected:NO];
    [self.mediaTypeChartButton setSelected:NO];
    [self.topSourcesChartButton setSelected:YES];
    [self.topAuthorsChartButton setSelected:NO];
    [self.topInfluencersChartButton setSelected:NO];
    self.storyIndex = 0;
    self.selectedTitle.text = @"Top Sources";
    self.storyTitle.text = @"Top Stories";
    self.collectionView.hidden = YES;
    [self.chartImageView sd_setImageWithURL:[NSURL URLWithString:[self.detailChartImageArray objectAtIndex:3]] placeholderImage:nil];
    //self.chartImageView.image = [UIImage imageNamed:@"doughnut_chart"];
//    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/276740356/FullIntel/CI/chart_story.json"]];
//    NSError *error;
//    chartStoryList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    [self.storyTableView reloadData];
}
- (IBAction)mediaTypeChartBtnClick:(id)sender {
    [self.trendOfCoverageChartButton setSelected:NO];
    [self.sentimentChartButton setSelected:NO];
    [self.mediaTypeChartButton setSelected:YES];
    [self.topSourcesChartButton setSelected:NO];
    [self.topAuthorsChartButton setSelected:NO];
    [self.topInfluencersChartButton setSelected:NO];
    self.storyIndex = 0;
    self.selectedTitle.text = @"Media Types";
    self.storyTitle.text = @"Top Stories";
    self.collectionView.hidden = YES;
    //self.chartImageView.image = [UIImage imageNamed:@"line_chart"];
    [self.chartImageView sd_setImageWithURL:[NSURL URLWithString:[self.detailChartImageArray objectAtIndex:2]] placeholderImage:nil];
//    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/276740356/FullIntel/CI/chart_story.json"]];
//    NSError *error;
//    chartStoryList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    [self.storyTableView reloadData];
}

- (IBAction)topAuthorsChartBtnClick:(id)sender {
    [self.trendOfCoverageChartButton setSelected:NO];
    [self.sentimentChartButton setSelected:NO];
    [self.mediaTypeChartButton setSelected:NO];
    [self.topSourcesChartButton setSelected:NO];
    [self.topAuthorsChartButton setSelected:YES];
    [self.topInfluencersChartButton setSelected:NO];
    self.storyIndex = 0;
    self.selectedTitle.text = @"Top Authors";
    self.storyTitle.text = @"Top Stories";
    self.collectionView.hidden = YES;
    //self.chartImageView.image = [UIImage imageNamed:@"doughnut_chart"];
    [self.chartImageView sd_setImageWithURL:[NSURL URLWithString:[self.detailChartImageArray objectAtIndex:4]] placeholderImage:nil];
//    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/276740356/FullIntel/CI/chart_story.json"]];
//    NSError *error;
//    chartStoryList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    [self.storyTableView reloadData];
//    [self.trendOfCoverageChartButton setSelected:NO];
//    [self.sentimentChartButton setSelected:NO];
//    [self.mediaTypeChartButton setSelected:NO];
//    [self.topSourcesChartButton setSelected:NO];
//    [self.topAuthorsChartButton setSelected:YES];
//    [self.topInfluencersChartButton setSelected:NO];
//    self.selectedTitle.text = @"";
//    self.collectionView.hidden = NO;
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"issue_list" ofType:@"json"];
//    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
//    NSError *error;
//    issueList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//    NSLog(@"number btn click count:%d",issueList.count);
//    [self.collectionView reloadData];
//    
//    
//    self.selectedItemArray = [[NSMutableArray alloc]init];
//    self.storyIndex = 1;
//    NSData *data1 = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/276740356/FullIntel/CI/outlets.json"]];
//    NSError *error1;
//    monitoringOutletList = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:&error1];
//    NSLog(@"issue lis:%@",monitoringOutletList);
//    [self.selectedItemArray addObject:@"Outlets"];
//    [self.storyTableView reloadData];
//    self.storyTitle.text = @"Top Outlets";
//    NSDictionary *issueDic = [issueList objectAtIndex:0];
//    [self.selectedItemArray addObject:[issueDic objectForKey:@"name"]];
//    [self.collectionView reloadData];
    
}

- (IBAction)sentimentChartBtnClick:(id)sender {
    //UIButton *btn = (UIButton *)sender;
    [self.trendOfCoverageChartButton setSelected:NO];
    [self.sentimentChartButton setSelected:YES];
    [self.mediaTypeChartButton setSelected:NO];
    [self.topSourcesChartButton setSelected:NO];
    [self.topAuthorsChartButton setSelected:NO];
    [self.topInfluencersChartButton setSelected:NO];
    self.storyIndex = 0;
    self.selectedTitle.text = @"Sentiment and Volume Over Time";
    self.storyTitle.text = @"Top Stories";
    self.collectionView.hidden = YES;
    //self.chartImageView.image = [UIImage imageNamed:@"pie_chart"];
    [self.chartImageView sd_setImageWithURL:[NSURL URLWithString:[self.detailChartImageArray objectAtIndex:1]] placeholderImage:nil];
//    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/276740356/FullIntel/CI/chart_story.json"]];
//    NSError *error;
//    chartStoryList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    [self.storyTableView reloadData];
}
- (IBAction)topInfluencersChartBtnClick:(id)sender {
    [self.trendOfCoverageChartButton setSelected:NO];
    [self.sentimentChartButton setSelected:NO];
    [self.mediaTypeChartButton setSelected:NO];
    [self.topSourcesChartButton setSelected:NO];
    [self.topAuthorsChartButton setSelected:NO];
    [self.topInfluencersChartButton setSelected:YES];
    self.storyIndex = 0;
    self.selectedTitle.text = @"Top Influencers";
    self.storyTitle.text = @"Top Stories";
    self.collectionView.hidden = YES;
    //self.chartImageView.image = [UIImage imageNamed:@"doughnut_chart"];
    [self.chartImageView sd_setImageWithURL:[NSURL URLWithString:[self.detailChartImageArray objectAtIndex:5]] placeholderImage:nil];
//    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/276740356/FullIntel/CI/chart_story.json"]];
//    NSError *error;
//    chartStoryList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    [self.storyTableView reloadData];
}

//for iPad
- (IBAction)topStoriesButtonClick:(id)sender {
    
    NSLog(@"constraint:%f",self.topStoriesViewLeadingConstraint.constant);
    if(!isTopStoriesOpen) {
        [UIView animateWithDuration:0.4
                         animations:^{
                             //[self.topStoriesButton setHidden:YES];
                             //[self.topStoriesButton setSelected:YES];
                             self.topStoriesButtonLabelWidthConstraint.constant = 0;
                             self.tableOuterView.layer.borderWidth = 1.0f;
                             self.tableOuterView.layer.borderColor = [UIColor lightGrayColor].CGColor;
                             isTopStoriesOpen = YES;
                             self.topStoriesViewLeadingConstraint.constant = self.view.frame.size.width-320;
                             [self.view layoutIfNeeded];
                             
                             //[self loadChartValuesWithReportType:localReportTypeId];
                             
                             
                         }];
    } else {
        [UIView animateWithDuration:0.4
                         animations:^{
                            // [self.topStoriesButton setHidden:NO];
                             //[self.topStoriesButton setSelected:NO];
                             self.topStoriesButtonLabelWidthConstraint.constant = 9;
                             self.tableOuterView.layer.borderWidth = 0.0f;
                             self.tableOuterView.layer.borderColor = [UIColor lightGrayColor].CGColor;
                             isTopStoriesOpen = NO;
                             self.topStoriesViewLeadingConstraint.constant = self.view.frame.size.width;
                             [self.view layoutIfNeeded];
                             //  [self loadChartValuesWithReportType:localReportTypeId];
                             
                         }];
    }
    
}


@end
