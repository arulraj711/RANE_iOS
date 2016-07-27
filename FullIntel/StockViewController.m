//
//  StockViewController.m
//  FullIntel
//
//  Created by cape start on 27/05/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "StockViewController.h"
#import "StockCell.h"
#import "TopStoriesCell.h"
#import "NHAlignmentFlowLayout.h"
#import "PKRevealController.h"
#import "FIWebService.h"
#import "Stories.h"
#import "Stocks.h"
#import "FIUtils.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FISharedResources.h"
#import "ViewController.h"
#import "UILabel+CustomHeaderLabel.h"

#define UIColorFromRGB(rgbValue)[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface StockViewController ()

@end

@implementation StockViewController
NHAlignmentFlowLayout *layout;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoginPage) name:@"authenticationFailed" object:nil];

    [self setUpViews];
}

-(void)viewDidAppear:(BOOL)animated{
    
    
    [super viewDidAppear:animated];
    [[FISharedResources sharedResourceManager]tagScreenInLocalytics:@"Stock Watch"];
    
   
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    
    UITextView *tv = object;
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    tv.font=[UIFont fontWithName:@"OpenSans" size:50.0];
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.sampleDataText addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    @try{
        [self.sampleDataText removeObserver:self forKeyPath:@"contentSize"];
    }@catch(id anException) {
        NSLog(@"error message:%@",anException);
    }
    
    
}

-(void)setUpViews{
    
    layout = [[NHAlignmentFlowLayout alloc] init];
    
    layout.sectionInset = UIEdgeInsetsMake(5, 8, 0, 10);
    
    layout.itemSize = CGSizeMake(300, 270);
    layout.minimumInteritemSpacing = 20.0f;
    layout.minimumLineSpacing = 20.0;
    layout.alignment = NHAlignmentTopLeftAligned;
    self.stockCollectionView.collectionViewLayout = layout;
    
    
    UIButton *Btn =[UIButton buttonWithType:UIButtonTypeCustom];
    
    [Btn setFrame:CGRectMake(0.0f,0.0f,16.0f,15.0f)];
    [Btn setBackgroundImage:[UIImage imageNamed:@"navmenu"]  forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(backBtnPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    [self.navigationItem setLeftBarButtonItem:addButton];
    
    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
//    label.backgroundColor = [UIColor clearColor];
//    label.font = [UIFont fontWithName:@"OpenSans" size:16];
//    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
//    label.text = _titleName;
//    label.textAlignment = NSTextAlignmentCenter;
//    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = [UILabel setCustomHeaderLabelFromText:self.titleName];
    
    
    NSMutableAttributedString *attriString=[[NSMutableAttributedString alloc]initWithString:@"STOCK WATCH provides stock market information and top stories on a list of companies that you are watching"];
    
    [attriString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Bold" size:20] range:NSMakeRange(0,11)];
    
    [attriString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0XA4131E) range:NSMakeRange(0,11)];
    
    _topLabel.attributedText=attriString;
    
    
    _stockWatchList=[[NSMutableArray alloc]init];
    _topStoriesList=[[NSMutableArray alloc]init];
    
    
//    _requestUpgradeButton.layer.borderColor=[[UIColor blackColor]CGColor];
//    _requestUpgradeButton.layer.borderWidth=1.5;
//    _requestUpgradeButton.layer.cornerRadius=5.0;
    
    [FIWebService getStockListDetails:@"Mock" onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *stockArray = [responseObject objectForKey:@"stockList"];
        
        NSMutableArray *ListArray = [NSMutableArray array];
        
        for(NSDictionary *dic in stockArray) {
            Stocks *stocks = [[Stocks alloc]init];
            [stocks getDetailsFromDictionary:dic];
            [ListArray addObject:stocks];
            
        }
        
        [_stockWatchList addObjectsFromArray:ListArray];
        
        
        NSArray *storyArray = [responseObject objectForKey:@"TopStories"];
        
        NSMutableArray *storyListArray = [NSMutableArray array];
        
        for(NSDictionary *dic in storyArray) {
            Stories *story = [[Stories alloc]init];
            [story getDetailsFromDictionary:dic];
            [storyListArray addObject:story];
            
        }
        
        [_topStoriesList addObjectsFromArray:storyListArray];
        
        
        
        [_stockCollectionView reloadData];
        [_topStoriesTableView reloadData];
        
        
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
    _rotateView.transform = CGAffineTransformMakeRotation(-0.6);
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)showLoginPage {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];
    UINavigationController *listView = [storyBoard instantiateViewControllerWithIdentifier:@"CorporateView"];
    [self.revealController setFrontViewController:listView];
    [self.revealController showViewController:self.revealController.leftViewController];
    
    NSArray *navArray = self.navigationController.viewControllers;
    if(navArray.count > 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        UIStoryboard *loginStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewController *loginView = [loginStoryBoard instantiateViewControllerWithIdentifier:@"LoginView"];
        UIWindow *window = [[UIApplication sharedApplication]windows][0];
        [window addSubview:loginView.view];
    } else {
        UIStoryboard *loginStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewController *loginView = [loginStoryBoard instantiateViewControllerWithIdentifier:@"LoginView"];
        UIWindow *window = [[UIApplication sharedApplication]windows][0];
        [window addSubview:loginView.view];
    }
    
    
    //[self presentViewController:loginView animated:YES completion:nil];
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
#pragma mark - UICollectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake(300, 270);
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    // NSLog(@"imp collection view:%d",self.socialLinksArray.count);
    NSInteger itemCount;

    if(view == self.stockCollectionView){
        itemCount = self.stockWatchList.count;
    }
    return itemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *collectionCell;

    
   if(cv == self.stockCollectionView) {
        StockCell *stockCell =(StockCell*) [cv dequeueReusableCellWithReuseIdentifier:@"stockCell" forIndexPath:indexPath];
       
       
       stockCell.contentView.layer.borderWidth = 1.0f;
       stockCell.contentView.layer.cornerRadius=5.0f;
       stockCell.contentView.layer.borderColor = [[UIColor colorWithRed:237.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1] CGColor];
       
       Stocks *stockDetails=(Stocks *)[_stockWatchList objectAtIndex:indexPath.row];
       
       stockCell.companyName.text=stockDetails.company_name;
       stockCell.value.text=stockDetails.value;
       stockCell.firstName.text=stockDetails.firstName;
       stockCell.lastName.text=stockDetails.lastName;
       stockCell.firstValue.text=stockDetails.firstValue;
       stockCell.secondValue.text=stockDetails.secondValue;
       
     
       
       [stockCell.graphImage sd_setImageWithURL:[NSURL URLWithString:stockDetails.imageUrl] placeholderImage:[UIImage imageNamed:@"FI"]];
       
       stockCell.graphImage.alpha=0.1;
       
       
       if([stockDetails.color isEqualToString:@"green"]){
           
           stockCell.firstValue.textColor=UIColorFromRGB(0X71ba81);
           stockCell.secondValue.textColor=UIColorFromRGB(0X71ba81);
           
           stockCell.downImage.image=[UIImage imageNamed:@"greenTriangle"];
       }else{
           
           stockCell.firstValue.textColor=UIColorFromRGB(0XA4131E);
           stockCell.secondValue.textColor=UIColorFromRGB(0XA4131E);
           
           stockCell.downImage.image=[UIImage imageNamed:@"redTriangle"];
       }
       
        collectionCell = stockCell;
   
    }    return collectionCell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.

    return _topStoriesList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableCell;

    TopStoriesCell *cell = (TopStoriesCell *)[tableView dequeueReusableCellWithIdentifier:@"TopStoriesCell"];
    
    Stories *story=(Stories *)[_topStoriesList objectAtIndex:indexPath.row];
    
    [cell.storyImageView sd_setImageWithURL:[NSURL URLWithString:story.image] placeholderImage:[UIImage imageNamed:@"FI"]];
    
    cell.storyLabel.text=story.story;
    cell.companyLabel.text=story.resource;
    
 
    [FIUtils makeRoundedView:cell.storyImageView];
    
    tableCell=cell;
    
    return cell;
        
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{

    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];

    if(toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation==UIInterfaceOrientationLandscapeRight){

       // NSLog(@"view size in Landscape :%f :%f :%f :%f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);

        layout.alignment = NHAlignmentTopLeftAligned;
        self.stockCollectionView.collectionViewLayout = layout;

    }else if(toInterfaceOrientation==UIInterfaceOrientationPortrait){

         // NSLog(@"view size in Portrait :%f :%f :%f :%f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);

        layout.alignment = NHAlignmentJustified;
        self.stockCollectionView.collectionViewLayout = layout;
    }
}

//-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:
//(NSTimeInterval)duration {
//
//    // Fade the collectionView out
//    [self.stockCollectionView setAlpha:0.0f];
//    
//    // Suppress the layout errors by invalidating the layout
//    [self.stockCollectionView.collectionViewLayout invalidateLayout];
//    
//    // Calculate the index of the item that the collectionView is currently displaying
//    CGPoint currentOffset = [self.stockCollectionView contentOffset];
//    self.currentIndex = currentOffset.x / self.stockCollectionView.frame.size.width;
//}
//
//-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//    
//    // Force realignment of cell being displayed
//    CGSize currentSize = self.stockCollectionView.bounds.size;
//    float offset = self.currentIndex * currentSize.width;
//    [self.stockCollectionView setContentOffset:CGPointMake(offset, 0)];
//    
//    // Fade the collectionView back in
//    [UIView animateWithDuration:0.125f animations:^{
//        [self.stockCollectionView setAlpha:1.0f];
//    }];
//    
//}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    if(fromInterfaceOrientation==UIInterfaceOrientationLandscapeLeft || fromInterfaceOrientation==UIInterfaceOrientationLandscapeRight){
        
       // NSLog(@"view size in Landscape :%f :%f :%f :%f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
        
        layout.alignment = NHAlignmentTopLeftAligned;
        self.stockCollectionView.collectionViewLayout = layout;
        
    }else if(fromInterfaceOrientation==UIInterfaceOrientationPortrait){
        
       // NSLog(@"view size in Portrait :%f :%f :%f :%f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
        
        layout.alignment = NHAlignmentJustified;
        self.stockCollectionView.collectionViewLayout = layout;
    }
}


- (IBAction)requestUpgradeButtonPressed:(id)sender {
    UIButton *btn=(UIButton *)sender;
    [btn setSelected:YES];
    [FIUtils callRequestionUpdateWithModuleId:2 withFeatureId:11];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.revealController showViewController:self.revealController.frontViewController];
}
@end
