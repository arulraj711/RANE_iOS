//
//  CorporateNewsListView.m
//  FullIntel
//
//  Created by Arul on 3/18/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

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
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define UIColorFromRGB(rgbValue)[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface CorporateNewsListView ()

@end

@implementation CorporateNewsListView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.revealController showViewController:self.revealController.leftViewController];
    messageString = @"Loading...";
    // NSLog(@"list did load");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCuratedNews) name:@"CuratedNews" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failToLoad) name:@"CuratedNewsFail" object:nil];
    self.isNewsLetterNav = NO;
    //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newsLetterNavigationToArticle:) name:@"NewsLetterNavigation" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopLoading) name:@"StopLoading" object:nil];
    
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
    
    
    
    // [self.revealController showViewController:self.revealController.leftViewController];
    UIButton *Btn =[UIButton buttonWithType:UIButtonTypeCustom];
    
    [Btn setFrame:CGRectMake(0.0f,0.0f,16.0f,15.0f)];
    [Btn setBackgroundImage:[UIImage imageNamed:@"navmenu"]  forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(backBtnPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    [self.navigationItem setLeftBarButtonItem:addButton];
    
    UIView *addBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    addBtnView.backgroundColor = [UIColor clearColor];
    
    UIButton *addBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setFrame:CGRectMake(0,0,40,40)];
    [addBtn setImage :[UIImage imageNamed:@"addcontent"]  forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addContentView) forControlEvents:UIControlEventTouchUpInside];
    [addBtnView addSubview:addBtn];
    UIBarButtonItem *addContentButton = [[UIBarButtonItem alloc] initWithCustomView:addBtnView];
    
    //    UIView *searchBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 15)];
    //    searchBtnView.backgroundColor = [UIColor clearColor];
    //    UIButton *searchBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    //    [searchBtn setFrame:CGRectMake(0.0f,0.0f,16.0f,15.0f)];
    //    [searchBtn setBackgroundImage:[UIImage imageNamed:@"rss_whiteicon"]  forState:UIControlStateNormal];
    //    [searchBtn setTitle:@"RSS" forState:UIControlStateNormal];
    //    [searchBtn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    //    [searchBtnView addSubview:searchBtn];
    //    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithCustomView:searchBtnView];
    //
    
    
    [self addRightBarItems];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Open Sans" size:16];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.text =_titleName;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    
    
    
    refreshControl = [[UIRefreshControl alloc]init];
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
    
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"TutorialBoxShown"];
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"TutorialShown"];
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"MarkImportantTutorialTrigger"];
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"SwipeUpAndDownTutorialTrigger"];
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"SwipeDownTutorialTrigger"];
    
    
    
    [self.revealController showViewController:self.revealController.leftViewController];
    
    
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

-(void)endOfTutorial{
    
    
    [self.revealController showViewController:self.revealController.leftViewController];
    
    
    
    UIStoryboard *centerStoryBoard = [UIStoryboard storyboardWithName:@"Tutorial" bundle:nil];
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
    
    
    
    UIStoryboard *centerStoryBoard = [UIStoryboard storyboardWithName:@"Tutorial" bundle:nil];
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

-(void)viewDidAppear:(BOOL)animated {
    self.articlesTableView.dataSource = nil;
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
        }        //        UIWindow *window = [[UIApplication sharedApplication]windows][0];
        //        [window addSubview:loginView.view];
    }
    
    
    //[self presentViewController:loginView animated:YES completion:nil];
}

-(void)stopLoading {
    NSLog(@"stop loading is calling");
    messageString = @"No articles to display";
    [activityIndicator stopAnimating];
    [self.articlesTableView reloadData];
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
    // NSLog(@"category id in curated news:%@",categoryId);
    self.devices = [[NSMutableArray alloc]init];
    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
    NSPredicate *predicate;
    if([newsLetterId isEqualToNumber:[NSNumber numberWithInt:1]]) {
        predicate  = [NSPredicate predicateWithFormat:@"newsletterId == %@",newsLetterId];
        
    } else {
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


-(void)loadLocalData {
    
    
    
    
    self.articlesTableView.dataSource = self;
    self.articlesTableView.delegate = self;
    NSNumber *categoryId = [[NSUserDefaults standardUserDefaults]objectForKey:@"categoryId"];
    NSNumber *folderId = [[NSUserDefaults standardUserDefaults]objectForKey:@"folderId"];
    NSNumber *contentTypeId = [[NSUserDefaults standardUserDefaults]objectForKey:@"parentId"];
    NSLog(@"load curated news list:%@ and folderid:%@",categoryId,folderId);
    // NSLog(@"category id in curated news:%@",categoryId);
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
    if([folderId isEqualToNumber:[NSNumber numberWithInt:0]]) {
        // NSInteger category = categoryStr.integerValue;
        NSString *inputJson;
        if([category isEqualToNumber:[NSNumber numberWithInt:-2]]) {
            inputJson = [FIUtils createInputJsonForContentWithToekn:[[NSUserDefaults standardUserDefaults] valueForKey:@"accesstoken"] lastArticleId:@"" contentTypeId:[NSNumber numberWithInt:1] listSize:10 activityTypeId:@"2" categoryId:nil];
        } else if([category isEqualToNumber:[NSNumber numberWithInt:-3]]) {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"SavedForLaterIsNew"];
            inputJson = [FIUtils createInputJsonForContentWithToekn:[[NSUserDefaults standardUserDefaults] valueForKey:@"accesstoken"] lastArticleId:@"" contentTypeId:[NSNumber numberWithInt:1] listSize:10 activityTypeId:@"3" categoryId:nil];
        } else {
            
            NSNumber *parentId = [[NSUserDefaults standardUserDefaults]objectForKey:@"parentId"];
            NSLog(@"parent id:%@",parentId);
            inputJson = [FIUtils createInputJsonForContentWithToekn:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] lastArticleId:@"" contentTypeId:parentId listSize:10 activityTypeId:@"" categoryId:category];
        }
        NSLog(@"input json:%@",inputJson);
        NSNumber *contentTypeId = [[NSUserDefaults standardUserDefaults]objectForKey:@"parentId"];
        [[FISharedResources sharedResourceManager]getCuratedNewsListWithAccessToken:inputJson withCategoryId:[[NSUserDefaults standardUserDefaults] valueForKey:@"categoryId"] withContentTypeId:contentTypeId withFlag:@"up" withLastArticleId:@""];
        // }
    } else {
        [[FISharedResources sharedResourceManager]fetchArticleFromFolderWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withFolderId:folderId withOffset:[NSNumber numberWithInt:0] withLimit:[NSNumber numberWithInt:5] withUpFlag:YES];
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
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"AddContent" bundle:nil];
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    UINavigationController *modalController = [storyBoard instantiateViewControllerWithIdentifier:@"addContentNav"];
    formSheet = [[MZFormSheetController alloc] initWithViewController:modalController];
    
    if(orientation == 1) {
        formSheet.presentedFormSheetSize = CGSizeMake(760, 650);
    } else {
        formSheet.presentedFormSheetSize = CGSizeMake(800, 650);
    }
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableCell;
    if(self.devices.count != 0) {
        //whatever else to configure your one cell you're going to return
        CorporateNewsCell *cell = (CorporateNewsCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
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
        NSString *dateStr = [FIUtils getDateFromTimeStamp:[[curatedNews valueForKey:@"publishedDate"] doubleValue]];
        cell.articleDate.text = dateStr;
        [cell.articleImageView sd_setImageWithURL:[NSURL URLWithString:[curatedNews valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"FI"]];
        [cell.articleImageView setContentMode:UIViewContentModeScaleAspectFill];
        cell.articleNumber.text = [curatedNews valueForKey:@"articleId"];
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
        // NSLog(@"multiple author array:%@",multipleAuthorArray);
        //cell.authorTitle.text = [author valueForKey:@"title"];
        //[cell.authorImageView sd_setImageWithURL:[NSURL URLWithString:[author valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"FI"]];
        
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
//        cell.outlet.text = [curatedNews valueForKey:@"outlet"];
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
            cell.contentView.alpha = 0.5;
        } else {
            cell.readStatusImageView.hidden = YES;
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
    
    
    
    tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return tableCell;
}

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
        cell.contentView.alpha = 0.5;
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
    //else
    // [headerView setBackgroundColor:[UIColor clearColor]];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
        NSString *userAccountTypeId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userAccountTypeId"]];
        CorporateNewsDetailsView *testView;
        //        if([userAccountTypeId isEqualToString:@"3"]) {
        //            testView = [storyBoard instantiateViewControllerWithIdentifier:@"NormalView"];
        //        }else if([userAccountTypeId isEqualToString:@"2"] || [userAccountTypeId isEqualToString:@"1"]) {
        testView = [storyBoard instantiateViewControllerWithIdentifier:@"UpgradeView"];
        // }
        testView.currentIndex = indexPath.row;
        testView.selectedIndexPath = indexPath;
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
        //[FIUtils showNoNetworkToast];
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
                    [[FISharedResources sharedResourceManager]getCuratedNewsDetailsWithDetails:resultStr];
                    [[FISharedResources sharedResourceManager]getCuratedNewsAuthorDetailsWithDetails:authorResultStr withArticleId:[curatedNews valueForKey:@"articleId"]];
                    
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

- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView
                  willDecelerate:(BOOL)decelerate{
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
            // NSInteger category = categoryStr.integerValue;
            if([folderId isEqualToNumber:[NSNumber numberWithInt:0]]) {
                if([category isEqualToNumber:[NSNumber numberWithInt:-2]]) {
                    inputJson = [FIUtils createInputJsonForContentWithToekn:[[NSUserDefaults standardUserDefaults] valueForKey:@"accesstoken"] lastArticleId:[curatedNews valueForKey:@"articleId"] contentTypeId:[NSNumber numberWithInt:1] listSize:10 activityTypeId:@"2" categoryId:nil];
                } else if([category isEqualToNumber:[NSNumber numberWithInt:-3]]) {
                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"SavedForLaterIsNew"];
                    inputJson = [FIUtils createInputJsonForContentWithToekn:[[NSUserDefaults standardUserDefaults] valueForKey:@"accesstoken"] lastArticleId:[curatedNews valueForKey:@"articleId"] contentTypeId:[NSNumber numberWithInt:1] listSize:10 activityTypeId:@"3" categoryId:nil];
                } else {
                    NSNumber *parentId = [[NSUserDefaults standardUserDefaults]objectForKey:@"parentId"];
                    NSLog(@"parent id:%@",parentId);
                    inputJson = [FIUtils createInputJsonForContentWithToekn:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] lastArticleId:[curatedNews valueForKey:@"articleId"] contentTypeId:parentId listSize:10 activityTypeId:@"" categoryId:category];
                    
                    
                }
                [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"FetchNextArticlesList"];
                NSNumber *contentTypeId = [[NSUserDefaults standardUserDefaults]objectForKey:@"parentId"];
                [[FISharedResources sharedResourceManager]getCuratedNewsListWithAccessToken:inputJson withCategoryId:[[NSUserDefaults standardUserDefaults] valueForKey:@"categoryId"] withContentTypeId:contentTypeId withFlag:@"" withLastArticleId:[curatedNews valueForKey:@"articleId"]];
            } else {
                [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"FetchNextArticlesList"];
                [[FISharedResources sharedResourceManager]fetchArticleFromFolderWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withFolderId:folderId withOffset:[NSNumber numberWithInt:self.devices.count] withLimit:[NSNumber numberWithInt:5] withUpFlag:NO];
            }
        }
        //[self reloadData];
    }
}


-(void)requestChange:(id)sender {
    
    
    UIStoryboard *centerStoryBoard = [UIStoryboard storyboardWithName:@"ResearchRequest" bundle:nil];
    UINavigationController *popOverView =[centerStoryBoard instantiateViewControllerWithIdentifier:@"requestNav"];
    
    ResearchRequestPopoverView *researchViewController=(ResearchRequestPopoverView *)[[popOverView viewControllers]objectAtIndex:0];
    // ResearchRequestPopoverView *popOverView = [[ResearchRequestPopoverView alloc]initWithNibName:@"ResearchRequestPopoverView" bundle:nil];
    //   popOverView.transitioningDelegate = self;
    researchViewController.fromAddContent = YES;
    popOverView.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:popOverView animated:NO completion:nil];
}

@end
