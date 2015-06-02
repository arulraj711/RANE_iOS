//
//  AddContentFirstLevelView.m
//  FullIntel
//
//  Created by Arul on 4/15/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "AddContentFirstLevelView.h"
#import "FirstLevelCell.h"
#import "MZFormSheetController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FISharedResources.h"
#import "FIContentCategory.h"
#import "UIView+Toast.h"
#import "AddContentSecondLevelView.h"
@interface AddContentFirstLevelView ()

@end

@implementation AddContentFirstLevelView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadContentCategory) name:@"contentCategory" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddContentExpire) name:@"AddContentExpire" object:nil];
    
   
    
    layout = (id)[self.contentCollectionView collectionViewLayout];
    layout.direction = UICollectionViewScrollDirectionVertical;
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    NSLog(@"current device orientation:%ld",(long)orientation);
    if(orientation == 1) {
        layout.blockPixels = CGSizeMake(120,150);
    }else {
        layout.blockPixels = CGSizeMake(130,150);
    }
    
    
    self.selectedIdArray = [[NSMutableArray alloc]init];
    self.checkedArray = [[NSMutableArray alloc]init];
    self.uncheckedArray = [[NSMutableArray alloc]init];
     [[NSUserDefaults standardUserDefaults]setObject:self.selectedIdArray forKey:@"secondLevelSelection"];
    [[NSUserDefaults standardUserDefaults]setObject:self.selectedIdArray forKey:@"thirdLevelSelection"];
    [[NSUserDefaults standardUserDefaults]setObject:self.selectedIdArray forKey:@"fourthLevelSelection"];
    
    NSMutableDictionary *contentCategoryJSON = [[NSMutableDictionary alloc] init];
    [contentCategoryJSON setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
    [contentCategoryJSON setObject:[NSNumber numberWithBool:NO] forKey:@"updateCategory"];
    
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:contentCategoryJSON options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
    [[FISharedResources sharedResourceManager]manageContentCategoryWithDetails:resultStr withFlag:0];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
     // NSLog(@"device rotate is working:%ld",(long)fromInterfaceOrientation);
    if(fromInterfaceOrientation == 1) {
        layout.blockPixels = CGSizeMake(130,150);
    }else {
        layout.blockPixels = CGSizeMake(120,150);
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Access to form sheet controller
    MZFormSheetController *controller = self.navigationController.formSheetController;
    controller.shouldDismissOnBackgroundViewTap = YES;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    self.showStatusBar = YES;
    [UIView animateWithDuration:0.3 animations:^{
        [self.navigationController.formSheetController setNeedsStatusBarAppearanceUpdate];
    }];
    
}


-(void)loadContentCategory {
    self.contentTypeArray = [[NSMutableArray alloc]initWithArray:[FISharedResources sharedResourceManager].contentTypeList];
    self.contentCategoryArray = [[NSMutableArray alloc]initWithArray:[FISharedResources sharedResourceManager].contentCategoryList];
    for(FIContentCategory *category in self.contentTypeArray) {
        if(category.isSubscribed) {
            [self.checkedArray addObject:category.categoryId];
            [self.selectedIdArray addObject:category.categoryId];
        } else {
            [self.uncheckedArray addObject:category.categoryId];
            [self.selectedIdArray removeObject:category.categoryId];
        }
    }
    [self.contentCollectionView reloadData];
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"selectedCategory" object:nil userInfo:@{@"innerArray":self.contentCategoryArray,@"previousArray":self.selectedIdArray,@"title":@"Select Topic"}];
    
    
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
   // [self collectionView:self.contentCollectionView didSelectItemAtIndexPath:indexPath];
}

- (void)secondLevelDidFinish:(AddContentSecondLevelView*)secondLevel {
     NSLog(@"first level delegate method is working fine:%@",secondLevel.previousArray);
    if(secondLevel.previousArray != 0) {
        self.selectedIdArray = secondLevel.previousArray;
    } else {
        [self.selectedIdArray removeAllObjects];
    }
    [self.contentCollectionView reloadData];
}


- (IBAction)requestChange:(id)sender {
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    
     [[NSNotificationCenter defaultCenter]postNotificationName:@"requestChange" object:nil userInfo:nil];
}


-(void)AddContentExpire {
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)closeAction:(id)sender {
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
    
    
    for(int i=0;i<self.checkedArray.count;i++) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:[self.checkedArray objectAtIndex:i] forKey:@"id"];
        [dic setObject:[NSNumber numberWithBool:YES] forKey:@"isSubscribed"];
        [contentType addObject:dic];
    }
    for(int i=0;i<self.uncheckedArray.count;i++) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:[self.uncheckedArray objectAtIndex:i] forKey:@"id"];
        [dic setObject:[NSNumber numberWithBool:NO] forKey:@"isSubscribed"];
        [contentType addObject:dic];
    }
    
    NSMutableDictionary *gradedetails = [[NSMutableDictionary alloc] init];
    [gradedetails setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
    [gradedetails setObject:[NSNumber numberWithBool:YES] forKey:@"updateCategory"];
    [gradedetails setObject:categoryArray forKey:@"contentCategory"];
    [gradedetails setObject:contentType forKey:@"contentType"];
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:gradedetails options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
    NSLog(@"final json format:%@",resultStr);
    [[FISharedResources sharedResourceManager]manageContentCategoryWithDetails:resultStr withFlag:1];
    
    //[self.view makeToast:@"Content types and Content categories updated successfully" duration:2 position:CSToastPositionCenter];
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark – RFQuiltLayoutDelegate


-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(1, 1);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(5, 5, 5, 10);
}
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    // NSLog(@"imp collection view");
    return self.contentTypeArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // NSLog(@"cell for item");
    FirstLevelCell *cell =(FirstLevelCell*) [cv dequeueReusableCellWithReuseIdentifier:@"FirstLevelCell" forIndexPath:indexPath];
    
    FIContentCategory *contentCategory = [self.contentTypeArray objectAtIndex:indexPath.row];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:contentCategory.imageUrl] placeholderImage:[UIImage imageNamed:@"FI"]];
    
    
   // [cell.image setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:contentCategory.imageUrl]]]];
    
    
    //[cell.image setContentMode:UIViewContentModeScaleAspectFit];
    cell.name.text = contentCategory.name;
    cell.checkMarkButton.tag = indexPath.row;
    
    if([self.selectedIdArray containsObject:contentCategory.categoryId]) {
        //[self.checkedArray addObject:contentCategory.categoryId];
        //[self.selectedIdArray addObject:contentCategory.categoryId];
        [cell.checkMarkButton setSelected:YES];
    }else {
        //[self.uncheckedArray addObject:contentCategory.categoryId];
        //[self.selectedIdArray removeObject:contentCategory.categoryId];
        [cell.checkMarkButton setSelected:NO];
    }
    
//    if([self.selectedIdArray containsObject:contentCategory.name]) {
//        [cell.checkMarkButton setSelected:YES];
//    } else {
//        [cell.checkMarkButton setSelected:NO];
//    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FIContentCategory *contentCategory = [self.contentTypeArray objectAtIndex:indexPath.row];
    if(contentCategory.listArray.count != 0) {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AddContent" bundle:nil];
    AddContentSecondLevelView *secondLevel = [storyboard instantiateViewControllerWithIdentifier:@"SecondLevel"];
    secondLevel.delegate = self;
    secondLevel.innerArray = contentCategory.listArray;
    secondLevel.title = contentCategory.name;
    secondLevel.previousArray = self.selectedIdArray;
    secondLevel.selectedId = contentCategory.categoryId;
    [self.navigationController pushViewController:secondLevel animated:YES];
    }
    
}

- (IBAction)checkMark:(id)sender {
    FIContentCategory *contentCategory = [self.contentTypeArray objectAtIndex:[sender tag]];
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
    
    NSLog(@"after selection:%@ and checked:%@ and unchecked:%@",self.selectedIdArray,self.checkedArray,self.uncheckedArray);

}

@end
