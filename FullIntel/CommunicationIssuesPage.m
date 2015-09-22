//
//  CommunicationIssuesPage.m
//  FullIntel
//
//  Created by cape start on 22/09/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "CommunicationIssuesPage.h"
#import "CICell.h"
#import "IssuesResultListPage.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface CommunicationIssuesPage ()

@end

@implementation CommunicationIssuesPage

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
    CICell *cell = (CICell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(indexPath.row == 0) {
        [cell.articleImage sd_setImageWithURL:[NSURL URLWithString:@"http://rack.0.mshcdn.com/media/ZgkyMDE1LzA5LzIyL2ExL3dhdGNodW5ib3hpLjk1YWRiLmpwZw/d7bf2e8b/5f9/watch-unboxing-Thumbnail-meta-no-logo.jpg"] placeholderImage:[UIImage imageNamed:@"FI"]];
        [cell.articleImage setContentMode:UIViewContentModeScaleAspectFill];
        cell.artileTitle.text = @"Q3 2015 Results";
    } else if(indexPath.row == 1) {
        [cell.articleImage sd_setImageWithURL:[NSURL URLWithString:@"http://www.planwallpaper.com/static/images/bicycle-1280x720.jpg"] placeholderImage:[UIImage imageNamed:@"FI"]];
        [cell.articleImage setContentMode:UIViewContentModeScaleAspectFill];
        cell.artileTitle.text = @"Issue 2 title";
    } else if(indexPath.row == 2) {
        [cell.articleImage sd_setImageWithURL:[NSURL URLWithString:@"http://o.aolcdn.com/dims5/amp:7efb2271504fd00eebe7e7006a6d4de56f319f39/r:960,504,min/c:960,504,0,3/q:80/http:/o.aolcdn.com/hss/storage/midas/4cfdf537c105f0c8c44fd27b1d761d97/202679242/omate-truesmart-plus.jpg"] placeholderImage:[UIImage imageNamed:@"FI"]];
        [cell.articleImage setContentMode:UIViewContentModeScaleAspectFill];
        cell.artileTitle.text = @"Issue 3 title";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //[cell.articleImageView sd_setImageWithURL:[NSURL URLWithString:[curatedNews valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"FI"]];
    //[cell.articleImageView setContentMode:UIViewContentModeScaleAspectFill];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"CommunicationIssues" bundle:nil];
    IssuesResultListPage *issuesList = [storyBoard instantiateViewControllerWithIdentifier:@"IssuesResultList"];
    [self.navigationController pushViewController:issuesList animated:YES];
    
}

@end
