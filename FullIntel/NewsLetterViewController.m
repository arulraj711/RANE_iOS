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
@interface NewsLetterViewController ()

@end

@implementation NewsLetterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *Btn =[UIButton buttonWithType:UIButtonTypeCustom];
    
    [Btn setFrame:CGRectMake(0.0f,0.0f,16.0f,15.0f)];
    [Btn setBackgroundImage:[UIImage imageNamed:@"navmenu"]  forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(backBtnPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    [self.navigationItem setLeftBarButtonItem:addButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchNewsLetter) name:@"FetchNewsLetterList" object:nil];
    
    [[FISharedResources sharedResourceManager]getNewsLetterListWithAccessToken:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetchNewsLetter {
    newsLetterArray = [[NSMutableArray alloc]initWithArray:[[FISharedResources sharedResourceManager]newsLetterList]];
    NSLog(@"news letter:%@",newsLetterArray);
    [self.newsListTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return newsLetterArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsLetterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    FINewsLetter *folder = [newsLetterArray objectAtIndex:indexPath.row];
    cell.newsLetterTitle.text = folder.newsLetterSubject;
    cell.articlesCount.text = [NSString stringWithFormat:@"%d",folder.newsLetterArticles.count];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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

@end
