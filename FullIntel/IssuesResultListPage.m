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
@interface IssuesResultListPage ()

@end

@implementation IssuesResultListPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //https://dl.dropboxusercontent.com/u/184003479/fullIntel/JSONS/CI/first_list_view.json
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated {
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/276740356/FullIntel/CI/first_list_view.json"]];
    NSError *error;
    issueList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"issue lis:%@",issueList);
    [self.issueListTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return issueList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IssueListCell *cell = (IssueListCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSDictionary *issueDic = [issueList objectAtIndex:indexPath.row];
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

- (IBAction)overviewButtonClick:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"CommunicationIssues" bundle:nil];
    IssueOverViewPage *overviewPage = [storyBoard instantiateViewControllerWithIdentifier:@"IssueOverView"];
    [self.navigationController pushViewController:overviewPage animated:YES];

}

- (IBAction)monitoringReportButtonClick:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"CommunicationIssues" bundle:nil];
    IssueMonitoringReportPage *monitoringReportPage = [storyBoard instantiateViewControllerWithIdentifier:@"IssueMonitoringReport"];
    [self.navigationController pushViewController:monitoringReportPage animated:YES];

}
@end
