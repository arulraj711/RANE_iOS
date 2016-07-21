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
#import "FISharedResources.h"
#import "UILabel+CustomHeaderLabel.h"

@interface CommunicationIssuesPage ()

@end

@implementation CommunicationIssuesPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *Btn =[UIButton buttonWithType:UIButtonTypeCustom];
    
    [Btn setFrame:CGRectMake(0.0f,0.0f,16.0f,15.0f)];
    [Btn setBackgroundImage:[UIImage imageNamed:@"navmenu"]  forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(backBtnPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    [self.navigationItem setLeftBarButtonItem:addButton];

//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
//    label.backgroundColor = [UIColor clearColor];
//    label.font = [UIFont fontWithName:@"Open Sans" size:16];
//    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
//    label.text =self.title;
//    label.textAlignment = NSTextAlignmentCenter;
//    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = [UILabel setCustomHeaderLabelFromText:self.title];
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.revealController.revealPanGestureRecognizer.delegate = self;
//        self.revealController.panDelegate = self;
    } else {
        
    }
}
- (void)handlePanGestureStart {
   // self.articlesTableView.scrollEnabled = NO;
    
}

-(void)handleVeriticalPan {
   // self.articlesTableView.scrollEnabled = YES;
}
-(void)handlePanGestureEnd {
  //  self.articlesTableView.scrollEnabled = YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
        return  YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backBtnPress {
    NSLog(@"back button press:%d",self.revealController.state);
    if(self.revealController.state == 2) {
        NSLog(@"left view closed");
        NSDictionary *dictionary = @{@"email":[[NSUserDefaults standardUserDefaults]objectForKey:@"customerEmail"]};
        [Localytics tagEvent:@"MenuClosed" attributes:dictionary];
        [self.revealController showViewController:self.revealController.frontViewController];
    } else if(self.revealController.state == 3){
        NSLog(@"left view opened");
        NSDictionary *dictionary = @{@"email":[[NSUserDefaults standardUserDefaults]objectForKey:@"customerEmail"]};
        [Localytics tagEvent:@"MenuOpened" attributes:dictionary];
        [self.revealController showViewController:self.revealController.leftViewController];
    }
    
}

-(void)viewDidAppear:(BOOL)animated {
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/276740356/FullIntel/CI/issues.json"]];
    NSError *error;
    issueList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"issue lis:%@",issueList);
    [self.issuesTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return issueList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CICell *cell = (CICell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
     NSDictionary *issueDic = [issueList objectAtIndex:indexPath.row];
    [cell.articleImage sd_setImageWithURL:[NSURL URLWithString:[issueDic objectForKey:@"articleImage"]] placeholderImage:[UIImage imageNamed:@"FI"]];
    [cell.articleImage setContentMode:UIViewContentModeScaleAspectFill];
    cell.artileTitle.text = [issueDic objectForKey:@"title"];
    cell.articleDesc.text = [issueDic objectForKey:@"desc"];
    cell.articlesCount.text = [issueDic objectForKey:@"articlesCount"];
    cell.outletsCount.text = [issueDic objectForKey:@"outletsCount"];
    cell.commentsCount.text = [issueDic objectForKey:@"commentsCount"];
   
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


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.revealController showViewController:self.revealController.frontViewController];
}

@end
