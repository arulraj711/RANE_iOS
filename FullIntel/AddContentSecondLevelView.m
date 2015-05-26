//
//  AddContentSecondLevelView.m
//  FullIntel
//
//  Created by Capestart on 5/4/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "AddContentSecondLevelView.h"
#import "SecondLevelCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FIContentCategory.h"
#import "AddContentThirdLevelView.h"

@interface AddContentSecondLevelView ()

@end

@implementation AddContentSecondLevelView
@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.selectTopicsLabel.hidden = YES;
    
    self.navigationController.navigationBar.hidden = YES;
    //self.categoryCollectionView.layer.borderColor = [UIColor lightGrayColor].CGColor;
   // self.categoryCollectionView.layer.borderWidth = 1.0f;
    self.selectedIdArray = [[NSMutableArray alloc]init];
    self.checkedArray = [[NSMutableArray alloc]init];
    self.uncheckedArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    layout = (id)[self.categoryCollectionView collectionViewLayout];
    layout.direction = UICollectionViewScrollDirectionVertical;
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    NSLog(@"current device orientation:%ld",(long)orientation);
    if(orientation == 1) {
        layout.blockPixels = CGSizeMake(170,200);
    }else {
        layout.blockPixels = CGSizeMake(200,200);
        
    }
    //layout.blockPixels = CGSizeMake(180,200);
    [self.categoryCollectionView reloadData];
    //[self loadSelectedCategory];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadSelectedCategory:) name:@"selectedCategory" object:nil];
 //   UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    

    if(orientation == 1) {
        testLabel = [[UILabel alloc]initWithFrame:CGRectMake((760-self.selectTopicsLabel.frame.size.width)/2, self.selectTopicsLabel.frame.origin.y ,self.selectTopicsLabel.frame.size.width,self.selectTopicsLabel.frame.size.height)];
        testLabel.text = @"Select Topics";
        testLabel.textAlignment = NSTextAlignmentCenter;
        testLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:18.0];
        //self.selectTopicsLabel.frame = CGRectMake(0, self.selectTopicsLabel.frame.origin.y, self.selectTopicsLabel.frame.size.width, self.selectTopicsLabel.frame.size.height);
        // layout.blockPixels = CGSizeMake(100,150);
    }else {
        // layout.blockPixels = CGSizeMake(130,150);
        testLabel = [[UILabel alloc]initWithFrame:CGRectMake((800-self.selectTopicsLabel.frame.size.width)/2, self.selectTopicsLabel.frame.origin.y ,self.selectTopicsLabel.frame.size.width,self.selectTopicsLabel.frame.size.height)];
        testLabel.text = @"Select Topics";
        testLabel.textAlignment = NSTextAlignmentCenter;
        testLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:18.0];
        //self.selectTopicsLabel.frame = CGRectMake((800-self.selectTopicsLabel.frame.size.width)/2, self.selectTopicsLabel.frame.origin.y, self.selectTopicsLabel.frame.size.width, self.selectTopicsLabel.frame.size.height);
    }
    [self.view addSubview:testLabel];
}

//-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//    
//    // NSLog(@"device rotate is working:%ld",(long)fromInterfaceOrientation);
//    if(fromInterfaceOrientation == 1) {
//      //  layout.blockPixels = CGSizeMake(130,150);
//        testLabel.frame = CGRectMake((800-testLabel.frame.size.width)/2, testLabel.frame.origin.y, testLabel.frame.size.width, testLabel.frame.size.height);
//    }else {
//       // layout.blockPixels = CGSizeMake(100,150);
//        testLabel.frame = CGRectMake((600-testLabel.frame.size.width)/2, testLabel.frame.origin.y, testLabel.frame.size.width, testLabel.frame.size.height);
//    }
//    
//}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:
(NSTimeInterval)duration {
    
    // Fade the collectionView out
    [self.categoryCollectionView setAlpha:0.0f];
    
    // Suppress the layout errors by invalidating the layout
    [self.categoryCollectionView.collectionViewLayout invalidateLayout];
    
    // Calculate the index of the item that the collectionView is currently displaying
   // CGPoint currentOffset = [self.categoryCollectionView contentOffset];
   // self.currentIndex = currentOffset.x / self.categoryCollectionView.frame.size.width;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    // Force realignment of cell being displayed
   // CGSize currentSize = self.categoryCollectionView.bounds.size;
  //  float offset = self.currentIndex * currentSize.width;
    [self.categoryCollectionView setContentOffset:CGPointMake(0, 0)];
    
    
    if(fromInterfaceOrientation == 1) {
        layout.blockPixels = CGSizeMake(200,200);
    }else {
        layout.blockPixels = CGSizeMake(170,200);
    }
    
    // Fade the collectionView back in
    [UIView animateWithDuration:0.125f animations:^{
        [self.categoryCollectionView setAlpha:1.0f];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)thirdLevelDidFinish:(AddContentThirdLevelView*)thirdLevel {
   // NSLog(@"delegate method is working fine");
    self.selectedIdArray = thirdLevel.previousArray;
    [self.categoryCollectionView reloadData];
}

-(void) viewWillDisappear:(BOOL)animated {
//    if(self.selectedIdArray.count != 0) {
//        [self.previousArray addObject:self.selectedId];
//    } else {
//        [self.previousArray removeAllObjects];
//    }
    [delegate secondLevelDidFinish:self];
    [super viewWillDisappear:animated];
}

- (void)loadSelectedCategory:(id)sender
{
    NSNotification *notification = sender;
    NSDictionary *userInfo = notification.userInfo;
    self.innerArray = [[NSMutableArray alloc]initWithArray:[userInfo objectForKey:@"innerArray"]];
    self.previousArray = [[NSMutableArray alloc]initWithArray:[userInfo objectForKey:@"previousArray"]];
   // NSLog(@"second level previous array:%@ and selected id:%@",self.previousArray,self.selectedId);
    //if([self.previousArray containsObject:self.selectedId]) {
        NSMutableArray *alreadySelectedArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"secondLevelSelection"];
        NSLog(@"already selected array count:%d",alreadySelectedArray.count);
        if(alreadySelectedArray.count ==0) {
            for(FIContentCategory *category in self.innerArray) {
                if(category.isSubscribed) {
                    [self.checkedArray addObject:category.categoryId];
                    [self.selectedIdArray addObject:category.categoryId];
                } else {
                    [self.uncheckedArray addObject:category.categoryId];
                    [self.selectedIdArray removeObject:category.categoryId];
                }
            }
        } else {
            self.selectedIdArray = [[NSMutableArray alloc]initWithArray:alreadySelectedArray];
        }
        
//    } else {
//        self.selectedIdArray = [[NSMutableArray alloc]init];
//    }
    NSLog(@"second level selected id array:%@",self.selectedIdArray);
    [self.categoryCollectionView reloadData];

    
//    for(FIContentCategory *category in self.innerArray) {
//        if(category.isSubscribed) {
//            [self.checkedArray addObject:category.categoryId];
//            [self.selectedIdArray addObject:category.categoryId];
//        } else {
//            [self.uncheckedArray addObject:category.categoryId];
//            [self.selectedIdArray removeObject:category.categoryId];
//        }
//    }
//    
//    [self.categoryCollectionView reloadData];
    // NSNumber  = [userInfo objectForKey:@"status"];
   // self.title = [userInfo objectForKey:@"title"];
    
}



#pragma mark – RFQuiltLayoutDelegate


-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(1, 1);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(5, 5, 5, 15);
}
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    // NSLog(@"imp collection view");
    return self.innerArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // NSLog(@"cell for item");
    SecondLevelCell *cell =(SecondLevelCell*) [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    FIContentCategory *contentCategory = [self.innerArray objectAtIndex:indexPath.row];
    cell.name.text = contentCategory.name;
    [cell.image sd_setImageWithURL:[NSURL URLWithString:contentCategory.imageUrl] placeholderImage:[UIImage imageNamed:@"FI"]];
    [cell.image setContentMode:UIViewContentModeScaleAspectFit];
    
    if([self.selectedIdArray containsObject:contentCategory.categoryId]) {
        
        [cell.checkMarkButton setSelected:YES];
    }else {
        
        [cell.checkMarkButton setSelected:NO];
    }
    
    cell.checkMarkButton.tag = indexPath.row;
    cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.contentView.layer.borderWidth = 1.0f;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FIContentCategory *contentCategory = [self.innerArray objectAtIndex:indexPath.row];
    if(contentCategory.listArray.count != 0) {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AddContent" bundle:nil];
    AddContentThirdLevelView *thirdLevel = [storyboard instantiateViewControllerWithIdentifier:@"ThirdLevel"];
    thirdLevel.delegate = self;
    thirdLevel.innerArray = contentCategory.listArray;
    thirdLevel.title = contentCategory.name;
    thirdLevel.previousArray = self.selectedIdArray;
    thirdLevel.selectedId = contentCategory.categoryId;
    [self.navigationController pushViewController:thirdLevel animated:YES];
    }
    
}

//-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//    SecondLevelCell *cell = (SecondLevelCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    [cell.checkMarkButton setSelected:NO];
//}

- (IBAction)checkMark:(id)sender {
    FIContentCategory *contentCategory = [self.innerArray objectAtIndex:[sender tag]];
    if([self.selectedIdArray containsObject:contentCategory.categoryId]) {
        [self.selectedIdArray removeObject:contentCategory.categoryId];
        [sender setSelected:NO];
        [self.checkedArray removeObject:contentCategory.categoryId];
        // } else {
        [self.uncheckedArray addObject:contentCategory.categoryId];
        // }
    } else {
        [self.selectedIdArray addObject:contentCategory.categoryId];
        [sender setSelected:YES];
        //  if([self.checkedArray containsObject:contentCategory.categoryId]) {
        [self.checkedArray addObject:contentCategory.categoryId];
        // } else {
        [self.uncheckedArray removeObject:contentCategory.categoryId];
        // }

    }
    [[NSUserDefaults standardUserDefaults]setObject:self.selectedIdArray forKey:@"secondLevelSelection"];
    [[NSUserDefaults standardUserDefaults]setObject:self.uncheckedArray forKey:@"secondLevelUnSelection"];
}
@end
