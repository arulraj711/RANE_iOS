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
#import "FIMenu.h"
#import "FirstLevelCell.h"

@interface AddContentThirdLevelView ()

@end

@implementation AddContentThirdLevelView
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectTopicsLabel.hidden = YES;
    //self.titleLabel.text = self.title;
//    self.selectedIdArray = [[NSMutableArray alloc]init];
//    self.uncheckedArray = [[NSMutableArray alloc]init];
    NSMutableArray *firstArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"thirdLevelSelection"];
    self.selectedIdArray = [[NSMutableArray alloc]initWithArray:firstArray];
    NSMutableArray *secondArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"thirdLevelUnSelection"];
    self.uncheckedArray = [[NSMutableArray alloc]initWithArray:secondArray];
    
    self.checkedArray = [[NSMutableArray alloc]init];
    //self.uncheckedArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
   // RFQuiltLayout* layout = (id)[self.categoryCollectionView collectionViewLayout];
    //layout.direction = UICollectionViewScrollDirectionVertical;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            testLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, self.selectTopicsLabel.frame.origin.y-10 ,self.selectTopicsLabel.frame.size.width,self.selectTopicsLabel.frame.size.height)];
            testLabel.text = self.title;
            testLabel.textAlignment = NSTextAlignmentCenter;
            testLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:18.0];
            //self.selectTopicsLabel.frame = CGRectMake(0, self.selectTopicsLabel.frame.origin.y, self.selectTopicsLabel.frame.size.width, self.selectTopicsLabel.frame.size.height);
            // layout.blockPixels = CGSizeMake(100,150);
        [self.view addSubview:testLabel];
        [self.categoryCollectionView reloadData];
        [self loadSelectedCategory];

    } else {
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        if(orientation == 1) {
            testLabel = [[UILabel alloc]initWithFrame:CGRectMake((320-self.selectTopicsLabel.frame.size.width)/2, self.selectTopicsLabel.frame.origin.y ,self.selectTopicsLabel.frame.size.width,self.selectTopicsLabel.frame.size.height)];
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
    //[[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isChanged"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


- (void)loadSelectedCategory
{
    //if(self.isSelected) {
        BOOL isChanged = [[NSUserDefaults standardUserDefaults]boolForKey:@"isThirdLevelChanged"];
        NSMutableArray *alreadySelectedArray = [[NSUserDefaults standardUserDefaults]objectForKey:[self.selectedId stringValue]];
       // NSLog(@"already selected array:%d",alreadySelectedArray.count);
        if(isChanged) {
            if(alreadySelectedArray.count == 0){
                for(FIContentCategory *category in self.innerArray) {
                    [self.checkedArray addObject:category.categoryId];
                    [self.selectedIdArray addObject:category.categoryId];
                    [self.uncheckedArray removeObject:category.categoryId];
                }
            } else {
                self.selectedIdArray = [[NSMutableArray alloc]initWithArray:alreadySelectedArray];
            }
        } else {
            for(FIContentCategory *category in self.innerArray) {
                if(category.isSubscribed) {
                    [self.checkedArray addObject:category.categoryId];
                    [self.selectedIdArray addObject:category.categoryId];
                } else {
                    [self.uncheckedArray addObject:category.categoryId];
                    [self.selectedIdArray removeObject:category.categoryId];
                }
            }
        }
//    } else {
//        self.selectedIdArray = [[NSMutableArray alloc]init];
//        [[NSUserDefaults standardUserDefaults]setObject:self.selectedIdArray forKey:[self.selectedId stringValue]];
////    }
//    [[NSUserDefaults standardUserDefaults]setObject:self.selectedIdArray forKey:@"thirdLevelSelection"];
//    [[NSUserDefaults standardUserDefaults]setObject:self.uncheckedArray forKey:@"thirdLevelUnSelection"];
//    [self.categoryCollectionView reloadData];
   
}

-(void) viewWillDisappear:(BOOL)animated {
    if(self.selectedIdArray.count == 0) {
       // [self.previousArray removeObject:self.selectedId];
        //self.selectedIdArray = [[NSMutableArray alloc]init];
        //[[NSUserDefaults standardUserDefaults]setObject:self.selectedIdArray forKey:[self.selectedId stringValue]];
    } else {
        [self.previousArray addObject:self.selectedId];
        [self.previousUnCheckArray removeObject:self.selectedId];
    }
    
//    if(self.selectedIdArray.count != 0) {
//        [self.previousArray addObject:self.selectedId];
//    } else {
//        [self.previousArray removeAllObjects];
//    }
    [delegate thirdLevelDidFinish:self];
    [super viewWillDisappear:animated];
}


- (void)fourthLevelDidFinish:(AddContentFourthLevelView*)thirdLevel {
    self.selectedIdArray = thirdLevel.previousArray;
//    for(int i =0; i <self.selectedIdArray.count;i++) {
//        [self.uncheckedArray removeObject:[self.selectedIdArray objectAtIndex:i]];
//    }
//    NSLog(@"selected array from previous:%@",self.selectedIdArray);
//    [[NSUserDefaults standardUserDefaults]setObject:self.selectedIdArray forKey:@"thirdLevelSelection"];
//     [[NSUserDefaults standardUserDefaults]setObject:self.uncheckedArray forKey:@"thirdLevelUnSelection"];
    [self.categoryCollectionView reloadData];
}

#pragma mark – RFQuiltLayoutDelegate
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(1, 1);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(5, 5, 5, 10);
}
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
     //NSLog(@"imp collection view");
    return self.innerArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // NSLog(@"cell for item");
    FirstLevelCell *cell =(FirstLevelCell*) [cv dequeueReusableCellWithReuseIdentifier:@"FirstLevelCell" forIndexPath:indexPath];
    
    FIContentCategory *contentCategory = [self.innerArray objectAtIndex:indexPath.row];
    cell.name.text = contentCategory.name;
    
//    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"listPlaceholderImage.png"];
//    
//    [cell.image sd_setImageWithURL:[NSURL URLWithString:contentCategory.imageUrl] placeholderImage:[UIImage imageWithContentsOfFile:path]];
//    [cell.image setContentMode:UIViewContentModeScaleAspectFill];
    if([self.selectedIdArray containsObject:contentCategory.categoryId]) {
        
        [cell.checkMarkButton setSelected:YES];
    }else {
        [cell.checkMarkButton setSelected:NO];
    }
    if(contentCategory.listArray.count != 0) {
        cell.expandButton.hidden = NO;
    } else {
        cell.expandButton.hidden = YES;
    }
    cell.checkMarkButton.tag = indexPath.row;
    cell.expandButton.tag = indexPath.row;
    cell.contentView.layer.borderColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0].CGColor;
    cell.contentView.layer.borderWidth = 1.0f;
//    UITapGestureRecognizer *cellTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cellTap:)];
//    cell.tag = indexPath.row;
//    [cell addGestureRecognizer:cellTap];
    return cell;
}

-(void)cellTap:(UITapGestureRecognizer *)tapGesture {
    SecondLevelCell *cell =(SecondLevelCell*)tapGesture.view;
    FIContentCategory *contentCategory = [self.innerArray objectAtIndex:[tapGesture.view tag]];
    if(contentCategory.listArray.count != 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AddContentPhone" bundle:nil];
        AddContentFourthLevelView *thirdLevel = [storyboard instantiateViewControllerWithIdentifier:@"FourthLevel"];
        thirdLevel.delegate = self;
        thirdLevel.innerArray = contentCategory.listArray;
        thirdLevel.title = contentCategory.name;
        thirdLevel.previousArray = self.selectedIdArray;
        thirdLevel.selectedId = contentCategory.categoryId;
        if(cell.checkMarkButton.isSelected) {
            thirdLevel.isSelected = YES;
        } else {
            thirdLevel.isSelected = NO;
        }
        [self.navigationController pushViewController:thirdLevel animated:YES];
    }
}

- (IBAction)expandButtonClick:(id)sender {
    FIMenu *contentCategory = [self.innerArray objectAtIndex:[sender tag]];
    if(contentCategory.listArray.count != 0) {
        UIStoryboard *storyboard;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            storyboard = [UIStoryboard storyboardWithName:@"AddContentPhone" bundle:nil];
        } else if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            storyboard = [UIStoryboard storyboardWithName:@"AddContent" bundle:nil];
        }
        AddContentFourthLevelView *thirdLevel = [storyboard instantiateViewControllerWithIdentifier:@"FourthLevel"];
        thirdLevel.delegate = self;
        thirdLevel.innerArray = contentCategory.listArray;
        thirdLevel.title = contentCategory.name;
        thirdLevel.previousArray = self.selectedIdArray;
        thirdLevel.selectedId = contentCategory.nodeId;
//        if(cell.checkMarkButton.isSelected) {
//            thirdLevel.isSelected = YES;
//        } else {
//            thirdLevel.isSelected = NO;
//        }
        [self.navigationController pushViewController:thirdLevel animated:YES];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
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
        if([self.uncheckedArray containsObject:contentCategory.categoryId]){
            
        } else {
            [self.uncheckedArray addObject:contentCategory.categoryId];
        }
        
        // }
        NSMutableArray *testArray = [[NSMutableArray alloc]init];
        [[NSUserDefaults standardUserDefaults]setObject:testArray forKey:[contentCategory.categoryId stringValue]];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFourthLevelChanged"];
    } else {
        [self.selectedIdArray addObject:contentCategory.categoryId];
        [sender setSelected:YES];
        //  if([self.checkedArray containsObject:contentCategory.categoryId]) {
        [self.checkedArray addObject:contentCategory.categoryId];
        // } else {
        [self.uncheckedArray removeObject:contentCategory.categoryId];
        // }
    }
    
    NSDictionary *dictionary = @{@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"], @"userName":[[NSUserDefaults standardUserDefaults]objectForKey:@"firstName"],@"contentCategory":contentCategory.name};
    [Localytics tagEvent:@"AddContent Module Change" attributes:dictionary];
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isThirdLevelChanged"];
    
    NSLog(@"selected id array after removal:%@",self.selectedIdArray);
    NSLog(@"unchecked array :%@",self.uncheckedArray);
    [[NSUserDefaults standardUserDefaults]setObject:self.selectedIdArray forKey:[self.selectedId stringValue]];
    [[NSUserDefaults standardUserDefaults]setObject:self.selectedIdArray forKey:@"thirdLevelSelection"];
    [[NSUserDefaults standardUserDefaults]setObject:self.uncheckedArray forKey:@"thirdLevelUnSelection"];
}


- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
