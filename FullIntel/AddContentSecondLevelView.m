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
//#import "Localytics.h"
#import "pop.h"
#import "FISharedResources.h"
#import "FIMenu.h"
#import "FirstLevelCell.h"
#import "FIUnreadMenu.h"
#import "UIView+Toast.h"
#import "MZFormSheetController.h"
#import "FIUtils.h"
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
@interface AddContentSecondLevelView ()

@end

@implementation AddContentSecondLevelView
@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contents = [NSDictionary dictionaryWithObjectsAndKeys:
                     // Rounded rect buttons
                     @"A CMPopTipView will automatically position itself within the container view.", [NSNumber numberWithInt:11],
                     nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChangeNotification:)
                                                name:UITextFieldTextDidChangeNotification object:nil];
    
    UIBarButtonItem *addAcc = [[UIBarButtonItem alloc]
                               initWithTitle:@"Save"
                               style:UIBarButtonItemStylePlain
                               target:self
                               action:@selector(updateAddContent)];
    NSArray *arrBtns = [[NSArray alloc]initWithObjects:addAcc, nil];
    self.navigationItem.rightBarButtonItems = arrBtns;
    
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
//                                   initWithTitle:@"Back"
//                                   style:UIBarButtonItemStylePlain
//                                   target:nil
//                                   action:nil];
//    self.navigationItem.backBarButtonItem=backButton;
    
    self.selectTopicsLabel.hidden = YES;
    //self.navigationController.navigationBar.hidden = YES;
    //self.categoryCollectionView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    // self.categoryCollectionView.layer.borderWidth = 1.0f;
    self.selectedIdArray = [[NSMutableArray alloc]init];
    self.checkedArray = [[NSMutableArray alloc]init];
    self.uncheckedArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
//    layout = (id)[self.categoryCollectionView collectionViewLayout];
//    layout.direction = UICollectionViewScrollDirectionVertical;
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    //NSLog(@"current device orientation:%ld",(long)orientation);
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
       
            layout.blockPixels = CGSizeMake(110,110);

        
            testLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.selectTopicsLabel.frame.origin.y ,self.selectTopicsLabel.frame.size.width,self.selectTopicsLabel.frame.size.height)];
            testLabel.text = @"Topics";
            testLabel.textAlignment = NSTextAlignmentLeft;
            testLabel.font = [UIFont fontWithName:@"OpenSans" size:20.0];
        [self.view addSubview:testLabel];
    } else {
        if(orientation == 1) {
            layout.blockPixels = CGSizeMake(170,200);
        }else {
            layout.blockPixels = CGSizeMake(170,200);
            
        }
        if(orientation == 1) {
            testLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.selectTopicsLabel.frame.origin.y ,self.selectTopicsLabel.frame.size.width,self.selectTopicsLabel.frame.size.height)];
            testLabel.text = @"Topics";
            testLabel.textAlignment = NSTextAlignmentLeft;
            testLabel.font = [UIFont fontWithName:@"OpenSans" size:20.0];
        }else {
            // layout.blockPixels = CGSizeMake(130,150);
            testLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.selectTopicsLabel.frame.origin.y ,self.selectTopicsLabel.frame.size.width,self.selectTopicsLabel.frame.size.height)];
            testLabel.text = @"Topics";
            testLabel.textAlignment = NSTextAlignmentLeft;
            testLabel.font = [UIFont fontWithName:@"OpenSans" size:20.0];
            
        }
        [self.view addSubview:testLabel];
    }
    //layout.blockPixels = CGSizeMake(180,200);
    
    NSMutableArray *intermediateArray = [[NSMutableArray alloc]initWithArray:self.innerArray];
    
    for(FIMenu *menu in self.innerArray) {
        if(menu.name == NULL) {
            [intermediateArray removeObject:menu];
        }
    }
    
    self.innerArray = [[NSMutableArray alloc]initWithArray:intermediateArray];
    
    [self.categoryCollectionView reloadData];
    [self loadSelectedCategory];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadSelectedCategory:) name:@"selectedCategory" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SecondLevelTutorialTrigger) name:@"SecondLevelTutorialTrigger" object:nil];
    
    
    //   UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    
    
   
    [self.view addSubview:infoButton];
    [self.view addSubview:availableTopic];
    
    
    _tutorialContentView.hidden=YES;
    _tutorialContentView.layer.cornerRadius=5.0f;
    
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

-(void)stopSecondTutorial:(UITapGestureRecognizer *)sender{
    
    
    BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"SecondTutorialShown"];
    if (coachMarksShown == YES) {
        
        NSLog(@"triggerSecondTutorial");
        [self.view removeGestureRecognizer:tapEvent];
        
        _tutorialContentView.hidden=YES;
        
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"SecondTutorialShown"];
        
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"CloseAddContentTutorial"];
        
        [popAnimationTimer invalidate];
        
        [_categoryCollectionView reloadData];
        
        _tutorialContentView.hidden=YES;
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"closeAddContentView" object:nil];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MenuTutorialTrigger" object:nil];
        
        
        [self.view removeGestureRecognizer:tapEvent];
        
    }
}

-(void)SecondLevelTutorialTrigger{
    NSLog(@"second level tutorial");
    tapEvent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(stopSecondTutorial:)];
    
    [self.view addGestureRecognizer:tapEvent];
    
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"SecondTutorialShown"];
    
    
    [_categoryCollectionView reloadData];
    
    _tutorialContentView.hidden=NO;
    
}

-(void)permformAnimation:(NSTimer *)timer{
    
    
    
    
    SecondLevelCell *cell=timer.userInfo;
    
    [self animateFirstCell:cell];
    
}
-(void)animateFirstCell:(SecondLevelCell *)cell{
    
    [cell.layer removeAllAnimations];
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue=[NSValue valueWithCGSize:CGSizeMake(0.5, 0.5)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1,1)];
    scaleAnimation.springBounciness = 10;
    scaleAnimation.springSpeed=10;
    [cell.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
    
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    //[Localytics tagScreen:@"Add Content Topics"];
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
        layout.blockPixels = CGSizeMake(170,200);
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
    // NSLog(@"delegate method is working fine:%@",self.selectedIdArray);
    self.selectedIdArray = thirdLevel.previousArray;
    //NSLog(@"second selected id array:%@ and unchecked array:%@ and %@",self.selectedIdArray,self.uncheckedArray,thirdLevel.previousUnCheckArray);
    //    [[NSUserDefaults standardUserDefaults]setObject:self.selectedIdArray forKey:@"secondLevelSelection"];
    //    [[NSUserDefaults standardUserDefaults]setObject:self.uncheckedArray forKey:@"secondLevelUnSelection"];
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

- (void)loadSelectedCategory
{
    // NSLog(@"load seleced is working");
    //NSNotification *notification = sender;
    //NSDictionary *userInfo = notification.userInfo;
    //self.innerArray = [[NSMutableArray alloc]initWithArray:[userInfo objectForKey:@"innerArray"]];
    //self.previousArray = [[NSMutableArray alloc]initWithArray:[userInfo objectForKey:@"previousArray"]];
    // NSLog(@"second level previous array:%@ and selected id:%@",self.previousArray,self.selectedId);
    //if([self.previousArray containsObject:self.selectedId]) {
    NSMutableArray *alreadySelectedArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"secondLevelSelection"];
    // NSLog(@"already selected array count:%d",alreadySelectedArray.count);
    if(alreadySelectedArray.count ==0) {
        for(FIUnreadMenu *category in self.innerArray) {
            if([category.isSubscribed isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                [self.checkedArray addObject:category.nodeId];
                [self.selectedIdArray addObject:category.nodeId];
            } else {
                [self.uncheckedArray addObject:category.nodeId];
                [self.selectedIdArray removeObject:category.nodeId];
            }
        }
    } else {
        self.selectedIdArray = [[NSMutableArray alloc]initWithArray:alreadySelectedArray];
    }
    
    // [[NSUserDefaults standardUserDefaults]setObject:self.selectedIdArray forKey:@"secondLevelSelection"];
    //  [[NSUserDefaults standardUserDefaults]setObject:self.uncheckedArray forKey:@"secondLevelUnSelection"];
    
    //    } else {
    //        self.selectedIdArray = [[NSMutableArray alloc]init];
    //    }
    // NSLog(@"second level selected id array:%@",self.selectedIdArray);
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

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(1, 1);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(5, 5, 5, 15);
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
    FIMenu *contentCategory;
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
//    [cell.image setContentMode:UIViewContentModeScaleAspectFit];
    NSLog(@"selectedID array :%@",self.selectedIdArray);
    if([self.selectedIdArray containsObject:contentCategory.nodeId]) {
        
        [cell.checkMarkButton setSelected:YES];
    }else {
        
        [cell.checkMarkButton setSelected:NO];
    }
    cell.checkMarkButton.tag = indexPath.row;
    cell.expandButton.tag = indexPath.row;
    
    if(contentCategory.listArray.count != 0) {
        cell.expandButton.hidden = NO;
    } else {
        cell.expandButton.hidden = YES;
    }
    
    cell.contentView.layer.borderColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0].CGColor;
    cell.contentView.layer.borderWidth = 1.0f;
    
    BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"SecondTutorialShown"];
    if (coachMarksShown == YES) {
        
        
        if(indexPath.row==0){
            
            NSLog(@"animate first cell");
            
            cell.layer.borderWidth=1.0;
            cell.layer.borderColor=[[UIColor redColor]CGColor];
            
            
            popAnimationTimer=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(permformAnimation:) userInfo:cell repeats:YES];
        }
    }else{
        
        cell.layer.borderWidth=0.0;
        
    }
    
//    UITapGestureRecognizer *cellTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cellTap:)];
//    cell.tag = indexPath.row;
//    [cell addGestureRecognizer:cellTap];
    
    
    
    return cell;
}

-(void)cellTap:(UITapGestureRecognizer *)tapGesture {
    NSLog(@"cell tap is working:%d",[tapGesture.view tag]);
    BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"SecondTutorialShown"];
    if (coachMarksShown == NO) {
        NSLog(@"inside if");
        SecondLevelCell *cell = (SecondLevelCell *)tapGesture.view;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"contentSelected" object:nil];
        FIContentCategory *contentCategory = [self.innerArray objectAtIndex:[tapGesture.view tag]];
        if(contentCategory.listArray.count != 0) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AddContentPhone" bundle:nil];
            AddContentThirdLevelView *thirdLevel = [storyboard instantiateViewControllerWithIdentifier:@"ThirdLevel"];
            thirdLevel.delegate = self;
            thirdLevel.innerArray = contentCategory.listArray;
            thirdLevel.title = contentCategory.name;
            thirdLevel.previousArray = self.selectedIdArray;
            thirdLevel.previousUnCheckArray = self.uncheckedArray;
            thirdLevel.selectedId = contentCategory.categoryId;
            if(cell.checkMarkButton.isSelected) {
                thirdLevel.isSelected = YES;
            } else {
                thirdLevel.isSelected = NO;
            }
            
            [self.navigationController pushViewController:thirdLevel animated:YES];
        }
    }
}

- (IBAction)expandButtonClick:(id)sender {
    NSLog(@"expand button click :%ld",(long)[sender tag]);
   // SecondLevelCell *cell = (SecondLevelCell *)tapGesture.view;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"contentSelected" object:nil];
    FIMenu *contentCategory;
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
        AddContentThirdLevelView *thirdLevel = [storyboard instantiateViewControllerWithIdentifier:@"ThirdLevel"];
        thirdLevel.delegate = self;
        thirdLevel.innerArray = contentCategory.listArray;
        thirdLevel.title = contentCategory.name;
        thirdLevel.previousArray = self.selectedIdArray;
        thirdLevel.previousUnCheckArray = self.uncheckedArray;
        thirdLevel.selectedId = contentCategory.nodeId;
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
    
    
    
}

- (void)infoButtonClick:(id)sender {
    NSString *contentMessage = nil;
    UIView *contentView = nil;
    NSNumber *key = [NSNumber numberWithInteger:[(UIView *)sender tag]];
    id content = [self.contents objectForKey:key];
    if ([content isKindOfClass:[UIView class]]) {
        contentView = content;
    }
    else if ([content isKindOfClass:[NSString class]]) {
        contentMessage = content;
    }
    else {
        contentMessage = @"Level 1:Adobe,Google,Samsung,Apple\nLevel 2:Product,Service\nLevel 3: Photoshop,Dreamweaver\nLevel 4: North America";
    }
    
    NSString *title = nil;
    
    CMPopTipView *popTipView;
    if (contentView) {
        popTipView = [[CMPopTipView alloc] initWithCustomView:contentView];
    }
    else if (title) {
        popTipView = [[CMPopTipView alloc] initWithTitle:title message:contentMessage];
    }
    else {
        popTipView = [[CMPopTipView alloc] initWithMessage:contentMessage];
    }
    popTipView.delegate = self;
    popTipView.dismissTapAnywhere = YES;
    [popTipView autoDismissAnimated:YES atTimeInterval:3.0];
    UIButton *button = (UIButton *)sender;
    [popTipView presentPointingAtView:button inView:self.view animated:YES];
    
    self.currentPopTipViewTarget = sender;
}

- (IBAction)checkMark:(id)sender {
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"contentSelected" object:nil];
    
    FIMenu *contentCategory = [self.innerArray objectAtIndex:[sender tag]];
    if([self.selectedIdArray containsObject:contentCategory.nodeId]) {
        [self.selectedIdArray removeObject:contentCategory.nodeId];
        [sender setSelected:NO];
        [self.checkedArray removeObject:contentCategory.nodeId];
        // } else {
        [self.uncheckedArray addObject:contentCategory.nodeId];
        NSMutableArray *testArray = [[NSMutableArray alloc]init];
        [[NSUserDefaults standardUserDefaults]setObject:testArray forKey:[contentCategory.nodeId stringValue]];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isThirdLevelChanged"];
        
        // }
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

    [[NSUserDefaults standardUserDefaults]setObject:self.selectedIdArray forKey:@"secondLevelSelection"];
    [[NSUserDefaults standardUserDefaults]setObject:self.uncheckedArray forKey:@"secondLevelUnSelection"];
}
#pragma mark - CMPopTipViewDelegate methods

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView
{
    //  [self.visiblePopTipViews removeObject:popTipView];
    self.currentPopTipViewTarget = nil;
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

-(void)cancelButtonPress{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
