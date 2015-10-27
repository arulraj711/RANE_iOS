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
#import "FIUtils.h"
//#import "Localytics.h"
#import "pop.h"
@interface AddContentFirstLevelView ()


@property (nonatomic, readwrite) BOOL isContentChanged;
@end

@implementation AddContentFirstLevelView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadContentCategory) name:@"contentCategory" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddContentExpire) name:@"AddContentExpire" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentSelected) name:@"contentSelected" object:nil];
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backBtnPress) name:@"closeAddContentView" object:nil];
    
    layout = (id)[self.contentCollectionView collectionViewLayout];
    layout.direction = UICollectionViewScrollDirectionVertical;
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    //NSLog(@"current device orientation:%ld",(long)orientation);
    if(orientation == 1) {
        layout.blockPixels = CGSizeMake(120,150);
    }else {
        layout.blockPixels = CGSizeMake(130,150);
    }
    
    //[self.contentCollectionView reloadData];
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
    
    
    
    UIButton *Btn =[UIButton buttonWithType:UIButtonTypeCustom];
    
    [Btn setFrame:CGRectMake(0, 0, 60, 30)];
    // [Btn setBackgroundImage:[UIImage imageNamed:@"close"]  forState:UIControlStateNormal];
    
    [Btn setTitle:@"Cancel" forState:UIControlStateNormal];
    
    Btn.titleLabel.font= [UIFont fontWithName:@"OpenSans" size:17];
    [Btn addTarget:self action:@selector(backBtnPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    
    
    
    //        UIView *searchBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
    //        searchBtnView.backgroundColor = [UIColor clearColor];
    //        UIButton *searchBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    //        [searchBtn setFrame:CGRectMake(0, 0, 150, 30)];
    //     //   [searchBtn setBackgroundImage:[UIImage imageNamed:@"researchReq"]  forState:UIControlStateNormal];
    //
    //
    ////    searchBtn.titleLabel.font= [UIFont fontWithName:@"OpenSans" size:17];
    ////       [searchBtn setTitle:@"Research Request" forState:UIControlStateNormal];
    ////        [searchBtn addTarget:self action:@selector(requestChange:) forControlEvents:UIControlEventTouchUpInside];
    ////        [searchBtnView addSubview:searchBtn];
    ////        UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithCustomView:searchBtnView];
    
    
    [[UIBarButtonItem appearance]setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:addButton,  nil]];
    
    UIView *addBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    addBtnView.backgroundColor = [UIColor clearColor];
    
    UIButton *addBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setFrame:CGRectMake(0,0,50,30)];
    // [addBtn setImage :[UIImage imageNamed:@"checkMark"]  forState:UIControlStateNormal];
    
    [addBtn setTitle:@"Save" forState:UIControlStateNormal];
    
    addBtn.titleLabel.font= [UIFont fontWithName:@"OpenSans" size:17];
    [addBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBtnView addSubview:addBtn];
    UIBarButtonItem *addContentButton = [[UIBarButtonItem alloc] initWithCustomView:addBtnView];
    
    
    
    //    UIView *searchBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 15)];
    //    searchBtnView.backgroundColor = [UIColor clearColor];
    //    UIButton *searchBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    //    [searchBtn setFrame:CGRectMake(0.0f,0.0f,16.0f,15.0f)];
    //    [searchBtn setBackgroundImage:[UIImage imageNamed:@"search"]  forState:UIControlStateNormal];
    //    [searchBtn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    //    [searchBtnView addSubview:searchBtn];
    //    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithCustomView:searchBtnView];
    //
    //    UIView *settingsBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 15)];
    //    settingsBtnView.backgroundColor = [UIColor clearColor];
    //    UIButton *settingsBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    //    [settingsBtn setFrame:CGRectMake(0.0f,0.0f,15.0f,15.0f)];
    //    [settingsBtn setBackgroundImage:[UIImage imageNamed:@"settings"]  forState:UIControlStateNormal];
    //    [settingsBtn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    //    [settingsBtnView addSubview:settingsBtn];
    //    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithCustomView:settingsBtnView];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:addContentButton,  nil]];
    
    
    _requestChangeButton.layer.cornerRadius=5.0f;
    _requestChangeButton.layer.borderColor=[[UIColor darkGrayColor]CGColor];
    _requestChangeButton.layer.borderWidth=1.0f;
    
    _tutorialDescriptionView.layer.cornerRadius=5.0f;
    BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"TutorialShown"];
    if (coachMarksShown == YES) {
        _tutorialDescriptionView.hidden=YES;
        
    }else{
        
        _tutorialDescriptionView.hidden=NO;
        UITapGestureRecognizer *tapEvent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(triggerSecondTutorial)];
        
        [self.view addGestureRecognizer:tapEvent];
    }
    
    
    
    
    
}

-(void)triggerSecondTutorial{
    
    
    
    BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"TutorialShown"];
    if (coachMarksShown == NO) {
        _tutorialDescriptionView.hidden=YES;
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"SecondLevelTutorialTrigger" object:nil];
        
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"TutorialShown"];
        
        [popAnimationTimer invalidate];
        
        [_contentCollectionView reloadData];
        
    }
    
}


-(void)backBtnPress{
    
    [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"CancelChangesInAddContent"];
    BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"CloseAddContentTutorial"];
    if (coachMarksShown == YES) {
        
        //[[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"CancelChangesInAddContent"];
        
        [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    // NSLog(@"device rotate is working:%ld",(long)fromInterfaceOrientation);
    if(fromInterfaceOrientation == 1) {
        layout.blockPixels = CGSizeMake(130,150);
    }else {
        layout.blockPixels = CGSizeMake(120,150);
    }
    
}

-(void)contentSelected{
    
    _isContentChanged=YES;
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
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isThirdLevelChanged"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isFourthLevelChanged"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isFifthLevelChanged"];
    self.contentTypeArray = [[NSMutableArray alloc]initWithArray:[FISharedResources sharedResourceManager].contentTypeList];
    self.contentCategoryArray = [[NSMutableArray alloc]initWithArray:[FISharedResources sharedResourceManager].contentCategoryList];
    for(FIContentCategory *category in self.contentTypeArray) {
        //if([category.categoryId isEqualToNumber:[NSNumber numberWithInt:1]]) {
        if(category.isSubscribed) {
            [self.checkedArray addObject:category.categoryId];
            [self.selectedIdArray addObject:category.categoryId];
        } else {
            [self.uncheckedArray addObject:category.categoryId];
            [self.selectedIdArray removeObject:category.categoryId];
        }
        //}
    }
    [self.contentCollectionView reloadData];
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"selectedCategory" object:nil userInfo:@{@"innerArray":self.contentCategoryArray,@"previousArray":self.selectedIdArray,@"title":@"Select Topic"}];
    
    
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    // [self collectionView:self.contentCollectionView didSelectItemAtIndexPath:indexPath];
}

- (void)secondLevelDidFinish:(AddContentSecondLevelView*)secondLevel {
    // NSLog(@"first level delegate method is working fine:%@",secondLevel.previousArray);
    if(secondLevel.previousArray != 0) {
        self.selectedIdArray = secondLevel.previousArray;
    } else {
        [self.selectedIdArray removeAllObjects];
    }
    [self.contentCollectionView reloadData];
}


- (IBAction)requestChange:(id)sender {
    
    BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"CloseAddContentTutorial"];
    if (coachMarksShown == YES) {
        
        [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"requestChange" object:nil userInfo:nil];
        [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"ResearchRequestChangeInAddContent"];
    }
}

-(void)AddContentExpire {
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)closeAction:(id)sender {
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
        // NSLog(@"content type %d and category:%d and checked array:%d and unchecked array:%@",contentType.count,categoryArray.count,self.checkedArray.count,contentType);
        if(self.checkedArray.count == 0) {
            [self.view makeToast:@"Please select atleast one module" duration:1 position:CSToastPositionCenter];
        } else {
            NSMutableDictionary *gradedetails = [[NSMutableDictionary alloc] init];
            [gradedetails setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
            [gradedetails setObject:[NSNumber numberWithBool:YES] forKey:@"updateCategory"];
            [gradedetails setObject:categoryArray forKey:@"contentCategory"];
            [gradedetails setObject:contentType forKey:@"contentType"];
            NSData *jsondata = [NSJSONSerialization dataWithJSONObject:gradedetails options:NSJSONWritingPrettyPrinted error:nil];
            
            NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
            NSLog(@"final json format:%@",resultStr);
            
            if(_isContentChanged){
                
                [[FISharedResources sharedResourceManager]manageContentCategoryWithDetails:resultStr withFlag:1];
            }
            
            //[self.view makeToast:@"Content types and Content categories updated successfully" duration:2 position:CSToastPositionCenter];
            [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
    
}

#pragma mark – RFQuiltLayoutDelegate


-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(1, 1);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(5, 5, 5, 5);
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
    [cell.image setContentMode:UIViewContentModeScaleAspectFit];
    cell.name.text = contentCategory.name;
    cell.checkMarkButton.tag = indexPath.row;
    
    
    if(contentCategory.isCompanySubscribed) {
        //cell.gradientView.hidden = YES;
        cell.upgradeButton.hidden = YES;
        cell.checkMarkButton.hidden = NO;
    } else {
        NSNumber *accountTypeId = [[NSUserDefaults standardUserDefaults]objectForKey:@"userAccountTypeId"];
        //if([accountTypeId isEqualToNumber:[NSNumber numberWithInt:2]]) {
       // cell.gradientView.hidden = NO;
        cell.upgradeButton.hidden = NO;
        cell.checkMarkButton.hidden = YES;
        UITapGestureRecognizer *tapEvent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upgradeTap:)];
        cell.upgradeButton.tag = indexPath.row;
        [cell.upgradeButton addGestureRecognizer:tapEvent];
        //        } else {
        //
        //        }
        
    }
    
    
    
    //    if(self.contentTypeArray.count > 1) {
    //        if(indexPath.row != 0) {
    //            cell.gradientView.hidden = NO;
    //            UITapGestureRecognizer *tapEvent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upgradeTap:)];
    //            cell.upgradeButton.tag = indexPath.row;
    //            [cell.upgradeButton addGestureRecognizer:tapEvent];
    //        } else {
    //            cell.gradientView.hidden = YES;
    //        }
    //    } else {
    //        cell.gradientView.hidden = YES;
    //    }
    
    if([self.selectedIdArray containsObject:contentCategory.categoryId]) {
        //[self.checkedArray addObject:contentCategory.categoryId];
        //[self.selectedIdArray addObject:contentCategory.categoryId];
        [cell.checkMarkButton setSelected:YES];
    }else {
        //[self.uncheckedArray addObject:contentCategory.categoryId];
        //[self.selectedIdArray removeObject:contentCategory.categoryId];
        [cell.checkMarkButton setSelected:NO];
    }
    
    
    
    BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"TutorialShown"];
    if (coachMarksShown == NO) {
        
        if(indexPath.row==0){
            cell.layer.borderWidth=1.0;
            cell.layer.borderColor=[[UIColor redColor]CGColor];
            
            popAnimationTimer=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(permformAnimation:) userInfo:cell repeats:YES];
        }else{
            cell.layer.borderWidth=0.0;
        }
        
    }else{
        
        cell.layer.borderWidth=0.0;
    }
    
    
    return cell;
}

-(void)permformAnimation:(NSTimer *)timer {
    FirstLevelCell *cell=timer.userInfo;
    
    [self animateFirstCell:cell];
    
}
-(void)animateFirstCell:(FirstLevelCell *)cell{
    
    [cell.layer removeAllAnimations];
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue=[NSValue valueWithCGSize:CGSizeMake(0.5, 0.5)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1,1)];
    scaleAnimation.springBounciness = 10;
    scaleAnimation.springSpeed=10;
    [cell.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
    
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"CloseAddContentTutorial"];
    if (coachMarksShown == YES) {
        FIContentCategory *contentCategory = [self.contentTypeArray objectAtIndex:indexPath.row];
        if(contentCategory.listArray.count != 0) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AddContent" bundle:nil];
            AddContentSecondLevelView *secondLevel = [storyboard instantiateViewControllerWithIdentifier:@"SecondLevel"];
            secondLevel.delegate = self;
            secondLevel.innerArray = contentCategory.listArray;
            secondLevel.title = contentCategory.name;
            secondLevel.previousArray = self.selectedIdArray;
            secondLevel.selectedId = contentCategory.categoryId;
            NSDictionary *dictionary = @{@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"], @"userName":[[NSUserDefaults standardUserDefaults]objectForKey:@"firstName"],@"contentCategory":contentCategory.name};
            [Localytics tagEvent:@"Addcontent Topic Change" attributes:dictionary];
            [self.navigationController pushViewController:secondLevel animated:YES];
        }
    }
}

-(void)upgradeTap:(UITapGestureRecognizer *)sender {
    UIView *view = sender.view;
    //NSLog(@"tag value:%d",view.tag);
    FIContentCategory *contentCategory = [self.contentTypeArray objectAtIndex:view.tag];
    //NSLog(@"slected name:%@ and id:%@",contentCategory.name,contentCategory.categoryId);
    if([contentCategory.categoryId isEqualToNumber:[NSNumber numberWithInt:2]]) {
        //Stock Watch
        [FIUtils callRequestionUpdateWithModuleId:2 withFeatureId:15];
    } else if([contentCategory.categoryId isEqualToNumber:[NSNumber numberWithInt:4]]) {
        //IP and Legal
        [FIUtils callRequestionUpdateWithModuleId:4 withFeatureId:15];
    } else if([contentCategory.categoryId isEqualToNumber:[NSNumber numberWithInt:5]]) {
        //Executive Moves
        [FIUtils callRequestionUpdateWithModuleId:5 withFeatureId:15];
    } else if([contentCategory.categoryId isEqualToNumber:[NSNumber numberWithInt:7]]) {
        //Influencer Comments
        [FIUtils callRequestionUpdateWithModuleId:7 withFeatureId:15];
    } else if([contentCategory.categoryId isEqualToNumber:[NSNumber numberWithInt:8]]) {
        //Deals
        [FIUtils callRequestionUpdateWithModuleId:8 withFeatureId:15];
    } else if([contentCategory.categoryId isEqualToNumber:[NSNumber numberWithInt:10]]) {
        //Deals
        [FIUtils callRequestionUpdateWithModuleId:11 withFeatureId:15];
    } else if([contentCategory.categoryId isEqualToNumber:[NSNumber numberWithInt:11]]) {
        //Deals
        [FIUtils callRequestionUpdateWithModuleId:12 withFeatureId:15];
    }
    NSDictionary *dictionary = @{@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"], @"userName":[[NSUserDefaults standardUserDefaults]objectForKey:@"firstName"],@"contentCategory":contentCategory.name};
    [Localytics tagEvent:@"AddcontentTopicUpgradeRequest" attributes:dictionary];
    [self.view makeToast:@"Your request has been sent." duration:1 position:CSToastPositionCenter];
}

- (IBAction)checkMark:(id)sender {
    _isContentChanged=YES;
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
