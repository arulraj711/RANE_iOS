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
#import "FIMenu.h"
#import "FirstLevelCell.h"
#import "FISharedResources.h"
#import "UIView+Toast.h"
#import "MZFormSheetController.h"
#import "FIUtils.h"

@interface AddContentFourthLevelView ()

@end

@implementation AddContentFourthLevelView
@synthesize  delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChangeNotification:)
                                                name:UITextFieldTextDidChangeNotification object:nil];
    
    self.selectTopicsLabel.hidden = YES;
   // self.titleLabel.text = self.title;
    
    
    UIBarButtonItem *addAcc = [[UIBarButtonItem alloc]
                               initWithTitle:@"Save"
                               style:UIBarButtonItemStylePlain
                               target:self
                               action:@selector(updateAddContent)];
    NSArray *arrBtns = [[NSArray alloc]initWithObjects:addAcc, nil];
    self.navigationItem.rightBarButtonItems = arrBtns;
    
    
    NSMutableArray *firstArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"fourthLevelSelection"];
    NSMutableArray *secondArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"fourthLevelUnSelection"];
    self.selectedIdArray = [[NSMutableArray alloc]initWithArray:firstArray];
    self.uncheckedArray = [[NSMutableArray alloc]initWithArray:secondArray];
    self.checkedArray = [[NSMutableArray alloc]init];
    
    // Do any additional setup after loading the view.
//    RFQuiltLayout* layout = (id)[self.categoryCollectionView collectionViewLayout];
//    layout.direction = UICollectionViewScrollDirectionVertical;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        //layout.blockPixels = CGSizeMake(110,110);
       // UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
            testLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, self.selectTopicsLabel.frame.origin.y-10 ,self.selectTopicsLabel.frame.size.width,self.selectTopicsLabel.frame.size.height)];
            testLabel.text = self.title;
            testLabel.textAlignment = NSTextAlignmentCenter;
            testLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:18.0];
        [self.view addSubview:testLabel];
        

        
    } else {
    //layout.blockPixels = CGSizeMake(180,180);
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        if(orientation == 1) {
            testLabel = [[UILabel alloc]initWithFrame:CGRectMake((130-self.selectTopicsLabel.frame.size.width)/2, self.selectTopicsLabel.frame.origin.y ,self.selectTopicsLabel.frame.size.width,self.selectTopicsLabel.frame.size.height)];
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
        

    }
    [self.categoryCollectionView reloadData];
    [self loadSelectedCategory];
}


-(void)textChangeNotification:(NSNotification *)notification {
    NSLog(@"search notification");
    [self searchRecordsAsPerText:self.searchTextField.text];
}

-(void)searchRecordsAsPerText:(NSString *)string {
    [searchArray removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[cd] %@", string];
    NSArray *filtered = [self.innerArray filteredArrayUsingPredicate:predicate];
    NSLog(@"filtered array :%@",filtered);
    searchArray = [[NSMutableArray alloc]initWithArray:filtered];
    //    for (NSDictionary *obj in self.contentTypeArray){
    //        NSString *sTemp = [obj valueForKey:@"TEXT"];
    //        NSRange titleResultsRange = [sTemp rangeOfString:string options:NSCaseInsensitiveSearch];
    //
    //        if (titleResultsRange.length > 0)
    //        {
    //            [searchArray addObject:obj];
    //        }
    //    }
    //[searchTable reloadData];
    [self.categoryCollectionView reloadData];
}


- (void)loadSelectedCategory
{
    //if(self.isSelected) {
        BOOL isChanged = [[NSUserDefaults standardUserDefaults]boolForKey:@"isFourthLevelChanged"];
        NSMutableArray *alreadySelectedArray = [[NSUserDefaults standardUserDefaults]objectForKey:[self.selectedId stringValue]];
        
        if(isChanged) {
            if(alreadySelectedArray.count == 0){
                for(FIContentCategory *category in self.innerArray) {
                    [self.checkedArray addObject:category.categoryId];
                    [self.selectedIdArray addObject:category.categoryId];
                   // [self.uncheckedArray removeObject:category.categoryId];
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
//    }
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
    if(self.selectedIdArray.count == 0) {
        //[self.previousArray removeObject:self.selectedId];
        //self.selectedIdArray = [[NSMutableArray alloc]init];
        //[[NSUserDefaults standardUserDefaults]setObject:self.selectedIdArray forKey:[self.selectedId stringValue]];
    } else {
        [self.previousArray addObject:self.selectedId];
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
    NSInteger rowCount = 0;
    if(searchArray.count != 0) {
        rowCount = searchArray.count;
    } else {
        rowCount = self.innerArray.count;
    }
    return rowCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // NSLog(@"cell for item");
    FirstLevelCell *cell =(FirstLevelCell*) [cv dequeueReusableCellWithReuseIdentifier:@"FirstLevelCell" forIndexPath:indexPath];
    
    FIContentCategory *contentCategory;
    if(searchArray.count != 0) {
        contentCategory = [searchArray objectAtIndex:indexPath.row];
    } else {
        contentCategory = [self.innerArray objectAtIndex:indexPath.row];
    }
    cell.name.text = contentCategory.name;
    
//    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"listPlaceholderImage.png"];
//    
//    [cell.image sd_setImageWithURL:[NSURL URLWithString:contentCategory.imageUrl] placeholderImage:[UIImage imageWithContentsOfFile:path]];
//   [cell.image setContentMode:UIViewContentModeScaleAspectFill];
    if([self.selectedIdArray containsObject:contentCategory.categoryId]) {
        //[self.selectedIdArray addObject:contentCategory.categoryId];
        [cell.checkMarkButton setSelected:YES];
    }else {
       // [self.selectedIdArray removeObject:contentCategory.categoryId];
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
    UITapGestureRecognizer *cellTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cellTap:)];
    cell.tag = indexPath.row;
    [cell addGestureRecognizer:cellTap];
    return cell;
}

-(void)cellTap:(UITapGestureRecognizer *)tapGesture {
    SecondLevelCell *cell =(SecondLevelCell*)tapGesture.view;
    FIContentCategory *contentCategory = [self.innerArray objectAtIndex:[tapGesture.view tag]];
    if(contentCategory.listArray.count != 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AddContentPhone" bundle:nil];
        AddContentFifthLevelView *thirdLevel = [storyboard instantiateViewControllerWithIdentifier:@"FifthLevel"];
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
    FIContentCategory *contentCategory;
    if(searchArray.count != 0) {
        contentCategory = [searchArray objectAtIndex:[sender tag]];
    } else {
        contentCategory = [self.innerArray objectAtIndex:[sender tag]];
    }
    if(contentCategory.listArray.count != 0) {
        UIStoryboard *storyboard;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            storyboard = [UIStoryboard storyboardWithName:@"AddContentPhone" bundle:nil];
        } else if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            storyboard = [UIStoryboard storyboardWithName:@"AddContent" bundle:nil];
        }
        AddContentFifthLevelView *thirdLevel = [storyboard instantiateViewControllerWithIdentifier:@"FifthLevel"];
        thirdLevel.delegate = self;
        thirdLevel.innerArray = contentCategory.listArray;
        thirdLevel.title = contentCategory.name;
        thirdLevel.previousArray = self.selectedIdArray;
        thirdLevel.selectedId = contentCategory.categoryId;
        thirdLevel.firstLevelCheckedArray = self.firstLevelCheckedArray;
        thirdLevel.firstLevelUnCheckedArray = self.firstLevelUnCheckedArray;
//        if(cell.checkMarkButton.isSelected) {
//            thirdLevel.isSelected = YES;
//        } else {
//            thirdLevel.isSelected = NO;
//        }
        [self.navigationController pushViewController:thirdLevel animated:YES];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    SecondLevelCell *cell =(SecondLevelCell*)[self.categoryCollectionView cellForItemAtIndexPath:indexPath];
//    FIContentCategory *contentCategory = [self.innerArray objectAtIndex:indexPath.row];
//    if(contentCategory.listArray.count != 0) {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AddContent" bundle:nil];
//        AddContentFifthLevelView *thirdLevel = [storyboard instantiateViewControllerWithIdentifier:@"FifthLevel"];
//        thirdLevel.delegate = self;
//        thirdLevel.innerArray = contentCategory.listArray;
//        thirdLevel.title = contentCategory.name;
//        thirdLevel.previousArray = self.selectedIdArray;
//        thirdLevel.selectedId = contentCategory.categoryId;
//        if(cell.checkMarkButton.isSelected) {
//            thirdLevel.isSelected = YES;
//        } else {
//            thirdLevel.isSelected = NO;
//        }
//        [self.navigationController pushViewController:thirdLevel animated:YES];
//    }
}

//-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//    SecondLevelCell *cell = (SecondLevelCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    [cell.checkMarkButton setSelected:NO];
//}

- (IBAction)checkMark:(id)sender {
        FIMenu *contentCategory = [self.innerArray objectAtIndex:[sender tag]];
        if([self.selectedIdArray containsObject:contentCategory.nodeId]) {
            [self.selectedIdArray removeObject:contentCategory.nodeId];
            [sender setSelected:NO];
            [self.checkedArray removeObject:contentCategory.nodeId];
            // } else {
            [self.uncheckedArray addObject:contentCategory.nodeId];
            // }
            NSMutableArray *testArray = [[NSMutableArray alloc]init];
            [[NSUserDefaults standardUserDefaults]setObject:testArray forKey:[contentCategory.nodeId stringValue]];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFifthLevelChanged"];
        } else {
            [self.selectedIdArray addObject:contentCategory.nodeId];
            [sender setSelected:YES];
            //  if([self.checkedArray containsObject:contentCategory.categoryId]) {
            [self.checkedArray addObject:contentCategory.nodeId];
            // } else {
            [self.uncheckedArray removeObject:contentCategory.nodeId];
            // }
        }
    NSDictionary *dictionary = @{@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"], @"userName":[[NSUserDefaults standardUserDefaults]objectForKey:@"firstName"],@"contentCategory":contentCategory.name};
    [Localytics tagEvent:@"AddContent Module Change" attributes:dictionary];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFourthLevelChanged"];
    [[NSUserDefaults standardUserDefaults]setObject:self.selectedIdArray forKey:[self.selectedId stringValue]];
    [[NSUserDefaults standardUserDefaults]setObject:self.selectedIdArray forKey:@"fourthLevelSelection"];
    [[NSUserDefaults standardUserDefaults]setObject:self.uncheckedArray forKey:@"fourthLevelUnSelection"];
}

-(void)updateAddContent {
    [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"SaveChangesInAddContent"];
    BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"CloseAddContentTutorial"];
    if (coachMarksShown == YES) {
        
        NSMutableArray *categoryArray = [[NSMutableArray alloc]init];
        NSMutableArray *contentType = [[NSMutableArray alloc]init];
        
        NSMutableArray *secondLevelSelection = [[NSUserDefaults standardUserDefaults]objectForKey:@"secondLevelSelection"];
        for(int i=0;i<secondLevelSelection.count;i++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:[secondLevelSelection objectAtIndex:i] forKey:@"id"];
            [dic setObject:[NSNumber numberWithBool:YES] forKey:@"isSubscribed"];
            [categoryArray addObject:dic];
        }
        
        NSMutableArray *secondLevelUnSelection = [[NSUserDefaults standardUserDefaults]objectForKey:@"secondLevelUnSelection"];
        for(int i=0;i<secondLevelUnSelection.count;i++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:[secondLevelUnSelection objectAtIndex:i] forKey:@"id"];
            [dic setObject:[NSNumber numberWithBool:NO] forKey:@"isSubscribed"];
            [categoryArray addObject:dic];
        }
        
        
        NSMutableArray *thirdLevelSelection = [[NSUserDefaults standardUserDefaults]objectForKey:@"thirdLevelSelection"];
        for(int i=0;i<thirdLevelSelection.count;i++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:[thirdLevelSelection objectAtIndex:i] forKey:@"id"];
            [dic setObject:[NSNumber numberWithBool:YES] forKey:@"isSubscribed"];
            [categoryArray addObject:dic];
        }
        
        NSMutableArray *thirdLevelUnSelection = [[NSUserDefaults standardUserDefaults]objectForKey:@"thirdLevelUnSelection"];
        for(int i=0;i<thirdLevelUnSelection.count;i++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:[thirdLevelUnSelection objectAtIndex:i] forKey:@"id"];
            [dic setObject:[NSNumber numberWithBool:NO] forKey:@"isSubscribed"];
            [categoryArray addObject:dic];
        }
        
        NSMutableArray *fourthLevelSelection = [[NSUserDefaults standardUserDefaults]objectForKey:@"fourthLevelSelection"];
        for(int i=0;i<fourthLevelSelection.count;i++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:[fourthLevelSelection objectAtIndex:i] forKey:@"id"];
            [dic setObject:[NSNumber numberWithBool:YES] forKey:@"isSubscribed"];
            [categoryArray addObject:dic];
        }
        
        NSMutableArray *fourthLevelUnSelection = [[NSUserDefaults standardUserDefaults]objectForKey:@"fourthLevelUnSelection"];
        for(int i=0;i<fourthLevelUnSelection.count;i++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:[fourthLevelUnSelection objectAtIndex:i] forKey:@"id"];
            [dic setObject:[NSNumber numberWithBool:NO] forKey:@"isSubscribed"];
            [categoryArray addObject:dic];
        }
        
        NSMutableArray *fifthLevelSelection = [[NSUserDefaults standardUserDefaults]objectForKey:@"fifthLevelSelection"];
        for(int i=0;i<fifthLevelSelection.count;i++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:[fifthLevelSelection objectAtIndex:i] forKey:@"id"];
            [dic setObject:[NSNumber numberWithBool:YES] forKey:@"isSubscribed"];
            [categoryArray addObject:dic];
        }
        
        NSMutableArray *fifthLevelUnSelection = [[NSUserDefaults standardUserDefaults]objectForKey:@"fifthLevelUnSelection"];
        for(int i=0;i<fifthLevelUnSelection.count;i++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:[fifthLevelUnSelection objectAtIndex:i] forKey:@"id"];
            [dic setObject:[NSNumber numberWithBool:NO] forKey:@"isSubscribed"];
            [categoryArray addObject:dic];
        }
        
        for(int i=0;i<self.firstLevelCheckedArray.count;i++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            
            NSDictionary *contentTypeDic = [self.firstLevelCheckedArray objectAtIndex:i];
            
            [dic setObject:[contentTypeDic objectForKey:@"id"] forKey:@"id"];
            [dic setObject:[contentTypeDic objectForKey:@"companyId"] forKey:@"companyId"];
            [dic setObject:[contentTypeDic objectForKey:@"contentTypeForCustomerId"] forKey:@"contentTypeForCustomerId"];
            [dic setObject:[NSNumber numberWithBool:YES] forKey:@"isSubscribed"];
            [contentType addObject:dic];
        }
        for(int i=0;i<self.firstLevelUnCheckedArray.count;i++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            NSDictionary *contentTypeDic = [self.firstLevelUnCheckedArray objectAtIndex:i];
            
            [dic setObject:[contentTypeDic objectForKey:@"id"] forKey:@"id"];
            [dic setObject:[contentTypeDic objectForKey:@"companyId"] forKey:@"companyId"];
            [dic setObject:[contentTypeDic objectForKey:@"contentTypeForCustomerId"] forKey:@"contentTypeForCustomerId"];
            [dic setObject:[NSNumber numberWithBool:NO] forKey:@"isSubscribed"];
            [contentType addObject:dic];
        }
        // NSLog(@"content type %d and category:%d and checked array:%d and unchecked array:%@",contentType.count,categoryArray.count,self.checkedArray.count,contentType);
        //        if(self.checkedArray.count == 0) {
        //            NSManagedObject *addContentBrandingIdentity = [FIUtils getBrandFromBrandingIdentityForId:[NSNumber numberWithInt:35]];
        //            NSString *message = [NSString stringWithFormat:@"%@",[addContentBrandingIdentity valueForKey:@"name"]];
        //            [self.view makeToast:message duration:1 position:CSToastPositionCenter];
        //        } else {
        NSMutableDictionary *gradedetails = [[NSMutableDictionary alloc] init];
        [gradedetails setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
        [gradedetails setObject:[NSNumber numberWithBool:YES] forKey:@"updateCategory"];
        [gradedetails setObject:categoryArray forKey:@"contentCategory"];
        [gradedetails setObject:contentType forKey:@"contentType"];
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:gradedetails options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
        NSLog(@"final json format:%@",resultStr);
        
        //if(_isContentChanged){
        
        [[FISharedResources sharedResourceManager]manageContentCategoryWithDetails:resultStr withFlag:1];
        // }
        
        //[self.view makeToast:@"Content types and Content categories updated successfully" duration:2 position:CSToastPositionCenter];
        [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
        // }
        
    }
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
