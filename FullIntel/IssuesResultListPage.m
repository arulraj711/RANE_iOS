//
//  IssuesResultListPage.m
//  FullIntel
//
//  Created by cape start on 22/09/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "IssuesResultListPage.h"
#import "CorporateNewsCell.h"
#import "IssueOverViewPage.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "IssueMonitoringReportPage.h"
#import "IssueListCell.h"
#import "IssueDrillInPage.h"
#import "IssueMonitoringCell.h"
#define UIColorFromRGB(rgbValue)[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface IssuesResultListPage ()

@end

@implementation IssuesResultListPage

- (void)viewDidLoad {
    [super viewDidLoad];
    //For setting issue title and description
    self.issueTitle.text = self.issueTitleString;
    self.issueDescription.text = self.issueDescriptionString;
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated {
    
    
    
    //For setting main chart images
    [self.chartImage1 sd_setImageWithURL:[NSURL URLWithString:[self.mainChartImageArray objectAtIndex:0]] placeholderImage:nil];
    [self.chartImage2 sd_setImageWithURL:[NSURL URLWithString:[self.mainChartImageArray objectAtIndex:1]] placeholderImage:nil];
    [self.chartImage3 sd_setImageWithURL:[NSURL URLWithString:[self.mainChartImageArray objectAtIndex:2]] placeholderImage:nil];
    
//    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/276740356/FullIntel/CI/CI_SubChartType.json"]];
//    NSError *error;
//    issueList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//    NSLog(@"issue lis:%@",issueList);
    //[self.issueListTableView reloadData];
    //[self.collectionView reloadData];
    
    
    NSData *data1 = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.articleListUrl]];
    NSError *error1;
    articleList = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:&error1];
    NSLog(@"issue lis:%@",articleList);
    [self.issueListTableView reloadData];
    //[self.collectionView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return articleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IssueListCell *cell = (IssueListCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSDictionary *issueDic = [articleList objectAtIndex:indexPath.row];
    NSLog(@"issue title:%@",[issueDic objectForKey:@"title"]);
    cell.articleTitle.text = [issueDic objectForKey:@"title"];
    [cell.articleImage sd_setImageWithURL:[NSURL URLWithString:[issueDic valueForKey:@"articleImageUrl"]] placeholderImage:[UIImage imageNamed:@"FI"]];
    [cell.articleImage setContentMode:UIViewContentModeScaleAspectFill];
    cell.articleData.text = [issueDic objectForKey:@"date"];
    cell.articleOutlet.text =  [issueDic objectForKey:@"outlet"];
    cell.articleAuthor.text = [issueDic objectForKey:@"author"];
    cell.articleDesc.text = [issueDic objectForKey:@"desc"];
    cell.contentView.alpha = 1.0f;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"CommunicationIssues" bundle:nil];
    IssueDrillInPage *issuesList = [storyBoard instantiateViewControllerWithIdentifier:@"IssueDrillInPage"];
    [self.navigationController pushViewController:issuesList animated:YES];
    
}

/* CollectionView datasource */
 -(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
 return 1;
 }
 
 -(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
 return issueList.count;
 }
 
 -(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
 // NSLog(@"collectionview cell for item");
 IssueMonitoringCell *cell = (IssueMonitoringCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
 
// cell.cellOuterView.layer.masksToBounds = YES;
// cell.cellOuterView.layer.cornerRadius = 60;
// cell.cellOuterView.layer.borderColor = [UIColor lightGrayColor].CGColor;
// cell.cellOuterView.layer.borderWidth = 1;
 NSDictionary *issueDic = [issueList objectAtIndex:indexPath.row];
 
 cell.title.text = [issueDic objectForKey:@"name"];
 cell.cntLabel.text = [issueDic objectForKey:@"count"];
 
 //if([self.selectedItemArray containsObject:[issueDic objectForKey:@"name"]]) {
 //cell.cellOuterView.backgroundColor = UIColorFromRGB(0Xebebeb);
[cell.imageView sd_setImageWithURL:[NSURL URLWithString:[self.subChartImageArray objectAtIndex:indexPath.row]] placeholderImage:nil];
// self.selectedTitle.text = [issueDic objectForKey:@"name"];
// } else {
// cell.cellOuterView.backgroundColor = [UIColor whiteColor];
// }
 return cell;
 }

- (IBAction)overviewButtonClick:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"CommunicationIssues" bundle:nil];
    IssueOverViewPage *overviewPage = [storyBoard instantiateViewControllerWithIdentifier:@"IssueOverView"];
    overviewPage.overviewImageUrl = self.overviewImageUrl;
    [self.navigationController pushViewController:overviewPage animated:YES];

}

- (IBAction)monitoringReportButtonClick:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"CommunicationIssues" bundle:nil];
    IssueMonitoringReportPage *monitoringReportPage = [storyBoard instantiateViewControllerWithIdentifier:@"IssueMonitoringReport"];
    monitoringReportPage.issueTitleString = self.issueTitleString;
    monitoringReportPage.detailChartImageArray = self.detailChartImageArray;
    monitoringReportPage.topStoriesJSONUrl = self.topStoriesJSONUrl;
    [self.navigationController pushViewController:monitoringReportPage animated:YES];

}
@end
