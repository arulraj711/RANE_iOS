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
#import "ReportCollectionCell.h"
#define UIColorFromRGB(rgbValue)[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface ChartListViewController ()

@end

@implementation ChartListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.revealController showViewController:self.revealController.frontViewController];
    UIButton *navBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [navBtn setFrame:CGRectMake(0.0f,0.0f,16.0f,15.0f)];
    [navBtn setBackgroundImage:[UIImage imageNamed:@"navmenu"]  forState:UIControlStateNormal];
    [navBtn addTarget:self action:@selector(backBtnPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:navBtn];
    [self.navigationItem setLeftBarButtonItem:addButton];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Open Sans" size:16];
    // label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.text =@"MEDIA ANALYSIS";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    
    
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
    
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.alpha = 1.0;
    activityIndicator.center = self.view.center;
    activityIndicator.hidesWhenStopped = YES;
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    
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
    [activityIndicator stopAnimating];
    NSNotification *notification = sender;
    reportListArray = [[notification userInfo] objectForKey:@"reportListArray"];
    NSLog(@"report list array count:%d",reportListArray.count);
    [self.reportListTableView reloadData];
    [self.reportCollectionView reloadData];
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
    chartView.titleString = reportListObj.reportTitle;
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

#pragma mark - UICollectionView Datasource

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(20, 10, 20, 10);
//}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return reportListArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // NSLog(@"collectionview cell for item");
    ReportCollectionCell *cell = (ReportCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
   // cell.contentView.layer.cornerRadius = 2.0f;
    cell.contentView.layer.borderWidth = 1.0f;
    cell.contentView.layer.borderColor = [UIColorFromRGB(0XEEF1F1) CGColor];
    cell.contentView.layer.masksToBounds = YES;
    
    cell.layer.shadowColor = [UIColorFromRGB(0XD1D1D1) CGColor];
    cell.layer.shadowOffset = CGSizeMake(0, 0.0f);
    cell.layer.shadowRadius = 1.0f;
    cell.layer.shadowOpacity = 0.5f;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
    
    
    ReportListObject *reportListObj = [reportListArray objectAtIndex:indexPath.row];
    cell.reportTitleLabel.text = reportListObj.reportTitle;
    NSString *reportFromDate = [FIUtils getDateFromTimeStamp:[reportListObj.reportFromDate doubleValue]];
    cell.reportFromDateLabel.text = reportFromDate;
    NSString *reportToDate = [FIUtils getDateFromTimeStamp:[reportListObj.reportToDate doubleValue]];
    cell.reportToDateLabel.text = reportToDate;
    NSString *reportCreatedDate = [FIUtils getDateFromTimeStamp:[reportListObj.createdDate doubleValue]];
    cell.reportCreatedDateLabel.text = reportCreatedDate;
    
    UITapGestureRecognizer *tapEvent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(downloadButtonClick:)];
    cell.downloadButton.tag = indexPath.row;
    [cell.downloadButton addGestureRecognizer:tapEvent];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
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
    chartView.titleString = reportListObj.reportTitle;
    [self.navigationController pushViewController:chartView animated:YES];
}

-(void)downloadButtonClick:(UITapGestureRecognizer *)tapGesture {
    NSLog(@"download index:%d",tapGesture.view.tag);
    int selectedTag = tapGesture.view.tag;
    ReportListObject *reportListObj = [reportListArray objectAtIndex:selectedTag];
   // [[FISharedResources sharedResourceManager]downloadReportForReportId:reportListObj.reportId];
}

@end
