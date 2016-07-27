//
//  NewsLetterViewController.m
//  FullIntel
//
//  Created by Prabhu on 30/06/1937 SAKA.
//  Copyright (c) 1937 SAKA CapeStart. All rights reserved.
//

#import "NewsLetterViewController.h"
#import "FISharedResources.h"
#import "FINewsLetter.h"
#import "NewsLetterCell.h"
#import "CorporateNewsListView.h"
#import "UILabel+CustomHeaderLabel.h"
#import "UIImage+CustomNavIconImage.h"

@interface NewsLetterViewController ()

@end

@implementation NewsLetterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.revealController showViewController:self.revealController.frontViewController];
    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
//    label.backgroundColor = [UIColor clearColor];
//    label.font = [UIFont fontWithName:@"Open Sans" size:16];
//   // label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
//    label.text =@"DAILY DIGEST";
//    label.textAlignment = NSTextAlignmentCenter;
//    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = [UILabel setCustomHeaderLabelFromText:self.titleName];
    
    // Do any additional setup after loading the view.
    UIButton *Btn =[UIButton buttonWithType:UIButtonTypeCustom];
    
    [Btn setFrame:CGRectMake(0.0f,0.0f,16.0f,15.0f)];
    [Btn setBackgroundImage:[UIImage createCustomNavIconFromImage:@"navmenu"]  forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(backBtnPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    [self.navigationItem setLeftBarButtonItem:addButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchNewsLetter) name:@"FetchNewsLetterList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoginPage) name:@"authenticationFailed" object:nil];
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.alpha = 1.0;
    activityIndicator.center = self.view.center;
    activityIndicator.hidesWhenStopped = YES;
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    [[FISharedResources sharedResourceManager]getNewsLetterListWithAccessToken:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showLoginPage {
    [self.revealController showViewController:self.revealController.frontViewController];
    NSArray *navArray = self.navigationController.viewControllers;
    if(navArray.count > 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
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
    
    
    //        [self presentViewController:loginView animated:YES completion:nil];
}


-(void)fetchNewsLetter {
    newsLetterArray = [[NSMutableArray alloc]initWithArray:[[FISharedResources sharedResourceManager]newsLetterList]];
    NSLog(@"news letter:%@ and id:%@",newsLetterArray,self.newsletterArticleId);
    [activityIndicator stopAnimating];
    if(self.newsletterArticleId.length != 0) {
        [[NSUserDefaults standardUserDefaults]setObject:self.newsletterId forKey:@"newsletterId"];
        [[FISharedResources sharedResourceManager]fetchArticleFromNewsLetterWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withNewsLetterId:self.newsletterId withPageNo:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withUpFlag:NO withFlag:NO withQuery:@"" withFilterBy:@""];
        UIStoryboard *centerStoryBoard;
        CorporateNewsListView *listView;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            centerStoryBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListViewPhone" bundle:nil];
            listView = [centerStoryBoard instantiateViewControllerWithIdentifier:@"CorporateNewsListViewPhone"];
        } else {
            centerStoryBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];
            listView = [centerStoryBoard instantiateViewControllerWithIdentifier:@"CorporateNewsListView"];
        }
        listView.selectedNewsLetterArticleId = self.newsletterArticleId;
        [self.navigationController pushViewController:listView animated:YES];
    }
    [self.newsListTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return newsLetterArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsLetterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    FINewsLetter *newsletter = [newsLetterArray objectAtIndex:indexPath.row];
    int serialNumber = indexPath.row+1;
    cell.serialNumber.text = [NSString stringWithFormat:@"%d",serialNumber];
//    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
//        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
//        if(orientation == 0){
//            //Default orientation
//            //UI is in Default (Portrait) -- this is really a just a failsafe.
//        }else if(orientation == UIInterfaceOrientationPortrait) {
//            //Do something if the orientation is in Portrait
//            NSString *titName = newsletter.newsLetterSubject;
//            if(titName.length > 15) {
//                cell.newsLetterTitle.text = [NSString stringWithFormat:@"%@...",[titName substringToIndex:15]];
//            }
//            else {
//                cell.newsLetterTitle.text = newsletter.newsLetterSubject;
//            }
//        }
//    }
    cell.newsLetterTitle.text = newsletter.newsLetterSubject;
    cell.articlesCount.text = [NSString stringWithFormat:@"%d",newsletter.newsLetterArticles.count];
    cell.createdDate.text = newsletter.createdDate;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  //  [self.revealController showViewController:self.revealController.frontViewController];
    [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"Click Newsletter List"];
    
    FINewsLetter *newsletter = [newsLetterArray objectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults]setObject:newsletter.newsLetterId forKey:@"newsletterId"];
    [[FISharedResources sharedResourceManager]fetchArticleFromNewsLetterWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withNewsLetterId:newsletter.newsLetterId withPageNo:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withUpFlag:NO withFlag:NO withQuery:@"" withFilterBy:@""];
    UIStoryboard *centerStoryBoard;
    CorporateNewsListView *listView;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        centerStoryBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListViewPhone" bundle:nil];
        listView = [centerStoryBoard instantiateViewControllerWithIdentifier:@"CorporateNewsListViewPhone"];
    } else {
        centerStoryBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];
        listView = [centerStoryBoard instantiateViewControllerWithIdentifier:@"CorporateNewsListView"];
    }
    listView.titleName = newsletter.newsLetterSubject;
    listView.mediaAnalysisArticleCount = [NSNumber numberWithInt:0];
    [self.navigationController pushViewController:listView animated:YES];
}

-(void)backBtnPress {
    NSLog(@"back button press:%d",self.revealController.state);
    if(self.revealController.state == 2 || self.revealController.state == 1) {
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

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self.revealController showViewController:self.revealController.frontViewController];
}

@end
