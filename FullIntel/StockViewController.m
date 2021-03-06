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
@interface StockViewController ()

@end

@implementation StockViewController
NHAlignmentFlowLayout *layout;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    [self setUpViews];
}

-(void)viewDidAppear:(BOOL)animated{
    
    
    [super viewDidAppear:animated];
    
    
   
}

-(void)setUpViews{
    
    layout = [[NHAlignmentFlowLayout alloc] init];
    
    layout.sectionInset = UIEdgeInsetsMake(5, 10, 0, 10);
    
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
    
    
    NSMutableAttributedString *attriString=[[NSMutableAttributedString alloc]initWithString:@"STOCK WATCH provides stock market information and top stories on a list of companies that you are watching"];
    
    [attriString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Bold" size:20] range:NSMakeRange(0,11)];
    
    [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,11)];
    
    _topLabel.attributedText=attriString;
    
    
    _stockWatchList=[[NSMutableArray alloc]init];
    _topStoriesList=[[NSMutableArray alloc]init];
    
    
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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backBtnPress {

    
    if(self.revealController.state == PKRevealControllerShowsLeftViewControllerInPresentationMode) {
        NSLog(@"left view opened");
        [self.revealController showViewController:self.revealController.frontViewController];
    } else {
        NSLog(@"left view closed");
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
       stockCell.contentView.layer.cornerRadius=3.0f;
       stockCell.contentView.layer.borderColor = [[UIColor colorWithRed:237.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1] CGColor];
       
       Stocks *stockDetails=(Stocks *)[_stockWatchList objectAtIndex:indexPath.row];
       
       stockCell.companyName.text=stockDetails.company_name;
       stockCell.value.text=stockDetails.value;
       stockCell.firstName.text=stockDetails.firstName;
       stockCell.lastName.text=stockDetails.lastName;
       stockCell.firstValue.text=stockDetails.firstValue;
       stockCell.secondValue.text=stockDetails.secondValue;
       
       
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
    
    [cell.storyImageView sd_setImageWithURL:[NSURL URLWithString:story.image] placeholderImage:[UIImage imageNamed:@"peoples"]];
    
    cell.storyLabel.text=story.story;
    cell.companyLabel.text=story.resource;
    
 
    [FIUtils makeRoundedView:cell.storyImageView];
    
    tableCell=cell;
    
    return cell;
        
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{

    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];

    if(toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation==UIInterfaceOrientationLandscapeRight){

        NSLog(@"view size in Landscape :%f :%f :%f :%f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);

        layout.alignment = NHAlignmentTopLeftAligned;
        self.stockCollectionView.collectionViewLayout = layout;

    }else if(toInterfaceOrientation==UIInterfaceOrientationPortrait){

          NSLog(@"view size in Portrait :%f :%f :%f :%f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);

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
        
        NSLog(@"view size in Landscape :%f :%f :%f :%f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
        
        layout.alignment = NHAlignmentTopLeftAligned;
        self.stockCollectionView.collectionViewLayout = layout;
        
    }else if(fromInterfaceOrientation==UIInterfaceOrientationPortrait){
        
        NSLog(@"view size in Portrait :%f :%f :%f :%f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
        
        layout.alignment = NHAlignmentJustified;
        self.stockCollectionView.collectionViewLayout = layout;
    }
}


@end
