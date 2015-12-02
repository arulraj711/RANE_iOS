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
@interface NewsLetterViewController ()

@end

@implementation NewsLetterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.revealController showViewController:self.revealController.frontViewController];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Open Sans" size:16];
   // label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.text =@"DAILY DIGEST";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    
    // Do any additional setup after loading the view.
    UIButton *Btn =[UIButton buttonWithType:UIButtonTypeCustom];
    
    [Btn setFrame:CGRectMake(0.0f,0.0f,16.0f,15.0f)];
    [Btn setBackgroundImage:[UIImage imageNamed:@"navmenu"]  forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(backBtnPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    [self.navigationItem setLeftBarButtonItem:addButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchNewsLetter) name:@"FetchNewsLetterList" object:nil];
    
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

-(void)fetchNewsLetter {
    newsLetterArray = [[NSMutableArray alloc]initWithArray:[[FISharedResources sharedResourceManager]newsLetterList]];
    NSLog(@"news letter:%@ and id:%@",newsLetterArray,self.newsletterArticleId);
    [activityIndicator stopAnimating];
    if(self.newsletterArticleId.length != 0) {
        [[NSUserDefaults standardUserDefaults]setObject:self.newsletterId forKey:@"newsletterId"];
        [[FISharedResources sharedResourceManager]fetchArticleFromNewsLetterWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withNewsLetterId:self.newsletterId withLastArticleId:@"" withLimit:[NSNumber numberWithInt:10] withUpFlag:NO withFlag:NO];
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
    cell.newsLetterTitle.text = newsletter.newsLetterSubject;
    cell.articlesCount.text = [NSString stringWithFormat:@"%d",newsletter.newsLetterArticles.count];
    cell.createdDate.text = newsletter.createdDate;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  //  [self.revealController showViewController:self.revealController.frontViewController];
    FINewsLetter *newsletter = [newsLetterArray objectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults]setObject:newsletter.newsLetterId forKey:@"newsletterId"];
    [[FISharedResources sharedResourceManager]fetchArticleFromNewsLetterWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withNewsLetterId:newsletter.newsLetterId withLastArticleId:@"" withLimit:[NSNumber numberWithInt:10] withUpFlag:NO withFlag:NO];
    
    
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
    [self.navigationController pushViewController:listView animated:YES];
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

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self.revealController showViewController:self.revealController.frontViewController];
}

@end
