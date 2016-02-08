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
#import "SavedListPopoverView.h"
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
    NSLog(@"view did load title:%@",self.titleName);
    
    [super viewDidLoad];

    //toolbar additions---------------------------------------------------
    CGRect frame, remain;
    CGRectDivide(self.view.bounds, &frame, &remain, 44, CGRectMaxYEdge);
    toolbar = [[UIToolbar alloc] initWithFrame:frame];
    markAsReadButton = [[UIBarButtonItem alloc] initWithTitle:@"Mark as read" style:UIBarButtonItemStyleDone target:self action:@selector(markAsRead) ];
    [markAsReadButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]
                                    forState:UIControlStateNormal];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    addTofolder=[[UIBarButtonItem alloc]initWithTitle:@"Add to folder" style:UIBarButtonItemStyleDone target:self action:@selector(addTOFolder)];
    [addTofolder setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]
                               forState:UIControlStateNormal];
    
    [toolbar setItems:[[NSArray alloc] initWithObjects:markAsReadButton,spacer,addTofolder,nil]];
    
    NSString *headerColor = [[NSUserDefaults standardUserDefaults]objectForKey:@"headerColor"];
    NSString *stringWithoutSpaces = [headerColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
    [toolbar setBarTintColor:[FIUtils colorWithHexString:stringWithoutSpaces]];
    [toolbar setBarTintColor: [UIColor colorWithRed:97/255.0 green:98/255.0 blue:100/255.0 alpha:1.0]];
    toolbar.tintColor = [UIColor whiteColor];
    toolbar.barStyle = UIBarStyleBlack;
    [toolbar setBackgroundColor:[FIUtils colorWithHexString:stringWithoutSpaces]];
    [toolbar setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    [self.view addSubview:toolbar];
    toolbar.hidden = YES;
    
    
    
    
    //toolbar additions---------------------------------------------------

    
    
    
    isSearchingInteger = 0;
    switchForFilter = 0;
    [self addButtonsOnNavigationBar];
    self.articlesTableView.allowsMultipleSelection = YES;

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
    
    //Receive AddToFolder and MarkAsRead Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyForAddToFolder) name:@"notifyForAddToFolder" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyForMarkAsRead) name:@"notifyForMarkAsRead" object:nil];
    
    
    // NSLog(@"list did load");notifyForLast24
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyForUnread) name:@"notifyForUnreadMenu" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyForLast) name:@"notifyForLast24" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyForAll) name:@"notifyForAll" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAlpha) name:@"changeAlphaVal" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCuratedNews) name:@"CuratedNews" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failToLoad) name:@"CuratedNewsFail" object:nil];
    self.isNewsLetterNav = NO;
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
    UILongPressGestureRecognizer *markedImpTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    [self.articlesTableView addGestureRecognizer:markedImpTap];
    
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.revealController.revealPanGestureRecognizer.delegate = self;
        self.revealController.panDelegate = self;
    } else {
        
    }

    //Set Default segment selection as "None"
    [self.segmentControl setSelectedSegmentIndex:2];
}

- (void)handlePanGestureStart {
    self.articlesTableView.scrollEnabled = NO;
    
}

-(void)handleVeriticalPan {
    self.articlesTableView.scrollEnabled = YES;
}
-(void)handlePanGestureEnd {
    self.articlesTableView.scrollEnabled = YES;
}


-(void)changeAlpha{
    self.view.alpha = 1;
}

-(void)notifyForUnread{
        _spinner.hidden=NO;
        switchForFilter = 1;
        [self callSearchAPIWithStringForUnread:@"" withFilterString:@"UNREAD"];
        _spinner.hidden=YES;
   
    
}
-(void)notifyForAll{
    _spinner.hidden=NO;
    switchForFilter = 0;
    [self clearFilteredDataFromTable:@"CuratedNews"];
    [self loadCuratedNews];
    _spinner.hidden=YES;

}
-(void)notifyForLast{
        _spinner.hidden=NO;
        switchForFilter = 2;
        [self callSearchAPIWithStringForUnread:@"" withFilterString:@"RECENT"];
        _spinner.hidden=YES;

}


-(void)notifyForMarkAsRead {
    //Mark as read functionality
    //NSLog(@"Mark As Read --->%@ and %@",articleIdToBePassed,unreadArticleIdArray);
    NSString *categoryStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"categoryId"]];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
    [resultDic setObject:self.filterArray forKey:@"selectedArticleIds"];
    [resultDic setObject:@"1" forKey:@"status"];
    [resultDic setObject:@"true" forKey:@"isSelected"];
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
    // [self.curatedNewsDetail setValue:[NSNumber numberWithBool:NO] forKey:@"saveForLater"];
    if([[FISharedResources sharedResourceManager]serviceIsReachable]) {
        [[FISharedResources sharedResourceManager]setUserActivitiesOnArticlesWithDetails:resultStr];
    }
    for(NSString *articleId in self.filterArray) {
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
                [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"readStatus"];
                [curatedNews setValue:[NSNumber numberWithInt:0] forKey:@"isFilter"];
                
                if([[FISharedResources sharedResourceManager]serviceIsReachable]) {
                    // [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"isReadStatusSync"];
                } else {
                    [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"isReadStatusSync"];
                }
                
                NSNumber *markImpStatus = [curatedNews valueForKey:@"markAsImportant"];
                NSNumber *saveForLaterStatus = [curatedNews valueForKey:@"saveForLater"];
                
                if([markImpStatus isEqualToNumber:[NSNumber numberWithInt:1]] && [saveForLaterStatus isEqualToNumber:[NSNumber numberWithInt:1]]) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMenuCount" object:nil userInfo:@{@"type":@"all"}];
                } else if([markImpStatus isEqualToNumber:[NSNumber numberWithInt:1]]) {
                    // NSLog(@"both type is working");
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMenuCount" object:nil userInfo:@{@"type":@"bothMarkImp"}];
                }else if([saveForLaterStatus isEqualToNumber:[NSNumber numberWithInt:1]]) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMenuCount" object:nil userInfo:@{@"type":@"bothSavedForLater"}];
                }else {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMenuCount" object:nil userInfo:@{@"type":categoryStr}];
                }
                
            }
        }
        [managedObjectContext save:nil];
    }
    [self.articlesTableView reloadData];
}



-(void)notifyForAddToFolder {
    //Add to folder functionality
    //NSLog(@"Add To Folder --->%@ and %@",articleIdToBePassed,unreadArticleIdArray);
    [self.articlesTableView setContentOffset:CGPointZero animated:YES];

    [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"FolderClick"];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"SavedListPopoverViewPhone" bundle:nil];
        SavedListPopoverView *popOverView = [storyBoard instantiateViewControllerWithIdentifier:@"SavedList"];
        //self.superview.alpha = 0.4;
        popOverView.selectedArticleId = @"";
        popOverView.selectedArticleIdArray = [[NSMutableArray alloc]initWithArray:self.filterArray];
        popover = [[FPPopoverController alloc] initWithViewController:popOverView];
        popover.border = NO;
        popover.delegate = self;
        
        //[popover setShadowsHidden:YES];
        popover.tint = FPPopoverWhiteTint;
        popover.contentSize = CGSizeMake(300, 260);
        popover.arrowDirection = FPPopoverArrowDirectionAny;
        [popover presentPopoverFromView:self.view];
    }
    else{
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"SavedListPopoverView" bundle:nil];
        SavedListPopoverView *popOverView = [storyBoard instantiateViewControllerWithIdentifier:@"SavedList"];
        popOverView.selectedArticleId = @"";
        popOverView.selectedArticleIdArray = [[NSMutableArray alloc]initWithArray:self.filterArray];
        self.popOver =[[UIPopoverController alloc] initWithContentViewController:popOverView];
        self.popOver.popoverContentSize=CGSizeMake(350, 267);
        //self.popOver.delegate = self;
        [self.popOver presentPopoverFromRect:CGRectMake(self.actionButton.frame.origin.x, self.actionButton.frame.origin.y, self.actionButton.frame.size.width, 100) inView:self.articlesTableView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}



- (void)callSearchAPIWithStringForUnread:(NSString *)searchString withFilterString:(NSString *)filterString {
    //TODO: refresh your data
    //if(self.devices.count == 0){
    NSNumber *newsLetterId = [[NSUserDefaults standardUserDefaults]objectForKey:@"newsletterId"];
    NSNumber *folderId = [[NSUserDefaults standardUserDefaults]objectForKey:@"folderId"];
    NSNumber *category = [[NSUserDefaults standardUserDefaults] valueForKey:@"categoryId"];
    // NSInteger category = categoryStr.integerValue;
    NSLog(@"folder id:%@ and categoryid:%@",folderId,category);
    NSString *queryString;
    if([folderId isEqualToNumber:[NSNumber numberWithInt:0]] && [newsLetterId isEqualToNumber:[NSNumber numberWithInt:0]]) {
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
    } else if(![folderId isEqualToNumber:[NSNumber numberWithInt:0]]){
        [[FISharedResources sharedResourceManager]fetchArticleFromFolderWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withFolderId:folderId withPageNo:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withUpFlag:NO withQuery:searchString withFilterBy:filterString];
    } else if(![newsLetterId isEqualToNumber:[NSNumber numberWithInt:0]]) {
        [[FISharedResources sharedResourceManager]fetchArticleFromNewsLetterWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withNewsLetterId:newsLetterId withPageNo:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withUpFlag:NO withFlag:NO withQuery:searchString withFilterBy:filterString];
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
//    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
//    
//    //Ignoring specific orientations
//    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown) {
//        return;
//    }
//    
//    // We need to allow a slight pause before running handler to make sure rotation has been processed by the view hierarchy
//    [self performSelectorOnMainThread:@selector(handleDeviceOrientationChange:) withObject:coachMarksView waitUntilDone:NO];
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
    if (isSearching) {
        searchBar.hidden = NO;
//        self.navigationItem.rightBarButtonItems = nil;
//        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.titleView = nil;

    }

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
//    isSearchingInteger = 0;
    if ([searchBar.text isEqualToString:@""]) {
        [self cancelButtonEvent];
    }
    [searchBar resignFirstResponder];
    searchBar.hidden = YES;
//    [[NSUserDefaults standardUserDefaults] setInteger:5 forKey:@"selectionValue"];


}
-(void)viewDidAppear:(BOOL)animated {    

    NSString *accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"];
    if(accessToken.length == 0) {
        // NSLog(@"corporate if part");
        //[self showLoginPage];
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

    

    
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
////    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-270, 0, 188, 44)];
//    [searchBar setFrame:CGRectMake(searchBar.frame.origin.x+20 , 0.f, 0.f, 0.f)];
    [self didClickCancelButton];

}
-(void)showLoginPage {
    [self.revealController showViewController:self.revealController.frontViewController];
    NSArray *navArray = self.navigationController.viewControllers;
    if(navArray.count > 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        UIStoryboard *centerStoryBoard;
        UIViewController *viewCtlr;
        
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        {
            centerStoryBoard = [UIStoryboard storyboardWithName:@"MainPhone" bundle:nil];
            viewCtlr = [centerStoryBoard instantiateViewControllerWithIdentifier:@"LoginView"];
            
            
        } else {
            centerStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            viewCtlr = [centerStoryBoard instantiateViewControllerWithIdentifier:@"LoginView"];
            
            
        }
        
        
        [self.revealController setFrontViewController:viewCtlr];
        [self.revealController showViewController:self.revealController.frontViewController];
    } else {
        UIStoryboard *centerStoryBoard;
        UIViewController *viewCtlr;
        
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        {
            centerStoryBoard = [UIStoryboard storyboardWithName:@"MainPhone" bundle:nil];
            viewCtlr = [centerStoryBoard instantiateViewControllerWithIdentifier:@"LoginView"];
            
            
        } else {
            centerStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            viewCtlr = [centerStoryBoard instantiateViewControllerWithIdentifier:@"LoginView"];
            
            
        }
        
        
        [self.revealController setFrontViewController:viewCtlr];
        [self.revealController showViewController:self.revealController.frontViewController];
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
    
    navBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [navBtn setFrame:CGRectMake(0.0f,0.0f,16.0f,15.0f)];
    [navBtn setBackgroundImage:[UIImage imageNamed:@"navmenu"]  forState:UIControlStateNormal];
    [navBtn addTarget:self action:@selector(backBtnPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:navBtn];
    NSNumber *newsLetterId = [[NSUserDefaults standardUserDefaults]objectForKey:@"newsletterId"];
    BOOL isFolderClick = [[NSUserDefaults standardUserDefaults]boolForKey:@"isFolderClick"];
    if(isFolderClick) {
        
    } else if([newsLetterId isEqualToNumber:[NSNumber numberWithInt:0]]) {
        [self.navigationItem setLeftBarButtonItem:addButton];
    } else {
        
    }
    
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        Btns =[UIButton buttonWithType:UIButtonTypeCustom];
        [Btns setFrame:CGRectMake(0.0f,0.0f,20.0f,20.0f)];
        [Btns setBackgroundImage:[UIImage imageNamed:@"settingsFilter"]  forState:UIControlStateNormal];
        [Btns addTarget:self action:@selector(settingsButtonFilter) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *addButtons = [[UIBarButtonItem alloc] initWithCustomView:Btns];
        // [self.navigationItem setRightBarButtonItem:addButtons];
        
       UIButton *Btnns =[UIButton buttonWithType:UIButtonTypeCustom];
        [Btnns setFrame:CGRectMake(0.0f,0.0f,10.0f,10.0f)];
        [Btnns setBackgroundImage:[UIImage imageNamed:@""]  forState:UIControlStateNormal];
        UIBarButtonItem *addButtonsBtnns = [[UIBarButtonItem alloc] initWithCustomView:Btnns];

        searchButtons =[UIButton buttonWithType:UIButtonTypeCustom];
        [searchButtons setFrame:CGRectMake(0.0f,0.0f,16.0f,15.0f)];
        [searchButtons setBackgroundImage:[UIImage imageNamed:@"search"]  forState:UIControlStateNormal];
        [searchButtons addTarget:self action:@selector(searchButtonFilter) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *addButtonsRight = [[UIBarButtonItem alloc] initWithCustomView:searchButtons];
        NSArray *buttonsArr = [NSArray arrayWithObjects:addButtons,addButtonsBtnns,addButtonsRight, nil];
        [self.navigationItem setRightBarButtonItems:buttonsArr];

        
    }
    else{
        self.navigationItem.rightBarButtonItem = nil;
        
        UIButton *Btnns =[UIButton buttonWithType:UIButtonTypeCustom];
        [Btnns setFrame:CGRectMake(0.0f,0.0f,20.0f,20.0f)];
        [Btnns setBackgroundImage:[UIImage imageNamed:@""]  forState:UIControlStateNormal];
        UIBarButtonItem *addButtonsBtnns = [[UIBarButtonItem alloc] initWithCustomView:Btnns];

       
        
        searchButtons =[UIButton buttonWithType:UIButtonTypeCustom];
        [searchButtons setFrame:CGRectMake(0.0f,0.0f,16.0f,15.0f)];
        [searchButtons setBackgroundImage:[UIImage imageNamed:@"search"]  forState:UIControlStateNormal];
        [searchButtons addTarget:self action:@selector(searchButtonFilter) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *addButtonsRight = [[UIBarButtonItem alloc] initWithCustomView:searchButtons];
                
        NSArray *buttonsArr = [NSArray arrayWithObjects:addButtonsBtnns,addButtonsRight, nil];
        [self.navigationItem setRightBarButtonItems:buttonsArr];

        
    }
    

}

-(void)loadCuratedNews {
    // [[UIApplication sharedApplication] setApplicationIconBadgeNumber:100];
    
    self.articlesTableView.dataSource = self;
    self.articlesTableView.delegate = self;
    NSNumber *categoryId = [[NSUserDefaults standardUserDefaults]objectForKey:@"categoryId"];
    NSNumber *folderId = [[NSUserDefaults standardUserDefaults]objectForKey:@"folderId"];
    NSNumber *contentTypeId = [[NSUserDefaults standardUserDefaults]objectForKey:@"parentId"];
    NSNumber *newsLetterId = [[NSUserDefaults standardUserDefaults]objectForKey:@"newsletterId"];
    NSLog(@"load curated news categoryId:%@ and folderid:%@ and contentTypeId:%@ and newsletterid:%@",categoryId,folderId,contentTypeId,newsLetterId);
    self.devices = [[NSMutableArray alloc]init];
    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
    NSPredicate *predicate;
    
    if([newsLetterId isEqualToNumber:[NSNumber numberWithInt:0]] && [folderId isEqualToNumber:[NSNumber numberWithInt:0]]) {
        BOOL savedForLaterIsNew =[[NSUserDefaults standardUserDefaults]boolForKey:@"SavedForLaterIsNew"];
        if([categoryId isEqualToNumber:[NSNumber numberWithInt:-3]]) {
            if(isSearching) {
                predicate  = [NSPredicate predicateWithFormat:@"saveForLater == %@ AND categoryId==%@ AND isSearch == %@",[NSNumber numberWithBool:YES],categoryId,[NSNumber numberWithBool:isSearching]];
            } else if(switchForFilter == 1) {
                predicate  = [NSPredicate predicateWithFormat:@"saveForLater == %@ AND categoryId==%@ AND isFilter == %@",[NSNumber numberWithBool:YES],categoryId,[NSNumber numberWithInt:switchForFilter]];
            } else if(switchForFilter == 2) {
                predicate  = [NSPredicate predicateWithFormat:@"saveForLater == %@ AND categoryId==%@ AND isFilter == %@",[NSNumber numberWithBool:YES],categoryId,[NSNumber numberWithInt:switchForFilter]];
            } else {
                predicate  = [NSPredicate predicateWithFormat:@"saveForLater == %@ AND categoryId==%@",[NSNumber numberWithBool:YES],categoryId];
            }
            
        } else {
            if(isSearching) {
                predicate  = [NSPredicate predicateWithFormat:@"categoryId==%@ AND contentTypeId==%@ AND isSearch == %@",categoryId,contentTypeId,[NSNumber numberWithBool:isSearching]];
            } else if(switchForFilter == 1) {
                predicate  = [NSPredicate predicateWithFormat:@"categoryId==%@ AND contentTypeId==%@ AND isFilter == %@",categoryId,contentTypeId,[NSNumber numberWithInt:switchForFilter]];
            } else if(switchForFilter == 2) {
                predicate  = [NSPredicate predicateWithFormat:@"categoryId==%@ AND contentTypeId==%@ AND isFilter == %@",categoryId,contentTypeId,[NSNumber numberWithInt:switchForFilter]];
            } else {
                predicate  = [NSPredicate predicateWithFormat:@"categoryId==%@ AND contentTypeId==%@",categoryId,contentTypeId];
            }
            
        }
    } else if(![folderId isEqualToNumber:[NSNumber numberWithInt:0]]) {
        if(isSearching) {
            predicate  = [NSPredicate predicateWithFormat:@"isFolder == %@ AND folderId == %@ AND isSearch == %@",[NSNumber numberWithBool:YES],folderId,[NSNumber numberWithBool:isSearching]];
        } else if(switchForFilter == 1) {
            predicate  = [NSPredicate predicateWithFormat:@"isFolder == %@ AND folderId == %@ AND isFilter == %@",[NSNumber numberWithBool:YES],folderId,[NSNumber numberWithInt:switchForFilter]];
        } else if(switchForFilter == 2) {
            predicate  = [NSPredicate predicateWithFormat:@"isFolder == %@ AND folderId == %@ AND isFilter == %@",[NSNumber numberWithBool:YES],folderId,[NSNumber numberWithInt:switchForFilter]];
        } else {
            predicate  = [NSPredicate predicateWithFormat:@"isFolder == %@ AND folderId == %@",[NSNumber numberWithBool:YES],folderId];
        }
    } else if(![newsLetterId isEqualToNumber:[NSNumber numberWithInt:0]]) {
        [self.revealController showViewController:self.revealController.frontViewController];
        if(isSearching) {
            predicate  = [NSPredicate predicateWithFormat:@"newsletterId == %@ AND isSearch == %@",newsLetterId,[NSNumber numberWithBool:isSearching]];
        } else if(switchForFilter == 1) {
            predicate  = [NSPredicate predicateWithFormat:@"newsletterId == %@ AND isFilter == %@",newsLetterId,[NSNumber numberWithInt:switchForFilter]];
        } else if(switchForFilter == 2) {
            predicate  = [NSPredicate predicateWithFormat:@"newsletterId == %@ AND isFilter == %@",newsLetterId,[NSNumber numberWithInt:switchForFilter]];
        } else {
            predicate  = [NSPredicate predicateWithFormat:@"newsletterId == %@",newsLetterId];
        }
        
    }
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *date = [[NSSortDescriptor alloc] initWithKey:@"modifiedDate" ascending:NO];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:date, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
   
    NSLog(@"curated news list count:%lu",(unsigned long)newPerson.count);
    
    if(newPerson.count != 0) {
        
       // [self addRightBarItems];
        
        [activityIndicator stopAnimating];
        
    } else {
        
    }
    

    if([categoryId isEqualToNumber:[NSNumber numberWithInt:-3]]) {
        self.devices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    }else {
        self.devices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        
    }
    NSLog(@"%lu",(unsigned long)[self.devices count]);
    NSLog(@"news article id:%@",self.selectedNewsLetterArticleId);
    
        
    articleIdToBePassed = [self.devices valueForKey:@"articleId"];
    NSLog(@"articleIdToBePassed = %@",articleIdToBePassed);
    
    self.filterArray = [[NSMutableArray alloc]init];
    if(self.segmentControl.selectedSegmentIndex == 0) {
        //Fetch all articles
        for(NSManagedObject *curatedNews in self.devices) {
            
                [self.filterArray addObject:[curatedNews valueForKey:@"articleId"]];
            
        }
    } else if(self.segmentControl.selectedSegmentIndex == 1) {
        //Fetch Unread articles
        for(NSManagedObject *curatedNews in self.devices) {
            if([[curatedNews valueForKey:@"readStatus"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                
            } else {
                [self.filterArray addObject:[curatedNews valueForKey:@"articleId"]];
            }
        }
    } else if(self.segmentControl.selectedSegmentIndex == 2) {
        //Handle none articles
        [self.filterArray removeAllObjects];
    }
    
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
    
    NSLog(@"%f",Btns.frame.origin.x);
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MoreSettingsViewPhone" bundle:nil];
    MoreSettingsView *popOverView = [storyBoard instantiateViewControllerWithIdentifier:@"MoreSettingsView"];
    popOverView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.view.alpha = 0.65;
    popOverView.dropDownValue = 1;
    popOverView.xPositions = Btns.frame.origin.x;
    popOverView.yPositions =Btns.frame.origin.y;
    [self presentViewController:popOverView animated:NO completion:nil];

}
-(void)searchButtonFilter{
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.navigationItem.rightBarButtonItems = nil;
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.titleView = nil;

        searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-18, 44)];
        searchBar.showsCancelButton = YES;
        [searchBar setTintColor:[UIColor whiteColor]];
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTintColor:[UIColor darkGrayColor]];
        
        searchBar.delegate = self;
        [searchBar setPlaceholder:@"Search article or topic"];
        [self.navigationController.navigationBar addSubview:searchBar];
        [searchBar becomeFirstResponder];

    }
    else{
        self.navigationItem.rightBarButtonItems = nil;
        NSLog(@"%f %f",SCREEN_WIDTH-580, SCREEN_WIDTH-320);
        searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-270, 0, 188, 44)];
        searchBar.showsCancelButton = YES;
        [searchBar setTintColor:[UIColor whiteColor]];
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTintColor:[UIColor darkGrayColor]];
        
        searchBar.delegate = self;
        [searchBar setPlaceholder:@"Search article or topic"];
        [self.navigationController.navigationBar addSubview:searchBar];
        [searchBar becomeFirstResponder];

        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(didClickCancelButton)];

    }

}
-(void)didClickCancelButton{
    isSearching =0;
    [searchBar resignFirstResponder];
    searchBar.hidden = YES;
    [self clearSearchedDataFromTable:@"CuratedNews"];
    [self loadCuratedNews];
    [self addButtonsOnNavigationBar];
    
    [self commonMethodToAddTitle];
}
-(void)commonMethodToAddTitle{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Open Sans" size:16];
    // label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.text =_titleName;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor]; // change this color
    
    self.navigationItem.titleView = label;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBars
{
    isSearching =0;
    [searchBars resignFirstResponder];
    searchBars.hidden = YES;
    [self clearSearchedDataFromTable:@"CuratedNews"];
    [self loadCuratedNews];
    [self addButtonsOnNavigationBar];
    [self commonMethodToAddTitle];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBars {
    [searchBars resignFirstResponder];
    if (switchForFilter ==0)
    {
         [self callSearchAPIWithStringForUnread:searchBars.text withFilterString:@""];

    }
    else if (switchForFilter == 1)
    {
         [self callSearchAPIWithStringForUnread:searchBars.text withFilterString:@"UNREAD"];

    }
    else if (switchForFilter == 2)
    {
         [self callSearchAPIWithStringForUnread:searchBars.text withFilterString:@"RECENT"];
 
    }

//     [self callSearchAPIWithString:searchBars.text];
}

-(void)commonMethodForSearchBarExit
{
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
        if([searchText length] != 0) {
            isSearching = YES;
            //[self searchTableList];
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
    NSNumber *newsLetterId = [[NSUserDefaults standardUserDefaults]objectForKey:@"newsletterId"];
    // NSInteger category = categoryStr.integerValue;
    NSLog(@"folder id:%@ and categoryid:%@",folderId,category);
    NSString *queryString;
    if([folderId isEqualToNumber:[NSNumber numberWithInt:0]] && [newsLetterId isEqualToNumber:[NSNumber numberWithInt:0]]) {
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
        NSLog(@"input query json:%@",queryString);
        NSNumber *contentTypeId = [[NSUserDefaults standardUserDefaults]objectForKey:@"parentId"];
        
        [[FISharedResources sharedResourceManager]getCuratedNewsListWithAccessToken:queryString withCategoryId:category withContentTypeId:contentTypeId withFlag:@"" withLastArticleId:@"" withActivityTypeId:[NSNumber numberWithInt:2]];
        
        
        // }
    } else if(![newsLetterId isEqualToNumber:[NSNumber numberWithInt:0]]) {
        [[FISharedResources sharedResourceManager]fetchArticleFromNewsLetterWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withNewsLetterId:newsLetterId withPageNo:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withUpFlag:NO withFlag:NO withQuery:searchString withFilterBy:@""];
    } else if(![folderId isEqualToNumber:[NSNumber numberWithInt:0]]){
        [[FISharedResources sharedResourceManager]fetchArticleFromFolderWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withFolderId:folderId withPageNo:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withUpFlag:NO withQuery:searchString withFilterBy:@""];
    }
    [refreshControl endRefreshing];
    //    [self.influencerTableView reloadData];
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
    NSNumber *newsLetterId = [[NSUserDefaults standardUserDefaults]objectForKey:@"newsletterId"];
    NSString *queryString;
    if([folderId isEqualToNumber:[NSNumber numberWithInt:0]] && [newsLetterId isEqualToNumber:[NSNumber numberWithInt:0]]) {
        // NSInteger category = categoryStr.integerValue;
        if([category isEqualToNumber:[NSNumber numberWithInt:-2]]) {
//            if (isSearching) {
//                queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] valueForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withQuery:searchBar.text withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"" withActivityTypeID:[NSNumber numberWithInt:2]];
//            } else
                if (switchForFilter == 1){
                queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withQuery:searchBar.text withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"UNREAD" withActivityTypeID:[NSNumber numberWithInt:2]];
                
            } else if (switchForFilter == 2){
                queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withQuery:searchBar.text withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"RECENT" withActivityTypeID:[NSNumber numberWithInt:2]];
                
            }else {
                queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] valueForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withQuery:searchBar.text withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"" withActivityTypeID:[NSNumber numberWithInt:2]];
            }
        } else if([category isEqualToNumber:[NSNumber numberWithInt:-3]]) {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"SavedForLaterIsNew"];
//            if (isSearching) {
//                queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withQuery:searchBar.text withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"" withActivityTypeID:[NSNumber numberWithInt:3]];
//            } else
                if (switchForFilter == 1){
                queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withQuery:searchBar.text withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"UNREAD" withActivityTypeID:[NSNumber numberWithInt:3]];
                
            } else if (switchForFilter == 2){
                queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withQuery:searchBar.text withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"RECENT" withActivityTypeID:[NSNumber numberWithInt:3]];
                
            }else {
                queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withQuery:searchBar.text withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"" withActivityTypeID:[NSNumber numberWithInt:3]];
            }
        } else {
            
            NSNumber *parentId = [[NSUserDefaults standardUserDefaults]objectForKey:@"parentId"];
            NSLog(@"parent id:%@",parentId);
//            if (isSearching) {
//                queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:parentId withPageNumber:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withQuery:searchBar.text withContentCategoryId:category withOrderBy:@"" withFilterBy:@"" withActivityTypeID:[NSNumber numberWithInt:0]];
//            } else
                if (switchForFilter == 1){
                queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withQuery:searchBar.text withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"UNREAD" withActivityTypeID:[NSNumber numberWithInt:0]];
                
            } else if (switchForFilter == 2){
                queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withQuery:searchBar.text withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"RECENT" withActivityTypeID:[NSNumber numberWithInt:0]];
                
            }else {
                queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:parentId withPageNumber:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withQuery:searchBar.text withContentCategoryId:category withOrderBy:@"" withFilterBy:@"" withActivityTypeID:[NSNumber numberWithInt:0]];
            }
            

        }
        NSNumber *contentTypeId = [[NSUserDefaults standardUserDefaults]objectForKey:@"parentId"];
        if (isSearching) {
            [[FISharedResources sharedResourceManager]getCuratedNewsListWithAccessToken:queryString withCategoryId:category withContentTypeId:contentTypeId withFlag:@"up" withLastArticleId:@"" withActivityTypeId:[NSNumber numberWithInt:2]];
        } else {
            [[FISharedResources sharedResourceManager]getCuratedNewsListWithAccessToken:queryString withCategoryId:category withContentTypeId:contentTypeId withFlag:@"up" withLastArticleId:@"" withActivityTypeId:[NSNumber numberWithInt:2]];
        }
        

        
        // }
    } else if(![newsLetterId isEqualToNumber:[NSNumber numberWithInt:0]]) {
//        if(isSearching) {
//            [[FISharedResources sharedResourceManager]fetchArticleFromNewsLetterWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withNewsLetterId:newsLetterId withPageNo:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withUpFlag:NO withFlag:NO withQuery:searchBar.text withFilterBy:@""];
//        } else
            if (switchForFilter == 1){
            [[FISharedResources sharedResourceManager]fetchArticleFromNewsLetterWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withNewsLetterId:newsLetterId withPageNo:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withUpFlag:NO withFlag:NO withQuery:searchBar.text withFilterBy:@"UNREAD"];
            
            
        } else if (switchForFilter == 2){
            [[FISharedResources sharedResourceManager]fetchArticleFromNewsLetterWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withNewsLetterId:newsLetterId withPageNo:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withUpFlag:NO withFlag:NO withQuery:searchBar.text withFilterBy:@"RECENT"];
            
        }else {
            [[FISharedResources sharedResourceManager]fetchArticleFromNewsLetterWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withNewsLetterId:newsLetterId withPageNo:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withUpFlag:NO withFlag:NO withQuery:searchBar.text withFilterBy:@""];
        }
    } else if(![folderId isEqualToNumber:[NSNumber numberWithInt:0]]){
//        if (isSearching) {
//            [[FISharedResources sharedResourceManager]fetchArticleFromFolderWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withFolderId:folderId withPageNo:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withUpFlag:NO withQuery:searchBar.text withFilterBy:@""];
//        } else
            if (switchForFilter == 1){
            [[FISharedResources sharedResourceManager]fetchArticleFromFolderWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withFolderId:folderId withPageNo:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withUpFlag:NO withQuery:searchBar.text withFilterBy:@"UNREAD"];
        } else if (switchForFilter == 2){
            [[FISharedResources sharedResourceManager]fetchArticleFromFolderWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withFolderId:folderId withPageNo:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withUpFlag:NO withQuery:searchBar.text withFilterBy:@"RECENT"];
            
        }else {
            [[FISharedResources sharedResourceManager]fetchArticleFromFolderWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withFolderId:folderId withPageNo:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withUpFlag:YES withQuery:searchBar.text withFilterBy:@""];
        }
        
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
            [curatedNews setValue:[NSNumber numberWithInt:0] forKey:@"isFilter"];
            
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
    NSLog(@"marked imp read status:%@",number);
    if([[curatedNews valueForKey:@"readStatus"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
        if([number isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMenuCount" object:nil userInfo:@{@"type":@"-3",@"isSelected":[NSNumber numberWithBool:NO]}];
            //[curatedNews setValue:[NSNumber numberWithBool:NO] forKey:@"saveForLater"];
        } else {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMenuCount" object:nil userInfo:@{@"type":@"-3",@"isSelected":[NSNumber numberWithBool:YES]}];
           // [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"saveForLater"];
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
            NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]);
            NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"firstName"]);
            NSLog(@"%@",[curatedNews valueForKey:@"title"]);
            NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"companyName"]);
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
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMenuCount" object:nil userInfo:@{@"type":@"-2",@"isSelected":[NSNumber numberWithBool:YES]}];
                        //[curatedNews setValue:[NSNumber numberWithBool:NO] forKey:@"markAsImportant"];
                    } else {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMenuCount" object:nil userInfo:@{@"type":@"-2",@"isSelected":[NSNumber numberWithBool:NO]}];
                       // [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"markAsImportant"];
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
                    //[curatedNews setValue:[NSNumber numberWithBool:NO] forKey:@"markAsImportant"];
                } else {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMenuCount" object:nil userInfo:@{@"type":@"-2",@"isSelected":[NSNumber numberWithBool:YES]}];
                   // [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"markAsImportant"];
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
        
        if([[tableView indexPathsForSelectedRows] containsObject:indexPath]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

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
                
//                cell.messageCountText.textColor = [FIUtils colorWithHexString:@"666E73"];
                cell.messageCountText.textColor =UIColorFromRGB(0x666E73);

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
        if (isSearching) {
            [self highlight:cell.authorName withString:searchBar.text];
        }
        
        // NSLog(@"multiple author array:%@",multipleAuthorArray);
        // cell.authorTitle.text = [author valueForKey:@"title"];
        // [cell.authorImageView sd_setImageWithURL:[NSURL URLWithString:[author valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"FI"]];
        
        cell.title.text = [curatedNews valueForKey:@"title"];
        if (isSearching) {
            [self highlight:cell.title withString:searchBar.text];
        }
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
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
                if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
                {
                    // code for landscape orientation
                    
                }
                if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
                {
                    // code for Portrait orientation
                    NSString *authorName = cell.authorName.text;
                    NSString *outletName = cell.outlet.text;
                    if(outletName.length > 15 && authorName.length > 15) {
                        cell.outlet.text = [NSString stringWithFormat:@"%@...",[outletName substringToIndex:15]];
                        cell.authorName.text = [NSString stringWithFormat:@"%@...",[authorName substringToIndex:15]];
                        cell.messageIcon.hidden = YES;
                        cell.messageCountText.hidden = YES;
                    } else if(outletName.length > 15) {
                        cell.outlet.text = [NSString stringWithFormat:@"%@...",[outletName substringToIndex:15]];
                        cell.messageIcon.hidden = YES;
                        cell.messageCountText.hidden = YES;
                    } else if(authorName.length > 15) {
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
        
        
        //Handle checkbox based on segement selected control
        if(self.segmentControl.selectedSegmentIndex == 0) {
            [cell.checkMarkButton setSelected:YES];
        } else if(self.segmentControl.selectedSegmentIndex == 1) {
            if([[curatedNews valueForKey:@"readStatus"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                [cell.checkMarkButton setSelected:NO];
            } else {
                [cell.checkMarkButton setSelected:YES];
            }
        } else if(self.segmentControl.selectedSegmentIndex == 2) {
            [cell.checkMarkButton setSelected:NO];
        }
        
        if(cell.checkMarkButton.isSelected) {
           // [actionArticleIdList addObject:[curatedNews valueForKey:@"articleId"]];
        } else {
            
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
- (void)highlight:(UILabel *)isLabel withString:(NSString *)searchString{
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: searchString options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (!error)
    {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:isLabel.text];
        NSArray *allMatches = [regex matchesInString:isLabel.text options:0 range:NSMakeRange(0, [isLabel.text length])];
        for (NSTextCheckingResult *aMatch in allMatches)
        {
            NSRange matchRange = [aMatch range];
            [attributedString setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range: matchRange];
        }
        [isLabel setAttributedText:attributedString];

    }

    
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
//-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
//    
//    UIView* accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 24, 50)];
//    UIImageView* accessoryViewImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bluecircle"]];
//    accessoryViewImage.center = CGPointMake(12, 25);
//    [accessoryView addSubview:accessoryViewImage];
//    [cell setAccessoryView:accessoryView];
//    cell.accessoryType = UITableViewCellAccessoryCheckmark;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(longPressActive ? @"yes" : @"No");

//    if (longPressActive) { //Perform action desired when cell is long pressed
//        
//        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
//        
//        UIView* accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 24, 50)];
//        UIImageView* accessoryViewImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bluecircle_checked"]];
//        accessoryViewImage.center = CGPointMake(12, 25);
//        [accessoryView addSubview:accessoryViewImage];
//        [cell setAccessoryView:accessoryView];
//        [self addToolbarAndChangeNavBar];
//        
//      
//
//    }else { //Perform action desired when cell is selected normally
    
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        
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
            NSLog(@"%d",isSearching);
            NSLog(@"%@",articleIdToBePassed);
            
            testView = [storyBoard instantiateViewControllerWithIdentifier:@"UpgradeView"];
            testView.searchText = searchBar.text;
            testView.switchForFilter = switchForFilter;
            testView.articleTitle = _titleName;
            testView.currentIndex = indexPath.row;
            testView.selectedIndexPath = indexPath;
            testView.isSearching = isSearching;
            testView.articleIdFromSearchLst =articleIdToBePassed;
            [self.navigationController pushViewController:testView animated:YES];
        }
//    }
}
-(void)addToolbarAndChangeNavBar{
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = nil;

    toolbar.hidden = NO;
    
    [searchButtons setHidden:YES];
    [Btns setHidden:YES];
    [navBtn setHidden:YES];
    
    //navigation additions---------------------------------------------------

    CancelButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [CancelButton setFrame:CGRectMake(0.0f,0.0f,66.0f,36.0f)];
    [CancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [CancelButton addTarget:self action:@selector(cancelButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:CancelButton];
    
    [self.navigationItem setLeftBarButtonItem:addButton];

    
    selectAll =[UIButton buttonWithType:UIButtonTypeCustom];
    [selectAll setFrame:CGRectMake(0.0f,0.0f,86.0f,36.0f)];
    [selectAll setTitle:@"Select all" forState:UIControlStateNormal];
    [selectAll addTarget:self action:@selector(selectAllButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addButtons = [[UIBarButtonItem alloc] initWithCustomView:selectAll];
    
    [self.navigationItem setRightBarButtonItem:addButtons];

//    UIBarButtonItem *CancelButton =
//    [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonEvent)];
//    UIBarButtonItem *selectAll =
//    [[UIBarButtonItem alloc]initWithTitle:@"Select All" style:UIBarButtonItemStylePlain target:self action:@selector(selectAllButtonEvent)];
//    self.navigationItem.leftBarButtonItem = CancelButton;
//    self.navigationItem.rightBarButtonItem = selectAll;
}
-(void)markAsRead{
    
}
-(void)addTOFolder{
    
}
-(void)cancelButtonEvent{
      self.navigationItem.rightBarButtonItem = nil;
      self.navigationItem.leftBarButtonItem = nil;
      [self addButtonsOnNavigationBar];
//      longPressActive = NO;
    [self.articlesTableView reloadData];

//    [searchButtons setHidden:NO];
//    [Btns setHidden:NO];
//    [navBtn setHidden:NO];

//    self.navigationItem.rightBarButtonItem = nil;
//    self.navigationItem.leftBarButtonItem = nil;
    [self.navigationController setToolbarHidden:YES animated:YES];
//    [toolbar removeFromSuperview];
//    [self.view :toolbar];

    toolbar.hidden = YES;
}
-(void)selectAllButtonEvent{
    
        NSUInteger numberOfrows = [self.articlesTableView numberOfRowsInSection:0];
        NSLog(@"%lu",(unsigned long)numberOfrows);
        for (NSUInteger s = 0; s < numberOfrows; ++s) {
            NSUInteger numberOfRowsInSection = [self.articlesTableView numberOfRowsInSection:s];
//           NSIndexPath *idxPath = [NSIndexPath indexPathForRow:r inSection:s];
//          [self.selectedCells addObject:idxPath];
//          [self.selecedStates addObject:self.states[idxPath.row]];
//            longPressActive = YES;
            [self.articlesTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:s inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
            [self tableView:self.articlesTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:s inSection:0]];
            
        }
//        [self.articlesTableView reloadData];
}
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    
    CGPoint p = [gestureRecognizer locationInView:self.articlesTableView];
    NSIndexPath *indexPath = [self.articlesTableView indexPathForRowAtPoint:p];
    if (indexPath == nil) {
        NSLog(@"long press on table view but not on a row");
    }
    else
    {
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
        {
            NSLog(@"long press on table view at row %ld", (long)indexPath.row);
            
            [gestureRecognizer cancelsTouchesInView];
            //longPressActive = YES;
            //[self.articlesTableView selectRowAtIndexPath:indexPath
            //                           animated:NO
            //                      scrollPosition:UITableViewScrollPositionNone];
            //[self tableView:self.articlesTableView didSelectRowAtIndexPath:indexPath];
        }
//        }else if (gestureRecognizer.state == UIGestureRecognizerStateEnded ||
//                  gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
//            longPressActive = NO;
//            
//        }
    }
}

-(void)checkMark:(UITapGestureRecognizer *)tapGesture {
    NSInteger selectedTag = [tapGesture view].tag;
    NSManagedObject *curatedNews = [self.devices objectAtIndex:selectedTag];
    NSLog(@"checked news:%@",curatedNews);
    NSString *articleId = [curatedNews valueForKey:@"articleId"];
    UIButton *checkMarkBtn = (UIButton *)[tapGesture view];
    if(checkMarkBtn.selected) {
        if([self.filterArray containsObject:articleId]) {
            [self.filterArray removeObject:articleId];
        } else {
            [self.filterArray addObject:articleId];
        }
        [checkMarkBtn setSelected:NO];
    }else {
        if([self.filterArray containsObject:articleId]) {
            [self.filterArray removeObject:articleId];
        } else {
            [self.filterArray addObject:articleId];
        }

        [checkMarkBtn setSelected:YES];
    }
    NSLog(@"after selection filter array%d",self.filterArray.count);
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
//                [curatedNewsDetail setValue:[NSNumber numberWithBool:NO] forKey:@"markAsImportant"];
//                [curatedNews setValue:[NSNumber numberWithBool:NO] forKey:@"markAsImportant"];
                
                if([[curatedNews valueForKey:@"readStatus"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
                    if(number == [NSNumber numberWithInt:1]) {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMenuCount" object:nil userInfo:@{@"type":@"-2",@"isSelected":[NSNumber numberWithBool:NO]}];
                       // [curatedNews setValue:[NSNumber numberWithBool:NO] forKey:@"markAsImportant"];
                    } else {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMenuCount" object:nil userInfo:@{@"type":@"-2",@"isSelected":[NSNumber numberWithBool:YES]}];
                        //[curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"markAsImportant"];
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
//            [curatedNewsDetail setValue:[NSNumber numberWithBool:YES] forKey:@"markAsImportant"];
//            [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"markAsImportant"];
            [curatedNews setValue:[NSNumber numberWithInt:[loginUserIdString intValue]] forKey:@"markAsImportantUserId"];
            if([[curatedNews valueForKey:@"readStatus"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
                if(number == [NSNumber numberWithInt:1]) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMenuCount" object:nil userInfo:@{@"type":@"-2",@"isSelected":[NSNumber numberWithBool:NO]}];
                  //  [curatedNews setValue:[NSNumber numberWithBool:NO] forKey:@"markAsImportant"];
                } else {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMenuCount" object:nil userInfo:@{@"type":@"-2",@"isSelected":[NSNumber numberWithBool:YES]}];
                    //[curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"markAsImportant"];
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
        if([number isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMenuCount" object:nil userInfo:@{@"type":@"-3",@"isSelected":[NSNumber numberWithBool:NO]}];
           // [curatedNews setValue:[NSNumber numberWithBool:NO] forKey:@"saveForLater"];
        } else {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMenuCount" object:nil userInfo:@{@"type":@"-3",@"isSelected":[NSNumber numberWithBool:YES]}];
           // [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"saveForLater"];
        }
    }
    
    
    
    NSManagedObject *curatedNewsDetail = [curatedNews valueForKey:@"details"];
    if([[FISharedResources sharedResourceManager]serviceIsReachable]) {
        UIButton *savedBtn = (UIButton *)[tapGesture view];
        if(savedBtn.selected) {
            [savedBtn setSelected:NO];
            [resultDic setObject:@"false" forKey:@"isSelected"];
//            [curatedNewsDetail setValue:[NSNumber numberWithBool:NO] forKey:@"saveForLater"];
//            [curatedNews setValue:[NSNumber numberWithBool:NO] forKey:@"saveForLater"];
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
            
//            [curatedNewsDetail setValue:[NSNumber numberWithBool:YES] forKey:@"saveForLater"];
//            [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"saveForLater"];
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

            
            [_spinner startAnimating];
            
            _spinner.hidden=NO;
            
            self.articlesTableView.tableFooterView = _spinner;
            
            NSManagedObject *curatedNews = [self.devices lastObject];
            NSString *inputJson;
            NSNumber *folderId = [[NSUserDefaults standardUserDefaults]objectForKey:@"folderId"];
            NSNumber *category = [[NSUserDefaults standardUserDefaults] valueForKey:@"categoryId"];
            NSNumber *newsLetterId = [[NSUserDefaults standardUserDefaults]objectForKey:@"newsletterId"];
            // NSInteger category = categoryStr.integerValue;
            
            //newcomers
            
            NSNumber *parentId = [[NSUserDefaults standardUserDefaults]objectForKey:@"parentId"];
            NSLog(@"parent id:%@",parentId);
            NSManagedObjectContext *context = [[FISharedResources sharedResourceManager] managedObjectContext];
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
            NSPredicate *predicate;
            
            
            
            if([newsLetterId isEqualToNumber:[NSNumber numberWithInt:0]] && [folderId isEqualToNumber:[NSNumber numberWithInt:0]]) {
                BOOL savedForLaterIsNew =[[NSUserDefaults standardUserDefaults]boolForKey:@"SavedForLaterIsNew"];
                if([category isEqualToNumber:[NSNumber numberWithInt:-3]]) {
                    
                    if(isSearching) {
                        predicate  = [NSPredicate predicateWithFormat:@"saveForLater == %@ AND categoryId==%@ AND isSearch == %@",[NSNumber numberWithBool:YES],category,[NSNumber numberWithBool:isSearching]];
                    } else if(switchForFilter == 1) {
                        predicate  = [NSPredicate predicateWithFormat:@"saveForLater == %@ AND categoryId==%@ AND isFilter == %@",[NSNumber numberWithBool:YES],category,[NSNumber numberWithInt:switchForFilter]];
                    } else if(switchForFilter == 2) {
                        predicate  = [NSPredicate predicateWithFormat:@"saveForLater == %@ AND categoryId==%@ AND isFilter == %@",[NSNumber numberWithBool:YES],category,[NSNumber numberWithInt:switchForFilter]];
                    } else {
                        predicate  = [NSPredicate predicateWithFormat:@"saveForLater == %@ AND categoryId==%@",[NSNumber numberWithBool:YES],category];
                    }
                } else {
                    if(isSearching) {
                        predicate  = [NSPredicate predicateWithFormat:@"categoryId==%@ AND contentTypeId==%@ AND isSearch == %@",category,parentId,[NSNumber numberWithBool:isSearching]];
                    } else if(switchForFilter == 1) {
                        predicate  = [NSPredicate predicateWithFormat:@"categoryId==%@ AND contentTypeId==%@ AND isFilter == %@",category,parentId,[NSNumber numberWithInt:switchForFilter]];
                    } else if(switchForFilter == 2) {
                        predicate  = [NSPredicate predicateWithFormat:@"categoryId==%@ AND contentTypeId==%@ AND isFilter == %@",category,parentId,[NSNumber numberWithInt:switchForFilter]];
                    } else {
                        predicate  = [NSPredicate predicateWithFormat:@"categoryId==%@ AND contentTypeId==%@",category,parentId];
                    }
                    
                }
            } else if(![folderId isEqualToNumber:[NSNumber numberWithInt:0]]) {
                if(isSearching) {
                    predicate  = [NSPredicate predicateWithFormat:@"isFolder == %@ AND folderId == %@ AND isSearch == %@",[NSNumber numberWithBool:YES],folderId,[NSNumber numberWithBool:isSearching]];
                } else if(switchForFilter == 1) {
                    predicate  = [NSPredicate predicateWithFormat:@"isFolder == %@ AND folderId == %@ AND isFilter == %@",[NSNumber numberWithBool:YES],folderId,[NSNumber numberWithInt:switchForFilter]];
                } else if(switchForFilter == 2) {
                    predicate  = [NSPredicate predicateWithFormat:@"isFolder == %@ AND folderId == %@ AND isFilter == %@",[NSNumber numberWithBool:YES],folderId,[NSNumber numberWithInt:switchForFilter]];
                } else {
                    predicate  = [NSPredicate predicateWithFormat:@"isFolder == %@ AND folderId == %@",[NSNumber numberWithBool:YES],folderId];
                }
            } else if(![newsLetterId isEqualToNumber:[NSNumber numberWithInt:0]]) {
                [self.revealController showViewController:self.revealController.frontViewController];
                if(isSearching) {
                    predicate  = [NSPredicate predicateWithFormat:@"newsletterId == %@ AND isSearch == %@",newsLetterId,[NSNumber numberWithBool:isSearching]];
                } else if(switchForFilter == 1) {
                    predicate  = [NSPredicate predicateWithFormat:@"newsletterId == %@ AND isFilter == %@",newsLetterId,[NSNumber numberWithInt:switchForFilter]];
                } else if(switchForFilter == 2) {
                    predicate  = [NSPredicate predicateWithFormat:@"newsletterId == %@ AND isFilter == %@",newsLetterId,[NSNumber numberWithInt:switchForFilter]];
                } else {
                    predicate  = [NSPredicate predicateWithFormat:@"newsletterId == %@",newsLetterId];
                }
                
            }
            
//            predicate = [NSPredicate predicateWithFormat:@"contentTypeId == %@ AND categoryId == %@",parentId,category];
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
            //NSNumber *newsLetterId = [[NSUserDefaults standardUserDefaults]objectForKey:@"newsletterId"];
            if([folderId isEqualToNumber:[NSNumber numberWithInt:0]] && [newsLetterId isEqualToNumber:[NSNumber numberWithInt:0]]) {
                if([category isEqualToNumber:[NSNumber numberWithInt:-2]]) {
                    //Handle markedimportant
                    NSString *queryString;
//                    if (isSearching) {
//                        queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withQuery:searchBar.text withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"" withActivityTypeID:[NSNumber numberWithInt:2]];
//                    } else
                        if (switchForFilter == 1){
                        queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withQuery:searchBar.text withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"UNREAD" withActivityTypeID:[NSNumber numberWithInt:2]];
                        
                    } else if (switchForFilter == 2){
                        queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withQuery:searchBar.text withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"RECENT" withActivityTypeID:[NSNumber numberWithInt:2]];
                        
                    } else {
                         queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withQuery:searchBar.text withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"" withActivityTypeID:[NSNumber numberWithInt:2]];
                    }
                    [[FISharedResources sharedResourceManager]getCuratedNewsListWithAccessToken:queryString withCategoryId:category withContentTypeId:parentId withFlag:@"" withLastArticleId:[curatedNews valueForKey:@"articleId"] withActivityTypeId:[NSNumber numberWithInt:2]];
                    
                } else if([category isEqualToNumber:[NSNumber numberWithInt:-3]]) {
                    //Handle saved for later
                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"SavedForLaterIsNew"];
                    NSString *queryString;
//                    if (isSearching) {
//                         queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withQuery:searchBar.text withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"" withActivityTypeID:[NSNumber numberWithInt:3]];
//                    } else
                        if (switchForFilter == 1){
                        queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withQuery:searchBar.text withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"UNREAD" withActivityTypeID:[NSNumber numberWithInt:3]];
                        
                    } else if (switchForFilter == 2){
                        queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withQuery:searchBar.text withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"RECENT" withActivityTypeID:[NSNumber numberWithInt:3]];
                        
                    }else {
                        queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withQuery:searchBar.text withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"" withActivityTypeID:[NSNumber numberWithInt:3]];
                    }
                    
                    [[FISharedResources sharedResourceManager]getCuratedNewsListWithAccessToken:queryString withCategoryId:category withContentTypeId:parentId withFlag:@"" withLastArticleId:[curatedNews valueForKey:@"articleId"] withActivityTypeId:[NSNumber numberWithInt:3]];
                    
                } else {
                    //handle other modules
                    NSString *queryString;
//                   if (isSearching) {
//                       queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:parentId withPageNumber:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withQuery:searchBar.text withContentCategoryId:category withOrderBy:@"" withFilterBy:@"" withActivityTypeID:[NSNumber numberWithInt:0]];
//                   } else
                       if (switchForFilter == 1){
                       queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withQuery:searchBar.text withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"UNREAD" withActivityTypeID:[NSNumber numberWithInt:0]];
                       
                   } else if (switchForFilter == 2){
                       queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withQuery:searchBar.text withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"RECENT" withActivityTypeID:[NSNumber numberWithInt:0]];
                       
                   }else {
                        queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:parentId withPageNumber:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withQuery:searchBar.text withContentCategoryId:category withOrderBy:@"" withFilterBy:@"" withActivityTypeID:[NSNumber numberWithInt:0]];
                   }
                    
                    [[FISharedResources sharedResourceManager]getCuratedNewsListWithAccessToken:queryString withCategoryId:category withContentTypeId:parentId withFlag:@"" withLastArticleId:[curatedNews valueForKey:@"articleId"] withActivityTypeId:[NSNumber numberWithInt:0]];
                    
                }
                
            } else if(![newsLetterId isEqualToNumber:[NSNumber numberWithInt:0]]) {
//                if (isSearching) {
//                    [[FISharedResources sharedResourceManager]fetchArticleFromNewsLetterWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withNewsLetterId:newsLetterId withPageNo:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withUpFlag:NO withFlag:NO withQuery:searchBar.text withFilterBy:@""];
//                } else
                    if (switchForFilter == 1){
                    [[FISharedResources sharedResourceManager]fetchArticleFromNewsLetterWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withNewsLetterId:newsLetterId withPageNo:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withUpFlag:NO withFlag:NO withQuery:searchBar.text withFilterBy:@"UNREAD"];
                    
                    
                } else if (switchForFilter == 2){
                    [[FISharedResources sharedResourceManager]fetchArticleFromNewsLetterWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withNewsLetterId:newsLetterId withPageNo:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withUpFlag:NO withFlag:NO withQuery:searchBar.text withFilterBy:@"RECENT"];
                    
                } else {
                    [[FISharedResources sharedResourceManager]fetchArticleFromNewsLetterWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withNewsLetterId:newsLetterId withPageNo:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withUpFlag:NO withFlag:NO withQuery:searchBar.text withFilterBy:@""];
                }
            }else if(![folderId isEqualToNumber:[NSNumber numberWithInt:0]]){
                [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"FetchNextArticlesList"];
//                if (isSearching) {
//                    [[FISharedResources sharedResourceManager]fetchArticleFromFolderWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withFolderId:folderId withPageNo:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withUpFlag:NO withQuery:searchBar.text withFilterBy:@""];
//                } else
                    if (switchForFilter == 1){
                    [[FISharedResources sharedResourceManager]fetchArticleFromFolderWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withFolderId:folderId withPageNo:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withUpFlag:NO withQuery:searchBar.text withFilterBy:@"UNREAD"];
                } else if (switchForFilter == 2){
                    [[FISharedResources sharedResourceManager]fetchArticleFromFolderWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withFolderId:folderId withPageNo:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withUpFlag:NO withQuery:searchBar.text withFilterBy:@"RECENT"];
                    
                } else {
                    [[FISharedResources sharedResourceManager]fetchArticleFromFolderWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withFolderId:folderId withPageNo:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withUpFlag:NO withQuery:searchBar.text withFilterBy:@""];
                }
                
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



- (BOOL)clearSearchedDataFromTable:(NSString *)tableName{
    NSManagedObjectContext *myContext = [[FISharedResources sharedResourceManager] managedObjectContext];
    NSFetchRequest *fetchAllObjects = [[NSFetchRequest alloc] init];
    [fetchAllObjects setEntity:[NSEntityDescription entityForName:tableName inManagedObjectContext:myContext]];
    [fetchAllObjects setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSearch == %@",[NSNumber numberWithBool:YES]];
    [fetchAllObjects setPredicate:predicate];
    NSError *error = nil;
    NSArray *allObjects = [myContext executeFetchRequest:fetchAllObjects error:&error];
    for (NSManagedObject *object in allObjects) {
        [myContext deleteObject:object];
    }
    
    NSError *saveError = nil;
    if (![myContext save:&saveError]) {
        
    }
    
    return (saveError == nil);
}


- (BOOL)clearFilteredDataFromTable:(NSString *)tableName{
    NSManagedObjectContext *myContext = [[FISharedResources sharedResourceManager] managedObjectContext];
    NSFetchRequest *fetchAllObjects = [[NSFetchRequest alloc] init];
    [fetchAllObjects setEntity:[NSEntityDescription entityForName:tableName inManagedObjectContext:myContext]];
    [fetchAllObjects setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFilter == %@ OR isFilter == %@",[NSNumber numberWithInt:1],[NSNumber numberWithInt:2]];
    [fetchAllObjects setPredicate:predicate];
    NSError *error = nil;
    NSArray *allObjects = [myContext executeFetchRequest:fetchAllObjects error:&error];
    for (NSManagedObject *object in allObjects) {
        [myContext deleteObject:object];
    }
    
    NSError *saveError = nil;
    if (![myContext save:&saveError]) {
        
    }
    
    return (saveError == nil);
}

- (IBAction)filterButtonClick:(id)sender {
    UIButton *filterBtn = (UIButton *)sender;
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MoreSettingsViewPhone" bundle:nil];
    MoreSettingsView *popOverView = [storyBoard instantiateViewControllerWithIdentifier:@"MoreSettingsView"];
    popOverView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.view.alpha = 0.65;
    popOverView.dropDownValue = 1;
    popOverView.xPositions = filterBtn.frame.origin.x;
    popOverView.yPositions =filterBtn.frame.origin.y;
    popOverView.buttonWidth = filterBtn.frame.size.width;
    popOverView.buttonHeight = filterBtn.frame.size.height;
    [self presentViewController:popOverView animated:NO completion:nil];
}

- (IBAction)actionsButtonClick:(id)sender {
    UIButton *actionsBtn = (UIButton *)sender;
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MoreSettingsViewPhone" bundle:nil];
    MoreSettingsView *popOverView = [storyBoard instantiateViewControllerWithIdentifier:@"MoreSettingsView"];
    popOverView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.view.alpha = 0.65;
    popOverView.dropDownValue = 2;
    popOverView.xPositions = actionsBtn.frame.origin.x;
    popOverView.yPositions =actionsBtn.frame.origin.y;
    popOverView.buttonWidth = actionsBtn.frame.size.width;
    popOverView.buttonHeight = actionsBtn.frame.size.height;
    [self presentViewController:popOverView animated:NO completion:nil];
}
- (IBAction)segmentControlAction:(id)sender {
   // [unreadArticleIdArray removeAllObjects];
    [self loadCuratedNews];
    NSLog(@"after segment control cnt:%d",self.filterArray.count);
    [self.articlesTableView reloadData];
}
@end
