//
//  AddContentThirdLevelView.m
//  FullIntel
//
//  Created by Capestart on 5/4/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "AddContentThirdLevelView.h"
#import "SecondLevelCell.h"
#import "FIContentCategory.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AddContentFourthLevelView.h"

@interface AddContentThirdLevelView ()

@end

@implementation AddContentThirdLevelView
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.title;
    self.selectedIdArray = [[NSMutableArray alloc]init];
    self.checkedArray = [[NSMutableArray alloc]init];
    self.uncheckedArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    RFQuiltLayout* layout = (id)[self.categoryCollectionView collectionViewLayout];
    layout.direction = UICollectionViewScrollDirectionVertical;
    layout.blockPixels = CGSizeMake(150,150);
    [self.categoryCollectionView reloadData];
    [self loadSelectedCategory];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadSelectedCategory
{
    if([self.previousArray containsObject:self.selectedId]) {
        NSMutableArray *alreadySelectedArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"thirdLevelSelection"];
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

-(void) viewWillDisappear:(BOOL)animated {
    if(self.selectedIdArray.count != 0) {
        [self.previousArray addObject:self.selectedId];
    } else {
        [self.previousArray removeAllObjects];
    }
    [delegate thirdLevelDidFinish:self];
    [super viewWillDisappear:animated];
}


- (void)fourthLevelDidFinish:(AddContentFourthLevelView*)thirdLevel {
    self.selectedIdArray = thirdLevel.previousArray;
    NSLog(@"selected array from previous:%@",self.selectedIdArray);
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
    //[cell.image setContentMode:UIViewContentModeScaleToFill];
    if([self.selectedIdArray containsObject:contentCategory.categoryId]) {
        
        [cell.checkMarkButton setSelected:YES];
    }else {
        [cell.checkMarkButton setSelected:NO];
    }
//    if(contentCategory.isSubscribed) {
//        [self.selectedIdArray addObject:contentCategory.categoryId];
//        [cell.checkMarkButton setSelected:YES];
//    }else {
//        [self.selectedIdArray removeObject:contentCategory.categoryId];
//        [cell.checkMarkButton setSelected:NO];
//    }
    cell.checkMarkButton.tag = indexPath.row;
    cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.contentView.layer.borderWidth = 1.0f;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FIContentCategory *contentCategory = [self.innerArray objectAtIndex:indexPath.row];
    if(contentCategory.listArray.count != 0) {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AddContent" bundle:nil];
    AddContentFourthLevelView *thirdLevel = [storyboard instantiateViewControllerWithIdentifier:@"FourthLevel"];
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
    
    [[NSUserDefaults standardUserDefaults]setObject:self.selectedIdArray forKey:@"thirdLevelSelection"];
    [[NSUserDefaults standardUserDefaults]setObject:self.uncheckedArray forKey:@"thirdLevelUnSelection"];
}


- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
