//
//  LeftViewController.m
//  FullIntel
//
//  Created by Arul on 2/17/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "LeftViewController.h"
#import "RADataObject.h"
#import "RATableViewCell.h"
#import "FISharedResources.h"
#import "FIMenu.h"
#import "PKRevealController.h"
#import "CorporateNewsListView.h"
#import "InfluencerListView.h"
#import "AddContentFirstLevelView.h"
#import "FIUtils.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FIUtils.h"
#import "ResearchRequestPopoverView.h"
#import "PresentingAnimator.h"
#import "DismissingAnimator.h"
#import "StockViewController.h"
#import "InfluencerListView.h"
#import "DealsViewController.h"
#import "IpAndLegalViewController.h"
#import "ExecutiveMovesController.h"
#import "CorporateNewsListView.h"
#import "FIFolder.h"
#import "FolderViewController.h"
#import "FISharedResources.h"
#import "pop.h"
#define UIColorFromRGB(rgbValue)[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface LeftViewController () <RATreeViewDelegate, RATreeViewDataSource>

@property (strong, nonatomic) NSMutableArray *data;
@property (weak, nonatomic) RATreeView *treeView;

@property (strong, nonatomic) UIBarButtonItem *editButton;

@end

@implementation LeftViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMenus) name:@"MenuList" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(afterLogout) name:@"logoutSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestChange:) name:@"requestChange" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openFolderView:) name:@"openFolderView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMenuCount:) name:@"updateMenuCount" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addContentButtonClick:) name:@"TutorialTrigger" object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addOverlayAndBox) name:@"MenuTutorialTrigger" object:nil];
    
    
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(afterFirstTutorial) name:@"MarkImportantTutorialTrigger" object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(afterSecondTutorial) name:@"MainListTutorialTrigger" object:nil];
    
    
    self.addContentButton.layer.cornerRadius = 5.0f;
    self.addContentButton.layer.masksToBounds = YES;
    self.addContentButton.layer.borderWidth = 1.0f;
    self.addContentButton.layer.borderColor = [UIColor colorWithRed:(220/255.0) green:(223/255.0) blue:(224/255.0) alpha:1].CGColor;
    
    self.researchButton.layer.cornerRadius = 5.0f;
    self.researchButton.layer.masksToBounds = YES;
    self.researchButton.layer.borderWidth = 1.0f;
    self.researchButton.layer.borderColor = [UIColor colorWithRed:(220/255.0) green:(223/255.0) blue:(224/255.0) alpha:1].CGColor;
    NSMutableArray *objectArray;
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"];
    if(accessToken.length != 0) {
        
        NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
        NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:@"MenuList"];
        NSLog(@"data value:%@ and length:%d",dataRepresentingSavedArray,dataRepresentingSavedArray.length);
        if (dataRepresentingSavedArray.length != 0)
        {
            NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
            if (oldSavedArray != nil)
                objectArray = [[NSMutableArray alloc] initWithArray:oldSavedArray];
            else
                objectArray = [[NSMutableArray alloc] init];
        }
    }
    
    NSString *companyLogoImageStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"companyLogo"];
    NSString *companyNameStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"companyName"];
    
    [self.companyLogo sd_setImageWithURL:[NSURL URLWithString:companyLogoImageStr] placeholderImage:[UIImage imageNamed:@"FI"]];
    self.companyName.text = [companyNameStr uppercaseString];
    self.companyName.numberOfLines = 1;
    self.companyName.minimumFontSize = 8.;
    self.companyName.adjustsFontSizeToFitWidth = YES;
    
    treeView = [[RATreeView alloc] initWithFrame:self.treeBackView.bounds];
    treeView.delegate = self;
    treeView.dataSource = self;
    treeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
   // [treeView reloadData];
    [treeView setBackgroundColor:[UIColor clearColor]];
    self.treeView = treeView;
    [self.treeView registerNib:[UINib nibWithNibName:NSStringFromClass([RATableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([RATableViewCell class])];
    [self.treeBackView addSubview:self.treeView];
   // NSLog(@"menu array count in viewdidload:%lu",(unsigned long)objectArray.count);
    
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    
    self.isFirstTime = YES;
    
    
   
    
    //[self.treeBackView insertSubview:treeView atIndex:0];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = NSLocalizedString(@"Things", nil);
    [self updateNavigationItemButton];
    
    
    self.menus = [[NSMutableArray alloc]initWithArray:objectArray];
    [self test:self.menus];
    [treeView reloadData];
    
    
    if(self.data.count > 2) {
        NSLog(@"come selectrow method");
        [self.treeView selectRowForItem:[self.data objectAtIndex:2] animated:YES scrollPosition:RATreeViewScrollPositionTop];
        //[self treeView:self.treeView didSelectRowForItem:[self.data objectAtIndex:2]];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"directLoad" object:nil];
    }
    
    

}
-(void)afterSecondTutorial{
    
    
    NSLog(@"Coming here afterSecondTutorial");
    
    [popAnimationTimerTwo invalidate];
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"MarkImportantTutorialTriggerShown"];
    
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"MainListArrowTutorial"];
    
   [_treeView reloadData];
    
    
}
-(void)afterFirstTutorial{
    
    
    [popAnimationTimer invalidate];
    
    _treeView.layer.borderWidth=0.0;
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"MarkImportantTutorialTriggerShown"];
    
    [_treeView reloadData];
}


-(void)performAnimationForMarkImportant:(NSTimer *)timer{
    
    RATableViewCell *cell=timer.userInfo;
    
    [self performAnimationForFirstItemInTreeView:cell];
    
    
    
    
}

-(void)performAnimationForFirstItemInTreeView:(RATableViewCell *)cell{
    
    [cell.layer removeAllAnimations];
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue=[NSValue valueWithCGSize:CGSizeMake(0.5, 0.5)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1,1)];
    scaleAnimation.springBounciness = 10;
    scaleAnimation.springSpeed=10;
    [cell.layer  pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
    
}
-(void)permformAnimation:(NSTimer *)timer{
    
    
    [_treeView.layer removeAllAnimations];
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue=[NSValue valueWithCGSize:CGSizeMake(0.5, 0.5)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1,1)];
    scaleAnimation.springBounciness = 10;
    scaleAnimation.springSpeed=10;
    [_treeView.layer  pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
    
}

-(void)addOverlayAndBox{
    
    
    UIStoryboard *centerStoryBoard = [UIStoryboard storyboardWithName:@"Tutorial" bundle:nil];
    UIViewController *popOverView =[centerStoryBoard instantiateViewControllerWithIdentifier:@"LeftMenuTutorialPopViewController"];
    
    //  ResearchRequestPopoverView *researchViewController=(ResearchRequestPopoverView *)[[popOverView viewControllers]objectAtIndex:0];
    
    //  ResearchRequestPopoverView *popOverView = [[ResearchRequestPopoverView alloc]initWithNibName:@"ResearchRequestPopoverView" bundle:nil];
    //  popOverView.transitioningDelegate = self;
    popOverView.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:popOverView animated:NO completion:nil];

    
    _treeView.layer.borderWidth=1.0;
    _treeView.layer.borderColor=[UIColorFromRGB(0XA4131E) CGColor];
    
    
        popAnimationTimer=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(permformAnimation:) userInfo:nil repeats:YES];
    
    
    
    
}

-(void)openFolderView:(id)sender {
    NSLog(@"open folder view");
    NSNotification *notification = sender;
    NSDictionary *userInfo = notification.userInfo;
    NSNumber *folderId = [userInfo objectForKey:@"folderId"];
    NSLog(@"selected folder id:%@ and data count:%d",folderId,self.data.count);
    RADataObject *folderDataObj = [self.data objectAtIndex:8];
//    for(RADataObject *dataObject in self.data) {
//        NSLog(@"selected %@ and coming %@",folderId,dataObject.nodeId);
//        if(dataObject.nodeId != nil) {
//            if([folderId isEqualToNumber:dataObject.nodeId]) {
//                folderDataObj = dataObject;
//                //return;
//            }
//        }
//    }
    NSLog(@"selected data object:%@ and children count:%d",folderDataObj,folderDataObj.children.count);
    [self.treeView expandRowForItem:folderDataObj];
    for(RADataObject *testObject in folderDataObj.children) {
        if([folderId isEqualToNumber:testObject.nodeId]) {
            NSLog(@"selcted folder:%@ and name:%@",testObject,testObject.name);
            [self.treeView selectRowForItem:testObject animated:YES scrollPosition:RATreeViewScrollPositionTop];
            [self treeView:self.treeView didSelectRowForItem:testObject];
            
        }
    }
    
}


//-(void)addCoachView{
//    
//    [coachMarksView removeFromSuperview];
//    
//    BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"MenuCoachShown"];
//    if (coachMarksShown == NO) {
//    
//     coachMarks = @[
//                            @{
//                                @"rect": [NSValue valueWithCGRect:CGRectMake(5, 185, 260, 40)],
//                                @"caption": @"You can subscribe more categories or remove any categories you dislike"
//                                },
//                            @{
//                                @"rect": [NSValue valueWithCGRect:CGRectMake(self.treeBackView.frame.origin.x, self.treeBackView.frame.origin.y, self.treeBackView.frame.size.width, self.view.frame.size.height-550)],
//                                @"caption": @"List of all articles available"
//                                }
//                            
//                            ];
//     coachMarksView = [[WSCoachMarksView alloc] initWithFrame:CGRectMake(0, 0, 280, self.view.frame.size.height) coachMarks:coachMarks];
//        coachMarksView.delegate=self;
//    [self.view addSubview:coachMarksView];
//    [coachMarksView start];
//        
//    }
//    
//}


- (void)deviceOrientationDidChange:(NSNotification *)notification {
    
    //Obtaining the current device orientation
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    //Ignoring specific orientations
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown) {
        return;
    }
    
    // We need to allow a slight pause before running handler to make sure rotation has been processed by the view hierarchy
    [self performSelectorOnMainThread:@selector(handleDeviceOrientationChange:) withObject:coachMarksView waitUntilDone:NO];
}

- (void)handleDeviceOrientationChange:(WSCoachMarksView*)coachMarksView {
    
    // Begin the whole coach marks process again from the beginning, rebuilding the coachmarks with updated co-ordinates

  
}
-(void)updateMenuCount:(id)sender {
    
    RADataObject *dataObj;
    RADataObject *anotherDataObj;
    RADataObject *savedForLaterDataObj;
    NSNotification *notification = sender;
    NSDictionary *userInfo = notification.userInfo;
    NSString *type = [userInfo objectForKey:@"type"];
    NSMutableArray *reloadArray = [[NSMutableArray alloc]init];
    //NSLog(@"type value:%@",type);
    
    if([type isEqualToString:@"all"]) {
        dataObj = [self.data objectAtIndex:2];
        int cnt = [dataObj.unReadCount intValue];
        dataObj.unReadCount = [NSNumber numberWithInt:cnt-1];
        
        anotherDataObj = [self.data objectAtIndex:0];
        int nextCnt = [anotherDataObj.unReadCount intValue];
        anotherDataObj.unReadCount = [NSNumber numberWithInt:nextCnt-1];
        
        savedForLaterDataObj= [self.data objectAtIndex:1];
        int savedForLaterCnt = [savedForLaterDataObj.unReadCount intValue];
        savedForLaterDataObj.unReadCount = [NSNumber numberWithInt:savedForLaterCnt-1];
        [reloadArray addObject:dataObj];
        [reloadArray addObject:anotherDataObj];
        [reloadArray addObject:savedForLaterDataObj];
    } else if([type isEqualToString:@"bothMarkImp"]) {
        dataObj = [self.data objectAtIndex:2];
        int cnt = [dataObj.unReadCount intValue];
        dataObj.unReadCount = [NSNumber numberWithInt:cnt-1];
        
        anotherDataObj = [self.data objectAtIndex:0];
        int nextCnt = [anotherDataObj.unReadCount intValue];
        anotherDataObj.unReadCount = [NSNumber numberWithInt:nextCnt-1];
    
        [reloadArray addObject:dataObj];
        [reloadArray addObject:anotherDataObj];
        
    } else if([type isEqualToString:@"bothSavedForLater"]){
        dataObj = [self.data objectAtIndex:2];
        int cnt = [dataObj.unReadCount intValue];
        dataObj.unReadCount = [NSNumber numberWithInt:cnt-1];
        
        savedForLaterDataObj= [self.data objectAtIndex:1];
        int savedForLaterCnt = [savedForLaterDataObj.unReadCount intValue];
        savedForLaterDataObj.unReadCount = [NSNumber numberWithInt:savedForLaterCnt-1];
        
        [reloadArray addObject:dataObj];
        [reloadArray addObject:savedForLaterDataObj];
        
    }else if([type isEqualToString:@"-1"]) {
        dataObj = [self.data objectAtIndex:2];
        int cnt = [dataObj.unReadCount intValue];
        dataObj.unReadCount = [NSNumber numberWithInt:cnt-1];
        [reloadArray addObject:dataObj];
    }else if([type isEqualToString:@"-2"]) {
        NSNumber *num = [userInfo objectForKey:@"isSelected"];
       // NSLog(@"selected number:%@",num);
        if([num isEqualToNumber:[NSNumber numberWithInt:1]]){
            dataObj = [self.data objectAtIndex:0];
            int cnt = [dataObj.unReadCount intValue];
            dataObj.unReadCount = [NSNumber numberWithInt:cnt+1];
            [reloadArray addObject:dataObj];
        } else if([num isEqualToNumber:[NSNumber numberWithInt:0]]) {
            //NSLog(@"come inside");
            dataObj = [self.data objectAtIndex:0];
            int cnt = [dataObj.unReadCount intValue];
            dataObj.unReadCount = [NSNumber numberWithInt:cnt-1];
            [reloadArray addObject:dataObj];
        }
        
    } else if([type isEqualToString:@"-3"]) {
        NSNumber *num = [userInfo objectForKey:@"isSelected"];
        // NSLog(@"selected number:%@",num);
        if([num isEqualToNumber:[NSNumber numberWithInt:1]]){
            dataObj = [self.data objectAtIndex:1];
            int cnt = [dataObj.unReadCount intValue];
            dataObj.unReadCount = [NSNumber numberWithInt:cnt+1];
            [reloadArray addObject:dataObj];
        } else if([num isEqualToNumber:[NSNumber numberWithInt:0]]) {
            //NSLog(@"come inside");
            dataObj = [self.data objectAtIndex:1];
            int cnt = [dataObj.unReadCount intValue];
            dataObj.unReadCount = [NSNumber numberWithInt:cnt-1];
            [reloadArray addObject:dataObj];
        }
    } else {
        dataObj = [self.data objectAtIndex:2];
        int cnt = [dataObj.unReadCount intValue];
        dataObj.unReadCount = [NSNumber numberWithInt:cnt-1];
        
        [reloadArray addObject:dataObj];
    }
    
    
    [self.treeView reloadRowsForItems:reloadArray withRowAnimation:RATreeViewRowAnimationNone];
}

-(void)viewDidAppear:(BOOL)animated {
   
//    if([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >= 7) {
//        CGRect statusBarViewRect = [[UIApplication sharedApplication] statusBarFrame];
//        float heightPadding = statusBarViewRect.size.height+self.navigationController.navigationBar.frame.size.height;
//        self.treeView.contentInset = UIEdgeInsetsMake(heightPadding, 0.0, 0.0, 0.0);
//        self.treeView.contentOffset = CGPointMake(0.0, -heightPadding);
//    }
    
    [[FISharedResources sharedResourceManager]tagScreenInLocalytics:@"Main Menu"];
    
    NSString *menuBackgroundColor = [[NSUserDefaults standardUserDefaults]objectForKey:@"menuBgColor"];
    NSString *stringWithoutSpaces = [menuBackgroundColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
    [self.view setBackgroundColor: [FIUtils colorWithHexString:stringWithoutSpaces]];
    self.treeView.frame = self.treeBackView.bounds;
    
    
    
}

-(void)loadMenus {
    NSLog(@"load menu calling twice");
    NSString *menuBackgroundColor = [[NSUserDefaults standardUserDefaults]objectForKey:@"menuBgColor"];
    NSString *stringWithoutSpaces = [menuBackgroundColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
    [self.view setBackgroundColor: [FIUtils colorWithHexString:stringWithoutSpaces]];
    
    
    NSString *companyLogoImageStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"companyLogo"];
    NSString *companyNameStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"companyName"];
    
    [self.companyLogo sd_setImageWithURL:[NSURL URLWithString:companyLogoImageStr] placeholderImage:[UIImage imageNamed:@"FI"]];
    self.companyName.text = [companyNameStr uppercaseString];
    self.companyName.numberOfLines = 1;
    self.companyName.minimumFontSize = 8.;
    self.companyName.adjustsFontSizeToFitWidth = YES;
    
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:@"MenuList"];
    if (dataRepresentingSavedArray.length != 0)
    {
        NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
        if (oldSavedArray != nil) {
             self.menus = [[NSMutableArray alloc]initWithArray:oldSavedArray];
        }
    }
    
    
   
    NSLog(@"menu count:%lu",(unsigned long)self.menus.count);
    [self test:self.menus];
    [treeView reloadData];
    NSLog(@"data count:%lu",(unsigned long)self.data.count);
    NSString *accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"];
    if(accessToken.length > 0) {
        [self.treeView selectRowForItem:[self.data objectAtIndex:2] animated:YES scrollPosition:RATreeViewScrollPositionTop];
        //[self treeView:self.treeView didSelectRowForItem:[self.data objectAtIndex:2]];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"directLoad" object:nil];
    }
    
    
    
     [self presentTutorialPopViewController];
}

-(void)test:(NSMutableArray *)array {
    
    self.data = [[NSMutableArray alloc]init];
    for(FIMenu *menu in array) {
        
        RADataObject *dataObj = [self recursiveDataObjectFrom:menu];
       // NSLog(@"for loop:%@",dataObj);
        [self.data addObject:dataObj];
    }
    //self.data = [NSArray arrayWithObjects:phone, computer, car, bike, house, flats, motorbike, drinks, food, nil];
    
    NSMutableArray *folderArray;
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:@"FolderList"];
    if (dataRepresentingSavedArray != nil)
    {
        NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
       // NSLog(@"folder array:%@",oldSavedArray);
        folderArray = [[NSMutableArray alloc]initWithArray:oldSavedArray];
    }
    
    
    
    RADataObject *folderDataObj = [[RADataObject alloc]init];
    folderDataObj.name = @"FOLDER";
    folderDataObj.nodeId = [NSNumber numberWithInt:-100];
    folderDataObj.isFolder = YES;
    NSMutableArray *childArray = [[NSMutableArray alloc]init];
    //NSArray *menuArray = menu.listArray;
    for(int i=0; i<folderArray.count; i++) {
        RADataObject *insideMenu = [[RADataObject alloc]init];
        FIFolder *folder = [folderArray objectAtIndex:i];
        insideMenu.nodeId = folder.folderId;
        insideMenu.name = [folder.folderName uppercaseString];
        insideMenu.isFolder = YES;
        [childArray addObject:insideMenu];
    }
    folderDataObj.children = childArray;
    [self.data addObject:folderDataObj];
    
    
    RADataObject *dataObj = [[RADataObject alloc]init];
    dataObj.name = @"LOGOUT";
    dataObj.children = nil;
    [self.data addObject:dataObj];
   // [treeView reloadData];
}

-(RADataObject *)recursiveDataObjectFrom:(FIMenu *)menu {
    RADataObject *dataObj = [[RADataObject alloc]init];
    dataObj.name = menu.name;
    dataObj.nodeId = menu.nodeId;
    dataObj.unReadCount = menu.unreadCount;
   // menu.name = [dic objectForKey:@"Name"];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSArray *menuArray = menu.listArray;
    for(FIMenu *dict in menuArray) {
        RADataObject *insideMenu = [self recursiveDataObjectFrom:dict];
        [array addObject:insideMenu];
    }
    dataObj.children = array;
    //menu.listArray = array;
    return dataObj;
}

-(void)viewDidDisappear:(BOOL)animated {
   // [self.treeView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    if([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >= 7) {
//        CGRect statusBarViewRect = [[UIApplication sharedApplication] statusBarFrame];
//        float heightPadding = statusBarViewRect.size.height+self.navigationController.navigationBar.frame.size.height;
//        self.treeView.contentInset = UIEdgeInsetsMake(heightPadding, 0.0, 0.0, 0.0);
//        self.treeView.contentOffset = CGPointMake(0.0, -heightPadding);
//    }
//    
//    self.treeView.frame = self.treeBackView.bounds;
}

-(void)presentTutorialPopViewController{
    
    
    BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"TutorialBoxShown"];
    if (coachMarksShown == NO) {
    
    UIStoryboard *centerStoryBoard = [UIStoryboard storyboardWithName:@"Tutorial" bundle:nil];
    UINavigationController *popOverView =[centerStoryBoard instantiateViewControllerWithIdentifier:@"tutorialPop"];
    
    //  ResearchRequestPopoverView *researchViewController=(ResearchRequestPopoverView *)[[popOverView viewControllers]objectAtIndex:0];
    
    //  ResearchRequestPopoverView *popOverView = [[ResearchRequestPopoverView alloc]initWithNibName:@"ResearchRequestPopoverView" bundle:nil];
    //  popOverView.transitioningDelegate = self;
    popOverView.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:popOverView animated:NO completion:nil];
        
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"TutorialBoxShown"];
        
    }
    
}
#pragma mark - Actions

- (void)editButtonTapped:(id)sender
{
    [self.treeView setEditing:!self.treeView.isEditing animated:YES];
    [self updateNavigationItemButton];
}

- (void)updateNavigationItemButton
{
    UIBarButtonSystemItem systemItem = self.treeView.isEditing ? UIBarButtonSystemItemDone : UIBarButtonSystemItemEdit;
    self.editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:self action:@selector(editButtonTapped:)];
    self.navigationItem.rightBarButtonItem = self.editButton;
}


#pragma mark TreeView Delegate methods

- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item
{
    return 40;
}

- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item
{
    return YES;
}

- (void)treeView:(RATreeView *)treeViews willExpandRowForItem:(id)item
{
    RATableViewCell *cell = (RATableViewCell *)[treeViews cellForItem:item];
    [cell setAdditionButtonHidden:NO animated:YES];
}

- (void)treeView:(RATreeView *)treeViews willCollapseRowForItem:(id)item
{
    RATableViewCell *cell = (RATableViewCell *)[treeViews cellForItem:item];
    [cell setAdditionButtonHidden:YES animated:YES];
}

- (void)treeView:(RATreeView *)treeView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowForItem:(id)item
{
    if (editingStyle != UITableViewCellEditingStyleDelete) {
        return;
    }
    
    RADataObject *parent = [self.treeView parentForItem:item];
    NSInteger index = 0;
    
    if (parent == nil) {
        index = [self.data indexOfObject:item];
        NSMutableArray *children = [self.data mutableCopy];
        [children removeObject:item];
        self.data = [children copy];
        
    } else {
        index = [parent.children indexOfObject:item];
        [parent removeChild:item];
    }
    
    [self.treeView deleteItemsAtIndexes:[NSIndexSet indexSetWithIndex:index] inParent:parent withAnimation:RATreeViewRowAnimationRight];
    if (parent) {
        [self.treeView reloadRowsForItems:@[parent] withRowAnimation:RATreeViewRowAnimationNone];
    }
}




#pragma mark TreeView Data Source


//- (void)treeView:(RATreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item {
//    RATableViewCell *cell1 = (RATableViewCell*)[self.treeView cellForItem:item];
//    if(cell1.isSelected) {
//        NSLog(@"cell is selected");
//        cell1.customTitleLabel.textColor = UIColorFromRGB(0x1e8cd4);
//    }else {
//        NSLog(@"cell is not selected");
//        cell1.customTitleLabel.textColor = [UIColor blackColor];
//    }
//}


- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item
{
   // NSLog(@"cell for item:%@",item);
    
    RADataObject *dataObject = item;
    NSInteger level = [self.treeView levelForCellForItem:item];
    NSInteger numberOfChildren = [dataObject.children count];
    
    NSString *detailText = [NSString localizedStringWithFormat:@"Number of children %@", [@(numberOfChildren) stringValue]];
    
   
    RATableViewCell *cell = [self.treeView dequeueReusableCellWithIdentifier:NSStringFromClass([RATableViewCell class])];
    NSString *menuBackgroundColor = [[NSUserDefaults standardUserDefaults]objectForKey:@"menuBgColor"];
    NSString *stringWithoutSpaces = [menuBackgroundColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
    cell.backgroundColor = [FIUtils colorWithHexString:stringWithoutSpaces];
    [cell setupWithTitle:dataObject.name detailText:detailText level:level additionButtonHidden:NO];
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithRed:(230/255.0) green:(230/255.0) blue:(230/255.0) alpha:1];
    //cell.selectedBackgroundView = selectionColor;
    
    
    
    BOOL expanded = [self.treeView isCellForItemExpanded:item];
    if(expanded) {
        [cell.expandButton setSelected:YES];
    } else{
        [cell.expandButton setSelected:NO];
    }
    
    
    
    if(![[dataObject.name uppercaseString] isEqualToString:@"MARKED IMPORTANT"]) {
        UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        separatorLineView.backgroundColor = [UIColor colorWithRed:(220/255.0) green:(223/255.0) blue:(224/255.0) alpha:1];
        [cell.contentView addSubview:separatorLineView];
        
        
   
        
    }else{
        
        BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"MarkImportantTutorialTriggerShown"];
        if (coachMarksShown == YES) {
            popAnimationTimerTwo=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(performAnimationForMarkImportant:) userInfo:cell repeats:YES];
            
            cell.layer.borderColor=[UIColorFromRGB(0XA4131E) CGColor];
            cell.layer.borderWidth=1.0;
            
        }else{
            
            cell.layer.borderWidth=0.0;
        }
    }
    if([dataObject.unReadCount intValue] > 0) {
        cell.countLabel.hidden = NO;
        cell.countLabel.text = [NSString stringWithFormat:@"%@",dataObject.unReadCount];
    }else {
        cell.countLabel.hidden = YES;
    }
    if(numberOfChildren > 0) {
        cell.expandButton.hidden = NO;
        [cell.expandButton addTarget:self action:@selector(dropDown) forControlEvents:UIControlEventTouchUpInside];
    }else {
        cell.expandButton.hidden = YES;
    }

    
    
    
    CGFloat left;
    if(!dataObject.isFolder) {
        if([dataObject.nodeId integerValue] == 9) {
            left = 40 + 11 + 20 * level;
            cell.iconImage.hidden = NO;
            cell.iconImage.image = [UIImage imageNamed:@"markedImp"];
            
            
            
            
            
        } else if([dataObject.nodeId integerValue] == 6) {
            left = 40 + 11 + 20 * level;
            cell.iconImage.hidden = NO;
            cell.iconImage.image = [UIImage imageNamed:@"savedForLater"];
        } else if([[dataObject.name uppercaseString] isEqualToString:@"LOGOUT"]) {
            left = 40 + 11 + 20 * level;
            cell.iconImage.hidden = NO;
            cell.iconImage.image = [UIImage imageNamed:@"logout"];
        } else {
            left = 34 + 20 * level;
            cell.iconImage.hidden = YES;
        }
    } else {
        if([[dataObject.name uppercaseString]isEqualToString:@"FOLDER"]) {
            
            left = 40 + 11 + 20 * level;
            cell.iconImage.hidden = NO;
            cell.iconImage.image = [UIImage imageNamed:@"folder_menu"];
        }else {
            left = 34 + 20 * level;
            cell.iconImage.hidden = YES;
        }
    }
    
    if([[dataObject.name uppercaseString]isEqualToString:@"RSS"]) {
        cell.rssImage.hidden = NO;
    } else {
        cell.rssImage.hidden = YES;
    }
    
    CGRect titleFrame = cell.customTitleLabel.frame;
    titleFrame.origin.x = left;
    cell.customTitleLabel.frame = titleFrame;
    
    
    NSString *highlightColor = [[NSUserDefaults standardUserDefaults]objectForKey:@"highlightColor"];
    NSString *highColor = [highlightColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    if(cell.customTitleLabel.isHighlighted)
    {
        cell.customTitleLabel.highlightedTextColor = [FIUtils colorWithHexString:stringWithoutSpaces];
    }
    else
    {
        cell.customTitleLabel.highlightedTextColor = [FIUtils colorWithHexString:highColor];
    }
    return cell;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [self.data count];
    }
    
    RADataObject *data = item;
    return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    RADataObject *data = item;
    if (item == nil) {
        return [self.data objectAtIndex:index];
    }
    
    return data.children[index];
}

-(void)dropDown {
   // [self.revealController showViewController:self.revealController.frontViewController];
    
}
-(void)treeView:(RATreeView *)treeView didDeselectRowForItem:(id)item {
//    RATableViewCell *cell = (RATableViewCell *)[self.treeView cellForItem:item];
//    cell.customTitleLabel.highlightedTextColor = UIColorFromRGB(0x666E73);
//    cell.iconImage.image = [cell.iconImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//
//    cell.iconImage.tintColor = UIColorFromRGB(0x666E73);
}




- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item {
    RADataObject *data = item;
   // NSLog(@"did select row:%@",data.name);
    RATableViewCell *cell = (RATableViewCell *)[self.treeView cellForItem:item];
    BOOL expanded = [self.treeView isCellForItemExpanded:item];
    if(expanded) {
       // NSLog(@"list is expanded");
        [cell.expandButton setSelected:NO];
    }else {
       // NSLog(@"list is clopsed");
        [cell.expandButton setSelected:YES];
    }

    
        NSString *menuBackgroundColor = [[NSUserDefaults standardUserDefaults]objectForKey:@"highlightColor"];
        NSString *stringWithoutSpaces = [menuBackgroundColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
        
        cell.customTitleLabel.highlightedTextColor = [FIUtils colorWithHexString:stringWithoutSpaces];
    if([data.nodeId integerValue] == 9 && !data.isFolder) {
        UIStoryboard *centerStoryBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];
        UINavigationController *navCtlr = [centerStoryBoard instantiateViewControllerWithIdentifier:@"CorporateView"];
        
        CorporateNewsListView *CorporateNewsListViewObj=(CorporateNewsListView *)[[navCtlr viewControllers]objectAtIndex:0];
        
        CorporateNewsListViewObj.titleName=data.name;
        
        [self.revealController setFrontViewController:navCtlr];
        NSMutableDictionary *gradedetails = [[NSMutableDictionary alloc] init];
        [gradedetails setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
        [gradedetails setObject:@"" forKey:@"lastArticleId"];
        [gradedetails setObject:[NSNumber numberWithInt:10] forKey:@"listSize"];
        [gradedetails setObject:@"2" forKey:@"activityTypeIds"];
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:gradedetails options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
        [[FISharedResources sharedResourceManager]getCuratedNewsListWithAccessToken:resultStr withCategoryId:[NSNumber numberWithInt:-2] withFlag:@"" withLastArticleId:@""];
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:-2] forKey:@"categoryId"];
        
    } else if([data.nodeId integerValue] == 1 && !data.isFolder) {
        NSLog(@"row selection calling");
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:-1] forKey:@"categoryId"];
        UIStoryboard *centerStoryBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];
        UINavigationController *navCtlr = [centerStoryBoard instantiateViewControllerWithIdentifier:@"CorporateView"];
        
        CorporateNewsListView *CorporateNewsListViewObj=(CorporateNewsListView *)[[navCtlr viewControllers]objectAtIndex:0];
        
        CorporateNewsListViewObj.titleName=data.name;
        [self.revealController setFrontViewController:navCtlr];
        
        
        
        
    } else if([data.nodeId integerValue] == 6 && !data.isFolder) {
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:-3] forKey:@"categoryId"];
        UIStoryboard *centerStoryBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];
        UINavigationController *navCtlr = [centerStoryBoard instantiateViewControllerWithIdentifier:@"CorporateView"];
        
        CorporateNewsListView *CorporateNewsListViewObj=(CorporateNewsListView *)[[navCtlr viewControllers]objectAtIndex:0];
        if([[FISharedResources sharedResourceManager]serviceIsReachable]) {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"SavedForLaterIsNew"];
            NSMutableDictionary *gradedetails = [[NSMutableDictionary alloc] init];
            [gradedetails setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
            [gradedetails setObject:@"" forKey:@"lastArticleId"];
            [gradedetails setObject:[NSNumber numberWithInt:10] forKey:@"listSize"];
            [gradedetails setObject:@"3" forKey:@"activityTypeIds"];
            NSData *jsondata = [NSJSONSerialization dataWithJSONObject:gradedetails options:NSJSONWritingPrettyPrinted error:nil];
            
            NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
            [[FISharedResources sharedResourceManager]getCuratedNewsListWithAccessToken:resultStr withCategoryId:[NSNumber numberWithInt:-3] withFlag:@"" withLastArticleId:@""];
        } else {
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"SavedForLaterIsNew"];
        }
        
        CorporateNewsListViewObj.titleName=data.name;
        [self.revealController setFrontViewController:navCtlr];
    } else if([data.nodeId integerValue] == 7 && !data.isFolder) {
        UIStoryboard *centerStoryBoard = [UIStoryboard storyboardWithName:@"InfluencerListView" bundle:nil];
        UINavigationController *navCtlr = [centerStoryBoard instantiateViewControllerWithIdentifier:@"InfluencerView"];
        
         InfluencerListView *InfluencerListViewObj=(InfluencerListView *)[[navCtlr viewControllers]objectAtIndex:0];
        
        InfluencerListViewObj.titleName=data.name;
        
        [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"Influencer List View"];
        
        [self.revealController setFrontViewController:navCtlr];
    }else if([data.nodeId integerValue] == 8 && !data.isFolder) {
        UIStoryboard *centerStoryBoard = [UIStoryboard storyboardWithName:@"Deals" bundle:nil];
        UINavigationController *navCtlr = [centerStoryBoard instantiateViewControllerWithIdentifier:@"DealsViewController"];
        
        DealsViewController *DealsViewControllerObj=(DealsViewController *)[[navCtlr viewControllers]objectAtIndex:0];
        DealsViewControllerObj.titleName=data.name;
        
            [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"Deals View"];
        
        [self.revealController setFrontViewController:navCtlr];
    }else if([data.nodeId integerValue] == 2 && !data.isFolder) {
        UIStoryboard *centerStoryBoard = [UIStoryboard storyboardWithName:@"stock" bundle:nil];
        UINavigationController *navCtlr = [centerStoryBoard instantiateViewControllerWithIdentifier:@"StockViewController"];
        StockViewController *StockViewControllerObj=(StockViewController *)[[navCtlr viewControllers]objectAtIndex:0];
        StockViewControllerObj.titleName=data.name;
        
          [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"Stock View"];
        
         [self.revealController setFrontViewController:navCtlr];
    }
    else if([data.nodeId integerValue] == 4 && !data.isFolder) {
        UIStoryboard *centerStoryBoard = [UIStoryboard storyboardWithName:@"IpAndLegal" bundle:nil];
        UINavigationController *navCtlr = [centerStoryBoard instantiateViewControllerWithIdentifier:@"IpAndLegalViewController"];
        
        IpAndLegalViewController *IpAndLegalViewControllerObj=(IpAndLegalViewController *)[[navCtlr viewControllers]objectAtIndex:0];
        
        IpAndLegalViewControllerObj.titleName=data.name;
        
                  [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"IpAndLegal View"];
        
        [self.revealController setFrontViewController:navCtlr];
        

    } else if([data.nodeId integerValue] == 5 && !data.isFolder) {
        UIStoryboard *centerStoryBoard = [UIStoryboard storyboardWithName:@"ExecutiveMoves" bundle:nil];
        UINavigationController *navCtlr = [centerStoryBoard instantiateViewControllerWithIdentifier:@"ExecutiveMoves"];
        
        ExecutiveMovesController *ExecutiveMovesControllerObj=(ExecutiveMovesController *)[[navCtlr viewControllers]objectAtIndex:0];
        ExecutiveMovesControllerObj.titleName=data.name;
        [self.revealController setFrontViewController:navCtlr];
        
           [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"ExecutiveMoves View"];
        
    }else if([[data.name uppercaseString] isEqualToString:@"LOGOUT"]) {
        

        
             [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"Log Out"];
        
        NSMutableDictionary *logoutDic = [[NSMutableDictionary alloc] init];
        [logoutDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:logoutDic options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
        [[FISharedResources sharedResourceManager] logoutUserWithDetails:resultStr withFlag:[NSNumber numberWithInt:1]];
        
    }
    NSLog(@"left click:%@",data.nodeId);
    if([[data.name uppercaseString] isEqualToString:@"LOGOUT"]) {
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:0] forKey:@"folderId"];
    } else if(data.isFolder){
        UIStoryboard *centerStoryBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];
        UINavigationController *navCtlr = [centerStoryBoard instantiateViewControllerWithIdentifier:@"CorporateView"];
        CorporateNewsListView *CorporateNewsListViewObj=(CorporateNewsListView *)[[navCtlr viewControllers]objectAtIndex:0];
        CorporateNewsListViewObj.titleName=data.name;
        if(data.nodeId != nil) {
            if([data.nodeId isEqualToNumber:[NSNumber numberWithInt:-100]]){
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isRSSField"];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FolderView" bundle:nil];
                UINavigationController *navCtlr = [storyboard instantiateViewControllerWithIdentifier:@"FolderView"];
//               // FolderViewController *folderView = [storyboard instantiateViewControllerWithIdentifier:@"FolderView"];
                [self.revealController setFrontViewController:navCtlr];
            } else {
                if([[data.name uppercaseString]isEqualToString:@"RSS"]) {
                    
                    [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"RSS Folder"];
                    
                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isRSSField"];
                } else {
                    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isRSSField"];
                }
                
                [[NSUserDefaults standardUserDefaults]setObject:data.nodeId forKey:@"folderId"];
                [self.revealController setFrontViewController:navCtlr];
                [[FISharedResources sharedResourceManager]fetchArticleFromFolderWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withFolderId:data.nodeId withOffset:[NSNumber numberWithInt:0] withLimit:[NSNumber numberWithInt:5] withUpFlag:NO];
            }
            
        }
        
    } else {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isRSSField"];
        if([data.nodeId integerValue] == 1 || [data.nodeId integerValue] == 9 || [data.nodeId integerValue] == 6 || [data.nodeId integerValue] == 7 || [data.nodeId integerValue]==2 || [data.nodeId integerValue]==8 || [data.nodeId integerValue]==4 || [data.nodeId integerValue]==5) {
            [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:0] forKey:@"folderId"];
            // NSLog(@"empty node id");
        }else {
            UIStoryboard *centerStoryBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];
            UINavigationController *navCtlr = [centerStoryBoard instantiateViewControllerWithIdentifier:@"CorporateView"];
            
            CorporateNewsListView *CorporateNewsListViewObj=(CorporateNewsListView *)[[navCtlr viewControllers]objectAtIndex:0];
            
            CorporateNewsListViewObj.titleName=data.name;
            
            
            NSString *inputJson = [FIUtils createInputJsonForContentWithToekn:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] lastArticleId:@"" contentTypeId:@"1" listSize:10 activityTypeId:@"" categoryId:data.nodeId];
            
//            if(data.isFolder) {
//                NSLog(@"folder click and folder id:%@",data.nodeId);
//                if(data.nodeId != nil) {
//                    [[NSUserDefaults standardUserDefaults]setObject:data.nodeId forKey:@"folderId"];
//                    [self.revealController setFrontViewController:navCtlr];
//                    [[FISharedResources sharedResourceManager]fetchArticleFromFolderWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withFolderId:data.nodeId];
//                }
//                
//            } else {
                [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:0] forKey:@"folderId"];
                [self.revealController setFrontViewController:navCtlr];
                [[NSUserDefaults standardUserDefaults]setObject:data.nodeId forKey:@"categoryId"];
                [[FISharedResources sharedResourceManager]getCuratedNewsListWithAccessToken:inputJson withCategoryId:data.nodeId withFlag:@"" withLastArticleId:@""];
           // }
            
        }
    }
    
}


//-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:
//(NSTimeInterval)duration {
//    
//    // Fade the collectionView out
//    [self.collectionView setAlpha:0.0f];
//    
//    // Suppress the layout errors by invalidating the layout
//    [self.collectionView.collectionViewLayout invalidateLayout];
//    
//    // Calculate the index of the item that the collectionView is currently displaying
//    CGPoint currentOffset = [self.collectionView contentOffset];
//    self.currentIndex = currentOffset.x / self.collectionView.frame.size.width;
//}




-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    self.treeView.frame = self.treeBackView.bounds;
  //  NSLog(@"device rotate is working:%ld",(long)fromInterfaceOrientation);
    if(fromInterfaceOrientation == UIInterfaceOrientationPortrait) {
        formSheet.presentedFormSheetSize = CGSizeMake(800, 650);
    }else {
        formSheet.presentedFormSheetSize = CGSizeMake(760, 650);
    }
    
//    // Force realignment of cell being displayed
//    CGSize currentSize = self.collectionView.bounds.size;
//    float offset = self.currentIndex * currentSize.width;
//    [self.collectionView setContentOffset:CGPointMake(offset, 0)];
//    
//    // Fade the collectionView back in
//    [UIView animateWithDuration:0.125f animations:^{
//        [self.collectionView setAlpha:1.0f];
//    }];
    
}

- (IBAction)researchRequestButtonClick:(UIButton *)sender {
    
    [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"ResearchRequest"];
    
    UIStoryboard *centerStoryBoard = [UIStoryboard storyboardWithName:@"ResearchRequest" bundle:nil];
    UINavigationController *popOverView =[centerStoryBoard instantiateViewControllerWithIdentifier:@"requestNav"];
    
  //  ResearchRequestPopoverView *researchViewController=(ResearchRequestPopoverView *)[[popOverView viewControllers]objectAtIndex:0];
    
  //  ResearchRequestPopoverView *popOverView = [[ResearchRequestPopoverView alloc]initWithNibName:@"ResearchRequestPopoverView" bundle:nil];
 //  popOverView.transitioningDelegate = self;
    popOverView.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:popOverView animated:NO completion:nil];
}

-(void)requestChange:(id)sender {
    
    
        [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"Request Change"];
    
    UIStoryboard *centerStoryBoard = [UIStoryboard storyboardWithName:@"ResearchRequest" bundle:nil];
    UINavigationController *popOverView =[centerStoryBoard instantiateViewControllerWithIdentifier:@"requestNav"];
    
    ResearchRequestPopoverView *researchViewController=(ResearchRequestPopoverView *)[[popOverView viewControllers]objectAtIndex:0];
   // ResearchRequestPopoverView *popOverView = [[ResearchRequestPopoverView alloc]initWithNibName:@"ResearchRequestPopoverView" bundle:nil];
 //   popOverView.transitioningDelegate = self;
    researchViewController.fromAddContent = YES;
    popOverView.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:popOverView animated:NO completion:nil];
}

- (IBAction)addContentButtonClick:(id)sender {
    
    
        [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"Add Content Main Menu"];
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
   
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"AddContent" bundle:nil];
    
    UINavigationController *modalController = [storyBoard instantiateViewControllerWithIdentifier:@"addContentNav"];
    formSheet = [[MZFormSheetController alloc] initWithViewController:modalController];
    if(orientation == 1) {
        formSheet.presentedFormSheetSize = CGSizeMake(760, 650);
    } else {
        formSheet.presentedFormSheetSize = CGSizeMake(800, 650);
    }
    
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.shouldDismissOnBackgroundViewTap = NO;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    __weak MZFormSheetController *weakFormSheet = formSheet;
    
    
    // If you want to animate status bar use this code
    formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
        UINavigationController *navController = (UINavigationController *)weakFormSheet.presentedFSViewController;
        if ([navController.topViewController isKindOfClass:[AddContentFirstLevelView class]]) {
            //AddContentFirstLevelView *mzvc = (AddContentFirstLevelView *)navController.topViewController;
          //  mzvc.showStatusBar = NO;
        }
        
        
        [UIView animateWithDuration:0.3 animations:^{
            if ([weakFormSheet respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                [weakFormSheet setNeedsStatusBarAppearanceUpdate];
            }
        }];
    };
    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
        // Passing data
        UINavigationController *navController = (UINavigationController *)presentedFSViewController;
       // navController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        
        
        
        [navController.navigationBar setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:
          [UIColor whiteColor],
          UITextAttributeTextColor,
          [UIFont fontWithName:@"OpenSans" size:18.0],
          UITextAttributeFont,
          nil]];
        
        navController.topViewController.title = @"Add Content";
    };
    formSheet.transitionStyle = MZFormSheetTransitionStyleCustom;
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
//    NSString *accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"];
//    if(accessToken.length > 0) {
        [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
            
        }];
   // }
    
}


-(void)afterLogout {
    [FIUtils deleteExistingData];
   // [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isFIViewSelected"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"MenuList"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"accesstoken"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"firstTimeFlag"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"companyLogo"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"companyName"];
    UIStoryboard *centerStoryBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];
    UINavigationController *navCtlr = [centerStoryBoard instantiateViewControllerWithIdentifier:@"CorporateView"];
    // [[UINavigationBar appearance] setBarTintColor: [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0]];
    // navCtlr.navigationBar.tintColor = [UIColor whiteColor];
    [self.revealController setFrontViewController:navCtlr];
    [self.revealController showViewController:self.revealController.frontViewController];
}


#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    return [PresentingAnimator new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [DismissingAnimator new];
}

@end
