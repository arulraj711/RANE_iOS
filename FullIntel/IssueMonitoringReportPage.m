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
@interface IssueMonitoringReportPage ()

@end

@implementation IssueMonitoringReportPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"index_1" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [self.detailsWebview loadHTMLString:htmlString baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    
    self.monitoringInfluencerTableView.hidden = YES;
    self.monitoringOutletTableView.hidden = NO;
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/276740356/FullIntel/CI/outlets.json"]];
    NSError *error;
    monitoringOutletList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"issue lis:%@",monitoringOutletList);
    [self.monitoringOutletTableView reloadData];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}




-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IssueMonitoringCell *cell = (IssueMonitoringCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.cellOuterView.layer.masksToBounds = YES;
    cell.cellOuterView.layer.cornerRadius = 75;
    cell.cellOuterView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.cellOuterView.layer.borderWidth = 1;
    if(indexPath.row == 0) {
        cell.title.text = @"Outlets";
        cell.cntLabel.text = @"54";
    } else if(indexPath.row == 1) {
        cell.title.text = @"Authors";
        cell.cntLabel.text = @"63";
    } else if(indexPath.row == 2) {
        cell.title.text = @"Influencers";
        cell.cntLabel.text = @"13";
    } else if(indexPath.row == 3) {
        cell.title.text = @"Friends";
        cell.cntLabel.text = @"43";
    } else if(indexPath.row == 4) {
        cell.title.text = @"Foes";
        cell.cntLabel.text = @"24";
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"CI select row");
    if(indexPath.row == 0) {
        self.monitoringInfluencerTableView.hidden = YES;
        self.monitoringOutletTableView.hidden = NO;
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/276740356/FullIntel/CI/outlets.json"]];
        NSError *error;
        monitoringOutletList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSLog(@"issue lis:%@",monitoringOutletList);
        [self.monitoringOutletTableView reloadData];
    }else if(indexPath.row == 1) {
        self.monitoringOutletTableView.hidden = YES;
        self.monitoringInfluencerTableView.hidden = NO;
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/276740356/FullIntel/CI/authors.json"]];
        NSError *error;
        monitoringOutletList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSLog(@"issue lis:%@",monitoringOutletList);
        [self.monitoringInfluencerTableView reloadData];
    } else if(indexPath.row == 2) {
        self.monitoringOutletTableView.hidden = YES;
        self.monitoringInfluencerTableView.hidden = NO;
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/276740356/FullIntel/CI/influencers.json"]];
        NSError *error;
        monitoringOutletList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSLog(@"issue lis:%@",monitoringOutletList);
        [self.monitoringInfluencerTableView reloadData];
    } else if(indexPath.row == 3) {
        self.monitoringOutletTableView.hidden = YES;
        self.monitoringInfluencerTableView.hidden = NO;
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/276740356/FullIntel/CI/friends.json"]];
        NSError *error;
        monitoringOutletList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSLog(@"issue lis:%@",monitoringOutletList);
        [self.monitoringInfluencerTableView reloadData];
    } else if(indexPath.row == 4) {
        self.monitoringOutletTableView.hidden = YES;
        self.monitoringInfluencerTableView.hidden = NO;
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/276740356/FullIntel/CI/foes.json"]];
        NSError *error;
        monitoringOutletList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSLog(@"issue lis:%@",monitoringOutletList);
        [self.monitoringInfluencerTableView reloadData];
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return monitoringOutletList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if(tableView == self.monitoringOutletTableView) {
        IssueMonitoringOutletCell *outletCell = (IssueMonitoringOutletCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
        NSDictionary *issueDic = [monitoringOutletList objectAtIndex:indexPath.row];
        outletCell.articleTitle.text = [issueDic objectForKey:@"title"];
        [outletCell.articleImage sd_setImageWithURL:[NSURL URLWithString:[issueDic valueForKey:@"articleImageUrl"]] placeholderImage:[UIImage imageNamed:@"FI"]];
        [outletCell.articleImage setContentMode:UIViewContentModeScaleAspectFill];
        outletCell.articleDate.text = [issueDic objectForKey:@"date"];
        outletCell.articleOutlet.text =  [issueDic objectForKey:@"outlet"];
        outletCell.articleAuthor.text = [issueDic objectForKey:@"author"];
        outletCell.articleDesc.text = [issueDic objectForKey:@"desc"];
        outletCell.contentView.alpha = 1.0f;
        cell = outletCell;
    } else if(tableView == self.monitoringInfluencerTableView) {
        IssueMonitoringInfluencerCell *influencerCell = (IssueMonitoringInfluencerCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
        NSDictionary *issueDic = [monitoringOutletList objectAtIndex:indexPath.row];
        influencerCell.articleTitle.text = [issueDic objectForKey:@"title"];
        [influencerCell.articleAuthorImage sd_setImageWithURL:[NSURL URLWithString:[issueDic valueForKey:@"authorImage"]] placeholderImage:[UIImage imageNamed:@"FI"]];
        [influencerCell.articleAuthorImage setContentMode:UIViewContentModeScaleAspectFill];
        influencerCell.articleDate.text = [issueDic objectForKey:@"date"];
        influencerCell.articleOutlet.text =  [issueDic objectForKey:@"outlet"];
        influencerCell.articleAuthor.text = [issueDic objectForKey:@"author"];
        influencerCell.articleDesc.text = [issueDic objectForKey:@"desc"];
        influencerCell.articleAuthorTitle.text = [issueDic objectForKey:@"authorTitle"];
        influencerCell.contentView.alpha = 1.0f;
        cell = influencerCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"CommunicationIssues" bundle:nil];
    IssueDrillInPage *issuesList = [storyBoard instantiateViewControllerWithIdentifier:@"IssueDrillInPage"];
    [self.navigationController pushViewController:issuesList animated:YES];
    
}


@end
