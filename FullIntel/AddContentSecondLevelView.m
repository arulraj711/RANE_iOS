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
#import "Localytics.h"
#import "pop.h"

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
    //NSLog(@"current device orientation:%ld",(long)orientation);
    if(orientation == 1) {
        layout.blockPixels = CGSizeMake(170,200);
    }else {
        layout.blockPixels = CGSizeMake(170,200);
        
    }
    //layout.blockPixels = CGSizeMake(180,200);
    [self.categoryCollectionView reloadData];
    //[self loadSelectedCategory];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadSelectedCategory:) name:@"selectedCategory" object:nil];
    
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SecondLevelTutorialTrigger) name:@"SecondLevelTutorialTrigger" object:nil];
    

 //   UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    

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
    [self.view addSubview:infoButton];
    [self.view addSubview:availableTopic];
    

    _tutorialContentView.hidden=YES;
    
    _tutorialContentView.layer.cornerRadius=5.0f;
    
    

    


    
    
}

-(void)stopSecondTutorial:(UITapGestureRecognizer *)sender{
    
    
    BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"SecondTutorialShown"];
    if (coachMarksShown == YES) {
    
    NSLog(@"triggerSecondTutorial");
    
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
    
    
    [Localytics tagScreen:@"Add Content Topics"];
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

- (void)loadSelectedCategory:(id)sender
{
   // NSLog(@"load seleced is working");
    NSNotification *notification = sender;
    NSDictionary *userInfo = notification.userInfo;
    self.innerArray = [[NSMutableArray alloc]initWithArray:[userInfo objectForKey:@"innerArray"]];
    self.previousArray = [[NSMutableArray alloc]initWithArray:[userInfo objectForKey:@"previousArray"]];
   // NSLog(@"second level previous array:%@ and selected id:%@",self.previousArray,self.selectedId);
    //if([self.previousArray containsObject:self.selectedId]) {
        NSMutableArray *alreadySelectedArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"secondLevelSelection"];
       // NSLog(@"already selected array count:%d",alreadySelectedArray.count);
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
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"SecondTutorialShown"];
    if (coachMarksShown == NO) {
    
    SecondLevelCell *cell =(SecondLevelCell*)[self.categoryCollectionView cellForItemAtIndexPath:indexPath];
     [[NSNotificationCenter defaultCenter]postNotificationName:@"contentSelected" object:nil];
    
    FIContentCategory *contentCategory = [self.innerArray objectAtIndex:indexPath.row];
    if(contentCategory.listArray.count != 0) {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AddContent" bundle:nil];
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
    
    FIContentCategory *contentCategory = [self.innerArray objectAtIndex:[sender tag]];
    if([self.selectedIdArray containsObject:contentCategory.categoryId]) {
        [self.selectedIdArray removeObject:contentCategory.categoryId];
        [sender setSelected:NO];
        [self.checkedArray removeObject:contentCategory.categoryId];
        // } else {
        [self.uncheckedArray addObject:contentCategory.categoryId];
        NSMutableArray *testArray = [[NSMutableArray alloc]init];
        [[NSUserDefaults standardUserDefaults]setObject:testArray forKey:[contentCategory.categoryId stringValue]];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isThirdLevelChanged"];
        
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
#pragma mark - CMPopTipViewDelegate methods

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView
{
    //  [self.visiblePopTipViews removeObject:popTipView];
    self.currentPopTipViewTarget = nil;
}
@end
