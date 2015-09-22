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
#import "IssueMonitoringReportPage.h"
@interface IssuesResultListPage ()

@end

@implementation IssuesResultListPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CorporateNewsCell *cell = (CorporateNewsCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    return cell;
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
