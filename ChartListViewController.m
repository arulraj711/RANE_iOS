//
//  ChartListViewController.m
//  FullIntel
//
//  Created by cape start on 24/02/16.
//  Copyright © 2016 CapeStart. All rights reserved.
//

#import "ChartListViewController.h"
#import "ChartViewController.h"
#import "PKRevealController.h"
#import "FISharedResources.h"
#import "ReportListCell.h"
#import "ReportListObject.h"

@interface ChartListViewController ()

@end

@implementation ChartListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *navBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [navBtn setFrame:CGRectMake(0.0f,0.0f,16.0f,15.0f)];
    [navBtn setBackgroundImage:[UIImage imageNamed:@"navmenu"]  forState:UIControlStateNormal];
    [navBtn addTarget:self action:@selector(backBtnPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:navBtn];
    [self.navigationItem setLeftBarButtonItem:addButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(afterFetchingReportList:)
                                                 name:@"FetchedReportList"
                                               object:nil];
    NSString *accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"];
    if(accessToken.length != 0) {
        [[FISharedResources sharedResourceManager]getReportList];
    } else {
        UIStoryboard *centerStoryBoard;
        UIViewController *viewCtlr;
        
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        {
            centerStoryBoard = [UIStoryboard storyboardWithName:@"MainPhone" bundle:nil];
            viewCtlr = [centerStoryBoard instantiateViewControllerWithIdentifier:@"LoginView"];
            
            
        } else {
            centerStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            viewCtlr = [centerStoryBoard instantiateViewControllerWithIdentifier:@"LoginView"];
            
            
        }
        [self.revealController setFrontViewController:viewCtlr];
        [self.revealController showViewController:self.revealController.frontViewController];
    }
    // Do any additional setup after loading the view.
}
-(void)backBtnPress {
    NSLog(@"back button press");
    if(self.revealController.state == PKRevealControllerShowsLeftViewControllerInPresentationMode) {
        NSLog(@"left view closed");
        NSDictionary *dictionary = @{@"email":[[NSUserDefaults standardUserDefaults]objectForKey:@"customerEmail"]};
        [Localytics tagEvent:@"MenuClosed" attributes:dictionary];
        [self.revealController showViewController:self.revealController.frontViewController];
    } else {
        NSLog(@"left view opened");
        NSDictionary *dictionary = @{@"email":[[NSUserDefaults standardUserDefaults]objectForKey:@"customerEmail"]};
        [Localytics tagEvent:@"MenuOpened" attributes:dictionary];
        [self.revealController showViewController:self.revealController.leftViewController];
    }
}

-(void)afterFetchingReportList:(id)sender {
    NSNotification *notification = sender;
    reportListArray = [[notification userInfo] objectForKey:@"reportListArray"];
    NSLog(@"report list array count:%d",reportListArray.count);
    [self.reportListTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return reportListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReportListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    ReportListObject *reportListObj = [reportListArray objectAtIndex:indexPath.row];
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        int serialNumber = indexPath.row+1;
        cell.serialNumber.text = [NSString stringWithFormat:@"%d",serialNumber];
    }
    cell.reportTitle.text = reportListObj.reportTitle;
    NSString *dateSTring = [FIUtils getDateFromTimeStamp:[reportListObj.reportFromDate doubleValue]];
    NSLog(@"%@",dateSTring);
    cell.dateCell.text = dateSTring;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard;
    ChartViewController *chartView;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        storyboard = [UIStoryboard storyboardWithName:@"ChartViewControlleriPhone" bundle:nil];
        chartView = [storyboard instantiateViewControllerWithIdentifier:@"ChartViewController"];
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"ChartViewControlleriPad" bundle:nil];
        chartView = [storyboard instantiateViewControllerWithIdentifier:@"ChartViewController"];
    }
    
    ReportListObject *reportListObj = [reportListArray objectAtIndex:indexPath.row];
    chartView.reportId = reportListObj.reportId;
    chartView.reportFromDate = reportListObj.reportFromDate;
    chartView.reportToDate = reportListObj.reportToDate;
    [self.navigationController pushViewController:chartView animated:YES];
}

- (IBAction)navigateToChartView:(id)sender {
    
    UIStoryboard *storyboard;
    ChartViewController *chartView;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        storyboard = [UIStoryboard storyboardWithName:@"ChartViewControlleriPhone" bundle:nil];
        chartView = [storyboard instantiateViewControllerWithIdentifier:@"ChartViewController"];
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"ChartViewControlleriPad" bundle:nil];
        chartView = [storyboard instantiateViewControllerWithIdentifier:@"ChartViewController"];
    }
    
    
    [self.navigationController pushViewController:chartView animated:YES];
}
@end
