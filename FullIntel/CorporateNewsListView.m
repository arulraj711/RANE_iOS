//
//  CorporateNewsListView.m
//  FullIntel
//
//  Created by Arul on 3/18/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//          - activitytypeid  -category
//marked    2                      -2
//saved     3                      -3
#import "CorporateNewsListView.h"
#import "ViewController.h"
#import "CorporateNewsCell.h"
#import "UIView+Toast.h"
#import "FISharedResources.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PKRevealController.h"
#import "CorporateNewsDetailsView.h"
#import "FIUtils.h"
#import "AddContentFirstLevelView.h"
#import "ResearchRequestPopoverView.h"
#import "pop.h"
#import "QuartzCore/QuartzCore.h"
#import "BGTableViewRowActionWithImage.h"
#import "MoreSettingsView.h"
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define UIColorFromRGB(rgbValue)[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

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

@interface CorporateNewsListView ()

@end

@implementation CorporateNewsListView

- (void)viewDidLoad {
    NSLog(@"view did load");
    
    [super viewDidLoad];
    isSearchingInteger = 0;
    switchForUnread = 0;
    _articlesTableView.multipleTouchEnabled = NO;
    _articlesTableView.allowsMultipleSelectionDuringEditing = NO;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.revealController.recognizesPanningOnFrontView = NO;
//        self.revealController. = @{PKRevealControllerRecognizesPanningOnFrontViewKey : @NO};
//        NSDictionary *options = @{
//                                  PKRevealControllerRecognizesPanningOnFrontViewKey : @NO
//                                  };
//        [self.navigationController.navigationBar addGestureRecognizer:self.revealController.revealPanGestureRecognizer];
    }
    else{
    }
    NSNumber *newsLetterId = [[NSUserDefaults standardUserDefaults]objectForKey:@"newsletterId"];
    BOOL isFolderClick = [[NSUserDefaults standardUserDefaults]boolForKey:@"isFolderClick"];
    NSLog(@"newsletter id:%@",newsLetterId);
    if(isFolderClick) {
        [self.revealController showViewController:self.revealController.frontViewController];
    } else if([newsLetterId isEqualToNumber:[NSNumber numberWithInt:0]]) {
        [self addButtonsOnNavigationBar];
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){
            BOOL isExpandButtonClick = [[NSUserDefaults standardUserDefaults]boolForKey:@"isExpandButtonClick"];
            if(isExpandButtonClick) {
                [self.revealController showViewController:self.revealController.leftViewController];
            } else {
                [self.revealController showViewController:self.revealController.frontViewController];
            }
            
        } else {
            [self.revealController showViewController:self.revealController.leftViewController];
        }
        
    } else {
        [self.revealController showViewController:self.revealController.frontViewController];
    }
    messageString = @"Loading...";
    // NSLog(@"list did load");notifyForLast24
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyForUnread) name:@"notifyForUnreadMenu" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyForLast) name:@"notifyForLast24" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAlpha) name:@"changeAlphaVal" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCuratedNews) name:@"CuratedNews" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failToLoad) name:@"CuratedNewsFail" object:nil];
    self.isNewsLetterNav = NO;
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMethodFor24Hrs) name:@"MethodFor24Hrs" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopLoading) name:@"StopLoading" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopLoadingForAlert) name:@"stopLoadingForAlert" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoginPage) name:@"authenticationFailed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestChange:) name:@"requestChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(markedImportantUpdate:) name:@"markedImportantUpdate" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveForLaterUpdate:) name:@"saveForLaterUpdate" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readStatusUpdate:) name:@"readStatusUpdate" object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addOverLayForTutorial) name:@"MainListArrowTutorial" object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(afterSwipeUpAndDownTutorial) name:@"SaveForLaterTutorialTrigger" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(afterSaveForLaterTutorial) name:@"DrillInTutorialTrigger" object:nil];
    
    //    self.actionsButton.layer.masksToBounds = YES;
    //    self.actionsButton.layer.cornerRadius = 5;
    //    self.actionsButton.layer.borderWidth = 1.0f;
    //    self.actionsButton.layer.borderColor = [UIColor lightTextColor].CGColor;
    //
    //    self.showButton.layer.masksToBounds = YES;
    //    self.showButton.layer.cornerRadius = 5;
    //    self.showButton.layer.borderWidth = 1.0f;
    //    self.showButton.layer.borderColor = [UIColor lightTextColor].CGColor;
    
    self.devices = [[NSMutableArray alloc]init];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endOfTutorial) name:@"EndOfTutorial" object:nil];
    
    
//    [self.revealController showViewController:self.revealController.leftViewController];
//    UIButton *Btn =[UIButton buttonWithType:UIButtonTypeCustom];
//    
//    [Btn setFrame:CGRectMake(0.0f,0.0f,16.0f,15.0f)];
//    [Btn setBackgroundImage:[UIImage imageNamed:@"navmenu"]  forState:UIControlStateNormal];
//    [Btn addTarget:self action:@selector(backBtnPress) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:Btn];
//    [self.navigationItem setLeftBarButtonItem:addButton];
//    
//    UIView *addBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
//    addBtnView.backgroundColor = [UIColor clearColor];
//    
//    UIButton *addBtn =[UIButton buttonWithType:UIButtonTypeCustom];
//    [addBtn setFrame:CGRectMake(0,0,40,40)];
//    [addBtn setImage :[UIImage imageNamed:@"addcontent"]  forState:UIControlStateNormal];
//    [addBtn addTarget:self action:@selector(addContentView) forControlEvents:UIControlEventTouchUpInside];
//    [addBtnView addSubview:addBtn];
//    UIBarButtonItem *addContentButton = [[UIBarButtonItem alloc] initWithCustomView:addBtnView];
    
//    UIView *searchBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 15)];
//    searchBtnView.backgroundColor = [UIColor clearColor];
//    UIButton *searchBtn =[UIButton buttonWithType:UIButtonTypeCustom];
//    [searchBtn setFrame:CGRectMake(0.0f,0.0f,16.0f,15.0f)];
//    [searchBtn setBackgroundImage:[UIImage imageNamed:@"rss_whiteicon"]  forState:UIControlStateNormal];
//    [searchBtn setTitle:@"RSS" forState:UIControlStateNormal];
//    [searchBtn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
//    [searchBtnView addSubview:searchBtn];
//    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithCustomView:searchBtnView];

    
    [self addRightBarItems];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Open Sans" size:16];
   // label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.text =_titleName;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    
    
    
    refreshControl = [[UIRefreshControl alloc]initWithFrame:CGRectMake(refreshControl.frame.origin.x-20, self.view.center.y, refreshControl.frame.size.width, refreshControl.frame.size.height)];
    //refreshControl.center = self.view.center;
    [self.articlesTableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    
    self.articlesTableView.dataSource = nil;
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.alpha = 1.0;
    activityIndicator.center = self.view.center;
    activityIndicator.hidesWhenStopped = YES;
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)changeAlpha{
    self.view.alpha = 1;
}

-(void)notifyForUnread{
    switchForUnread = 1;
    [self callSearchAPIWithStringForUnread:@"" withFilterString:@"UNREAD"];

}

-(void)notifyForLast{
    switchForUnread = 2;
    [self callSearchAPIWithStringForUnread:@"" withFilterString:@"RECENT"];
    [self newMethodFor24Hrs];
}


- (void)callSearchAPIWithStringForUnread:(NSString *)searchString withFilterString:(NSString *)filterString {
    //TODO: refresh your data
    //if(self.devices.count == 0) {
    NSNumber *folderId = [[NSUserDefaults standardUserDefaults]objectForKey:@"folderId"];
    NSNumber *category = [[NSUserDefaults standardUserDefaults] valueForKey:@"categoryId"];
    // NSInteger category = categoryStr.integerValue;
    NSLog(@"folder id:%@ and categoryid:%@",folderId,category);
    NSString *queryString;
    if([folderId isEqualToNumber:[NSNumber numberWithInt:0]]) {
        // NSInteger category = categoryStr.integerValue;
        NSString *inputJson;
        if([category isEqualToNumber:[NSNumber numberWithInt:-2]]) {
            
            queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] valueForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withQuery:searchString withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:filterString withActivityTypeID:[NSNumber numberWithInt:2]];
            
            
        } else if([category isEqualToNumber:[NSNumber numberWithInt:-3]]) {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"SavedForLaterIsNew"];
            
            queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withQuery:searchString withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:filterString withActivityTypeID:[NSNumber numberWithInt:3]];
            
            
        } else {
            
            NSNumber *parentId = [[NSUserDefaults standardUserDefaults]objectForKey:@"parentId"];
            NSLog(@"parent id:%@",parentId);
            
            queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:parentId withPageNumber:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withQuery:searchString withContentCategoryId:category withOrderBy:@"" withFilterBy:filterString withActivityTypeID:[NSNumber numberWithInt:0]];
            
        }
        NSLog(@"input json 111:%@",inputJson);
        NSNumber *contentTypeId = [[NSUserDefaults standardUserDefaults]objectForKey:@"parentId"];
        
        [[FISharedResources sharedResourceManager]getCuratedNewsListWithAccessToken:queryString withCategoryId:category withContentTypeId:contentTypeId withFlag:@"" withLastArticleId:@"" withActivityTypeId:[NSNumber numberWithInt:2]];
        
        
        // }
    } else {
        [[FISharedResources sharedResourceManager]fetchArticleFromFolderWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withFolderId:folderId withPageNo:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withUpFlag:YES];
    }
    [refreshControl endRefreshing];
    //    [self.influencerTableView reloadData];

}

- (double)timeStampValeOfDate: (NSDate *)dateInput{
    
//    NSDateFormatter *df=[[NSDateFormatter alloc] init];
//    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *inputDate = [df stringFromDate:dateInput];
//    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
//    NSDate *date = [df dateFromString:inputDate];
    
    NSTimeInterval since1970 = [dateInput timeIntervalSince1970]; // January 1st 1970
    
    double result = since1970 * 1000;
    return result;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (self.articlesTableView.editing)
        return NO;
    else
        return YES;
}

-(void)redirectToNewsLetterArticleWithId:(NSString *)articleId {
    if(self.devices.count != 0) {
        
        //UpgradeView
        UIStoryboard *storyBoard;
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        {
            storyBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListViewPhone" bundle:nil];

        } else {
            storyBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];

        }
        NSString *userAccountTypeId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userAccountTypeId"]];
        CorporateNewsDetailsView *testView;
        testView = [storyBoard instantiateViewControllerWithIdentifier:@"UpgradeView"];
        testView.selectedNewsArticleId = self.selectedNewsLetterArticleId;
        [self.navigationController pushViewController:testView animated:YES];
    }
}


-(void)triggerTutorial{
    NSLog(@"trigger tutorial function");
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"TutorialBoxShown"];
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"TutorialShown"];
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"MarkImportantTutorialTrigger"];
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"SwipeUpAndDownTutorialTrigger"];
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"SwipeDownTutorialTrigger"];
    
    
    
    [self.revealController showViewController:self.revealController.leftViewController];
    
    
    BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"TutorialBoxShown"];
    if (coachMarksShown == NO) {
        UIStoryboard *centerStoryBoard;
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){
            centerStoryBoard = [UIStoryboard storyboardWithName:@"TutorialiPhone" bundle:nil];
        } else {
            centerStoryBoard = [UIStoryboard storyboardWithName:@"Tutorial" bundle:nil];
        }
        UINavigationController *popOverView =[centerStoryBoard instantiateViewControllerWithIdentifier:@"tutorialPop"];
        
        //  ResearchRequestPopoverView *researchViewController=(ResearchRequestPopoverView *)[[popOverView viewControllers]objectAtIndex:0];
        
        //  ResearchRequestPopoverView *popOverView = [[ResearchRequestPopoverView alloc]initWithNibName:@"ResearchRequestPopoverView" bundle:nil];
        //  popOverView.transitioningDelegate = self;
        popOverView.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:popOverView animated:NO completion:nil];
        
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"TutorialBoxShown"];
        
    }
    
}

-(void)endOfTutorial{
    
    
    [self.revealController showViewController:self.revealController.leftViewController];
    
    
    UIStoryboard *centerStoryBoard;
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){
        centerStoryBoard = [UIStoryboard storyboardWithName:@"TutorialiPhone" bundle:nil];
    } else {
        centerStoryBoard = [UIStoryboard storyboardWithName:@"Tutorial" bundle:nil];
    }
    // UIViewController *popOverView =[centerStoryBoard instantiateViewControllerWithIdentifier:@"MainListTutorialViewController"];
    
    UINavigationController *popOverView =[centerStoryBoard instantiateViewControllerWithIdentifier:@"EndOfTutorialViewController"];
    popOverView.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:popOverView animated:NO completion:nil];
    
    
}
-(void)afterSaveForLaterTutorial{
    
    [popAnimationTimer invalidate];
    
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"SaveForLaterTutorialShown"];
    
    [self.articlesTableView reloadData];
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.articlesTableView selectRowAtIndexPath:indexPath
                                        animated:YES
                                  scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.articlesTableView didSelectRowAtIndexPath:indexPath];
    
    
    [self performSelector:@selector(triggerDrillInTutorial) withObject:nil afterDelay:2.0];
    
}

-(void)triggerDrillInTutorial{
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DrillDownTutorialTrigger" object:nil];
}

-(void)afterSwipeUpAndDownTutorial{
    
    
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"SaveForLaterTutorialShown"];
    
    [self.articlesTableView reloadData];
}
-(void)addOverLayForTutorial{
    
    
    
    [self.revealController showViewController:self.revealController.frontViewController];
    
    UIStoryboard *centerStoryBoard;
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){
        centerStoryBoard = [UIStoryboard storyboardWithName:@"TutorialiPhone" bundle:nil];
    } else {
        centerStoryBoard = [UIStoryboard storyboardWithName:@"Tutorial" bundle:nil];
    }
    // UIViewController *popOverView =[centerStoryBoard instantiateViewControllerWithIdentifier:@"MainListTutorialViewController"];
    
    UINavigationController *popOverView =[centerStoryBoard instantiateViewControllerWithIdentifier:@"MainListTutorialPopUp"];
    popOverView.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:popOverView animated:NO completion:nil];
    
    
}

//-(void)updateNewsTitle {
//    
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
//    label.backgroundColor = [UIColor clearColor];
//    label.font = [UIFont fontWithName:@"Open Sans" size:16];
//    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
//    label.text =_titleName;
//    label.textAlignment = NSTextAlignmentCenter;
//    label.textColor = [UIColor whiteColor]; // change this color
//    self.navigationItem.titleView = label;
//    
//    
//    self.devices = [[NSMutableArray alloc]init];
//    self.articlesTableView.dataSource = nil;
//    NSString *accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"];
//    if(accessToken.length == 0) {
//        // NSLog(@"corporate if part");
//        [self showLoginPage];
//    } else {
//        //        BOOL isFirst = [[NSUserDefaults standardUserDefaults]boolForKey:@"firstTimeFlag"];
//        //        if(isFirst) {
//        
//        
//        
//        [self loadCuratedNews];
//        //        }
//    }
//}


-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    NSLog(@"scrollViewWillBeginDecelerating");
    
    [self closeMenu];

}

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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
//            self.revealController.revealPanGestureRecognizer.delegate = nil;
    [self closeMenu];
}


-(void)closeMenu{
    
    if(self.revealController.state == PKRevealControllerShowsLeftViewControllerInPresentationMode) {
        // NSLog(@"left view opened");
        [self.revealController showViewController:self.revealController.frontViewController];
    }
    
    
}
-(void)addRightBarItems {
    UIView *rssBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 35)];
    UIButton *rssButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 35)];
    [rssButton setImage:[UIImage imageNamed:@"rss_whiteicon"] forState:UIControlStateNormal];
    [rssButton setImageEdgeInsets:UIEdgeInsetsMake(0,62,0,0)];
    [rssButton setTitle:@"Export" forState:UIControlStateNormal];
    [rssButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rssButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:14];
    [rssButton setTitleEdgeInsets: UIEdgeInsetsMake(0,0,0,40)];
    [rssButton addTarget:self action:@selector(openRSSField) forControlEvents:UIControlEventTouchUpInside];
    [rssBtnView addSubview:rssButton];
    UIBarButtonItem *RSSButton = [[UIBarButtonItem alloc] initWithCustomView:rssBtnView];
    BOOL isRssField = [[NSUserDefaults standardUserDefaults]boolForKey:@"isRSSField"];
    if(isRssField) {
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:RSSButton, nil]];
    } else {
        //[self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:addContentButton,nil]];
    }
}
-(void)viewWillAppear:(BOOL)animated{
//    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){
//    self.revealController.revealPanGestureRecognizer.delegate = self;
//    }
//    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
//    if ( screenHeight > 480 && screenHeight < 736 ){
//        NSLog(@"iPhone 6");
//        
//        
//    }
//    else if (screenHeight == 320){
//        self.articlesTableView.frame = CGRectMake(0.f, 0.f, 320, 667);
//        NSLog(@"iPhone 5");
//
//    }
//    
//    
//    else if ( screenHeight > 480 ){
//        NSLog(@"iPhone 6 Plus");
//    }
//
}
-(void)viewDidDisappear:(BOOL)animated{
    isSearchingInteger = 0;

}
-(void)viewDidAppear:(BOOL)animated {
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"];
    if(accessToken.length == 0) {
        // NSLog(@"corporate if part");
        [self showLoginPage];
    } else {
        //        BOOL isFirst = [[NSUserDefaults standardUserDefaults]boolForKey:@"firstTimeFlag"];
        //        if(isFirst) {
        //[self loadCuratedNews];
        //        }
        [[FISharedResources sharedResourceManager]tagScreenInLocalytics:self.titleName];
        [self loadCuratedNews];
    }
}
//-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
//
//    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
//
//    if(toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation==UIInterfaceOrientationLandscapeRight){
//
//        NSLog(@"view size in Landscape :%f :%f :%f :%f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
//
//        self.corporateListWidthConstraint.constant=self.view.frame.size.width-30;
//
//    }else if(toInterfaceOrientation==UIInterfaceOrientationPortrait){
//
//          NSLog(@"view size in Portrait :%f :%f :%f :%f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
//
//        self.corporateListWidthConstraint.constant=self.view.frame.size.width-30;
//    }
//}

#pragma mark -
#pragma mark Rotation handling methods

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:
(NSTimeInterval)duration {
    
    // Fade the collectionView out
    
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    // Force realignment of cell being displayed
    
    //    CGSize contentSize=self.articlesTableView.contentSize;
    //    contentSize.width=self.articlesTableView.bounds.size.width;
    //    self.articlesTableView.contentSize=contentSize;
    
    //    [self.articlesTableView beginUpdates];
    //    [self.articlesTableView endUpdates];
}
-(void)showLoginPage {
    NSArray *navArray = self.navigationController.viewControllers;
    if(navArray.count > 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        UIStoryboard *loginStoryBoard;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            loginStoryBoard = [UIStoryboard storyboardWithName:@"MainPhone" bundle:nil];
            ViewController *loginView = [loginStoryBoard instantiateViewControllerWithIdentifier:@"LoginViewPhone"];
            [self presentViewController:loginView animated:YES completion:nil];
            //        UIWindow *window = [[UIApplication sharedApplication]windows][0];
            //        [window addSubview:loginView.view];

        } else {
            loginStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ViewController *loginView = [loginStoryBoard instantiateViewControllerWithIdentifier:@"LoginView"];
            [self presentViewController:loginView animated:YES completion:nil];
            //        UIWindow *window = [[UIApplication sharedApplication]windows][0];
            //        [window addSubview:loginView.view];
        }
        
    } else {
        UIStoryboard *loginStoryBoard;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            loginStoryBoard = [UIStoryboard storyboardWithName:@"MainPhone" bundle:nil];
            ViewController *loginView = [loginStoryBoard instantiateViewControllerWithIdentifier:@"LoginViewPhone"];
            [self presentViewController:loginView animated:YES completion:nil];
            //        UIWindow *window = [[UIApplication sharedApplication]windows][0];
            //        [window addSubview:loginView.view];
            
        } else {
            loginStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ViewController *loginView = [loginStoryBoard instantiateViewControllerWithIdentifier:@"LoginView"];
            [self presentViewController:loginView animated:YES completion:nil];
            //        UIWindow *window = [[UIApplication sharedApplication]windows][0];
            //        [window addSubview:loginView.view];
        }   //        UIWindow *window = [[UIApplication sharedApplication]windows][0];
            //        [window addSubview:loginView.view];
    }
    
    
            //        [self presentViewController:loginView animated:YES completion:nil];
}

-(void)stopLoading {
    [self.devices removeAllObjects];
    NSLog(@"stop loading is calling");
    messageString = @"No articles to display";
    [activityIndicator stopAnimating];
    [self.articlesTableView reloadData];
}
-(void)stopLoadingForAlert{
    NSLog(@"stopLoadingForAlert");
    [activityIndicator stopAnimating];
    _spinner.hidden=YES;
    [self.spinner stopAnimating];
}
-(void)addButtonsOnNavigationBar
{
    UIButton *Btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [Btn setFrame:CGRectMake(0.0f,0.0f,16.0f,15.0f)];
    [Btn setBackgroundImage:[UIImage imageNamed:@"navmenu"]  forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(backBtnPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    [self.navigationItem setLeftBarButtonItem:addButton];
    
    Btns =[UIButton buttonWithType:UIButtonTypeCustom];
    [Btns setFrame:CGRectMake(0.0f,0.0f,16.0f,15.0f)];
    [Btns setBackgroundImage:[UIImage imageNamed:@"settingsMIcon"]  forState:UIControlStateNormal];
    [Btns addTarget:self action:@selector(settingsButtonFilter) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addButtons = [[UIBarButtonItem alloc] initWithCustomView:Btns];
    // [self.navigationItem setRightBarButtonItem:addButtons];
    
    searchButtons =[UIButton buttonWithType:UIButtonTypeCustom];
    [searchButtons setFrame:CGRectMake(0.0f,0.0f,16.0f,15.0f)];
    [searchButtons setBackgroundImage:[UIImage imageNamed:@"search"]  forState:UIControlStateNormal];
    [searchButtons addTarget:self action:@selector(searchButtonFilter) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addButtonsRight = [[UIBarButtonItem alloc] initWithCustomView:searchButtons];
    NSArray *buttonsArr = [NSArray arrayWithObjects:addButtons,addButtonsRight, nil];
    [self.navigationItem setRightBarButtonItems:buttonsArr];

}
-(void)newMethodFor24Hrs
{
    
//    NSDate *now = [[NSDate alloc]init];
//    
//    NSLog(@"%@", now);
//    
//    NSDateComponents *components = [[NSDateComponents alloc] init];
//    
//    [components setDay:-1];
//    
//    NSDate *yesterday = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:0];
//    
//    NSLog(@"%@", yesterday);
//    
//    
//    
//    double todayDate = [self timeStampValeOfDate:now];
//    
//    double yesterdayDate = [self timeStampValeOfDate:yesterday];
//    
//    NSLog(@"%@",  [NSDecimalNumber numberWithDouble:todayDate]);
//    
//    NSLog(@"%@",  [NSDecimalNumber numberWithDouble:yesterdayDate]);
//    
//    
//    
//    
//    
//    NSNumber *categoryId = [[NSUserDefaults standardUserDefaults]objectForKey:@"categoryId"];
//    
//    
//    
//    NSNumber *folderId = [[NSUserDefaults standardUserDefaults]objectForKey:@"folderId"];
//    
//    
//    
//    NSNumber *contentTypeId = [[NSUserDefaults standardUserDefaults]objectForKey:@"parentId"];
//    
//    
//    
//    NSNumber *newsLetterId = [[NSUserDefaults standardUserDefaults]objectForKey:@"newsletterId"];
//    
//    
//    
//    
//    
//    
//    
//    NSLog(@"load curated news categoryId:%@ and folderid:%@ and contentTypeId:%@ and newsletterid:%@",categoryId,folderId,contentTypeId,newsLetterId);
//    
//    
//    
//    //    NSLog(@"category id in curated news:%@",categoryId);
//    
//    
//    
//    //    self.devices = [[NSMutableArray alloc]init];
//    
//    
//    
//    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
//    
//    
//    
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
//    
//    
//    
//    NSPredicate *predicate;
//    
//    
//    
//    if([newsLetterId isEqualToNumber:[NSNumber numberWithInt:0]]) {
//        
//        BOOL isFolderClick = [[NSUserDefaults standardUserDefaults]boolForKey:@"isFolderClick"];
//        
//        if(isFolderClick) {
//            
//            
//            
//        } else {
//            
//            [self addButtonsOnNavigationBar];
//            
//        }
//        
//        
//        
//        if([folderId isEqualToNumber:[NSNumber numberWithInt:0]]) {
//            
//            if([categoryId isEqualToNumber:[NSNumber numberWithInt:-3]]) {
//                
//                NSLog(@"if part");
//                
//                BOOL savedForLaterIsNew =[[NSUserDefaults standardUserDefaults]boolForKey:@"SavedForLaterIsNew"];
//                
//                if(savedForLaterIsNew){
//                    
//                    if([categoryId isEqualToNumber:[NSNumber numberWithInt:-1]]) {
//                        
//                        predicate  = [NSPredicate predicateWithFormat:@"saveForLater == %@ AND contentTypeId==%@ AND publishedDate >= %@ AND publishedDate <= %@",[NSNumber numberWithBool:YES],contentTypeId, [NSDecimalNumber numberWithDouble:yesterdayDate], [NSDecimalNumber numberWithDouble:todayDate]];
//                        
//                    } else {
//                        
//                        predicate  = [NSPredicate predicateWithFormat:@"saveForLater == %@ AND categoryId == %@  AND publishedDate >= %@ AND publishedDate <= %@",[NSNumber numberWithBool:YES],categoryId, [NSDecimalNumber numberWithDouble:yesterdayDate], [NSDecimalNumber numberWithDouble:todayDate]];
//                        
//                    }
//                    
//                } else {
//                    
//                    NSLog(@"saved for later old");
//                    
//                    predicate  = [NSPredicate predicateWithFormat:@"saveForLater == %@ AND categoryId == %@  AND publishedDate >= %@ AND publishedDate <= %@",[NSNumber numberWithBool:YES],categoryId, [NSDecimalNumber numberWithDouble:yesterdayDate], [NSDecimalNumber numberWithDouble:todayDate]];
//                    
//                }
//                
//                // [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"SavedForLaterIsNew"];
//                
//                
//                
//            } else {
//                
//                NSLog(@"else part");
//                
//                NSLog(@"content btype:%@ and category:%@",contentTypeId,categoryId);
//                
//                predicate  = [NSPredicate predicateWithFormat:@"categoryId==%@ AND contentTypeId==%@  AND publishedDate >= %@ AND publishedDate <= %@",categoryId,contentTypeId, [NSDecimalNumber numberWithDouble:yesterdayDate], [NSDecimalNumber numberWithDouble:todayDate]];
//                
//            }
//            
//        } else {
//            
//            predicate  = [NSPredicate predicateWithFormat:@"isFolder == %@ AND folderId == %@  AND publishedDate >= %@ AND publishedDate <= %@",[NSNumber numberWithBool:YES],folderId, [NSDecimalNumber numberWithDouble:yesterdayDate], [NSDecimalNumber numberWithDouble:todayDate]];
//            
//        }
//        
//        
//        
//    } else {
//        
//        [self.revealController showViewController:self.revealController.frontViewController];
//        
//        predicate  = [NSPredicate predicateWithFormat:@"newsletterId == %@  AND publishedDate >= %@ AND publishedDate <= %@",newsLetterId, [NSDecimalNumber numberWithDouble:yesterdayDate], [NSDecimalNumber numberWithDouble:todayDate]];
//        
//        
//        
//    }
//    
//    [fetchRequest setPredicate:predicate];
//    
//    
//    
//    //    if([categoryId isEqualToNumber:[NSNumber numberWithInt:-3]]) {
//    
//    //        self.devices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
//    
//    //    }else {
//    
//    //        self.devices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
//    
//    //    }
//    
//    
//    
//    switchForUnread = 0;
//    
//    NSLog(@"%@",self.devices);
//    
//    
//    
//    
//    
//    NSArray *existingArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
//    
//    NSLog(@"%@",existingArray);
//    
//    
//    
//    
//    
//    
//    
//    //first for date sorting--------------------------------------------------------------------------------------------------------------------
//    
//    
//    
//    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"publishedDate" ascending:NO];
//    
//    
//    
//    NSArray *sortedPeople = [existingArray sortedArrayUsingDescriptors:@[sortDescriptor]];
//    
//    NSLog(@"%@", sortedPeople);
//    
    
    
    //newcomers to define just 24hours--------------------------------------------------------------------------------------------------------------------
    
    
        NSDate *now = [[NSDate alloc]init];
    
        NSLog(@"%@", now);
    
        NSDateComponents *components = [[NSDateComponents alloc] init];
        NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];

        [components setDay:-1];
    
        NSDate *yesterday = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:0];
    
        NSLog(@"%@", yesterday);
    
    
    
        double todayDate = [self timeStampValeOfDate:now];
    
        double yesterdayDate = [self timeStampValeOfDate:yesterday];
    
        NSLog(@"%@",  [NSDecimalNumber numberWithDouble:todayDate]);
    
        NSLog(@"%@",  [NSDecimalNumber numberWithDouble:yesterdayDate]);
    
        NSFetchRequest *fetchRequesta = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
    
        NSPredicate *predicatea;
    
    //    [NSPredicate predicateWithFormat:@"date BETWEEN %@", [NSArray arrayWithObjects:startOfDay, endOfDay, nil]]
    
        predicatea = [NSPredicate predicateWithFormat:@"publishedDate >= %@ AND publishedDate <= %@", [NSDecimalNumber numberWithDouble:yesterdayDate], [NSDecimalNumber numberWithDouble:todayDate]];
    
        [fetchRequesta setPredicate:predicatea];
    
        NSArray *existingArraya = [[managedObjectContext executeFetchRequest:fetchRequesta error:nil] mutableCopy];
    
        NSLog(@"Existing Array count ---->%lu",(unsigned long)existingArraya.count);
    
    
    
    
    
    if ([existingArraya count] == 0) {
        
        UIWindow *window = [[UIApplication sharedApplication]windows][0];
        
        [window makeToast:@"No articles within past 24 hours" duration:1.5 position:CSToastPositionCenter];
        
    } else {
        
        isSearchingInteger = 1;
        
        self.devices = [[NSMutableArray alloc]init];
        
        self.devices = [existingArraya mutableCopy];
        
        [_articlesTableView reloadData];
        
    }
    

    
}
-(void)loadCuratedNews {
    
    NSLog(@"%lu",(unsigned long)[self.devices count]);

    // [[UIApplication sharedApplication] setApplicationIconBadgeNumber:100];
    
    self.articlesTableView.dataSource = self;
    
    self.articlesTableView.delegate = self;
    
    NSNumber *categoryId = [[NSUserDefaults standardUserDefaults]objectForKey:@"categoryId"];
    
    NSNumber *folderId = [[NSUserDefaults standardUserDefaults]objectForKey:@"folderId"];
    
    NSNumber *contentTypeId = [[NSUserDefaults standardUserDefaults]objectForKey:@"parentId"];
    
    NSNumber *newsLetterId = [[NSUserDefaults standardUserDefaults]objectForKey:@"newsletterId"];
    
    
    
    NSLog(@"load curated news categoryId:%@ and folderid:%@ and contentTypeId:%@ and newsletterid:%@",categoryId,folderId,contentTypeId,newsLetterId);
    
    // NSLog(@"category id in curated news:%@",categoryId);
    
    self.devices = [[NSMutableArray alloc]init];
    
    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
    
    NSPredicate *predicate;
    
    if([newsLetterId isEqualToNumber:[NSNumber numberWithInt:0]]) {

        BOOL isFolderClick = [[NSUserDefaults standardUserDefaults]boolForKey:@"isFolderClick"];
        if(isFolderClick) {
            [self addButtonsOnNavigationBar];

        } else {
            [self addButtonsOnNavigationBar];
        }

        if([folderId isEqualToNumber:[NSNumber numberWithInt:0]]) {
            if([categoryId isEqualToNumber:[NSNumber numberWithInt:-3]]) {
                NSLog(@"if part");
                BOOL savedForLaterIsNew =[[NSUserDefaults standardUserDefaults]boolForKey:@"SavedForLaterIsNew"];
                if(savedForLaterIsNew){
                    if([categoryId isEqualToNumber:[NSNumber numberWithInt:-1]]) {
                        predicate  = [NSPredicate predicateWithFormat:@"saveForLater == %@ AND contentTypeId==%@",[NSNumber numberWithBool:YES],contentTypeId];
                    } else {
                        predicate  = [NSPredicate predicateWithFormat:@"saveForLater == %@ AND categoryId == %@",[NSNumber numberWithBool:YES],categoryId];
                    }
                } else {
                    NSLog(@"saved for later old");
                    predicate  = [NSPredicate predicateWithFormat:@"saveForLater == %@ AND categoryId == %@",[NSNumber numberWithBool:YES],categoryId];
                }
                // [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"SavedForLaterIsNew"];
                
            } else {
                NSLog(@"else part");
                NSLog(@"content btype:%@ and category:%@",contentTypeId,categoryId);
                predicate  = [NSPredicate predicateWithFormat:@"categoryId==%@ AND contentTypeId==%@",categoryId,contentTypeId];
            }
        } else {
            predicate  = [NSPredicate predicateWithFormat:@"isFolder == %@ AND folderId == %@",[NSNumber numberWithBool:YES],folderId];
        }
        
    } else {
        [self.revealController showViewController:self.revealController.frontViewController];
        predicate  = [NSPredicate predicateWithFormat:@"newsletterId == %@",newsLetterId];
        
    }
    
    
    
    
    
    
    [fetchRequest setPredicate:predicate];
    
    
    
    
    
//    NSSortDescriptor *date = [[NSSortDescriptor alloc] initWithKey:@"publishedDate" ascending:NO];
//    
//    NSLog(@"date:%@",date);
//    
//    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:date, nil];
//    
//    [fetchRequest setSortDescriptors:sortDescriptors];
//    
//    
//    
    
    
    
    
    NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    NSLog(@"curated news list count:%lu",(unsigned long)newPerson.count);
    
    if(newPerson.count != 0) {
        
        [self addRightBarItems];
        
        [activityIndicator stopAnimating];
        
    } else {
        
        self.navigationItem.rightBarButtonItems = nil;
        
        //messageString = @"No articles to display";
        
        //[activityIndicator stopAnimating];
        
        
        
    }
    
    
    
    //    if([categoryId isEqualToNumber:[NSNumber numberWithInt:-3]] && newPerson.count == 0) {
    
    //        [self stopLoading];
    
    //    }
    
    //    if(![folderId isEqualToNumber:[NSNumber numberWithInt:0]] && newPerson.count == 0) {
    
    //        [activityIndicator stopAnimating];
    
    //    }
    
    if([categoryId isEqualToNumber:[NSNumber numberWithInt:-3]]) {
        
        self.devices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        
        
        
    }else {
        
        self.devices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        
    }
    NSLog(@"%lu",(unsigned long)[self.devices count]);
    NSLog(@"news article id:%@",self.selectedNewsLetterArticleId);
    
    if(self.selectedNewsLetterArticleId.length != 0 && !self.isNewsLetterNav) {
        
        self.isNewsLetterNav = YES;
        
        [self redirectToNewsLetterArticleWithId:self.selectedNewsLetterArticleId];
        
    }
    
    
    
    //NSLog(@"devices:%d",self.devices.count);
    
    _spinner.hidden = YES;
    
    [_spinner stopAnimating];
    
    [self.articlesTableView reloadData];
    
    //   [self.revealController showViewController:self.revealController.leftViewController];
    
}
-(void)settingsButtonFilter{ 
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MoreSettingsViewPhone" bundle:nil];
    MoreSettingsView *popOverView = [storyBoard instantiateViewControllerWithIdentifier:@"MoreSettingsView"];
    popOverView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.view.alpha = 0.89;
    [self presentViewController:popOverView animated:NO completion:nil];

}
-(void)searchButtonFilter{
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.title = nil;

    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 44)];
    searchBar.showsCancelButton = YES;
    searchBar.delegate = self;
    [searchBar setPlaceholder:@"Search article or topic"];
    [self.navigationController.navigationBar addSubview:searchBar];

}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBars
{
    
    [searchBars resignFirstResponder];
    searchBars.hidden = YES;
//    NSNumber *category = [[NSUserDefaults standardUserDefaults] valueForKey:@"categoryId"];
//    
//    NSNumber *parentId = [[NSUserDefaults standardUserDefaults]objectForKey:@"parentId"];
//    NSLog(@"parent id:%@",parentId);
//    NSManagedObjectContext *context = [[FISharedResources sharedResourceManager] managedObjectContext];
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
//    NSPredicate *predicate;
//    NSLog(@"cancel button click content type id:%@ and category id:%@",parentId,category);
//    predicate = [NSPredicate predicateWithFormat:@"contentTypeId == %@ AND categoryId == %@",parentId,category];
//    [fetchRequest setPredicate:predicate];
//    NSArray *existingArray = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
//    self.devices = [existingArray mutableCopy];
//    
//    [_articlesTableView reloadData];
    [self loadCuratedNews];
    [self addButtonsOnNavigationBar];

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBars {
    [searchBars resignFirstResponder];
     [self callSearchAPIWithString:searchBars.text];
}

-(void)commonMethodForSearchBarExit
{
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
        if([searchText length] != 0) {
            isSearching = YES;
            [self searchTableList];
        }
        else {
            isSearching = NO;
        }

}
//    NSLog(@"Text change - %d",isSearching);
//    
//    //Remove all objects first.
//    [filteredContentList removeAllObjects];
//    
//    if([searchText length] != 0) {
//        isSearching = YES;
//        [self searchTableList];
//    }
//    else {
//        isSearching = NO;
//    }
//    // [self.tblContentList reloadData];
//}
//
//
//
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    NSLog(@"Search Clicked");
//    [self searchTableList];
//}
- (void)searchTableList {
    if (isSearching) {
        NSString *searchString = searchBar.text;
        NSNumber *category = [[NSUserDefaults standardUserDefaults] valueForKey:@"categoryId"];
        
        NSNumber *parentId = [[NSUserDefaults standardUserDefaults]objectForKey:@"parentId"];
        NSLog(@"parent id:%@",parentId);
        NSManagedObjectContext *context = [[FISharedResources sharedResourceManager] managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
        NSPredicate *predicate;
        predicate = [NSPredicate predicateWithFormat:@"contentTypeId == %@ AND categoryId == %@",parentId,category];
        [fetchRequest setPredicate:predicate];
        NSArray *existingArray = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
        NSLog(@"Existing Array count ---->%lu",(unsigned long)existingArray.count);
        NSLog(@"Existing Array count ---->%@",existingArray);
        NSArray *idList = [existingArray valueForKey:@"title"]; // array of "id" numbers
        NSLog(@"---->%@",idList);
        
        NSPredicate *pred =[NSPredicate predicateWithFormat:@"title beginswith[c] %@ OR title contains[cd] %@", searchString, searchString];
        
        NSArray *beginWithB = [existingArray filteredArrayUsingPredicate:pred];
        NSLog(@"beginwithB = %@",beginWithB);
        
        articleIdToBePassed = [beginWithB valueForKey:@"articleId"];
        NSLog(@"articleIdToBePassed = %@",articleIdToBePassed);
       
        self.devices = [beginWithB mutableCopy];
        isSearchingInteger = 1;
        [_articlesTableView reloadData];
    }
    
    
}


- (void)callSearchAPIWithString:(NSString *)searchString {
    //TODO: refresh your data
    //if(self.devices.count == 0) {
    
    NSNumber *folderId = [[NSUserDefaults standardUserDefaults]objectForKey:@"folderId"];
    NSNumber *category = [[NSUserDefaults standardUserDefaults] valueForKey:@"categoryId"];
    // NSInteger category = categoryStr.integerValue;
    NSLog(@"folder id:%@ and categoryid:%@",folderId,category);
    NSString *queryString;
    if([folderId isEqualToNumber:[NSNumber numberWithInt:0]]) {
        // NSInteger category = categoryStr.integerValue;
        NSString *inputJson;
        if([category isEqualToNumber:[NSNumber numberWithInt:-2]]) {
            
            queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] valueForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withQuery:searchString withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"" withActivityTypeID:[NSNumber numberWithInt:2]];
            
            
        } else if([category isEqualToNumber:[NSNumber numberWithInt:-3]]) {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"SavedForLaterIsNew"];
            
            queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withQuery:searchString withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"" withActivityTypeID:[NSNumber numberWithInt:3]];
            
            
        } else {
            
            NSNumber *parentId = [[NSUserDefaults standardUserDefaults]objectForKey:@"parentId"];
            NSLog(@"parent id:%@",parentId);
            
            queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:parentId withPageNumber:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withQuery:searchString withContentCategoryId:category withOrderBy:@"" withFilterBy:@"" withActivityTypeID:[NSNumber numberWithInt:0]];
            
        }
        NSLog(@"input json 111:%@",inputJson);
        NSNumber *contentTypeId = [[NSUserDefaults standardUserDefaults]objectForKey:@"parentId"];
        
        [[FISharedResources sharedResourceManager]getCuratedNewsListWithAccessToken:queryString withCategoryId:category withContentTypeId:contentTypeId withFlag:@"" withLastArticleId:@"" withActivityTypeId:[NSNumber numberWithInt:2]];
        
        
        // }
    } else {
        [[FISharedResources sharedResourceManager]fetchArticleFromFolderWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withFolderId:folderId withPageNo:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withUpFlag:YES];
    }
    [refreshControl endRefreshing];
    //    [self.influencerTableView reloadData];
}

-(void)loadLocalData {
    
    self.articlesTableView.dataSource = self;
    self.articlesTableView.delegate = self;
    NSNumber *categoryId = [[NSUserDefaults standardUserDefaults]objectForKey:@"categoryId"];
    NSNumber *folderId = [[NSUserDefaults standardUserDefaults]objectForKey:@"folderId"];
    NSNumber *contentTypeId = [[NSUserDefaults standardUserDefaults]objectForKey:@"parentId"];
    NSLog(@"load curated news list:%@ and folderid:%@",categoryId,folderId);
    //NSLog(@"category id in curated news:%@",categoryId);
    self.devices = [[NSMutableArray alloc]init];
    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
    NSPredicate *predicate;
    if([folderId isEqualToNumber:[NSNumber numberWithInt:0]]) {
        if([categoryId isEqualToNumber:[NSNumber numberWithInt:-3]]) {
            NSLog(@"if part");
            BOOL savedForLaterIsNew =[[NSUserDefaults standardUserDefaults]boolForKey:@"SavedForLaterIsNew"];
            if(savedForLaterIsNew){
                //                NSLog(@"saved for later new");
                //                if([categoryId isEqualToNumber:[NSNumber numberWithInt:-1]]) {
                //                    predicate  = [NSPredicate predicateWithFormat:@"saveForLater == %@ AND contentTypeId==%@",[NSNumber numberWithBool:YES],contentTypeId];
                //                } else {
                predicate  = [NSPredicate predicateWithFormat:@"contentTypeId == %@ AND categoryId == %@",contentTypeId,categoryId];
                //}
                
            } else {
                NSLog(@"saved for later old");
                predicate  = [NSPredicate predicateWithFormat:@"saveForLater == %@",[NSNumber numberWithBool:YES]];
            }
            // [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"SavedForLaterIsNew"];
            
        } else {
            if([categoryId isEqualToNumber:[NSNumber numberWithInt:-1]]) {
                predicate  = [NSPredicate predicateWithFormat:@"contentTypeId==%@ AND categoryId==%@",contentTypeId,categoryId];
            } else if([categoryId isEqualToNumber:[NSNumber numberWithInt:-2]]) {
                predicate  = [NSPredicate predicateWithFormat:@"categoryId==%@",categoryId];
            } else {
                predicate  = [NSPredicate predicateWithFormat:@"categoryId==%@ AND contentTypeId==%@",categoryId,contentTypeId];
            }
            //}
        }
    } else {
        predicate  = [NSPredicate predicateWithFormat:@"isFolder == %@ AND folderId == %@",[NSNumber numberWithBool:YES],folderId];
    }
    
    
    [fetchRequest setPredicate:predicate];
    
    
    NSSortDescriptor *date = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSLog(@"date:%@",date);
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:date, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    
    NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSLog(@"curated news list count:%lu",(unsigned long)newPerson.count);
    if(newPerson.count != 0) {
        [self addRightBarItems];
        [activityIndicator stopAnimating];
    } else {
        self.navigationItem.rightBarButtonItems = nil;
        
    }
    
    //    if([categoryId isEqualToNumber:[NSNumber numberWithInt:-3]] && newPerson.count == 0) {
    //        [self stopLoading];
    //    }
    //    if(![folderId isEqualToNumber:[NSNumber numberWithInt:0]] && newPerson.count == 0) {
    //        [activityIndicator stopAnimating];
    //    }
    if([categoryId isEqualToNumber:[NSNumber numberWithInt:-3]]) {
        self.devices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        
    }else {
        self.devices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    }
    
    //NSLog(@"devices:%d",self.devices.count);
    _spinner.hidden = YES;
    [_spinner stopAnimating];
    [self.articlesTableView reloadData];
    //   [self.revealController showViewController:self.revealController.leftViewController];
}




-(void)failToLoad {
    self.spinner.hidden = YES;
    [self.spinner stopAnimating];
}


- (void)refreshTable {
    //TODO: refresh your data
    //if(self.devices.count == 0) {
    
    NSNumber *folderId = [[NSUserDefaults standardUserDefaults]objectForKey:@"folderId"];
    NSNumber *category = [[NSUserDefaults standardUserDefaults] valueForKey:@"categoryId"];
    // NSInteger category = categoryStr.integerValue;
    NSLog(@"folder id:%@ and categoryid:%@",folderId,category);
    NSString *queryString;
    if([folderId isEqualToNumber:[NSNumber numberWithInt:0]]) {
        // NSInteger category = categoryStr.integerValue;
        if([category isEqualToNumber:[NSNumber numberWithInt:-2]]) {
            if (isSearching) {
                queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] valueForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withQuery:searchBar.text withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"" withActivityTypeID:[NSNumber numberWithInt:2]];
            } else {
                queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] valueForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withQuery:@"" withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"" withActivityTypeID:[NSNumber numberWithInt:2]];
            }
        } else if([category isEqualToNumber:[NSNumber numberWithInt:-3]]) {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"SavedForLaterIsNew"];
            if (isSearching) {
                queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withQuery:searchBar.text withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"" withActivityTypeID:[NSNumber numberWithInt:3]];
            } else {
                queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withQuery:@"" withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"" withActivityTypeID:[NSNumber numberWithInt:3]];
            }
        } else {
            
            NSNumber *parentId = [[NSUserDefaults standardUserDefaults]objectForKey:@"parentId"];
            NSLog(@"parent id:%@",parentId);
            if (isSearching) {
                queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:parentId withPageNumber:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withQuery:searchBar.text withContentCategoryId:category withOrderBy:@"" withFilterBy:@"" withActivityTypeID:[NSNumber numberWithInt:0]];
            } else {
                queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:parentId withPageNumber:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withQuery:@"" withContentCategoryId:category withOrderBy:@"" withFilterBy:@"" withActivityTypeID:[NSNumber numberWithInt:0]];
            }
            

        }
        NSNumber *contentTypeId = [[NSUserDefaults standardUserDefaults]objectForKey:@"parentId"];
        if (isSearching) {
            [[FISharedResources sharedResourceManager]getCuratedNewsListWithAccessToken:queryString withCategoryId:category withContentTypeId:contentTypeId withFlag:@"" withLastArticleId:@"" withActivityTypeId:[NSNumber numberWithInt:2]];
        } else {
            [[FISharedResources sharedResourceManager]getCuratedNewsListWithAccessToken:queryString withCategoryId:category withContentTypeId:contentTypeId withFlag:@"up" withLastArticleId:@"" withActivityTypeId:[NSNumber numberWithInt:2]];
        }
        

        
        // }
    } else {
        [[FISharedResources sharedResourceManager]fetchArticleFromFolderWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withFolderId:folderId withPageNo:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withUpFlag:YES];
    }
    [refreshControl endRefreshing];
    //    [self.influencerTableView reloadData];
}


-(void)openRSSField {
    if ([MFMailComposeViewController canSendMail]) {
        // Yes we can send mail.
        [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"OpenRSSField"];
        mailComposer = [[MFMailComposeViewController alloc]init];
        mailComposer.mailComposeDelegate = self;
        [mailComposer setSubject:@"FullIntel RSS feed"];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont
                                                                               fontWithName:@"Open Sans" size:18], NSFontAttributeName,
                                    [UIColor whiteColor], NSForegroundColorAttributeName, nil];
        mailComposer.navigationBar.titleTextAttributes = attributes;
        // [mailComposer.navigationBar setTintColor:[UIColor whiteColor]];
        NSString *rssString = [[NSUserDefaults standardUserDefaults]objectForKey:@"RSSURL"];
        if(rssString.length != 0) {
            NSString *mailBodyString = [NSString stringWithFormat:@"%@\n\n%@\n\n%@",@"Hi There,",@"Please use the following URL to receive RSS feed from FullIntel Application.",rssString];
            [mailComposer setMessageBody:mailBodyString isHTML:NO];
        }
        
        [self presentViewController:mailComposer animated:YES completion:nil];
    } else{
        NSString *rssString = [[NSUserDefaults standardUserDefaults]objectForKey:@"RSSURL"];
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        [pb setString:rssString];
        UIWindow *window = [[UIApplication sharedApplication]windows][0];
        [window makeToast:@"A link to the RSS feed is copied to your clipboard" duration:1.5 position:CSToastPositionCenter];
    }
}




#pragma mark - mail compose delegate
-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (result) {
        //NSLog(@"Result : %d",result);
        [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"RSS Mail Send"];
    }
    if (error) {
        //NSLog(@"Error : %@",error);
    }
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)addContentView {
    UIStoryboard *storyBoard;
    UINavigationController *modalController;

    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        storyBoard = [UIStoryboard storyboardWithName:@"AddContent" bundle:nil];
        modalController = [storyBoard instantiateViewControllerWithIdentifier:@"addContentNav"];
    }
    else{
        storyBoard = [UIStoryboard storyboardWithName:@"AddContent" bundle:nil];
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        modalController = [storyBoard instantiateViewControllerWithIdentifier:@"addContentNav"];
        if(orientation == 1) {
            formSheet.presentedFormSheetSize = CGSizeMake(760, 650);
        } else {
            formSheet.presentedFormSheetSize = CGSizeMake(800, 650);
        }
    }
    formSheet = [[MZFormSheetController alloc] initWithViewController:modalController];
    
    
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.shouldDismissOnBackgroundViewTap = YES;
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
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}

- (void)markedImportantUpdate:(id)sender
{
    NSNotification *notification = sender;
    NSDictionary *userInfo = notification.userInfo;
    NSIndexPath *indexPath = [userInfo objectForKey:@"indexPath"];
    NSString *articleId = [userInfo objectForKey:@"articleId"];
    // NSNumber  = [userInfo objectForKey:@"status"];
    NSManagedObject *curatedNews = [self.devices objectAtIndex:indexPath.row];
    [curatedNews setValue:[userInfo objectForKey:@"status"] forKey:@"markAsImportant"];
    
    //    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
    //    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@ ",articleId];
    //    [fetchRequest setPredicate:predicate];
    //    NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    //   // NSLog(@"new person array count:%d",newPerson.count);
    //    if(newPerson.count != 0) {
    //        //NSManagedObject *curatedNews = [newPerson objectAtIndex:0];
    //        for(NSManagedObject *curatedNews in newPerson) {
    //           // NSLog(@"for loop update");
    //            [curatedNews setValue:[userInfo objectForKey:@"status"] forKey:@"markAsImportant"];
    //
    //            if([[FISharedResources sharedResourceManager]serviceIsReachable]) {
    //                // [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"isReadStatusSync"];
    //            } else {
    //                [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"isMarkedImpStatusSync"];
    //            }
    //        }
    //    }
    //    [managedObjectContext save:nil];
    
    [self updateMarkedImportantStatusForRow:indexPath];
    
}

-(void)saveForLaterUpdate:(id)sender {
    NSNotification *notification = sender;
    NSDictionary *userInfo = notification.userInfo;
    NSIndexPath *indexPath = [userInfo objectForKey:@"indexPath"];
    // NSNumber  = [userInfo objectForKey:@"status"];
    NSManagedObject *curatedNews = [self.devices objectAtIndex:indexPath.row];
    [curatedNews setValue:[userInfo objectForKey:@"status"] forKey:@"saveForLater"];
    [self updateSaveForLaterStatusForRow:indexPath];
}

-(void)readStatusUpdate:(id)sender {
    NSNotification *notification = sender;
    NSDictionary *userInfo = notification.userInfo;
    NSIndexPath *indexPath = [userInfo objectForKey:@"indexPath"];
    NSString *articleId = [userInfo objectForKey:@"articleId"];
    // NSLog(@"updated articleid:%@",articleId);
    // NSNumber  = [userInfo objectForKey:@"status"];
    // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void) {
    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@ ",articleId];
    [fetchRequest setPredicate:predicate];
    NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    //NSLog(@"new person array count:%d",newPerson.count);
    if(newPerson.count != 0) {
        //NSManagedObject *curatedNews = [newPerson objectAtIndex:0];
        for(NSManagedObject *curatedNews in newPerson) {
            NSLog(@"for loop update");
            [curatedNews setValue:[userInfo objectForKey:@"status"] forKey:@"readStatus"];
            
            if([[FISharedResources sharedResourceManager]serviceIsReachable]) {
                // [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"isReadStatusSync"];
            } else {
                [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"isReadStatusSync"];
            }
        }
        
        
        
    }
    [managedObjectContext save:nil];
    //    NSManagedObject *curatedNews = [self.devices objectAtIndex:indexPath.row];
    //    [curatedNews setValue:[userInfo objectForKey:@"status"] forKey:@"readStatus"];
    [self updateReadUnReadStatusForRow:indexPath];
    //});
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backBtnPress {
    NSLog(@"back button press");
    if(self.revealController.state == PKRevealControllerShowsLeftViewControllerInPresentationMode) {
         NSLog(@"left view closed");
        NSDictionary *dictionary = @{@"email":[[NSUserDefaults standardUserDefaults]objectForKey:@"customerEmail"]};
        [Localytics tagEvent:@"MenuClosed" attributes:dictionary];
        [self.revealController showViewController:self.revealController.frontViewController];
    } else {
         NSLog(@"left view opened");
        NSDictionary *dictionary = @{@"email":[[NSUserDefaults standardUserDefaults]objectForKey:@"customerEmail"]};
        [Localytics tagEvent:@"MenuOpened" attributes:dictionary];
        [self.revealController showViewController:self.revealController.leftViewController];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // NSLog(@"number of");
    // Return the number of rows in the section.
    NSInteger rowCnt;
    if(self.devices.count != 0) {
        rowCnt = self.devices.count;
    } else {
        rowCnt = 1;
    }
    return rowCnt;
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
    NSManagedObject *curatedNews = [self.devices objectAtIndex:indexPath.row];
    NSNumber *number = [curatedNews valueForKey:@"markAsImportant"];
    NSLog(@"%ld",(long)indexPath.row);
    UITableViewRowAction *moreAction;
        _articlesTableView.editing = nil;
    if([number isEqualToNumber:[NSNumber numberWithInt:1]]) {
        moreAction  =[BGTableViewRowActionWithImage rowActionWithStyle:UITableViewRowActionStyleDefault title:@"    " backgroundColor:[UIColor whiteColor] image:[UIImage imageNamed:@"star_selected_iphone"] forCellHeight:100 handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            [self markedImpActions:indexPath];
            
        }];
    } else {
        moreAction  =[BGTableViewRowActionWithImage rowActionWithStyle:UITableViewRowActionStyleDefault title:@"    " backgroundColor:[UIColor whiteColor] image:[UIImage imageNamed:@"star-iphone"] forCellHeight:100 handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            [self markedImpActions:indexPath];
        }];
    }
    
    UITableViewRowAction *moreAction2;
    if([[curatedNews valueForKey:@"saveForLater"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
        moreAction2 = [BGTableViewRowActionWithImage rowActionWithStyle:UITableViewRowActionStyleDefault title:@"    " backgroundColor:[UIColor whiteColor] image:[UIImage imageNamed:@"saved_selected_iphone"] forCellHeight:100 handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            [self savedActions:indexPath];
        }];
        
    } else {
        moreAction2 = [BGTableViewRowActionWithImage rowActionWithStyle:UITableViewRowActionStyleDefault title:@"    " backgroundColor:[UIColor whiteColor] image:[UIImage imageNamed:@"bookIphone"] forCellHeight:100 handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            [self savedActions:indexPath];
            moreAction2.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"saved_selected_iphone"]];

        }];
        
    }
    
//    UITableViewRowAction *moreAction3 = [BGTableViewRowActionWithImage rowActionWithStyle:UITableViewRowActionStyleDefault title:@"    " backgroundColor:[UIColor whiteColor] image:[UIImage imageNamed:@"folderPhone"] forCellHeight:100 handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
//        [_articlesTableView setEditing:NO];
//        
//    }];
    
    return @[moreAction, moreAction2];
    }
    else{
        return nil;
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // you need to implement this method too or nothing will work:
    
}
- (void)willTransitionToState:(UITableViewCellStateMask)state{
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
    return YES;
    }
    else{
        return NO;
    }
}
-(void)tableView:(UITableView *)tableView swipeAccessoryButtonPushedForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
}

-(void)firstButtonMEthod:(id)sender
{
    
    //    if([[curatedNews valueForKey:@"saveForLater"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
    sender = [BGTableViewRowActionWithImage rowActionWithStyle:UITableViewRowActionStyleDefault title:@"    " backgroundColor:[UIColor whiteColor] image:[UIImage imageNamed:@"bookIphone"] forCellHeight:100 handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        //  [_articlesTableView setEditing:NO];
    }];
}
-(void)savedActions:(NSIndexPath *)tapGesture {
    
    NSInteger selectedTag = tapGesture.row;
    NSManagedObject *curatedNews = [self.devices objectAtIndex:selectedTag];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
    [resultDic setObject:[curatedNews valueForKey:@"articleId"] forKey:@"selectedArticleId"];
    [resultDic setObject:@"3" forKey:@"status"];
    
    
    NSNumber *number = [curatedNews valueForKey:@"saveForLater"];
    // NSLog(@"marked imp read status:%@",number);
    if([[curatedNews valueForKey:@"readStatus"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
        if(number == [NSNumber numberWithInt:1]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMenuCount" object:nil userInfo:@{@"type":@"-3",@"isSelected":[NSNumber numberWithBool:NO]}];
            [curatedNews setValue:[NSNumber numberWithBool:NO] forKey:@"saveForLater"];
        } else {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMenuCount" object:nil userInfo:@{@"type":@"-3",@"isSelected":[NSNumber numberWithBool:YES]}];
            [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"saveForLater"];
        }
    }
    
    
    
    NSManagedObject *curatedNewsDetail = [curatedNews valueForKey:@"details"];
    if([[FISharedResources sharedResourceManager]serviceIsReachable]) {
        if([[curatedNews valueForKey:@"saveForLater"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [resultDic setObject:@"false" forKey:@"isSelected"];
            [curatedNewsDetail setValue:[NSNumber numberWithBool:NO] forKey:@"saveForLater"];
            [curatedNews setValue:[NSNumber numberWithBool:NO] forKey:@"saveForLater"];
            NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
            
            NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
            [[FISharedResources sharedResourceManager]setUserActivitiesOnArticlesWithDetails:resultStr];
            [self.view makeToast:@"Removed from \"Saved for Later\"" duration:1.0 position:CSToastPositionCenter];
            NSDictionary *dictionary = @{@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"], @"userName":[[NSUserDefaults standardUserDefaults]objectForKey:@"firstName"],@"article_Name":[curatedNews valueForKey:@"title"],@"companyName":[[NSUserDefaults standardUserDefaults]objectForKey:@"companyName"]};
            [Localytics tagEvent:@"Remove Save Later" attributes:dictionary];
        }else {
            [resultDic setObject:@"true" forKey:@"isSelected"];
            //NSLog(@"curated news detail:%@",curatedNewsDetail);
            if(curatedNewsDetail == nil) {
                // NSLog(@"details is null");
                NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                [resultDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
                [resultDic setObject:[curatedNews valueForKey:@"articleId"] forKey:@"selectedArticleId"];
                NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
                
                NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
                
                NSMutableDictionary *auhtorResultDic = [[NSMutableDictionary alloc] init];
                [auhtorResultDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
                [auhtorResultDic setObject:[curatedNews valueForKey:@"articleId"] forKey:@"articleId"];
                NSData *authorJsondata = [NSJSONSerialization dataWithJSONObject:auhtorResultDic options:NSJSONWritingPrettyPrinted error:nil];
                
                NSString *authorResultStr = [[NSString alloc]initWithData:authorJsondata encoding:NSUTF8StringEncoding];
                
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
                    //Background Thread
//                    [[FISharedResources sharedResourceManager]getCuratedNewsDetailsWithDetails:resultStr];
//                    [[FISharedResources sharedResourceManager]getCuratedNewsAuthorDetailsWithDetails:authorResultStr withArticleId:[curatedNews valueForKey:@"articleId"]];
                    
                });
                
            }
            
            [curatedNewsDetail setValue:[NSNumber numberWithBool:YES] forKey:@"saveForLater"];
            [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"saveForLater"];
            NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
            
            NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
            [[FISharedResources sharedResourceManager]setUserActivitiesOnArticlesWithDetails:resultStr];
            [self.view makeToast:@"Added to \"Saved for Later\"" duration:1.0 position:CSToastPositionCenter];
            NSDictionary *dictionary = @{@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"], @"userName":[[NSUserDefaults standardUserDefaults]objectForKey:@"firstName"],@"article_Name":[curatedNews valueForKey:@"title"],@"companyName":[[NSUserDefaults standardUserDefaults]objectForKey:@"companyName"]};
            [Localytics tagEvent:@"Save Later" attributes:dictionary];
        }
    } else {
        UIWindow *window = [[UIApplication sharedApplication]windows][0];
        NSArray *subViewArray = [window subviews];
        //NSLog(@"subview array count:%d",subViewArray.count);
        if(subViewArray.count == 1) {
            [[FISharedResources sharedResourceManager] showBannerView];
        }
        //[FIUtils showNoNetworkToast];
    }
    [_articlesTableView reloadData];
}

-(void)markedImpActions:(NSIndexPath *)tapGesture {
    NSInteger selectedTag = tapGesture.row;
    NSManagedObject *curatedNews = [self.devices objectAtIndex:selectedTag];
    
    NSString *markedImpUserId = [[curatedNews valueForKey:@"markAsImportantUserId"] stringValue];
    NSString *markedImpUserName = [curatedNews valueForKey:@"markAsImportantUserName"];
    NSString *loginUserIdString = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]];
    
    //NSLog(@"markedUserId:%@ and markedUserName:%@ and loginUserId:%@ and intvalue:%d",markedImpUserId,markedImpUserName,loginUserIdString,[loginUserIdString intValue]);
    
    //    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    //    f.numberStyle = NSNumberFormatterDecimalStyle;
    //    NSNumber *loginUserId = [f numberFromString:loginUserIdString];
    
    
    
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
    [resultDic setObject:[curatedNews valueForKey:@"articleId"] forKey:@"selectedArticleId"];
    [resultDic setObject:@"2" forKey:@"status"];
    NSNumber *number = [curatedNews valueForKey:@"markAsImportant"];
    // NSLog(@"marked imp read status:%@",number);
    
    NSManagedObject *curatedNewsDetail = [curatedNews valueForKey:@"details"];
    if([[FISharedResources sharedResourceManager]serviceIsReachable]) {
        if([number isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
            if([markedImpUserId isEqualToString:@"-1"]) {
                //Analyst
                [self.view makeToast:@"A FullIntel analyst marked this as important. If you like to change, please request via Feedback" duration:2.0 position:CSToastPositionCenter];
            } else if([markedImpUserId isEqualToString:loginUserIdString]) {
                //LoginUser
                
                [resultDic setObject:@"false" forKey:@"isSelected"];
                [curatedNewsDetail setValue:[NSNumber numberWithBool:NO] forKey:@"markAsImportant"];
                [curatedNews setValue:[NSNumber numberWithBool:NO] forKey:@"markAsImportant"];
                
                
                
                //                NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
                //                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
                //                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@ ",[curatedNews valueForKey:@"articleId"]];
                //                [fetchRequest setPredicate:predicate];
                //                NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
                //                // NSLog(@"new person array count:%d",newPerson.count);
                //                if(newPerson.count != 0) {
                //                    //NSManagedObject *curatedNews = [newPerson objectAtIndex:0];
                //                    for(NSManagedObject *curatedNews in newPerson) {
                //                        // NSLog(@"for loop update");
                //                        [curatedNews setValue:[NSNumber numberWithBool:NO] forKey:@"markAsImportant"];
                //
                //                        if([[FISharedResources sharedResourceManager]serviceIsReachable]) {
                //                            // [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"isReadStatusSync"];
                //                        } else {
                //                            [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"isMarkedImpStatusSync"];
                //                        }
                //                    }
                //                }
                //                [managedObjectContext save:nil];
                if([[curatedNews valueForKey:@"readStatus"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
                    if(number == [NSNumber numberWithInt:1]) {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMenuCount" object:nil userInfo:@{@"type":@"-2",@"isSelected":[NSNumber numberWithBool:NO]}];
                        [curatedNews setValue:[NSNumber numberWithBool:NO] forKey:@"markAsImportant"];
                    } else {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMenuCount" object:nil userInfo:@{@"type":@"-2",@"isSelected":[NSNumber numberWithBool:YES]}];
                        [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"markAsImportant"];
                    }
                }
                
                
                
                NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
                NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
                [[FISharedResources sharedResourceManager]setUserActivitiesOnArticlesWithDetails:resultStr];
                [self.view makeToast:@"Removed from \"Marked Important\"" duration:1.0 position:CSToastPositionCenter];
                NSDictionary *dictionary = @{@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"], @"userName":[[NSUserDefaults standardUserDefaults]objectForKey:@"firstName"],@"article_Name":[curatedNews valueForKey:@"title"],@"companyName":[[NSUserDefaults standardUserDefaults]objectForKey:@"companyName"]};
                [Localytics tagEvent:@"Remove Marked Important" attributes:dictionary];
                
            } else {
                //OtherUser
                NSString *messageStrings = [NSString stringWithFormat:@"If you like to change, please contact %@. who marked this article as important",markedImpUserName];
                [self.view makeToast:messageStrings duration:2.0 position:CSToastPositionCenter];
            }
            
            
        }else {
            [resultDic setObject:@"true" forKey:@"isSelected"];
            [curatedNewsDetail setValue:[NSNumber numberWithBool:YES] forKey:@"markAsImportant"];
            [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"markAsImportant"];
            [curatedNews setValue:[NSNumber numberWithInt:[loginUserIdString intValue]] forKey:@"markAsImportantUserId"];
            
            //            NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
            //            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
            //            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@ ",[curatedNews valueForKey:@"articleId"]];
            //            [fetchRequest setPredicate:predicate];
            //            NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
            //             NSLog(@"marked imp array count:%d",newPerson.count);
            //            if(newPerson.count != 0) {
            //                //NSManagedObject *curatedNews = [newPerson objectAtIndex:0];
            //                for(NSManagedObject *curatedNews in newPerson) {
            //                     NSLog(@"for loop update");
            //                    [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"markAsImportant"];
            //
            //                    if([[FISharedResources sharedResourceManager]serviceIsReachable]) {
            //                        // [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"isReadStatusSync"];
            //                    } else {
            //                        [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"isMarkedImpStatusSync"];
            //                    }
            //                }
            //            }
            //            [managedObjectContext save:nil];
            
            if([[curatedNews valueForKey:@"readStatus"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
                if(number == [NSNumber numberWithInt:1]) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMenuCount" object:nil userInfo:@{@"type":@"-2",@"isSelected":[NSNumber numberWithBool:NO]}];
                    [curatedNews setValue:[NSNumber numberWithBool:NO] forKey:@"markAsImportant"];
                } else {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMenuCount" object:nil userInfo:@{@"type":@"-2",@"isSelected":[NSNumber numberWithBool:YES]}];
                    [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"markAsImportant"];
                }
            }
            
            NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
            NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
            [[FISharedResources sharedResourceManager]setUserActivitiesOnArticlesWithDetails:resultStr];
            [self.view makeToast:@"Marked Important." duration:1.0 position:CSToastPositionCenter];
            NSDictionary *dictionary = @{@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"], @"userName":[[NSUserDefaults standardUserDefaults]objectForKey:@"firstName"],@"article_Name":[curatedNews valueForKey:@"title"],@"companyName":[[NSUserDefaults standardUserDefaults]objectForKey:@"companyName"]};
            [Localytics tagEvent:@"Marked Important" attributes:dictionary];
        }
    } else {
        UIWindow *window = [[UIApplication sharedApplication]windows][0];
        NSArray *subViewArray = [window subviews];
        //NSLog(@"subview array count:%d",subViewArray.count);
        if(subViewArray.count == 1) {
            [[FISharedResources sharedResourceManager] showBannerView];
        }
        //[FIUtils showNoNetworkToast];
    }
    [_articlesTableView reloadData];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *tableCell;
    
    if(self.devices.count != 0) {
       
        //whatever else to configure your one cell you're going to return
        CorporateNewsCell *cell = (CorporateNewsCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if(cell.isEditing == YES) {
            NSLog(@"cell editing yes ------------");
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else {
            NSLog(@"cell editing no ---------");
        }
        // Configure the cell...
        
        NSManagedObject *curatedNews = [self.devices objectAtIndex:indexPath.row];
        
        NSSet *authorSet = [curatedNews valueForKey:@"author"];
        NSMutableArray *authorArray = [[NSMutableArray alloc]initWithArray:[authorSet allObjects]];
        
        NSSet *legendsSet = [curatedNews valueForKey:@"legends"];
        NSMutableArray *legendsArray = [[NSMutableArray alloc]initWithArray:[legendsSet allObjects]];
        //  NSLog(@"curated news legend set:%d",legendsSet.count);
        legendsList = [[NSMutableArray alloc]init];
        for(NSManagedObject *legends in legendsArray) {
            if([[legends valueForKey:@"flag"]isEqualToString:@"yes"]) {
                [legendsList addObject:[legends valueForKey:@"name"]];
            }
        }
        
        // NSLog(@"curated news legends list:%d",legendsList.count);
        NSLog(@"total cnt:%@ and unread cnt:%@",[curatedNews valueForKey:@"totalComments"],[curatedNews valueForKey:@"unreadComments"]);
        NSNumber *totalMsgCount = [curatedNews valueForKey:@"totalComments"];
        NSNumber *totalUnreadCount = [curatedNews valueForKey:@"unreadComments"];
        if([totalMsgCount isEqualToNumber:[NSNumber numberWithInt:0]]) {
            //Handle empty message count
            cell.messageIcon.hidden = YES;
            cell.messageCountText.hidden = YES;
        } else {
            cell.messageIcon.hidden = NO;
            cell.messageCountText.hidden = NO;
            if([totalUnreadCount isEqualToNumber:[NSNumber numberWithInt:0]]) {
                //handle unread message count
                if([totalMsgCount isEqualToNumber:[NSNumber numberWithInt:1]]) {
                    cell.messageCountText.text = [NSString stringWithFormat:@"%@ Comment",totalMsgCount];
                } else {
                    cell.messageCountText.text = [NSString stringWithFormat:@"%@ Comments",totalMsgCount];
                }
                
                cell.messageCountText.textColor = [UIColor blackColor];
                cell.messageIcon.image = [UIImage imageNamed:@"chat_read"];
            } else {
                //handle read message count
                if([totalUnreadCount isEqualToNumber:[NSNumber numberWithInt:1]]) {
                    cell.messageCountText.text = [NSString stringWithFormat:@"%@ Comment",totalUnreadCount];
                } else {
                    cell.messageCountText.text = [NSString stringWithFormat:@"%@ Comments",totalUnreadCount];
                }
                
                cell.messageCountText.textColor = UIColorFromRGB(0XF299A2);
                cell.messageIcon.image = [UIImage imageNamed:@"chat_unread"];
                
            }
        }
        
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        {
            NSLog(@"%f",[[curatedNews valueForKey:@"publishedDate"] doubleValue]);
            
            NSString *dateStr = [FIUtils getDateFromTimeStampTwo:[[curatedNews valueForKey:@"publishedDate"] doubleValue]];
            NSLog(@"%@",dateStr);
            
            NSDateFormatter *frmaer=[[NSDateFormatter alloc]init];
            [frmaer setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            [frmaer setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
            NSDate *dats = [frmaer dateFromString:dateStr];
            NSLog(@"%@",dats);
            NSLog(@"%@",[FIUtils relativeDateStringForDate:dats]);
            
            NSString *finalDateString =[FIUtils relativeDateStringForDate:dats];
            NSLog(@"%@",finalDateString);
            cell.articleDate.text = finalDateString;
            
            //used for hardcoded testing of minutes**********************************************************
            
            NSString *dateStrnn = @"2016-01-27 11:00:00";
            NSDateFormatter *dateFormaeert = [[NSDateFormatter alloc] init];
            [dateFormaeert setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *dateiah = [dateFormaeert dateFromString:dateStrnn];
            NSLog(@"%@",dateiah);
            NSLog(@"%@",[FIUtils relativeDateStringForDate:dateiah]);
            
            //used for hardcoded testing of minutes***********************************************************
            
           
        } else
        {
            NSString *dateStr = [FIUtils getDateFromTimeStamp:[[curatedNews valueForKey:@"publishedDate"] doubleValue]];
            cell.articleDate.text = dateStr;
        }
        
//        NSLog(@"curated news legends list:%d",legendsList.count);
//        NSString *trialDate = [NSString stringWithFormat:@"2015-10-05 02:30:00 +0000"];
//        NSLog(@"%@",trialDate);
//        NSDateFormatter *dateFormattr = [[NSDateFormatter alloc] init];
//        [dateFormattr setDateFormat:@"yyyy-MM-dd hh:ss:mm zzzz"];542195656  204901501724
//        NSDate *formattedDateStrings = [dateFormattr dateFromString:trialDate];
//        NSLog(@"%@",formattedDateStrings);
//        NSString *finalDateStrings = [self relativeDateStringForDate:formattedDateStrings];
//        NSLog(@"%@",finalDateStrings);
//        cell.articleDate.text = dateStr;
        
        [cell.articleImageView sd_setImageWithURL:[NSURL URLWithString:[curatedNews valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"FI"]];
        [cell.articleImageView setContentMode:UIViewContentModeScaleAspectFill];
        cell.articleNumber.text = [curatedNews valueForKey:@"articleId"];
//        if (isSearchingInteger == 1) {
//            articleIdToBePassed =[curatedNews valueForKey:@"articleId"];
//        }
        cell.legendsArray = [[NSMutableArray alloc]initWithArray:legendsList];
        NSMutableArray *multipleAuthorArray = [[NSMutableArray alloc]init];
        if(authorArray.count != 0) {
            if(authorArray.count > 1) {
                for(int i=0;i<2;i++) {
                    NSManagedObject *authorObject = [authorArray objectAtIndex:i];
                    [multipleAuthorArray addObject:[authorObject valueForKey:@"name"]];
                }
                cell.authorName.text = [multipleAuthorArray componentsJoinedByString:@" and "];
            } else {
                NSManagedObject *authorObject = [authorArray objectAtIndex:0];
                cell.authorName.text = [authorObject valueForKey:@"name"];
            }
        }
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
            if(orientation == 0){
                //Default orientation
                //UI is in Default (Portrait) -- this is really a just a failsafe.
            }else if(orientation == UIInterfaceOrientationPortrait) {
                //Do something if the orientation is in Portrait
                NSString *authorName = cell.authorName.text;
                if(authorName.length > 15) {
                    cell.authorName.text = [NSString stringWithFormat:@"%@...",[authorName substringToIndex:15]];
                    cell.messageIcon.hidden = YES;
                    cell.messageCountText.hidden = YES;
                }
                else if (authorName.length == 0){
                    cell.iconForAuthor.hidden = YES;

                }
                else {
                    cell.messageIcon.hidden = NO;
                    cell.messageCountText.hidden = NO;
                }
            }
                  }
        
        // NSLog(@"multiple author array:%@",multipleAuthorArray);
        // cell.authorTitle.text = [author valueForKey:@"title"];
        // [cell.authorImageView sd_setImageWithURL:[NSURL URLWithString:[author valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"FI"]];
        
        cell.title.text = [curatedNews valueForKey:@"title"];
        NSRange r;
        NSString *s = [curatedNews valueForKey:@"desc"];
        while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
            s = [s stringByReplacingCharactersInRange:r withString:@""];
        s= [s stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
        
        UIFont *font = [UIFont fontWithName:@"OpenSans" size:14];
        UIColor *textColor = [UIColor colorWithRed:(102/255.0) green:(110/255.0) blue:(115/255.0) alpha:1];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        style.lineSpacing = 2;
        cell.descTextView.attributedText = [[NSAttributedString alloc]initWithString:s attributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:font,NSForegroundColorAttributeName:textColor}];
        CGFloat width =  [[curatedNews valueForKey:@"outlet"] sizeWithFont:[UIFont fontWithName:@"OpenSans" size:15 ]].width;
        if(width == 0) {
            cell.outletWidthConstraint.constant = 0;
            cell.outletImageWidthConstraint.constant = 0;
            cell.outletHorizontalConstraint.constant = 8;
        }
        else if(width < 126) {
            
            CGFloat value = width-8;
            cell.outletWidthConstraint.constant = value;
            cell.outletImageWidthConstraint.constant = 12;
            cell.outletHorizontalConstraint.constant = value+12+25;
        }else {
            
            CGFloat value = width-21;
            cell.outletWidthConstraint.constant = value;
            cell.outletImageWidthConstraint.constant = 12;
            cell.outletHorizontalConstraint.constant = value+12+25;
        }
        cell.outlet.text = [curatedNews valueForKey:@"outlet"];
        CGSize maximumLabelSize = CGSizeMake(600, FLT_MAX);
        CGSize expectedLabelSize = [[curatedNews valueForKey:@"title"] sizeWithFont:cell.title.font constrainedToSize:maximumLabelSize lineBreakMode:cell.title.lineBreakMode];
        //NSLog(@"text %@ and text height:%f",[curatedNews valueForKey:@"title"],expectedLabelSize.height);
        
        
        cell.titleHeightConstraint.constant = expectedLabelSize.height;
        NSNumber *number = [curatedNews valueForKey:@"markAsImportant"];
        //NSLog(@"marked important staus:%@",number);
        if(number == [NSNumber numberWithInt:1]) {
            
            [cell.markedImpButton setSelected:YES];
        } else {
            [cell.markedImpButton setSelected:NO];
        }
        
        
        if([[curatedNews valueForKey:@"saveForLater"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [cell.savedForLaterButton setSelected:YES];
        } else {
            [cell.savedForLaterButton setSelected:NO];
        }
        
        if([[curatedNews valueForKey:@"readStatus"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            cell.readStatusImageView.hidden = NO;
            cell.articleImageView.alpha = 0.5;
            cell.contentView.alpha = 1;
        } else {
            cell.readStatusImageView.hidden = YES;
            cell.articleImageView.alpha = 1;
            cell.contentView.alpha = 1;
        }
        
        //[self updateReadUnReadStatusForRow:indexPath];
        //[self updateMarkedImportantStatusForRow:indexPath];
        // [self updateSaveForLaterStatusForRow:indexPath];
        
        
        UITapGestureRecognizer *markedImpTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(markedImpAction:)];
        cell.markedImpButton.tag = indexPath.row;
        [cell.markedImpButton addGestureRecognizer:markedImpTap];
        
        UITapGestureRecognizer *savedLaterTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(savedAction:)];
        cell.savedForLaterButton.tag = indexPath.row;
        [cell.savedForLaterButton addGestureRecognizer:savedLaterTap];
        
        UITapGestureRecognizer *checkMarkTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkMark:)];
        cell.checkMarkButton.tag = indexPath.row;
        [cell.checkMarkButton addGestureRecognizer:checkMarkTap];
        
        
        
        BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"SaveForLaterTutorialShown"];
        if (coachMarksShown == YES) {
            
            if(indexPath.row==1){
                
                popAnimationTimer=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(performAnimationForMarkImportant:) userInfo:cell repeats:YES];
                
                cell.bookmarkView.layer.borderColor=[UIColorFromRGB(0XA4131E) CGColor];
                cell.bookmarkView.layer.borderWidth=1.0f;
                
            }else{
                
                cell.bookmarkView.layer.borderWidth=0.0f;
            }
            
        }else{
            
            cell.bookmarkView.layer.borderWidth=0.0f;
        }
        
        tableCell = cell;
    } else {
        
        
        
        tableCell = [[UITableViewCell alloc] init];
        tableCell.textLabel.text = messageString;
        tableCell.textLabel.textAlignment = NSTextAlignmentCenter;
        tableCell.textLabel.font = [UIFont fontWithName:@"OpenSans" size:28];
        tableCell.textLabel.textColor = [UIColor lightGrayColor];
    }

   // tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return tableCell;
}
//- (NSString *)relativeDateStringForDate:(NSDate *)date
//{
//    NSCalendarUnit units = NSCalendarUnitDay | NSCalendarUnitWeekOfYear |
//    NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
//    
//    // if `date` is before "now" (i.e. in the past) then the components will be positive
//    NSDateComponents *components = [[NSCalendar currentCalendar] components:units
//                                                                   fromDate:date
//                                                                     toDate:[NSDate date]
//                                                                    options:0];
//    if (components.year > 0) {
//        return [NSString stringWithFormat:@"%ldy ago", (long)components.year];
//    }
////    else if (components.month > 0) {
////        return [NSString stringWithFormat:@"%ldm ago", (long)components.month];
////    }
//    else if (components.weekOfYear > 0) {
//        return [NSString stringWithFormat:@"%ldw ago", (long)components.weekOfYear];
//    } else if (components.day > 0) {
//        if (components.day > 1) {
//            return [NSString stringWithFormat:@"%ldd ago", (long)components.day];
//        } else {
//            return @"1d ago";
//        }
//    }else if (components.hour > 0) {
//        return [NSString stringWithFormat:@"%ldh ago", (long)components.hour];
//    }else if (components.minute > 0) {
//        return [NSString stringWithFormat:@"%ldm ago", (long)components.minute];
//    }else if (components.second > 0) {
//        return [NSString stringWithFormat:@"%lds ago", (long)components.second];
//    }   else {
//        return @"Today";
//    }
//}
-(void)performAnimationForMarkImportant:(NSTimer *)timer{
    
    CorporateNewsCell *cell=timer.userInfo;
    
    [self performAnimationForFirstItemInTreeView:cell];
    
    
}

-(void)performAnimationForFirstItemInTreeView:(CorporateNewsCell *)cell{
    
    
    [cell.bookmarkView.layer removeAllAnimations];
    [cell.savedForLaterButton.layer removeAllAnimations];
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue=[NSValue valueWithCGSize:CGSizeMake(0.5, 0.5)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1,1)];
    scaleAnimation.springBounciness = 10;
    scaleAnimation.springSpeed=10;
    [cell.bookmarkView.layer  pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
    [cell.savedForLaterButton.layer  pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
}
-(void)updateReadUnReadStatusForRow:(NSIndexPath *)indexPath {
    NSManagedObject *curatedNews = [self.devices objectAtIndex:indexPath.row];
    NSNumber *number = [curatedNews valueForKey:@"readStatus"];
    CorporateNewsCell *cell = (CorporateNewsCell *)[self.articlesTableView cellForRowAtIndexPath:indexPath];
    // BOOL isRead = [NSNumber numberWithBool:[curatedNews valueForKey:@"readStatus"]];
    if(number == [NSNumber numberWithInt:1]) {
        // cell.title.alpha = 0.7f;
        cell.readStatusImageView.hidden = NO;
        cell.contentView.alpha = 1.0;
    } else {
        // cell.title.alpha = 1.0f;
        cell.readStatusImageView.hidden = YES;
        cell.contentView.alpha = 1.0;
    }
}

-(void)updateMarkedImportantStatusForRow:(NSIndexPath *)indexPath {
    
    NSManagedObject *curatedNews = [self.devices objectAtIndex:indexPath.row];
    CorporateNewsCell *cell = (CorporateNewsCell *)[self.articlesTableView cellForRowAtIndexPath:indexPath];
    NSNumber *number = [curatedNews valueForKey:@"markAsImportant"];
    if(number == [NSNumber numberWithInt:1]) {
        
        [cell.markedImpButton setSelected:YES];
    } else {
        [cell.markedImpButton setSelected:NO];
        
    }
}

-(void)updateSaveForLaterStatusForRow:(NSIndexPath *)indexPath {
    NSManagedObject *curatedNews = [self.devices objectAtIndex:indexPath.row];
    CorporateNewsCell *cell = (CorporateNewsCell *)[self.articlesTableView cellForRowAtIndexPath:indexPath];
    NSNumber *number = [curatedNews valueForKey:@"saveForLater"];
    if(number == [NSNumber numberWithInt:1]) {
        [cell.savedForLaterButton setSelected:YES];
    } else {
        [cell.savedForLaterButton setSelected:NO];
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 0)];
    //if (section == integerRepresentingYourSectionOfInterest)
    [headerView setBackgroundColor:[UIColor blueColor]];
    // else
    // [headerView setBackgroundColor:[UIColor clearColor]];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self searchBarCancelButtonClicked:searchBar];
    //    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    //    self.revealController.revealPanGestureRecognizer.delegate = nil;
    //    NSManagedObject *influencer = [self.devices objectAtIndex:indexPath.row];
    //    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];
    //    CorporateNewsDetailsView *detailView = [storyBoard instantiateViewControllerWithIdentifier:@"DetailView"];
    //    detailView.curatedNews = influencer;
    //    detailView.selectedIndexPath = indexPath;
    //    detailView.legendsArray = legendsList;
    //    [self.navigationController pushViewController:detailView animated:YES];    
    if(self.devices.count != 0) {
        
        //UpgradeView
        UIStoryboard *storyBoard;
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        {
            storyBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListViewPhone" bundle:nil];
            
        } else {
            storyBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];
            
        }
        NSString *userAccountTypeId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"d"]];
        CorporateNewsDetailsView *testView;
        //        if([userAccountTypeId isEqualToString:@"3"]) {
        //            testView = [storyBoard instantiateViewControllerWithIdentifier:@"NormalView"];
        //        }else if([userAccountTypeId isEqualToString:@"2"] || [userAccountTypeId isEqualToString:@"1"]) {
        NSLog(@"%@",_titleName);
        NSLog(@"%ld",(long)indexPath.row);
        NSLog(@"%@",indexPath);
        NSLog(@"%d",isSearchingInteger);
        NSLog(@"%@",articleIdToBePassed);

        testView = [storyBoard instantiateViewControllerWithIdentifier:@"UpgradeView"];
        // } =
        testView.articleTitle = _titleName;
        testView.currentIndex = indexPath.row;
        testView.selectedIndexPath = indexPath;
        testView.isSearching = isSearchingInteger;
        testView.articleIdFromSearchLst =articleIdToBePassed;
        [self.navigationController pushViewController:testView animated:YES];
    }
}

-(void)checkMark:(UITapGestureRecognizer *)tapGesture {
    UIButton *checkMarkBtn = (UIButton *)[tapGesture view];
    if(checkMarkBtn.selected) {
        [checkMarkBtn setSelected:NO];
    }else {
        [checkMarkBtn setSelected:YES];
    }
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//
//    [self closeMenu];
//}
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
//
//    [self closeMenu];
//}

- (void)scrollViewDidScroll: (UIScrollView*)scroll {


    // UITableView only moves in one direction, y axis
    CGFloat currentOffset = scroll.contentOffset.y;
    CGFloat maximumOffset = scroll.contentSize.height - scroll.frame.size.height;
    
    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= 10.0) {
        //NSLog(@"tableview reach the limt");
        // [self methodThatAddsDataAndReloadsTableView];
    }
    
}

-(void)markedImpAction:(UITapGestureRecognizer *)tapGesture {
    NSInteger selectedTag = [tapGesture view].tag;
    NSManagedObject *curatedNews = [self.devices objectAtIndex:selectedTag];
    
    NSString *markedImpUserId = [[curatedNews valueForKey:@"markAsImportantUserId"] stringValue];
    NSString *markedImpUserName = [curatedNews valueForKey:@"markAsImportantUserName"];
    NSString *loginUserIdString = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]];
    
    // NSLog(@"markedUserId:%@ and markedUserName:%@ and loginUserId:%@ and intvalue:%d",markedImpUserId,markedImpUserName,loginUserIdString,[loginUserIdString intValue]);
    //    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    //    f.numberStyle = NSNumberFormatterDecimalStyle;
    //    NSNumber *loginUserId = [f numberFromString:loginUserIdString];
    
    
    
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
    [resultDic setObject:[curatedNews valueForKey:@"articleId"] forKey:@"selectedArticleId"];
    [resultDic setObject:@"2" forKey:@"status"];
    NSNumber *number = [curatedNews valueForKey:@"markAsImportant"];
    // NSLog(@"marked imp read status:%@",number);
    
    NSManagedObject *curatedNewsDetail = [curatedNews valueForKey:@"details"];
    if([[FISharedResources sharedResourceManager]serviceIsReachable]) {
        UIButton *markedImpBtn = (UIButton *)[tapGesture view];
        if(markedImpBtn.selected) {
            
            if([markedImpUserId isEqualToString:@"-1"]) {
                //Analyst
                [self.view makeToast:@"A FullIntel analyst marked this as important. If you like to change, please request via Feedback" duration:2.0 position:CSToastPositionCenter];
            } else if([markedImpUserId isEqualToString:loginUserIdString]) {
                //LoginUser
                
                [markedImpBtn setSelected:NO];
                [resultDic setObject:@"false" forKey:@"isSelected"];
                [curatedNewsDetail setValue:[NSNumber numberWithBool:NO] forKey:@"markAsImportant"];
                [curatedNews setValue:[NSNumber numberWithBool:NO] forKey:@"markAsImportant"];
              
                //                NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
                //                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
                //                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@ ",[curatedNews valueForKey:@"articleId"]];
                //                [fetchRequest setPredicate:predicate];
                //                NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
                //                // NSLog(@"new person array count:%d",newPerson.count);
                //                if(newPerson.count != 0) {
                //                    //NSManagedObject *curatedNews = [newPerson objectAtIndex:0];
                //                    for(NSManagedObject *curatedNews in newPerson) {
                //                        // NSLog(@"for loop update");
                //                        [curatedNews setValue:[NSNumber numberWithBool:NO] forKey:@"markAsImportant"];
                //
                //                        if([[FISharedResources sharedResourceManager]serviceIsReachable]) {
                //                            // [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"isReadStatusSync"];
                //                        } else {
                //                            [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"isMarkedImpStatusSync"];
                //                        }
                //                    }
                //                }
                //                [managedObjectContext save:nil];
                if([[curatedNews valueForKey:@"readStatus"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
                    if(number == [NSNumber numberWithInt:1]) {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMenuCount" object:nil userInfo:@{@"type":@"-2",@"isSelected":[NSNumber numberWithBool:NO]}];
                        [curatedNews setValue:[NSNumber numberWithBool:NO] forKey:@"markAsImportant"];
                    } else {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMenuCount" object:nil userInfo:@{@"type":@"-2",@"isSelected":[NSNumber numberWithBool:YES]}];
                        [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"markAsImportant"];
                    }
                }
                
                
                
                NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
                NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
                [[FISharedResources sharedResourceManager]setUserActivitiesOnArticlesWithDetails:resultStr];
                [self.view makeToast:@"Removed from \"Marked Important\"" duration:1.0 position:CSToastPositionCenter];
                NSDictionary *dictionary = @{@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"], @"userName":[[NSUserDefaults standardUserDefaults]objectForKey:@"firstName"],@"article_Name":[curatedNews valueForKey:@"title"],@"companyName":[[NSUserDefaults standardUserDefaults]objectForKey:@"companyName"]};
                [Localytics tagEvent:@"Remove Marked Important" attributes:dictionary];
                
            } else {
                //OtherUser
                NSString *messageStrings = [NSString stringWithFormat:@"If you like to change, please contact %@. who marked this article as important",markedImpUserName];
                [self.view makeToast:messageStrings duration:2.0 position:CSToastPositionCenter];
            }
            
            
        }else {
            [markedImpBtn setSelected:YES];
            [resultDic setObject:@"true" forKey:@"isSelected"];
            [curatedNewsDetail setValue:[NSNumber numberWithBool:YES] forKey:@"markAsImportant"];
            [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"markAsImportant"];
            [curatedNews setValue:[NSNumber numberWithInt:[loginUserIdString intValue]] forKey:@"markAsImportantUserId"];
            //            NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
            //            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
            //            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@ ",[curatedNews valueForKey:@"articleId"]];
            //            [fetchRequest setPredicate:predicate];
            //            NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
            //             NSLog(@"marked imp array count:%d",newPerson.count);
            //            if(newPerson.count != 0) {
            //                //NSManagedObject *curatedNews = [newPerson objectAtIndex:0];
            //                for(NSManagedObject *curatedNews in newPerson) {
            //                     NSLog(@"for loop update");
            //                    [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"markAsImportant"];
            //
            //                    if([[FISharedResources sharedResourceManager]serviceIsReachable]) {
            //                        // [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"isReadStatusSync"];
            //                    } else {
            //                        [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"isMarkedImpStatusSync"];
            //                    }
            //                }
            //            }
            //            [managedObjectContext save:nil];
            
            if([[curatedNews valueForKey:@"readStatus"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
                if(number == [NSNumber numberWithInt:1]) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMenuCount" object:nil userInfo:@{@"type":@"-2",@"isSelected":[NSNumber numberWithBool:NO]}];
                    [curatedNews setValue:[NSNumber numberWithBool:NO] forKey:@"markAsImportant"];
                } else {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMenuCount" object:nil userInfo:@{@"type":@"-2",@"isSelected":[NSNumber numberWithBool:YES]}];
                    [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"markAsImportant"];
                }
            }
            
            NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
            NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
            [[FISharedResources sharedResourceManager]setUserActivitiesOnArticlesWithDetails:resultStr];
            [self.view makeToast:@"Marked Important." duration:1.0 position:CSToastPositionCenter];
            NSDictionary *dictionary = @{@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"], @"userName":[[NSUserDefaults standardUserDefaults]objectForKey:@"firstName"],@"article_Name":[curatedNews valueForKey:@"title"],@"companyName":[[NSUserDefaults standardUserDefaults]objectForKey:@"companyName"]};
            [Localytics tagEvent:@"Marked Important" attributes:dictionary];
        }
    } else {
        UIWindow *window = [[UIApplication sharedApplication]windows][0];
        NSArray *subViewArray = [window subviews];
        //NSLog(@"subview array count:%d",subViewArray.count);
        if(subViewArray.count == 1) {
            [[FISharedResources sharedResourceManager] showBannerView];
        }
    }
    
    
}

-(void)savedAction:(UITapGestureRecognizer *)tapGesture {
    
    NSInteger selectedTag = [tapGesture view].tag;
    NSManagedObject *curatedNews = [self.devices objectAtIndex:selectedTag];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
    [resultDic setObject:[curatedNews valueForKey:@"articleId"] forKey:@"selectedArticleId"];
    [resultDic setObject:@"3" forKey:@"status"];
    
    
    NSNumber *number = [curatedNews valueForKey:@"saveForLater"];
    // NSLog(@"marked imp read status:%@",number);
    if([[curatedNews valueForKey:@"readStatus"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
        if(number == [NSNumber numberWithInt:1]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMenuCount" object:nil userInfo:@{@"type":@"-3",@"isSelected":[NSNumber numberWithBool:NO]}];
            [curatedNews setValue:[NSNumber numberWithBool:NO] forKey:@"saveForLater"];
        } else {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMenuCount" object:nil userInfo:@{@"type":@"-3",@"isSelected":[NSNumber numberWithBool:YES]}];
            [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"saveForLater"];
        }
    }
    
    
    
    NSManagedObject *curatedNewsDetail = [curatedNews valueForKey:@"details"];
    if([[FISharedResources sharedResourceManager]serviceIsReachable]) {
        UIButton *savedBtn = (UIButton *)[tapGesture view];
        if(savedBtn.selected) {
            [savedBtn setSelected:NO];
            [resultDic setObject:@"false" forKey:@"isSelected"];
            [curatedNewsDetail setValue:[NSNumber numberWithBool:NO] forKey:@"saveForLater"];
            [curatedNews setValue:[NSNumber numberWithBool:NO] forKey:@"saveForLater"];
            NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
            
            NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
            [[FISharedResources sharedResourceManager]setUserActivitiesOnArticlesWithDetails:resultStr];
            [self.view makeToast:@"Removed from \"Saved for Later\"" duration:1.0 position:CSToastPositionCenter];
            NSDictionary *dictionary = @{@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"], @"userName":[[NSUserDefaults standardUserDefaults]objectForKey:@"firstName"],@"article_Name":[curatedNews valueForKey:@"title"],@"companyName":[[NSUserDefaults standardUserDefaults]objectForKey:@"companyName"]};
            [Localytics tagEvent:@"Remove Save Later" attributes:dictionary];
        }else {
            [savedBtn setSelected:YES];
            [resultDic setObject:@"true" forKey:@"isSelected"];
            //NSLog(@"curated news detail:%@",curatedNewsDetail);
            if(curatedNewsDetail == nil) {
                // NSLog(@"details is null");
                NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                [resultDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
                [resultDic setObject:[curatedNews valueForKey:@"articleId"] forKey:@"selectedArticleId"];
                NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
                
                NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
                
                NSMutableDictionary *auhtorResultDic = [[NSMutableDictionary alloc] init];
                [auhtorResultDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
                [auhtorResultDic setObject:[curatedNews valueForKey:@"articleId"] forKey:@"articleId"];
                NSData *authorJsondata = [NSJSONSerialization dataWithJSONObject:auhtorResultDic options:NSJSONWritingPrettyPrinted error:nil];
                
                NSString *authorResultStr = [[NSString alloc]initWithData:authorJsondata encoding:NSUTF8StringEncoding];
                
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
                    //Background Thread
//                    [[FISharedResources sharedResourceManager]getCuratedNewsDetailsWithDetails:resultStr];
//                    [[FISharedResources sharedResourceManager]getCuratedNewsAuthorDetailsWithDetails:authorResultStr withArticleId:[curatedNews valueForKey:@"articleId"]];
                    
                });
                
            }
            
            [curatedNewsDetail setValue:[NSNumber numberWithBool:YES] forKey:@"saveForLater"];
            [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"saveForLater"];
            NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
            
            NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
            [[FISharedResources sharedResourceManager]setUserActivitiesOnArticlesWithDetails:resultStr];
            [self.view makeToast:@"Added to \"Saved for Later\"" duration:1.0 position:CSToastPositionCenter];
            NSDictionary *dictionary = @{@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"], @"userName":[[NSUserDefaults standardUserDefaults]objectForKey:@"firstName"],@"article_Name":[curatedNews valueForKey:@"title"],@"companyName":[[NSUserDefaults standardUserDefaults]objectForKey:@"companyName"]};
            [Localytics tagEvent:@"Save Later" attributes:dictionary];
        }
    } else {
        UIWindow *window = [[UIApplication sharedApplication]windows][0];
        NSArray *subViewArray = [window subviews];
        //NSLog(@"subview array count:%d",subViewArray.count);
        if(subViewArray.count == 1) {
            [[FISharedResources sharedResourceManager] showBannerView];
        }
        //[FIUtils showNoNetworkToast];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;      // called when scroll view grinds to a halt
{

}
- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView
                  willDecelerate:(BOOL)decelerate{
//        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
//            self.revealController.revealPanGestureRecognizer.delegate = self;
    //NSLog(@"tableview scroll dragging");
    if(self.devices.count != 0){
        //NSLog(@"stepppp");
        CGPoint offset = self.articlesTableView.contentOffset;
        CGRect bounds = self.articlesTableView.bounds;
        CGSize size = self.articlesTableView.contentSize;
        UIEdgeInsets inset = self.articlesTableView.contentInset;
        
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        
        float reload_distance = 50;
        if(y > h + reload_distance) {
            // NSLog(@"load more data");
            
            _spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            _spinner.frame=CGRectMake(0, 0, 310, 44);

//            if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
//            {
//                CGFloat offx = _spinner.bounds.origin.x;
//                _spinner.frame=CGRectMake(offx-25, 0, 310, 44);
//
//            }
//            else{
//                
//            }
            
            [_spinner startAnimating];
            
            _spinner.hidden=NO;
            
            self.articlesTableView.tableFooterView = _spinner;
            
            NSManagedObject *curatedNews = [self.devices lastObject];
            NSString *inputJson;
            NSNumber *folderId = [[NSUserDefaults standardUserDefaults]objectForKey:@"folderId"];
            NSNumber *category = [[NSUserDefaults standardUserDefaults] valueForKey:@"categoryId"];
            // NSInteger category = categoryStr.integerValue;
            
            //newcomers
            
            NSNumber *parentId = [[NSUserDefaults standardUserDefaults]objectForKey:@"parentId"];
            NSLog(@"parent id:%@",parentId);
            NSManagedObjectContext *context = [[FISharedResources sharedResourceManager] managedObjectContext];
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
            NSPredicate *predicate;
            predicate = [NSPredicate predicateWithFormat:@"contentTypeId == %@ AND categoryId == %@",parentId,category];
            [fetchRequest setPredicate:predicate];
            NSArray *existingArray = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
            NSLog(@"Existing Array count ---->%lu",(unsigned long)existingArray.count);
            NSInteger mod = existingArray.count%10;
            NSLog(@"Existing mod ---->%ld",(long)mod);
            NSInteger pageNo;
            if (mod == 0) {
                 pageNo  = existingArray.count/10;

            } else {
                int defaultValue = 10 - mod;
                NSLog(@"defaultValue --->%d",defaultValue);

                pageNo  = (existingArray.count+defaultValue)/10;

            }
            NSLog(@"PageNo --->%ld",(long)pageNo);
            NSLog(@"folderId --->%@",folderId);

            
            if([folderId isEqualToNumber:[NSNumber numberWithInt:0]]) {
                if([category isEqualToNumber:[NSNumber numberWithInt:-2]]) {
                    NSString *queryString;
                    if (isSearching) {
                        queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withQuery:searchBar.text withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"" withActivityTypeID:[NSNumber numberWithInt:2]];
                    } else {
                         queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withQuery:@"" withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"" withActivityTypeID:[NSNumber numberWithInt:2]];
                    }
                    [[FISharedResources sharedResourceManager]getCuratedNewsListWithAccessToken:queryString withCategoryId:category withContentTypeId:parentId withFlag:@"" withLastArticleId:[curatedNews valueForKey:@"articleId"] withActivityTypeId:[NSNumber numberWithInt:2]];
                    
                } else if([category isEqualToNumber:[NSNumber numberWithInt:-3]]) {
                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"SavedForLaterIsNew"];
                    NSString *queryString;
                    if (isSearching) {
                         queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withQuery:searchBar.text withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"" withActivityTypeID:[NSNumber numberWithInt:3]];
                    } else {
                        queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withQuery:@"" withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"" withActivityTypeID:[NSNumber numberWithInt:3]];
                    }
                    
                    [[FISharedResources sharedResourceManager]getCuratedNewsListWithAccessToken:queryString withCategoryId:category withContentTypeId:parentId withFlag:@"" withLastArticleId:[curatedNews valueForKey:@"articleId"] withActivityTypeId:[NSNumber numberWithInt:3]];
                    
                } else {
                    NSString *queryString;
                   if (isSearching) {
                       queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:parentId withPageNumber:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withQuery:searchBar.text withContentCategoryId:category withOrderBy:@"" withFilterBy:@"" withActivityTypeID:[NSNumber numberWithInt:0]];
                   } else {
                        queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:parentId withPageNumber:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withQuery:@"" withContentCategoryId:category withOrderBy:@"" withFilterBy:@"" withActivityTypeID:[NSNumber numberWithInt:0]];
                   }
                    
                    [[FISharedResources sharedResourceManager]getCuratedNewsListWithAccessToken:queryString withCategoryId:category withContentTypeId:parentId withFlag:@"" withLastArticleId:[curatedNews valueForKey:@"articleId"] withActivityTypeId:[NSNumber numberWithInt:0]];
                    
                }
//                [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"FetchNextArticlesList"];
//                NSNumber *contentTypeId = [[NSUserDefaults standardUserDefaults]objectForKey:@"parentId"];
//                NSString *companyName = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"companyName"]];
//                NSString *queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:contentTypeId withPageNumber:[NSNumber numberWithInt:2] withSize:[NSNumber numberWithInt:10] withQuery:companyName withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"" withActivityTypeID:[NSNumber numberWithInt:0]];
                
            } else {
                [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"FetchNextArticlesList"];
                [[FISharedResources sharedResourceManager]fetchArticleFromFolderWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withFolderId:folderId withPageNo:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withUpFlag:NO];
            }
        }
        //[self reloadData];
    }
}


-(void)requestChange:(id)sender {
    
    
    UIStoryboard *centerStoryBoard = [UIStoryboard storyboardWithName:@"ResearchRequest" bundle:nil];
    UINavigationController *popOverView =[centerStoryBoard instantiateViewControllerWithIdentifier:@"requestNav"];
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        
    }
    else{
        
    }
    ResearchRequestPopoverView *researchViewController=(ResearchRequestPopoverView *)[[popOverView viewControllers]objectAtIndex:0];
    // ResearchRequestPopoverView *popOverView = [[ResearchRequestPopoverView alloc]initWithNibName:@"ResearchRequestPopoverView" bundle:nil];
    //   popOverView.transitioningDelegate = self;
    researchViewController.fromAddContent = YES;
    popOverView.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:popOverView animated:NO completion:nil];
}

@end
