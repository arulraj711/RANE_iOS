//
//  CorporateNewsDetailsTest.m
//  FullIntel
//
//  Created by Capestart on 5/13/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "CorporateNewsDetailsTest.h"
#import "CorporateDetailCell.h"
#import "FISharedResources.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FIUtils.h"

@interface CorporateNewsDetailsTest ()

@end

@implementation CorporateNewsDetailsTest

- (void)viewDidLoad {
    [super viewDidLoad];
    oneSecondTicker = [[NSTimer alloc] init];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [self.collectionView setPagingEnabled:YES];
    [self.collectionView setCollectionViewLayout:flowLayout];
    [self.collectionView reloadData];
    
   // self.collectionView.contentOffset = CGPointMake(self.collectionView.frame.size.width*2, 0);
    
    
    [self getArticleIdListFromDB];
    
}

-(void)viewDidAppear:(BOOL)animated {
    CGSize currentSize = self.collectionView.bounds.size;
    float offset = self.currentIndex * currentSize.width;
    [self.collectionView setContentOffset:CGPointMake(offset, 0)];
    
}


-(void)getArticleIdListFromDB {
    //[oneSecondTicker invalidate];
    
    
    BOOL testFlag = [[NSUserDefaults standardUserDefaults]boolForKey:@"Test"];
    if(testFlag) {
        NSLog(@"test flag is TRUE");
        self.collectionView.scrollEnabled = YES;
        NSManagedObjectContext *context = [[FISharedResources sharedResourceManager]managedObjectContext];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"CuratedNews" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
        
        NSMutableArray *elementsFromColumn = [[NSMutableArray alloc] init];
        for (NSManagedObject *fetchedObject in fetchedObjects) {
            [elementsFromColumn addObject:[fetchedObject valueForKey:@"articleId"]];
        }
        
        NSLog(@"elementsfrom column:%@",elementsFromColumn);
        self.articleIdArray = [[NSMutableArray alloc]initWithArray:elementsFromColumn];
        NSLog(@"article id array:%@",self.articleIdArray);
        [self.collectionView reloadData];
        [self.activityIndicator stopAnimating];
        [oneSecondTicker invalidate];
    } else {
        NSLog(@"test flag is FALSE");
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.articleIdArray.count;
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetsForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return UIEdgeInsetsMake(5, 5, 5, 10);
//}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   // NSLog(@"cell indexpath:%@",indexPath);
    CorporateDetailCell *cell = (CorporateDetailCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [cell.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];

    
    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@",[self.articleIdArray objectAtIndex:indexPath.row]];
    [fetchRequest setPredicate:predicate];
    NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if(newPerson.count != 0) {
        NSManagedObject *curatedNews = [newPerson objectAtIndex:0];
        //NSLog(@"selected curated news:%@",curatedNews);
        //curatedNewsDetail = [curatedNews valueForKey:@"details"];
        //curatedNewsAuthorDetail = [curatedNews valueForKey:@"authorDetails"];
        cell.articleTitle.text = [curatedNews valueForKey:@"title"];
        [cell.articleImageView sd_setImageWithURL:[NSURL URLWithString:[curatedNews valueForKey:@"image"]] placeholderImage:nil];
        [cell.articleImageView setContentMode:UIViewContentModeScaleAspectFill];
    }
    
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.collectionView.frame.size;
}

#pragma mark -
#pragma mark Rotation handling methods

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:
(NSTimeInterval)duration {
    
    // Fade the collectionView out
    [self.collectionView setAlpha:0.0f];
    
    // Suppress the layout errors by invalidating the layout
    [self.collectionView.collectionViewLayout invalidateLayout];
    
    // Calculate the index of the item that the collectionView is currently displaying
    CGPoint currentOffset = [self.collectionView contentOffset];
    self.currentIndex = currentOffset.x / self.collectionView.frame.size.width;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    // Force realignment of cell being displayed
    CGSize currentSize = self.collectionView.bounds.size;
    float offset = self.currentIndex * currentSize.width;
    [self.collectionView setContentOffset:CGPointMake(offset, 0)];
    
    // Fade the collectionView back in
    [UIView animateWithDuration:0.125f animations:^{
        [self.collectionView setAlpha:1.0f];
    }];
    
}

-(void)scrollViewDidScroll: (UIScrollView*)scrollView
{
    int lastCount = self.articleIdArray.count-1;
    float scrollOffset = self.collectionView.contentOffset.x;
    //NSLog(@"scrollview offset:%f and collectionview width:%f",scrollOffset,self.collectionView.frame.size.width*lastCount);
    if(scrollOffset > self.collectionView.frame.size.width*lastCount) {
       // NSLog(@"reached end");
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.view addSubview:self.activityIndicator];
        self.activityIndicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
        [self.activityIndicator startAnimating];
        
        self.collectionView.scrollEnabled = NO;
        NSString *inputJson = [FIUtils createInputJsonForContentWithToekn:[[NSUserDefaults standardUserDefaults] valueForKey:@"accesstoken"] lastArticleId:[self.articleIdArray lastObject] contentTypeId:@"1" listSize:10 activityTypeId:@"" categoryId:[[NSUserDefaults standardUserDefaults] valueForKey:@"categoryId"]];
        [[FISharedResources sharedResourceManager]getCuratedNewsListWithAccessToken:inputJson withCategoryId:[[[NSUserDefaults standardUserDefaults] valueForKey:@"categoryId"] integerValue] withFlag:@""];
        oneSecondTicker = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self
                                       selector:@selector(getArticleIdListFromDB) userInfo:nil repeats:YES];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"Test"];
    }
}


@end
