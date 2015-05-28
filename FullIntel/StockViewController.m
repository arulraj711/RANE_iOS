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

@interface StockViewController ()

@end

@implementation StockViewController
NHAlignmentFlowLayout *layout;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    layout = [[NHAlignmentFlowLayout alloc] init];

    layout.sectionInset = UIEdgeInsetsMake(5, 10, 0, 10);

    layout.itemSize = CGSizeMake(300, 270);
    layout.minimumInteritemSpacing = 20.0f;
    layout.minimumLineSpacing = 20.0;
    layout.alignment = NHAlignmentTopLeftAligned;
    self.stockCollectionView.collectionViewLayout = layout;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *collectionCell;

    
   if(cv == self.stockCollectionView) {
        StockCell *stockCell =(StockCell*) [cv dequeueReusableCellWithReuseIdentifier:@"stockCell" forIndexPath:indexPath];
       
       
       stockCell.contentView.layer.borderWidth = 1.0f;
       stockCell.contentView.layer.cornerRadius=3.0f;
       stockCell.contentView.layer.borderColor = [[UIColor colorWithRed:237.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1] CGColor];
       
         collectionCell = stockCell;
   
    }    return collectionCell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.

    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableCell;

    TopStoriesCell *cell = (TopStoriesCell *)[tableView dequeueReusableCellWithIdentifier:@"TopStoriesCell"];
    
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

@end
