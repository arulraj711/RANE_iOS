//
//  AddContentFourthLevelView.m
//  FullIntel
//
//  Created by Capestart on 5/4/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "AddContentFourthLevelView.h"
#import "AddContentFifthLevelView.h"
#import "SecondLevelCell.h"
#import "FIContentCategory.h"
#import "AddContentFifthLevelView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface AddContentFourthLevelView ()

@end

@implementation AddContentFourthLevelView
@synthesize  delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectTopicsLabel.hidden = YES;
   // self.titleLabel.text = self.title;
    self.selectedIdArray = [[NSMutableArray alloc]init];
    self.checkedArray = [[NSMutableArray alloc]init];
    self.uncheckedArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    RFQuiltLayout* layout = (id)[self.categoryCollectionView collectionViewLayout];
    layout.direction = UICollectionViewScrollDirectionVertical;
    layout.blockPixels = CGSizeMake(180,180);
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if(orientation == 1) {
        testLabel = [[UILabel alloc]initWithFrame:CGRectMake((760-self.selectTopicsLabel.frame.size.width)/2, self.selectTopicsLabel.frame.origin.y ,self.selectTopicsLabel.frame.size.width,self.selectTopicsLabel.frame.size.height)];
        testLabel.text = self.title;
        testLabel.textAlignment = NSTextAlignmentCenter;
        testLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:18.0];
        //self.selectTopicsLabel.frame = CGRectMake(0, self.selectTopicsLabel.frame.origin.y, self.selectTopicsLabel.frame.size.width, self.selectTopicsLabel.frame.size.height);
        // layout.blockPixels = CGSizeMake(100,150);
    }else {
        // layout.blockPixels = CGSizeMake(130,150);
        testLabel = [[UILabel alloc]initWithFrame:CGRectMake((800-self.selectTopicsLabel.frame.size.width)/2, self.selectTopicsLabel.frame.origin.y ,self.selectTopicsLabel.frame.size.width,self.selectTopicsLabel.frame.size.height)];
        testLabel.text = self.title;
        testLabel.textAlignment = NSTextAlignmentCenter;
        testLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:18.0];
        //self.selectTopicsLabel.frame = CGRectMake((800-self.selectTopicsLabel.frame.size.width)/2, self.selectTopicsLabel.frame.origin.y, self.selectTopicsLabel.frame.size.width, self.selectTopicsLabel.frame.size.height);
    }
    [self.view addSubview:testLabel];
    
    [self.categoryCollectionView reloadData];
    [self loadSelectedCategory];
}


- (void)loadSelectedCategory
{
    if([self.previousArray containsObject:self.selectedId]) {
        NSMutableArray *alreadySelectedArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"fourthLevelSelection"];
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
    } else {
        self.selectedIdArray = [[NSMutableArray alloc]init];
    }
    [self.categoryCollectionView reloadData];
    
}


-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    // NSLog(@"device rotate is working:%ld",(long)fromInterfaceOrientation);
    if(fromInterfaceOrientation == 1) {
        //  layout.blockPixels = CGSizeMake(130,150);
        testLabel.frame = CGRectMake((800-testLabel.frame.size.width)/2, testLabel.frame.origin.y, testLabel.frame.size.width, testLabel.frame.size.height);
    }else {
        // layout.blockPixels = CGSizeMake(100,150);
        testLabel.frame = CGRectMake((760-testLabel.frame.size.width)/2, testLabel.frame.origin.y, testLabel.frame.size.width, testLabel.frame.size.height);
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) viewWillDisappear:(BOOL)animated {
    if(self.selectedIdArray.count != 0) {
        [self.previousArray addObject:self.selectedId];
    } else {
        [self.previousArray removeAllObjects];
    }
    [delegate fourthLevelDidFinish:self];
    [super viewWillDisappear:animated];
}

- (void)fifthLevelDidFinish:(AddContentFifthLevelView*)fifthLevel {
    self.selectedIdArray = fifthLevel.previousArray;
   // NSLog(@"selected array from previous:%@",self.selectedIdArray);
    [self.categoryCollectionView reloadData];
}

#pragma mark – RFQuiltLayoutDelegate


-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(1, 1);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(5, 5, 5, 10);
}
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    NSLog(@"imp collection view");
    return self.innerArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // NSLog(@"cell for item");
    SecondLevelCell *cell =(SecondLevelCell*) [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    FIContentCategory *contentCategory = [self.innerArray objectAtIndex:indexPath.row];
    cell.name.text = contentCategory.name;
    [cell.image sd_setImageWithURL:[NSURL URLWithString:contentCategory.imageUrl] placeholderImage:[UIImage imageNamed:@"FI"]];
   // [cell.image setContentMode:UIViewContentModeScaleToFill];
    if([self.selectedIdArray containsObject:contentCategory.categoryId]) {
        //[self.selectedIdArray addObject:contentCategory.categoryId];
        [cell.checkMarkButton setSelected:YES];
    }else {
       // [self.selectedIdArray removeObject:contentCategory.categoryId];
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
        AddContentFifthLevelView *thirdLevel = [storyboard instantiateViewControllerWithIdentifier:@"FifthLevel"];
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
    [[NSUserDefaults standardUserDefaults]setObject:self.selectedIdArray forKey:@"fourthLevelSelection"];
    [[NSUserDefaults standardUserDefaults]setObject:self.uncheckedArray forKey:@"fourthLevelUnSelection"];
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
