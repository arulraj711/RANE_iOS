//
//  CorporateNewsDetailsTest.m
//  FullIntel
//
//  Created by Capestart on 5/13/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "CorporateNewsDetailsView.h"
#import "CorporateDetailCell.h"
#import "FISharedResources.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FIUtils.h"
#import "SocialWebView.h"
#import "MZFormSheetController.h"
#import "CommentsPopoverView.h"
#import "PresentingAnimator.h"
#import "DismissingAnimator.h"
#import "ResearchRequestPopoverView.h"
#import "MailPopoverView.h"
#import "SavedListPopoverView.h"
#import "UIView+Toast.h"
#import "pop.h"
#import "UILabel+CustomHeaderLabel.h"
#import "UIColor+CustomColor.h"


#define UIColorFromRGB(rgbValue)[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface CorporateNewsDetailsView ()

@end

@implementation CorporateNewsDetailsView
@synthesize forTopStories;
- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socialLinkSelected:) name:@"socialLinkSelected" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addOverLayForTutorial) name:@"DrillDownTutorialTrigger" object:nil];
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(afterSwipeDownTutorial) name:@"DrillInToolBoxTutorial" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endOfTutorial) name:@"EndOfDrillDownTutorial" object:nil];
    

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(widgetWebViewTrigger:) name:@"widgetWebViewCalled" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopLoadingForAlert) name:@"stopLoadingForAlert" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getArticleIdListFromDB) name:@"CuratedNewsDetailsUpdate" object:nil];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mailButtonClick:) name:@"mailButtonClick" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(globeButtonClick:) name:@"globeButtonClick" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCommentsView:) name:@"showCommentsView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentStatusUpdate:) name:@"commentStatusUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showResearchView:) name:@"showResearchView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWebView:) name:@"widgetSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(linkedinSelection:) name:@"linkedinSelection" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fbLinkSelection:) name:@"fbSelection" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextFolderClick:) name:@"nextFolderClick" object:nil];

    [self addCustomNavRightButton];
    oneSecondTicker = [[NSTimer alloc] init];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [self.collectionView setPagingEnabled:YES];
    [self.collectionView setCollectionViewLayout:flowLayout];
    // [self.collectionView reloadData];
    self.collectionView.dataSource = nil;
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.alpha = 1.0;
    activityIndicator.center = self.view.center;
    activityIndicator.hidesWhenStopped = YES;
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    innerWebView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-80)];
    // self.navigationItem.rightBarButtonItem =nil;
//    if (_isSearching == 1 || _switchForFilter==1 || _switchForFilter==2) {
//        self.articleIdArray = [[NSMutableArray alloc]initWithArray:self.articleIdFromSearchLst];
//        [self.collectionView reloadData];
//    }
//    else {
        [self getArticleIdListFromDB];

  //  }
    
    _tutorialTextBoxView.hidden=YES;
    _tutorialTextBoxView.layer.cornerRadius=5.0f;
    
}

-(void)endOfTutorial{
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"EndOfTutorial" object:nil];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    
    [super viewWillAppear:animated];
    
    [self.tutorialTextView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    
    [super viewWillDisappear:animated];
    
    [self.tutorialTextView removeObserver:self forKeyPath:@"contentSize"];
    
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    
    UITextView *tv = object;
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}


-(void)afterSwipeDownTutorial{
    
    
    coachMarks = @[
                   
                   @{
                       @"rect": [NSValue valueWithCGRect:CGRectMake(self.view.frame.origin.x+self.view.frame.size.width-360,self.view.frame.origin.y+self.view.frame.size.height-128,50,50)],
                       @"caption": @""
                       },
                   @{
                       @"rect": [NSValue valueWithCGRect:CGRectMake(self.view.frame.origin.x+self.view.frame.size.width-310,self.view.frame.origin.y+self.view.frame.size.height-128,50,50)],
                       @"caption": @""
                       },
                   
                   @{
                       @"rect": [NSValue valueWithCGRect:CGRectMake(self.view.frame.origin.x+self.view.frame.size.width-260,self.view.frame.origin.y+self.view.frame.size.height-128,50,50)],
                       @"caption": @""
                       },
                   
                   @{
                       @"rect": [NSValue valueWithCGRect:CGRectMake(self.view.frame.origin.x+self.view.frame.size.width-210,self.view.frame.origin.y+self.view.frame.size.height-128,50,50)],
                       @"caption": @""
                       },
                   
                   @{
                       @"rect": [NSValue valueWithCGRect:CGRectMake(self.view.frame.origin.x+self.view.frame.size.width-160,self.view.frame.origin.y+self.view.frame.size.height-128,50,50)],
                       @"caption": @""
                       },
                   
                   @{
                       @"rect": [NSValue valueWithCGRect:CGRectMake(self.view.frame.origin.x+self.view.frame.size.width-110,self.view.frame.origin.y+self.view.frame.size.height-128,50,50)],
                       @"caption": @""
                       },
                   
                   
                   @{
                       @"rect": [NSValue valueWithCGRect:CGRectMake(self.view.frame.origin.x+self.view.frame.size.width-60,self.view.frame.origin.y+self.view.frame.size.height-128,50,50)],
                       @"caption": @""
                       },
                   ];
    coachMarksView = [[WSCoachMarksView alloc] initWithFrame:self.view.bounds coachMarks:coachMarks];
    coachMarksView.delegate=self;
    [self.view addSubview:coachMarksView];
    [coachMarksView start];
    
    
    _tutorialTextBoxView.hidden=NO;
    
    
}


- (void)coachMarksView:(WSCoachMarksView*)coachMarksView didNavigateToIndex:(NSInteger)index{
    NSLog(@"Index:%ld",(long)index);
    
    NSString *indexString=[NSString stringWithFormat:@"%ld",(long)index];
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        if(index==0){
            
            _tutorialTextView.text=@"Mark Important";
            
        }else if (index==1){
            
            _tutorialTextView.text=@"Save For Later";
            
        }else if (index==2){
            
            _tutorialTextView.text=@"Comment";
            
        }else if (index==3){
            
            _tutorialTextView.text=@"Folder and RSS";
            
        }else if (index==4){
            
            
            _tutorialTextView.text=@"Research Request / Feedback";
        }else if (index==5){
            
            _tutorialTextView.text=@"Share";
            
        }else{
            
            _tutorialTextView.text=@"Share";
        }
    } else {
        if(index==0){
            
            _tutorialTextView.text=@"Mark Important";
            
        }else if (index==1){
            
            _tutorialTextView.text=@"Comment";
            
        }else if (index==2){
            
            _tutorialTextView.text=@"Email";
            
        }else if (index==3){
            
            _tutorialTextView.text=@"Folder and RSS";
            
        }else if (index==4){
            
            
            _tutorialTextView.text=@"Save For Later";
        }else if (index==5){
            
            _tutorialTextView.text=@"Research Request / Feedback";
            
        }else{
            
            _tutorialTextView.text=@"Share";
        }
    }
    
    
    
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DrillDownToolBoxTutorialNavigation" object:nil userInfo:@{@"index":indexString}];
    
    
    
}
- (void)coachMarksViewDidCleanup:(WSCoachMarksView*)coachMarksView{
    
    
    
    
    _tutorialTextBoxView.hidden=YES;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"coachMardRemoved" object:nil];
    
    
}
-(void)addOverLayForTutorial{
    
    
    
    UIStoryboard *centerStoryBoard;
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){
        centerStoryBoard = [UIStoryboard storyboardWithName:@"TutorialiPhone" bundle:nil];
    } else {
        centerStoryBoard = [UIStoryboard storyboardWithName:@"Tutorial" bundle:nil];
    }
    // UIViewController *popOverView =[centerStoryBoard instantiateViewControllerWithIdentifier:@"MainListTutorialViewController"];
    
    UINavigationController *popOverView =[centerStoryBoard instantiateViewControllerWithIdentifier:@"DrillDownListTutorialViewController"];
    popOverView.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:popOverView animated:NO completion:nil];
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    //[[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"firstTimeFlag"];
    [activityIndicator stopAnimating];
    
    [[FISharedResources sharedResourceManager]tagScreenInLocalytics:@"Curated List Detailed View"];
    
    // [[FISharedResources sharedResourceManager]tagScreenInLocalytics:@"Curated List Detailed View"];
    CGSize currentSize = self.collectionView.bounds.size;
    float offset = self.currentIndex * currentSize.width;
    [self.collectionView setContentOffset:CGPointMake(offset, 0)];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
}



-(void)addCustomNavRightButton {
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
//        label.backgroundColor = [UIColor clearColor];
//        label.font = [UIFont fontWithName:@"Open Sans" size:17];
//        label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
//        label.text = self.articleTitle;
//        label.textAlignment = NSTextAlignmentCenter;
//        label.textColor = [UIColor whiteColor]; // change this color
        self.navigationItem.titleView = [UILabel setCustomHeaderLabelFromText:self.articleTitle];
    }
    
    
    UIView *addBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    addBtnView.backgroundColor = [UIColor clearColor];
    
    UIButton *addBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setFrame:CGRectMake(0.0f,0.0f,35,35)];
    
    BOOL isFIViewSelected = [[NSUserDefaults standardUserDefaults]boolForKey:@"isFIViewSelected"];
    if(isFIViewSelected) {
        NSLog(@"fi view is selected");
        [addBtn setBackgroundImage:[UIImage imageNamed:@"nav_globe"]  forState:UIControlStateNormal];
        [addBtn setSelected:YES];
    } else {
        NSLog(@"fi view is not selected");
        
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *webviewImagePath = [documentsDirectory stringByAppendingPathComponent:@"webviewImage.png"];
        
        [addBtn setBackgroundImage:[UIImage imageWithContentsOfFile:webviewImagePath]  forState:UIControlStateNormal];
        [addBtn setSelected:NO];
    }
    [addBtn addTarget:self action:@selector(globeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [addBtnView addSubview:addBtn];
    UIBarButtonItem *addContentButton = [[UIBarButtonItem alloc] initWithCustomView:addBtnView];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:addContentButton,  nil]];
}

-(void)getArticleIdListFromDB {
    if ([forTopStories isEqualToNumber:[NSNumber numberWithInt:1]]) {
        self.articleIdArray =  [NSMutableArray arrayWithArray:_articleIdFromSearchLst];
        NSLog(@"selected article id:%@",self.articleIdArray);
        
        NSManagedObjectContext *context = [[FISharedResources sharedResourceManager]managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"CuratedNews" inManagedObjectContext:context];
        NSPredicate *predicate;
        predicate = [NSPredicate predicateWithFormat:@"isFromTopStories == %@",[NSNumber numberWithBool:YES]];
        [fetchRequest setPredicate:predicate];
        [fetchRequest setEntity:entity];
        
        NSSortDescriptor *date = [[NSSortDescriptor alloc] initWithKey:@"modifiedDate" ascending:NO];
        
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:date, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
        
        NSMutableArray *elementsFromColumn = [[NSMutableArray alloc] init];
        for (NSManagedObject *fetchedObject in fetchedObjects) {
            [elementsFromColumn addObject:[fetchedObject valueForKey:@"articleId"]];
        }
        
        NSLog(@"elementsfrom column:%@",elementsFromColumn);
        self.articleIdArray = [[NSMutableArray alloc]initWithArray:elementsFromColumn];
        NSLog(@"article id array:%@ and selected articleId:%@",self.articleIdArray,self.selectedNewsArticleId);
        if(self.selectedNewsArticleId.length != 0) {
            NSInteger atIndex = [self.articleIdArray indexOfObject:self.selectedNewsArticleId];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:atIndex inSection:0];
            self.selectedIndexPath = indexPath;
            //            [self.view layoutIfNeeded];
            //            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
            NSLog(@"selected indexpath:%ld",(long)self.selectedIndexPath.row);
            [self.collectionView reloadData];
        } else {
            if(self.articleIdArray.count != 0) {
                [self.collectionView reloadData];
            }
        }
        
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    else{
        BOOL testFlag = [[NSUserDefaults standardUserDefaults]boolForKey:@"Test"];
        if(testFlag) {
            NSLog(@"test flag is TRUE");
            
            [self.activityIndicator stopAnimating];
            [oneSecondTicker invalidate];
            NSNumber *categoryId = [[NSUserDefaults standardUserDefaults]objectForKey:@"categoryId"];
            NSNumber *folderId = [[NSUserDefaults standardUserDefaults]objectForKey:@"folderId"];
            NSNumber *contentTypeId = [[NSUserDefaults standardUserDefaults]objectForKey:@"parentId"];
            NSNumber *newsLetterId = [[NSUserDefaults standardUserDefaults]objectForKey:@"newsletterId"];
            self.collectionView.scrollEnabled = YES;
            NSManagedObjectContext *context = [[FISharedResources sharedResourceManager]managedObjectContext];
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"CuratedNews" inManagedObjectContext:context];
            NSPredicate *predicate;
            NSLog(@"newsletter id:%@ and %@",newsLetterId,self.isFromChart);
            if([self.isFromChart isEqualToNumber:[NSNumber numberWithInt:1]]) {
                if(self.isSearching) {
                    predicate = [NSPredicate predicateWithFormat:@"isFromChart == %@ AND isSearch == %@",[NSNumber numberWithBool:YES],[NSNumber numberWithBool:self.isSearching]];
                } else if(self.switchForFilter == 1) {
                    predicate = [NSPredicate predicateWithFormat:@"isFromChart == %@ AND isFilter == %@",[NSNumber numberWithBool:YES],[NSNumber numberWithInt:self.switchForFilter]];
                } else if(self.switchForFilter == 2) {
                    predicate = [NSPredicate predicateWithFormat:@"isFromChart == %@ AND isFilter == %@",[NSNumber numberWithBool:YES],[NSNumber numberWithInt:self.switchForFilter]];
                } else {
                    predicate = [NSPredicate predicateWithFormat:@"isFromChart == %@",[NSNumber numberWithBool:YES]];
                }
            } else {
                if([newsLetterId isEqualToNumber:[NSNumber numberWithInt:0]] && [folderId isEqualToNumber:[NSNumber numberWithInt:0]]) {
                    BOOL savedForLaterIsNew =[[NSUserDefaults standardUserDefaults]boolForKey:@"SavedForLaterIsNew"];
                    if([categoryId isEqualToNumber:[NSNumber numberWithInt:-3]]) {
                        if(self.isSearching) {
                            predicate  = [NSPredicate predicateWithFormat:@"saveForLater == %@ AND categoryId==%@ AND isSearch == %@",[NSNumber numberWithBool:YES],categoryId,[NSNumber numberWithBool:self.isSearching]];
                        } else if(self.switchForFilter == 1) {
                            predicate  = [NSPredicate predicateWithFormat:@"saveForLater == %@ AND categoryId==%@ AND isFilter == %@",[NSNumber numberWithBool:YES],categoryId,[NSNumber numberWithInt:self.switchForFilter]];
                        } else if(self.switchForFilter == 2) {
                            predicate  = [NSPredicate predicateWithFormat:@"saveForLater == %@ AND categoryId==%@ AND isFilter == %@",[NSNumber numberWithBool:YES],categoryId,[NSNumber numberWithInt:self.switchForFilter]];
                        } else {
                            predicate  = [NSPredicate predicateWithFormat:@"saveForLater == %@ AND categoryId==%@",[NSNumber numberWithBool:YES],categoryId];
                        }
                    } else {
                        if(self.isSearching) {
                            predicate  = [NSPredicate predicateWithFormat:@"categoryId==%@ AND contentTypeId==%@ AND isSearch == %@",categoryId,contentTypeId,[NSNumber numberWithBool:self.isSearching]];
                        } else if(self.switchForFilter == 1) {
                            predicate  = [NSPredicate predicateWithFormat:@"categoryId==%@ AND contentTypeId==%@ AND isFilter == %@",categoryId,contentTypeId,[NSNumber numberWithInt:self.switchForFilter]];
                        } else if(self.switchForFilter == 2) {
                            predicate  = [NSPredicate predicateWithFormat:@"categoryId==%@ AND contentTypeId==%@ AND isFilter == %@",categoryId,contentTypeId,[NSNumber numberWithInt:self.switchForFilter]];
                        } else {
                            predicate  = [NSPredicate predicateWithFormat:@"categoryId==%@ AND contentTypeId==%@",categoryId,contentTypeId];
                        }
                        
                    }
                } else if(![folderId isEqualToNumber:[NSNumber numberWithInt:0]]) {
                    if(self.isSearching) {
                        predicate  = [NSPredicate predicateWithFormat:@"isFolder == %@ AND folderId == %@ AND isSearch == %@",[NSNumber numberWithBool:YES],folderId,[NSNumber numberWithBool:self.isSearching]];
                    } else if(self.switchForFilter == 1) {
                        predicate  = [NSPredicate predicateWithFormat:@"isFolder == %@ AND folderId == %@ AND isFilter == %@",[NSNumber numberWithBool:YES],folderId,[NSNumber numberWithInt:self.switchForFilter]];
                    } else if(self.switchForFilter == 2) {
                        predicate  = [NSPredicate predicateWithFormat:@"isFolder == %@ AND folderId == %@ AND isFilter == %@",[NSNumber numberWithBool:YES],folderId,[NSNumber numberWithInt:self.switchForFilter]];
                    } else {
                        predicate  = [NSPredicate predicateWithFormat:@"isFolder == %@ AND folderId == %@",[NSNumber numberWithBool:YES],folderId];
                    }
                } else if(![newsLetterId isEqualToNumber:[NSNumber numberWithInt:0]]) {
                    [self.revealController showViewController:self.revealController.frontViewController];
                    if(self.isSearching) {
                        predicate  = [NSPredicate predicateWithFormat:@"newsletterId == %@ AND isSearch == %@",newsLetterId,[NSNumber numberWithBool:self.isSearching]];
                    } else if(self.switchForFilter == 1) {
                        predicate  = [NSPredicate predicateWithFormat:@"newsletterId == %@ AND isFilter == %@",newsLetterId,[NSNumber numberWithInt:self.switchForFilter]];
                    } else if(self.switchForFilter == 2) {
                        predicate  = [NSPredicate predicateWithFormat:@"newsletterId == %@ AND isFilter == %@",newsLetterId,[NSNumber numberWithInt:self.switchForFilter]];
                    } else {
                        predicate  = [NSPredicate predicateWithFormat:@"newsletterId == %@",newsLetterId];
                    }
                    
                }
            }
            
            [fetchRequest setPredicate:predicate];
            [fetchRequest setEntity:entity];
            
            NSSortDescriptor *date = [[NSSortDescriptor alloc] initWithKey:@"modifiedDate" ascending:NO];
            
            NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:date, nil];
            [fetchRequest setSortDescriptors:sortDescriptors];
            
            
            NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
            
            NSMutableArray *elementsFromColumn = [[NSMutableArray alloc] init];
            for (NSManagedObject *fetchedObject in fetchedObjects) {
                [elementsFromColumn addObject:[fetchedObject valueForKey:@"articleId"]];
            }
            
            NSLog(@"elementsfrom column:%@",elementsFromColumn);
            self.articleIdArray = [[NSMutableArray alloc]initWithArray:elementsFromColumn];
            NSLog(@"article id array:%@ and selected articleId:%@",self.articleIdArray,self.selectedNewsArticleId);
            if(self.selectedNewsArticleId.length != 0) {
                NSInteger atIndex = [self.articleIdArray indexOfObject:self.selectedNewsArticleId];
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:atIndex inSection:0];
                self.selectedIndexPath = indexPath;
                //            [self.view layoutIfNeeded];
                //            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
                NSLog(@"selected indexpath:%ld",(long)self.selectedIndexPath.row);
                [self.collectionView reloadData];
            } else {
                if(self.articleIdArray.count != 0) {
                    if(self.callAPIFromDrillIn) {
                        CGSize currentSize = self.collectionView.bounds.size;
                        int newValue = self.currentIndex+1;
                        float offset = newValue * currentSize.width;
                        [self.collectionView setContentOffset:CGPointMake(offset, 0)];
                    } else {
                        
                    }
                    
                    [self.collectionView reloadData];
                }
            }
        } else {
            NSLog(@"test flag is FALSE");
        }
        NSLog(@"selected article id:%@",self.articleIdArray);
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];

    }
}


- (void)deviceOrientationDidChange:(NSNotification *)notification {
    NSLog(@"device orientation changes");
    [self.collectionView reloadData];
    //Obtaining the current device orientation
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    //Ignoring specific orientations
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown) {
        return;
    }
    
    // We need to allow a slight pause before running handler to make sure rotation has been processed by the view hierarchy
    // [self performSelectorOnMainThread:@selector(handleDeviceOrientationChange:) withObject:coachMarksView waitUntilDone:NO];
}

//- (void)handleDeviceOrientationChange:(WSCoachMarksView*)coachMarksView {
//
//    // Begin the whole coach marks process again from the beginning, rebuilding the coachmarks with updated co-ordinates
//
//
//}



-(void)commentStatusUpdate:(id)sender {
    NSNotification *notification = sender;
    NSDictionary *userInfo = notification.userInfo;
    NSIndexPath *indexPath = [userInfo objectForKey:@"indexPath"];
    NSNumber *totalComments = [userInfo objectForKey:@"totalComments"];
    // NSLog(@"select indexpath row:%d and total comments:%@",indexPath.row,totalComments);
    // NSNumber  = [userInfo objectForKey:@"status"];
    // NSManagedObject *curatedNews = [self.devices objectAtIndex:indexPath.row];
    
    
    CorporateDetailCell *cell = (CorporateDetailCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    
    
    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@",[self.articleIdArray objectAtIndex:indexPath.row]];
    [fetchRequest setPredicate:predicate];
    NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if(newPerson.count != 0) {
        NSManagedObject *curatedNews = [newPerson objectAtIndex:0];
        NSManagedObject *curatedNewsDetails = [curatedNews valueForKey:@"details"];
        [curatedNewsDetails setValue:[NSNumber numberWithInt:0] forKey:@"unReadComment"];
        [curatedNewsDetails setValue:totalComments forKey:@"totalComments"];
        [curatedNews setValue:curatedNewsDetails forKey:@"details"];
    }
    [managedObjectContext save:nil];
//    NSNumber *unreadCnt = [curatedNewsDetail valueForKey:@"unReadComment"];
//  //  NSNumber *totalCnt = [curatedNewsDetail valueForKey:@"totalComments"];
//    if([unreadCnt isEqualToNumber:[NSNumber numberWithInt:0]]) {
//    cell.badgeTwo.value =[totalComments integerValue];
//    cell.badgeTwo.fillColor = UIColorFromRGB(0xbcbcbc);
//    }
}

-(void)fbLinkSelection:(id)sender {
    
    NSNotification *notification = sender;
    NSDictionary *userInfo = notification.userInfo;
    NSString *articleUrl = [userInfo objectForKey:@"artileUrl"];
    NSString *articleTitle = [userInfo objectForKey:@"articleTitle"];
    NSString *articleDesc = [userInfo objectForKey:@"articleDescription"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    UIStoryboard *storyBoard;
    SocialWebView *socialWebViewObj;
    UINavigationController *modalController;
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        storyBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListViewPhone" bundle:nil];
        modalController = [storyBoard instantiateViewControllerWithIdentifier:@"SocialWebViewPhone"];
        socialWebViewObj=(SocialWebView *)[[modalController viewControllers]objectAtIndex:0];
        socialWebViewObj.titleStr=@"";
        
    } else {
        storyBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];
        modalController = [storyBoard instantiateViewControllerWithIdentifier:@"SocialWebView"];
        socialWebViewObj=(SocialWebView *)[[modalController viewControllers]objectAtIndex:0];
        socialWebViewObj.titleStr=@"";
        
    }

    
    //    NSString *urlString = [NSString stringWithFormat:@"https://www.linkedin.com/shareArticle?mini=true&url=%@&title=%@&summary=%@&source=LinkedIn",articleUrl,articleTitle,articleDesc];
    
    NSString *urlString=[NSString stringWithFormat:@"https://www.facebook.com/dialog/feed?_path=feed&app_id=%@&client_id=%@&redirect_uri=%@&display=popup&caption=%@&link=%@&from_login=1",[[NSUserDefaults standardUserDefaults] objectForKey:@"facebookApiId"],[[NSUserDefaults standardUserDefaults] objectForKey:@"facebookClientId"],[[NSUserDefaults standardUserDefaults] objectForKey:@"facebookRedirectUrl"],articleTitle,articleUrl];
    
    NSLog(@"linked in url:%@",urlString);
    NSString* urlTextEscaped = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"after link:%@",urlTextEscaped);
    socialWebViewObj.urlString=urlTextEscaped;
    modalController.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:modalController animated:NO completion:^{
        // [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
}

-(void)linkedinSelection:(id)sender {
    
    NSNotification *notification = sender;
    NSDictionary *userInfo = notification.userInfo;
    NSString *articleUrl = [userInfo objectForKey:@"artileUrl"];
    NSString *articleTitle = [userInfo objectForKey:@"articleTitle"];
    NSString *articleDesc = [userInfo objectForKey:@"articleDescription"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    UIStoryboard *storyBoard;
    SocialWebView *socialWebViewObj;
    UINavigationController *modalController;
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        storyBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListViewPhone" bundle:nil];
        modalController = [storyBoard instantiateViewControllerWithIdentifier:@"SocialWebViewPhone"];
        socialWebViewObj=(SocialWebView *)[[modalController viewControllers]objectAtIndex:0];
        socialWebViewObj.titleStr=@"LinkedIn Share";
        
    } else {
        storyBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];
        modalController = [storyBoard instantiateViewControllerWithIdentifier:@"SocialWebView"];
        socialWebViewObj=(SocialWebView *)[[modalController viewControllers]objectAtIndex:0];
        socialWebViewObj.titleStr=@"LinkedIn Share";
    }
    NSString *linkedinTitleString = [NSString stringWithFormat:@"%@ %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"linkedinShareText"],articleTitle];
    NSString *urlString = [NSString stringWithFormat:@"https://www.linkedin.com/shareArticle?mini=true&url=%@&title=%@&summary=%@&source=%@",articleUrl,linkedinTitleString,articleDesc,[[NSUserDefaults standardUserDefaults]objectForKey:@"domainName"]];
    NSLog(@"linked in url:%@",urlString);
    NSString* urlTextEscaped = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"after link:%@",urlTextEscaped);
    socialWebViewObj.urlString=urlTextEscaped;
    modalController.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:modalController animated:NO completion:^{
        // [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.articleIdArray.count;
}




-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
     NSLog(@"cell indexpath:%ld",(long)indexPath.row);
    self.selectedIndexPath = indexPath;
    self.selectedIndex = indexPath.row;
    CorporateDetailCell *cell;
    NSNumber *articleDrillPlaceholderImageVisible = [[NSUserDefaults standardUserDefaults] objectForKey:@"articleDrillPlaceholderImageVisible"];
    if([articleDrillPlaceholderImageVisible isEqualToNumber:[NSNumber numberWithInt:1]]) {
        cell = (CorporateDetailCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"withArticleImage" forIndexPath:indexPath];
    } else {
        cell = (CorporateDetailCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"withoutArticleImage" forIndexPath:indexPath];
    }
    
    
    // [cell resetCellWebviewHeight];
    //[cell.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    cell.cachedImageViewSize = cell.articleImageView.frame;
    cell.isTwitterLoad = NO;
    cell.isTwitterAPICalled = NO;
    cell.socialcollectionView.delegate = nil;
    cell.socialcollectionView.dataSource = nil;
    cell.socialcollectionView.hidden = YES;
    cell.tweetsLocalCollectionView.delegate = nil;
    cell.tweetsLocalCollectionView.dataSource = nil;
    cell.tweetsLocalCollectionView.hidden = YES;
    [cell.activityIndicator removeFromSuperview];
    [cell.activityIndicator stopAnimating];
    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
    NSLog(@"%@",fetchRequest);
    
    NSLog(@"cell article id:%@",[self.articleIdArray objectAtIndex:indexPath.row]);
    NSPredicate *predicate;
//    if (_isSearching ==1) {
//        predicate = [NSPredicate predicateWithFormat:@"articleId == %@",_articleIdFromSearchLst];
//
//    }
//    else{
        predicate = [NSPredicate predicateWithFormat:@"articleId == %@",[self.articleIdArray objectAtIndex:indexPath.row]];

//    }
    [fetchRequest setPredicate:predicate];
    NSLog(@"%@",predicate);

    NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSLog(@"%@",newPerson);

    if(newPerson.count != 0) {
        NSManagedObject *curatedNews = [newPerson objectAtIndex:0];
         NSLog(@"selected curated news:%@",curatedNews);
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            curatedNewsDetail = [curatedNews valueForKey:@"details"];
            curatedNewsAuthorDetail = [curatedNews valueForKey:@"authorDetails"];
            NSLog(@"%@",curatedNewsDetail);
            NSLog(@"%@",curatedNewsAuthorDetail);

            NSString *htmlString;
            if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
            {

            htmlString = [NSString stringWithFormat:@"<body style='color:#000000;font-family:Open Sans;line-height: 1.7;font-size: 16px;font-weight: 310;'>%@",[curatedNewsDetail valueForKey:@"article"]];
            }
            else
            {
            htmlString = [NSString stringWithFormat:@"<body style='color:#666e73;font-family:Open Sans;line-height: 1.7;font-size: 16px;font-weight: 310;'>%@",[curatedNewsDetail valueForKey:@"article"]];

            }
            NSSet *relatedPostSet = [curatedNewsDetail valueForKey:@"relatedPost"];
            NSLog(@"%@",relatedPostSet);

            NSMutableArray *postArray = [[NSMutableArray alloc]initWithArray:[relatedPostSet allObjects]];
            NSLog(@"%@",postArray);
            
            NSLog(@"%@",htmlString);
            [cell.articleWebview loadHTMLString:htmlString baseURL:nil];

            if (self.isSearching) {

                
//
//                NSString *repString = [NSString stringWithFormat:@"<font color='red'>%@</font>",self.searchText];
//                // Then you need to replace a string (say 'stringA') with new string (say 'stringB')
//                // htmlString = [htmlString stringByReplacingOccurrencesOfString:@"Apple" withString:repString];
//                
//                htmlString =[htmlString stringByReplacingOccurrencesOfString:self.searchText withString:repString options:NSCaseInsensitiveSearch range: NSMakeRange(0, [htmlString length])];
//                [cell.articleWebview loadHTMLString:htmlString baseURL:nil];

                
                
                NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:self.searchText
                                                                                    options:NSRegularExpressionCaseInsensitive
                                                                                      error:NULL];
                NSString *output = [re stringByReplacingMatchesInString:htmlString
                                                                options:0
                                                                  range:NSMakeRange(0, htmlString.length)
                                                           withTemplate:@"<span style='background-color:#FFFF00'>$0</span>"];
                [cell.articleWebview loadHTMLString:output baseURL:nil];

                
            } else {
                [cell.articleWebview loadHTMLString:htmlString baseURL:nil];

            }


            
            
            
            
            
            
            

            [self updateCellViewType:cell forCuratedNews:curatedNews atIndexPath:indexPath];
            NSSet *authorSet = [curatedNews valueForKey:@"authorDetails"];
            NSMutableArray *legendsArray = [[NSMutableArray alloc]initWithArray:[authorSet allObjects]];
            NSManagedObject *author;
            if(legendsArray.count != 0) {
                author  = [legendsArray objectAtIndex:0];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self configureCell:cell forCuratedNews:curatedNews atIndexPath:indexPath];
                [self configureCellOutletDetails:cell forCuratedNews:curatedNews atIndexPath:indexPath];
                [self configureCellAuthorDetails:cell forCuratedNews:curatedNews atIndexPath:indexPath];
                [self updateCellMarkedImportantStatus:cell forCuratedNews:curatedNews atIndexPath:indexPath];
                [self updateCellSavedForLaterStatus:cell forCuratedNews:curatedNews atIndexPath:indexPath];
                [self updateCellCommentCount:cell forCuratedNews:curatedNewsDetail atIndexPath:indexPath];
                [self updateCellReadStatus:cell forCuratedNews:curatedNews atIndexPath:indexPath];
                //cell.webViewHeightConstraint.constant = 200;
                
                [self configureAuthorDetails:cell forCuratedNewsAuthor:author];
                cell.relatedPostArray = postArray;
                
                
                
            });
        });
    }
    return cell;
    
}

//-(void) highlightsSearchTerm:(NSString *)searchTerm withinString:(NSString *)inTerm forWebView:(UIWebView *)inWebView
//{
//    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:@"Obama"
//                                                                        options:NSRegularExpressionCaseInsensitive
//                                                                          error:NULL];
//    NSString *output = [re stringByReplacingMatchesInString:inTerm
//                                                    options:0
//                                                      range:NSMakeRange(0, inTerm.length)
//                                               withTemplate:@"<span class='highlight'>$0</span>"];
//    [inWebView loadHTMLString:output baseURL:nil];
//
//    
//}

-(void)configureAuthorDetails:(CorporateDetailCell *)cell forCuratedNewsAuthor:(NSManagedObject *)curatedNewsAuthor {
    self.socialLinksArray = [[NSMutableArray alloc]init];
    NSSet *socialMediaSet = [curatedNewsAuthor valueForKey:@"authorSocialMedia"];
    self.socialLinksArray = [[NSMutableArray alloc]initWithArray:[socialMediaSet allObjects]];
    if(self.socialLinksArray.count == 0) {
        //cell.socialLinkLabel.hidden = YES;
        //cell.socialLinkDivider.hidden = YES;
        //cell.socialLinkCollectionView.hidden = YES;
    } else {
        cell.socialLinksArray = self.socialLinksArray;
        cell.socialLinkLabel.hidden = NO;
        cell.socialLinkDivider.hidden = NO;
    }
    
    [cell.aboutAuthorImageView sd_setImageWithURL:[NSURL URLWithString:[curatedNewsAuthor valueForKey:@"imageURL"]] placeholderImage:[UIImage imageNamed:@"userIcon_150"]];
    [cell.aboutAuthorImageView setContentMode:UIViewContentModeScaleAspectFill];
    cell.authorNameStr = [curatedNewsAuthor valueForKey:@"firstName"];
    
    if([[curatedNewsAuthor valueForKey:@"starRating"] integerValue] == 0) {
        cell.ratingControl.hidden = YES;
    } else {
        cell.ratingControl.hidden = NO;
        cell.starRating.rating = [[curatedNewsAuthor valueForKey:@"starRating"] integerValue];
    }
    
    if([[curatedNewsAuthor valueForKey:@"isInfluencer"]isEqualToNumber:[NSNumber numberWithInt:1]]) {
        cell.influencerIconImage.hidden = NO;
    } else {
        cell.influencerIconImage.hidden = YES;
    }
    
    
    NSSet *workTitleSet = [curatedNewsAuthor valueForKey:@"authorWorkTitle"];
    NSMutableArray *workTitleArray = [[NSMutableArray alloc]initWithArray:[workTitleSet allObjects]];
    if(workTitleArray.count != 0) {
        cell.workTitleIcon.hidden = NO;
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        {
            cell.workTitleIconHeightConstraint.constant = 10;
            cell.workTitleLabelHeightConstraint.constant = 18;
            cell.outletImageTopConstraint.constant = 9;
            cell.outletLabelTopConstraint.constant = 1;
        }
        else{
            cell.workTitleIconHeightConstraint.constant = 15;
            cell.workTitleLabelHeightConstraint.constant = 21;
            cell.outletImageTopConstraint.constant = 10;
            cell.outletLabelTopConstraint.constant = 4;
        }
        
        NSManagedObject *workTitle = [workTitleArray objectAtIndex:0];
        cell.authorWorkTitleLabel.text = [workTitle valueForKey:@"title"];
//        if (self.isSearching) {
//            [self highlight:cell.authorWorkTitleLabel withString:self.searchText];
//        }
    } else {
        cell.workTitleIcon.hidden = YES;
        cell.workTitleIconHeightConstraint.constant = 0;
        cell.workTitleLabelHeightConstraint.constant = 0;
        cell.outletImageTopConstraint.constant = 0;
        cell.outletLabelTopConstraint.constant = 0;
        cell.authorWorkTitleLabel.text = @"";

    }
    
    
    NSSet *outletSet = [curatedNewsAuthor valueForKey:@"authorOutlet"];
    NSMutableArray *outletArray = [[NSMutableArray alloc]initWithArray:[outletSet allObjects]];
    if(outletArray.count != 0) {
        cell.outletIcon.hidden = NO;
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        {
            cell.locationImageTopConstarint.constant = 9;
            cell.outletIconHeightConstraint.constant = 10;
            cell.locationLabelTopConstraint.constant = 1;
            cell.outletLabelHeightConstraint.constant = 18;

        }
        else{
            cell.locationImageTopConstarint.constant = 10;
            cell.outletIconHeightConstraint.constant = 15;
            cell.locationLabelTopConstraint.constant = 4;
            cell.outletLabelHeightConstraint.constant = 21;

        }
        NSManagedObject *outlet = [outletArray objectAtIndex:0];
        cell.authorOutletName.text = [outlet valueForKey:@"outletname"];
//        if (self.isSearching) {
//            [self highlight:cell.authorOutletName withString:self.searchText];
//        }
    }else {
        cell.outletIcon.hidden = YES;
        cell.outletIconHeightConstraint.constant = 0;
        cell.locationImageTopConstarint.constant = 0;
        cell.locationLabelTopConstraint.constant = 0;
        cell.outletLabelHeightConstraint.constant = 0;
        cell.authorOutletName.text = @"";

    }
    
    
    NSString *city = [curatedNewsAuthor valueForKey:@"city"];
    NSString *country = [curatedNewsAuthor valueForKey:@"country"];
    NSString *authorPlace;
    if(city.length == 0 && country.length == 0) {
        authorPlace = @"";
    } else if(city.length == 0) {
        authorPlace = [NSString stringWithFormat:@"%@",country];
    } else if(country.length == 0) {
        authorPlace = [NSString stringWithFormat:@"%@",city];
    } else {
        authorPlace = [NSString stringWithFormat:@"%@, %@",city,country];
    }
    
    if(authorPlace.length !=0 ){
        cell.locationIcon.hidden = NO;
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        {
            cell.locationIconHeightConstraint.constant = 10;
            cell.locationLabelHeightConstraint.constant = 18;
            cell.beatsImageTopConstraint.constant = 9;
            cell.beatsLabelTopConstraint.constant = 1;
        }
        else{
            cell.locationIconHeightConstraint.constant = 15;
            cell.locationLabelHeightConstraint.constant = 21;
            cell.beatsImageTopConstraint.constant = 10;
            cell.beatsLabelTopConstraint.constant = 4;
        }
        
        cell.authorLocationLabel.text = authorPlace;
//        if (self.isSearching) {
//            [self highlight:cell.authorLocationLabel withString:self.searchText];
//        }
    } else {
        cell.locationIcon.hidden = YES;
        cell.locationIconHeightConstraint.constant = 0;
        cell.locationLabelHeightConstraint.constant = 0;
        cell.beatsImageTopConstraint.constant = 0;
        cell.beatsLabelTopConstraint.constant = 0;
        cell.authorLocationLabel.text = @"";

    }
    
    NSSet *beatSet = [curatedNewsAuthor valueForKey:@"authorBeat"];
    NSMutableArray *beatsArray = [[NSMutableArray alloc]initWithArray:[beatSet allObjects]];
    NSMutableArray *beats = [[NSMutableArray alloc]init];
    for(NSManagedObject *beat in beatsArray) {
        [beats addObject:[NSString stringWithFormat:@"#%@",[beat valueForKey:@"name"]]];
    }
    NSString *beatString = [beats componentsJoinedByString:@" "];
    if(beatString.length != 0){
        cell.beatsIcon.hidden = NO;
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        {
            cell.beatsIconHeightConstraint.constant = 10;
            cell.beatsLabelHeightConstraint.constant = 18;

        }
        else{
            cell.beatsIconHeightConstraint.constant = 15;
            cell.beatsLabelHeightConstraint.constant = 21;

        }
        cell.authorTagLabel.text = beatString;
//        if (self.isSearching) {
//            [self highlight:cell.authorTagLabel withString:self.searchText];
//        }
    } else {
        cell.beatsIcon.hidden = YES;
        cell.beatsIconHeightConstraint.constant = 0;
        cell.beatsLabelHeightConstraint.constant = 0;
        cell.authorTagLabel.text = @"";

    }
    
    NSString *bioString = [curatedNewsAuthor valueForKey:@"bibliography"];
    
    if(bioString.length != 0) {
        
        cell.bioTitleLabel.hidden = NO;
        cell.bioDivider.hidden = NO;
        cell.bioLabel.hidden = NO;
        cell.bioLabel.text = bioString;
//        if (self.isSearching) {
//            [self highlight:cell.bioLabel withString:self.searchText];
//        }
    } else {
        cell.bioTitleLabel.hidden = YES;
        cell.bioDivider.hidden = YES;
        cell.bioLabel.hidden = YES;
    }
    
}

-(void)updateCellMarkedImportantStatus:(CorporateDetailCell *)cell forCuratedNews:(NSManagedObject *)curatedNews atIndexPath:(NSIndexPath *)indexpath {
    NSNumber *markImpStatus = [curatedNews valueForKey:@"markAsImportant"];
    if([markImpStatus isEqualToNumber:[NSNumber numberWithInt:1]]) {
        [cell.markedImpButton setSelected:YES];
    } else {
        [cell.markedImpButton setSelected:NO];
    }
}

-(void)updateCellSavedForLaterStatus:(CorporateDetailCell *)cell forCuratedNews:(NSManagedObject *)curatedNews atIndexPath:(NSIndexPath *)indexpath {
    if([[curatedNews valueForKey:@"saveForLater"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
        [cell.savedForLaterButton setSelected:YES];
    } else {
        [cell.savedForLaterButton setSelected:NO];
    }
}

-(void)updateCellCommentCount:(CorporateDetailCell *)cell forCuratedNews:(NSManagedObject *)curatedNewsDetails atIndexPath:(NSIndexPath *)indexpath {
    NSNumber *unreadCnt = [curatedNewsDetails valueForKey:@"unReadComment"];
    NSNumber *totalCnt = [curatedNewsDetails valueForKey:@"totalComments"];
    //NSLog(@"after changing unread and total comments:%@ and %@",unreadCnt,totalCnt);
    if([unreadCnt isEqualToNumber:[NSNumber numberWithInt:0]]) {
        cell.badgeTwo.value = [totalCnt integerValue];
        cell.badgeTwo.fillColor = UIColorFromRGB(0xbcbcbc);
    } else {
        cell.badgeTwo.value = [unreadCnt integerValue];
        cell.badgeTwo.fillColor = UIColorFromRGB(0xF55567);
    }
    
}


-(void)updateCellViewType:(CorporateDetailCell *)cell forCuratedNews:(NSManagedObject *)curatedNews atIndexPath:(NSIndexPath *)indexpath {
    BOOL isFIViewSelected = [[NSUserDefaults standardUserDefaults]boolForKey:@"isFIViewSelected"];
    if(isFIViewSelected) {
        cell.detailsWebview.hidden = YES;
        cell.overlayView.hidden = YES;
        [cell.timer invalidate];
    } else {
        cell.detailsWebview.hidden = NO;
        cell.overlayView.hidden = NO;
        //dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [cell.detailsWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
        if([curatedNews valueForKey:@"articleUrlData"] == nil) {
            NSString *string = [NSString stringWithContentsOfURL:[NSURL URLWithString:[curatedNews valueForKey:@"articleUrl"]] encoding:NSASCIIStringEncoding error:nil];
            [curatedNews setValue:string forKey:@"articleUrlData"];
            [cell.detailsWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[curatedNews valueForKey:@"articleUrl"]]]];
        } else {
            if([[FISharedResources sharedResourceManager]serviceIsReachable]) {
                [cell.detailsWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[curatedNews valueForKey:@"articleUrl"]]]];
            } else {
                [cell.detailsWebview loadHTMLString:[curatedNews valueForKey:@"articleUrlData"] baseURL:nil];
            }
        }
        //});
    }
}

-(void)updateCellReadStatus:(CorporateDetailCell *)cell forCuratedNews:(NSManagedObject *)curatedNews atIndexPath:(NSIndexPath *)indexpath {
    NSNumber *number = [curatedNews valueForKey:@"readStatus"];
    NSString *categoryStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"categoryId"]];
    if([number isEqualToNumber:[NSNumber numberWithInt:1]]) {
        
    } else {
        
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
            [resultDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
            [resultDic setObject:[curatedNews valueForKey:@"articleId"] forKey:@"selectedArticleId"];
            [resultDic setObject:@"1" forKey:@"status"];
            [resultDic setObject:@"true" forKey:@"isSelected"];
            NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
            NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
            // [self.curatedNewsDetail setValue:[NSNumber numberWithBool:NO] forKey:@"saveForLater"];
            if([[FISharedResources sharedResourceManager]serviceIsReachable]) {
                [[FISharedResources sharedResourceManager]setUserActivitiesOnArticlesWithDetails:resultStr withFlag:NO];
            }
            
            
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
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
                [[NSNotificationCenter defaultCenter]postNotificationName:@"readStatusUpdate" object:nil userInfo:@{@"indexPath":indexpath,@"status":[NSNumber numberWithBool:YES],@"articleId":[self.articleIdArray objectAtIndex:indexpath.row]}];
                
            });
        });
        
        
    }
}


-(void)configureCell:(CorporateDetailCell *)cell forCuratedNews:(NSManagedObject *)curatedNews atIndexPath:(NSIndexPath *)indexpath {
    CGSize maximumLabelSize = CGSizeMake(200, FLT_MAX);
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        NSLog(@"starting constraint:%f",cell.articleTitleHeightConstraint.constant);
        //CGSize expectedLabelSize = [[curatedNews valueForKey:@"title"] sizeWithFont:cell.articleTitle.font constrainedToSize:maximumLabelSize lineBreakMode:cell.articleTitle.lineBreakMode];
       // NSLog(@"title height:%f",expectedLabelSize.height);
        UIFont *myFont = [UIFont fontWithName:@"OpenSans-Semibold" size:24.0];
        CGRect textRect = [[curatedNews valueForKey:@"title"] boundingRectWithSize:maximumLabelSize
                                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                                        attributes:@{NSFontAttributeName:myFont}
                                                                           context:nil];
        NSLog(@"another title calc:%f",textRect.size.height);
        
        cell.articleTitleHeightConstraint.constant = textRect.size.height+10;
        
        cell.articleTitle.text = [curatedNews valueForKey:@"title"];
    } else {
        cell.articleTitle.text = [curatedNews valueForKey:@"title"];
    }
    if (self.isSearching) {
        [self highlight:cell.articleTitle withString:self.searchText];
    }
    NSString *articleImageStr = [curatedNews valueForKey:@"image"];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *drillinPlaceHolderImagePath = [documentsDirectory stringByAppendingPathComponent:@"articleDrillPlaceholderImage.png"];

    NSNumber *articleDrillPlaceholderImageVisible = [[NSUserDefaults standardUserDefaults] objectForKey:@"articleDrillPlaceholderImageVisible"];
    if([articleDrillPlaceholderImageVisible isEqualToNumber:[NSNumber numberWithInt:1]]) {
        [cell.articleImageView sd_setImageWithURL:[NSURL URLWithString:articleImageStr] placeholderImage:[UIImage imageWithContentsOfFile:drillinPlaceHolderImagePath]];
        [cell.articleImageView setContentMode:UIViewContentModeScaleAspectFill];
        cell.cachedImageViewSize = cell.articleImageView.frame;
        //cell.gradButtonTops.image = [UIImage imageNamed:@"gradiant"];
        
    } else {
//        [cell.articleTitle removeConstraint:cell.titleLabelTopConstraint];
//        [cell removeConstraint:cell.titleLabelTopConstraint];
//        [cell.contentView removeConstraint:cell.titleLabelTopConstraint];
       // cell.titleLabelTopConstraint.constant = 30;
        cell.articleImageView.backgroundColor = [UIColor clearColor];
        //cell.articleImageView.alpha = 0.6f;
       // cell.articleTitle.textColor = [UIColor blackColor];
        cell.bannerImageViewHeightConstraint.constant = cell.articleTitleHeightConstraint.constant;
    }
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        cell.articleDate.text = [FIUtils getDateFromTimeStamp:[[curatedNews valueForKey:@"publishedDate"] doubleValue]];
        
    }

    cell.overlayArticleDate.text = [FIUtils getDateFromTimeStamp:[[curatedNews valueForKey:@"publishedDate"] doubleValue]];
    cell.overlayArticleDesc.text = [curatedNews valueForKey:@"desc"];
    
    NSString *listPlaceHolderImagePath = [documentsDirectory stringByAppendingPathComponent:@"listPlaceholderImage.png"];
    
    [cell.overlayArticleImageView sd_setImageWithURL:[NSURL URLWithString:articleImageStr] placeholderImage:[UIImage imageWithContentsOfFile:listPlaceHolderImagePath]];
    [cell.overlayArticleImageView setContentMode:UIViewContentModeScaleAspectFill];
    cell.overlayArticleTitle.text = [curatedNews valueForKey:@"title"];
    if (self.isSearching) {
        [self highlight:cell.overlayArticleTitle withString:self.searchText];
    }
    cell.markedImpUserId = [[curatedNews valueForKey:@"markAsImportantUserId"] stringValue];
    cell.markedImpUserName = [curatedNews valueForKey:@"markAsImportantUserName"];
    
    //Passing Cell Details
    cell.curatedNewsDetail = curatedNewsDetail;
    cell.selectedIndexPath = indexpath;
    cell.articleDesc = [curatedNews valueForKey:@"desc"];
    cell.selectedArticleTitle = [curatedNews valueForKey:@"title"];
    cell.selectedArticleUrl = [curatedNews valueForKey:@"articleUrl"];
    cell.selectedArticleId = [curatedNews valueForKey:@"articleId"];
    cell.selectedArticleImageUrl = [curatedNews valueForKey:@"image"];
}

-(void)configureCellOutletDetails:(CorporateDetailCell *)cell forCuratedNews:(NSManagedObject *)curatedNews atIndexPath:(NSIndexPath *)indexpath {
    //Configure Outlet Details
    NSString *outletString = [curatedNews valueForKey:@"outlet"];
    CGFloat width =  [outletString sizeWithFont:[UIFont fontWithName:@"OpenSans" size:14 ]].width;
    if(width == 0) {
        
    } else if(width < 59) {
        CGFloat value = width;
        cell.outletTextWidthConstraint.constant = value;
        // self.outletHorizontalConstraint.constant = value+10;
    }else {
        CGFloat value = width;
        cell.outletTextWidthConstraint.constant = value;
        //  self.outletHorizontalConstraint.constant = value+10;
    }
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        cell.articleOutlet.text = [curatedNews valueForKey:@"outlet"];

    }
    cell.overlayArticleOutlet.text = [curatedNews valueForKey:@"outlet"];
    
}

-(void)configureCellAuthorDetails:(CorporateDetailCell *)cell forCuratedNews:(NSManagedObject *)curatedNews atIndexPath:(NSIndexPath *)indexpath {
    //Configure Author Details
    NSSet *authorSet = [curatedNews valueForKey:@"author"];
    NSMutableArray *authorArray = [[NSMutableArray alloc]initWithArray:[authorSet allObjects]];
    NSMutableArray *multipleAuthorArray = [[NSMutableArray alloc]init];
    if(authorArray.count != 0) {
        if(authorArray.count > 1) {
            for(int i=0;i<2;i++) {
                NSManagedObject *authorObject = [authorArray objectAtIndex:i];
                [multipleAuthorArray addObject:[authorObject valueForKey:@"name"]];
            }
            
            if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
                NSManagedObject *authorObjectOne = [authorArray objectAtIndex:0];
                overallAuthorDetailOne = [authorObjectOne valueForKey:@"name"];
                NSLog(@"%@",[FIUtils getDateFromTimeStamp:[[curatedNews valueForKey:@"publishedDate"]doubleValue]]);
                
                cell.articleDate.text = [FIUtils getDateFromTimeStamp:[[curatedNews valueForKey:@"publishedDate"] doubleValue]];
                cell.articleOutlet.text = [curatedNews valueForKey:@"outlet"];
                cell.articleAuthor.text = overallAuthorDetailOne;
                cell.overlayArticleAuthor.text = overallAuthorDetailOne;
            
            }
            else
            {

                cell.articleAuthor.text = [multipleAuthorArray componentsJoinedByString:@" and "];
                cell.overlayArticleAuthor.text = [multipleAuthorArray componentsJoinedByString:@" and "];
                
            }
           
        } else {
            NSManagedObject *authorObject = [authorArray objectAtIndex:0];
            cell.overlayArticleAuthor.text = [authorObject valueForKey:@"name"];
            if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
                overallAuthorDetail = [authorObject valueForKey:@"name"];
                cell.articleDate.text = [FIUtils getDateFromTimeStamp:[[curatedNews valueForKey:@"publishedDate"] doubleValue]];
                cell.articleAuthor.text = overallAuthorDetail;
                cell.articleOutlet.text = [curatedNews valueForKey:@"outlet"];
                cell.overlayArticleAuthor.text = overallAuthorDetail;

            }
            else
            {
                NSManagedObject *authorObject = [authorArray objectAtIndex:0];
                cell.articleAuthor.text = [authorObject valueForKey:@"name"];
                cell.overlayArticleAuthor.text = [authorObject valueForKey:@"name"];
            }
            
            
            
        }
    }
    if (self.isSearching) {
        [self highlight:cell.articleOutlet withString:self.searchText];
        [self highlight:cell.articleAuthor withString:self.searchText];
        [self highlight:cell.overlayArticleAuthor withString:self.searchText];
        
    }
    NSManagedObject *authors;
    if(authorArray.count != 0) {
        authors = [authorArray objectAtIndex:0];
    }
    NSLog(@"%@",authors);
    cell.aboutAuthorName.text = [authors valueForKey:@"name"];
    cell.authorName.text = [authors valueForKey:@"name"];
    if (self.isSearching) {
        [self highlight:cell.aboutAuthorName withString:self.searchText];

    }

    
    NSSet *authorSets = [curatedNews valueForKey:@"authorDetails"];
    NSMutableArray *legendsArray = [[NSMutableArray alloc]initWithArray:[authorSets allObjects]];
    NSManagedObject *author;
    if(legendsArray.count != 0) {
        author  = [legendsArray objectAtIndex:0];
    }
    NSLog(@"Author Info ---->%@",author);
    NSSet *workTitleSet = [author valueForKey:@"authorWorkTitle"];
    NSMutableArray *workTitleArray = [[NSMutableArray alloc]initWithArray:[workTitleSet allObjects]];
    NSLog(@"Author Info ---->%@",workTitleArray);

    if (workTitleArray.count !=0) {
        NSManagedObject *workTitle = [workTitleArray objectAtIndex:0];
        cell.authorWorkTitle.text = [workTitle valueForKey:@"title"];
    }

    [cell.authorImageView sd_setImageWithURL:[NSURL URLWithString:[author valueForKey:@"imageURL"]] placeholderImage:[UIImage imageNamed:@"userIcon_150"]];
    [cell.authorImageView setContentMode:UIViewContentModeScaleAspectFill];
  
    
}

-(void)removeOverlay:(UITapGestureRecognizer *)gesture {
    // NSLog(@"remove overlay working");
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return self.collectionView.frame.size;
}

#pragma mark -
#pragma mark Rotation handling methods

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:
(NSTimeInterval)duration {
    
    // Fade the collectionView out
    [self.collectionView setAlpha:0.0f];
    
    
    // Suppress the layout errors by invalidating the layout
    //   [self.collectionView.collectionViewLayout invalidateLayout];
    
    // Calculate the index of the item that the collectionView is currently displaying
    CGPoint currentOffset = [self.collectionView contentOffset];
    self.currentIndex = currentOffset.x / self.collectionView.frame.size.width;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    // Force realignment of cell being displayed
    CGSize currentSize = self.collectionView.bounds.size;
    float offset = self.currentIndex * currentSize.width;
    [self.collectionView setContentOffset:CGPointMake(offset, 0)];
    
    // Fade the collectionView back in
    [UIView animateWithDuration:0.125f animations:^{
        [self.collectionView setAlpha:1.0f];
        
        [self.collectionView reloadData];
    }];
    
    
    
}

-(void)nextFolderClick:(id)sender {
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        {
           
            
            NSNotification *notification = sender;
            NSDictionary *userInfo = notification.userInfo;
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"SavedListPopoverViewPhone" bundle:nil];
            UINavigationController *navCtlr = [storyBoard instantiateViewControllerWithIdentifier:@"SavedList"];
            
//            popOverView.articleId = articleId;
//            popOverView.selectedIndexPath = indexPath;
//            SavedListPopoverView *popOverView=(SavedListPopoverView *)[[navCtlr viewControllers]objectAtIndex:0];
            
            navCtlr.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self presentViewController:navCtlr animated:NO completion:nil];


        }
    
    
}
-(void)showCommentsView:(id)sender {
    NSNotification *notification = sender;
    NSDictionary *userInfo = notification.userInfo;
    NSString *articleId = [userInfo objectForKey:@"articleId"];
    NSIndexPath *indexPath = [userInfo objectForKey:@"indexPath"];
    UIStoryboard *storyBoard;
    UINavigationController *navCtlr;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        storyBoard = [UIStoryboard storyboardWithName:@"CommentsPhone" bundle:nil];
    }
    else{
        storyBoard = [UIStoryboard storyboardWithName:@"Comments" bundle:nil];
    }
    navCtlr = [storyBoard instantiateViewControllerWithIdentifier:@"commentNav"];
    
    CommentsPopoverView *popOverView=(CommentsPopoverView *)[[navCtlr viewControllers]objectAtIndex:0];
    popOverView.articleId = articleId;
    popOverView.selectedIndexPath = indexPath;
    // popOverView.transitioningDelegate = self;
    navCtlr.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:navCtlr animated:NO completion:nil];


    //[self.navigationController presentViewController:popOverView
    //  animated:YES
    //completion:NULL];
}

-(void)showResearchView:(id)sender {
    
    NSNotification *notification = sender;
    NSDictionary *userInfo = notification.userInfo;
    NSString *articleId = [userInfo objectForKey:@"articleId"];
    NSString *articleTitle = [userInfo objectForKey:@"articleTitle"];
    NSString *articleUrl = [userInfo objectForKey:@"articleUrl"];
    
    
//    UIStoryboard *centerStoryBoard;
//    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
//        centerStoryBoard = [UIStoryboard storyboardWithName:@"ResearchRequestPhone" bundle:nil];
//    }
//    else{
//        centerStoryBoard = [UIStoryboard storyboardWithName:@"ResearchRequest" bundle:nil];
//    }
//    UINavigationController *popOverView =[centerStoryBoard instantiateViewControllerWithIdentifier:@"requestNav"];
//
//    ResearchRequestPopoverView *researchViewController=(ResearchRequestPopoverView *)[[popOverView viewControllers]objectAtIndex:0];
//    researchViewController.articleId = articleId;
//    researchViewController.articleTitle = articleTitle;
//    researchViewController.articleUrl = articleUrl;
//    //   popOverView.transitioningDelegate = self;
//    popOverView.modalPresentationStyle = UIModalPresentationCustom;
//    
//    [self presentViewController:popOverView animated:NO completion:nil];
    
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    UIStoryboard *storyBoard;
    UINavigationController *modalController;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        storyBoard = [UIStoryboard storyboardWithName:@"ResearchRequestPhone" bundle:nil];
        modalController = [storyBoard instantiateViewControllerWithIdentifier:@"requestNav"];
        ResearchRequestPopoverView *researchViewController=(ResearchRequestPopoverView *)[[modalController viewControllers]objectAtIndex:0];
        researchViewController.articleId = articleId;
        researchViewController.articleTitle = articleTitle;
        researchViewController.articleUrl = articleUrl;
        modalController.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:modalController animated:NO completion:nil];
    } else {
        storyBoard = [UIStoryboard storyboardWithName:@"ResearchRequest" bundle:nil];
        modalController = [storyBoard instantiateViewControllerWithIdentifier:@"requestNav"];
        
        ResearchRequestPopoverView *researchViewController=(ResearchRequestPopoverView *)[[modalController viewControllers]objectAtIndex:0];
        researchViewController.articleId = articleId;
        researchViewController.articleTitle = articleTitle;
        researchViewController.articleUrl = articleUrl;

        
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
        //formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
        //__weak MZFormSheetController *weakFormSheet = formSheet;
        
        
        // If you want to animate status bar use this code
//        formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
//            UINavigationController *navController = (UINavigationController *)weakFormSheet.presentedFSViewController;
//            if ([navController.topViewController isKindOfClass:[AddContentFirstLevelView class]]) {
//                //AddContentFirstLevelView *mzvc = (AddContentFirstLevelView *)navController.topViewController;
//                //  mzvc.showStatusBar = NO;
//            }
//            
//            
//            [UIView animateWithDuration:0.3 animations:^{
//                if ([weakFormSheet respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
//                    [weakFormSheet setNeedsStatusBarAppearanceUpdate];
//                }
//            }];
//        };
        
        formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
            // Passing data
            UINavigationController *navController = (UINavigationController *)presentedFSViewController;
            // navController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
            
            
            
            [navController.navigationBar setTitleTextAttributes:
             [NSDictionary dictionaryWithObjectsAndKeys:
              [UIColor headerTextColor],
              UITextAttributeTextColor,
              [UIFont fontWithName:@"OpenSans" size:18.0],
              UITextAttributeFont,
              nil]];
            
            navController.topViewController.title = @"Research Request";
        };
        formSheet.transitionStyle = MZFormSheetTransitionStyleCustom;
        
        [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
        
        //    NSString *accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"];
        //    if(accessToken.length > 0) {
        [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
            
        }];
        
    }
    
    
    
}

-(void)widgetWebViewTrigger:(id)sender{
    
    NSNotification *notification = sender;
    NSDictionary *userInfo = notification.userInfo;
    NSString *title = [userInfo objectForKey:@"name"];
    NSString *link = [userInfo objectForKey:@"link"];
    UIStoryboard *storyBoard;
    UINavigationController *modalController;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        storyBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListViewPhone" bundle:nil];
        
        SocialWebView *SocialWebViewObj = [storyBoard instantiateViewControllerWithIdentifier:@"widgetWebViewPhone"];
        SocialWebViewObj.titleStr=title;
        SocialWebViewObj.urlString=link;
        [self.navigationController pushViewController:SocialWebViewObj animated:YES];

    }
    else{
        storyBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];
        
        modalController = [storyBoard instantiateViewControllerWithIdentifier:@"widgetWebView"];
        SocialWebView *SocialWebViewObj=(SocialWebView *)[[modalController viewControllers]objectAtIndex:0];
        SocialWebViewObj.titleStr=title;
        SocialWebViewObj.urlString=link;
        modalController.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:modalController animated:NO completion:nil];
    }
    
    
    
    
}

- (void)socialLinkSelected:(id)sender
{
    NSNotification *notification = sender;
    NSDictionary *userInfo = notification.userInfo;
    NSString *title = [userInfo objectForKey:@"name"];
    NSString *link = [userInfo objectForKey:@"link"];
    UIStoryboard *storyBoard;
    SocialWebView *socialWebViewObj;
    UINavigationController *modalController;
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        storyBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListViewPhone" bundle:nil];
        modalController = [storyBoard instantiateViewControllerWithIdentifier:@"SocialWebViewPhone"];
        socialWebViewObj=(SocialWebView *)[[modalController viewControllers]objectAtIndex:0];
        
    } else {
        storyBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];
        modalController = [storyBoard instantiateViewControllerWithIdentifier:@"SocialWebView"];
        socialWebViewObj=(SocialWebView *)[[modalController viewControllers]objectAtIndex:0];
    }
    socialWebViewObj.titleStr=title;
    socialWebViewObj.urlString=link;
    
    modalController.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:modalController animated:NO completion:nil];
}

-(void)mailButtonClick:(id)sender {
    //NSLog(@"one");
    NSNotification *notification = sender;
    NSDictionary *userInfo = notification.userInfo;
    mailArticleId = [userInfo objectForKey:@"articleId"];
    mailTitle = [userInfo objectForKey:@"title"];
    mailBody = [userInfo objectForKey:@"body"];
    
    
    if ([MFMailComposeViewController canSendMail]) {
        mailComposer = [[MFMailComposeViewController alloc]init];
        mailComposer.mailComposeDelegate = self;
        [mailComposer setSubject:mailTitle];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont
                                                                               fontWithName:@"Open Sans" size:18], NSFontAttributeName,
                                    [UIColor whiteColor], NSForegroundColorAttributeName, nil];
        mailComposer.navigationBar.titleTextAttributes = attributes;
        // [mailComposer.navigationBar setTintColor:[UIColor whiteColor]];
        [mailComposer setMessageBody:mailBody isHTML:NO];
        [self presentViewController:mailComposer animated:YES completion:nil];
    }else{
        UIAlertView *alert;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Email an Article"
                 message:@"You have not setup a mail box in your device.Please go to settings and configure mail account or send mail via FullIntel App"
                 delegate:self
                 cancelButtonTitle:@"Cancel"
                 otherButtonTitles:@"Go to Settings",@"Send via FullIntel",nil];
        
        [alert show];
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 1) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"mailto:test@test.com"]];
    } else if(buttonIndex == 2) {
        UIStoryboard *centerStoryBoard;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            centerStoryBoard = [UIStoryboard storyboardWithName:@"MailStoryboardPhone" bundle:nil];
        } else {
            centerStoryBoard = [UIStoryboard storyboardWithName:@"MailStoryboard" bundle:nil];
        }
        UINavigationController *popOverView =[centerStoryBoard instantiateViewControllerWithIdentifier:@"mailNav"];        
        MailPopoverView *mailViewController=(MailPopoverView *)[[popOverView viewControllers]objectAtIndex:0];
        mailViewController.articleId= mailArticleId;
        mailViewController.mailSubject = mailTitle;
        mailViewController.mailBody = mailBody;
        // popOverView.transitioningDelegate = self;
        popOverView.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:popOverView animated:NO completion:nil];
    }
}


#pragma mark - mail compose delegate
-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (result) {
        //NSLog(@"Result : %d",result);
    }
    if (error) {
        //NSLog(@"Error : %@",error);
    }
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)globeButtonClick:(UIButton *)sender {
    
    if(sender.selected) {
        
        [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"SwitchToFullIntelView"];
        //NSLog(@"sender selected");
        
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *webviewImagePath = [documentsDirectory stringByAppendingPathComponent:@"webviewImage.png"];
        [sender setBackgroundImage:[UIImage imageWithContentsOfFile:webviewImagePath] forState:UIControlStateNormal];
        [sender setSelected:NO];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"removeWebView" object:nil userInfo:@{@"status":[NSNumber numberWithBool:0]}];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isFIViewSelected"];
    } else {
        //NSLog(@"sender is not selected");
        [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"SwitchToWebView"];
        
        [sender setBackgroundImage:[UIImage imageNamed:@"nav_globe"] forState:UIControlStateNormal];
        [sender setSelected:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"removeWebView" object:nil userInfo:@{@"status":[NSNumber numberWithBool:1]}];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFIViewSelected"];
    }
    [self.collectionView reloadData];
    
}
-(void)stopLoadingForAlert{
    [self.activityIndicator stopAnimating];
    self.collectionView.scrollEnabled = YES;
 
}
-(void)scrollViewDidScroll: (UIScrollView*)scrollView
{
    
    CorporateDetailCell *cell = (CorporateDetailCell *)[self.collectionView cellForItemAtIndexPath:self.selectedIndexPath];
    // [cell resetCellWebviewHeight];
    [cell.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    // NSLog(@"collection view scroll");
    int lastCount = self.articleIdArray.count-1;
    NSLog(@"%@",self.articleIdArray);
    NSLog(@"%d",lastCount);

    float scrollOffset = self.collectionView.contentOffset.x;
    
    BOOL isFIViewSelected = [[NSUserDefaults standardUserDefaults]boolForKey:@"isFIViewSelected"];
    if(isFIViewSelected) {
        //Show FI View
        // [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"FIArticlesNavigationInDrillIn"];
    }else {
        //Show Web View
        //  [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"WebViewArticlesNavigationInDrillIn"];
    }
    
    
    float scrollOffsetY = self.collectionView.contentOffset.y;
    
    
    NSLog(@"collection scroll x:%f and y:%f",scrollOffset,scrollOffsetY);
    if(scrollOffset > self.collectionView.frame.size.width*lastCount) {
        self.callAPIFromDrillIn = YES;
        if(self.articleIdArray.count != 0) {
          //  NSString *inputJson;
            NSNumber *parentId = [[NSUserDefaults standardUserDefaults]objectForKey:@"parentId"];
            NSLog(@"parent id:%@",parentId);
            NSNumber *folderId = [[NSUserDefaults standardUserDefaults]objectForKey:@"folderId"];
            NSNumber *category = [[NSUserDefaults standardUserDefaults] valueForKey:@"categoryId"];
            NSNumber *newsLetterId = [[NSUserDefaults standardUserDefaults]objectForKey:@"newsletterId"];
//            NSNumber *contentTypeIDS;
//            NSNumber *activityTypeIDS;
            NSManagedObjectContext *context = [[FISharedResources sharedResourceManager] managedObjectContext];
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
            NSPredicate *predicate;
            if([self.isFromChart isEqualToNumber:[NSNumber numberWithInt:1]]) {
                if(self.isSearching) {
                    predicate = [NSPredicate predicateWithFormat:@"isFromChart == %@ AND isSearch == %@",[NSNumber numberWithBool:YES],[NSNumber numberWithBool:self.isSearching]];
                } else if(self.switchForFilter == 1) {
                    predicate = [NSPredicate predicateWithFormat:@"isFromChart == %@ AND isFilter == %@",[NSNumber numberWithBool:YES],[NSNumber numberWithInt:self.switchForFilter]];
                } else if(self.switchForFilter == 2) {
                    predicate = [NSPredicate predicateWithFormat:@"isFromChart == %@ AND isFilter == %@",[NSNumber numberWithBool:YES],[NSNumber numberWithInt:self.switchForFilter]];
                } else {
                    predicate = [NSPredicate predicateWithFormat:@"isFromChart == %@",[NSNumber numberWithBool:YES]];
                }
            } else {
                if([newsLetterId isEqualToNumber:[NSNumber numberWithInt:0]] && [folderId isEqualToNumber:[NSNumber numberWithInt:0]]) {
                    BOOL savedForLaterIsNew =[[NSUserDefaults standardUserDefaults]boolForKey:@"SavedForLaterIsNew"];
                    if([category isEqualToNumber:[NSNumber numberWithInt:-3]]) {
                        if(self.isSearching) {
                            predicate  = [NSPredicate predicateWithFormat:@"saveForLater == %@ AND categoryId==%@ AND isSearch == %@",[NSNumber numberWithBool:YES],category,[NSNumber numberWithBool:self.isSearching]];
                        } else if(self.switchForFilter == 1) {
                            predicate  = [NSPredicate predicateWithFormat:@"saveForLater == %@ AND categoryId==%@ AND isFilter == %@",[NSNumber numberWithBool:YES],category,[NSNumber numberWithInt:self.switchForFilter]];
                        } else if(self.switchForFilter == 2) {
                            predicate  = [NSPredicate predicateWithFormat:@"saveForLater == %@ AND categoryId==%@ AND isFilter == %@",[NSNumber numberWithBool:YES],category,[NSNumber numberWithInt:self.switchForFilter]];
                        } else {
                            predicate  = [NSPredicate predicateWithFormat:@"saveForLater == %@ AND categoryId==%@",[NSNumber numberWithBool:YES],category];
                        }
                    } else {
                        if(self.isSearching) {
                            predicate  = [NSPredicate predicateWithFormat:@"categoryId==%@ AND contentTypeId==%@ AND isSearch == %@",category,parentId,[NSNumber numberWithBool:self.isSearching]];
                        } else if(self.switchForFilter == 1) {
                            predicate  = [NSPredicate predicateWithFormat:@"categoryId==%@ AND contentTypeId==%@ AND isFilter == %@",category,parentId,[NSNumber numberWithInt:self.switchForFilter]];
                        } else if(self.switchForFilter == 2) {
                            predicate  = [NSPredicate predicateWithFormat:@"categoryId==%@ AND contentTypeId==%@ AND isFilter == %@",category,parentId,[NSNumber numberWithInt:self.switchForFilter]];
                        } else {
                            predicate  = [NSPredicate predicateWithFormat:@"categoryId==%@ AND contentTypeId==%@",category,parentId];
                        }
                        
                    }
                } else if(![folderId isEqualToNumber:[NSNumber numberWithInt:0]]) {
                    if(self.isSearching) {
                        predicate  = [NSPredicate predicateWithFormat:@"isFolder == %@ AND folderId == %@ AND isSearch == %@",[NSNumber numberWithBool:YES],folderId,[NSNumber numberWithBool:self.isSearching]];
                    } else if(self.switchForFilter == 1) {
                        predicate  = [NSPredicate predicateWithFormat:@"isFolder == %@ AND folderId == %@ AND isFilter == %@",[NSNumber numberWithBool:YES],folderId,[NSNumber numberWithInt:self.switchForFilter]];
                    } else if(self.switchForFilter == 2) {
                        predicate  = [NSPredicate predicateWithFormat:@"isFolder == %@ AND folderId == %@ AND isFilter == %@",[NSNumber numberWithBool:YES],folderId,[NSNumber numberWithInt:self.switchForFilter]];
                    } else {
                        predicate  = [NSPredicate predicateWithFormat:@"isFolder == %@ AND folderId == %@",[NSNumber numberWithBool:YES],folderId];
                    }
                } else if(![newsLetterId isEqualToNumber:[NSNumber numberWithInt:0]]) {
                    [self.revealController showViewController:self.revealController.frontViewController];
                    if(self.isSearching) {
                        predicate  = [NSPredicate predicateWithFormat:@"newsletterId == %@ AND isSearch == %@",newsLetterId,[NSNumber numberWithBool:self.isSearching]];
                    } else if(self.switchForFilter == 1) {
                        predicate  = [NSPredicate predicateWithFormat:@"newsletterId == %@ AND isFilter == %@",newsLetterId,[NSNumber numberWithInt:self.switchForFilter]];
                    } else if(self.switchForFilter == 2) {
                        predicate  = [NSPredicate predicateWithFormat:@"newsletterId == %@ AND isFilter == %@",newsLetterId,[NSNumber numberWithInt:self.switchForFilter]];
                    } else {
                        predicate  = [NSPredicate predicateWithFormat:@"newsletterId == %@",newsLetterId];
                    }
                    
                }
            }
            
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
            if ([forTopStories isEqualToNumber:[NSNumber numberWithInt:0]]) {

                self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [self.view addSubview:self.activityIndicator];
                self.activityIndicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
                [self.activityIndicator startAnimating];
                self.collectionView.scrollEnabled = NO;
                
                if([self.isFromChart isEqualToNumber:[NSNumber numberWithInt:1]]) {
                    NSString *filterString;
                    if (self.switchForFilter == 1){
                        filterString = @"UNREAD";
                    } else if (self.switchForFilter == 2){
                        filterString = @"RECENT";
                    } else {
                        filterString = @"";
                    }
                    //refresh list view for media analysis data 1.Need to check the report type id
                    if([self.reportTypeId isEqualToNumber:[NSNumber numberWithInt:1]]) {
                        //Trend of coverage
                        [[FISharedResources sharedResourceManager]getTrendOfCoverageArticleListFromDate:self.clickedDate endDateIn:self.trendOfCoverageEndDateIn fromDate:self.reportFromDate toDate:self.reportToDate withSize:[NSNumber numberWithInteger:10] withPageNo:[NSNumber numberWithInteger:pageNo] withFilterBy:filterString withQuery:self.searchText withFlag:@"" withLastArticleId:[self.articleIdArray lastObject]];
                    } else if([self.reportTypeId isEqualToNumber:[NSNumber numberWithInt:2]]) {
                        [[FISharedResources sharedResourceManager]getKeyTopicsArticleListFromField1:@"fields.name" value1:self.keyTopicsBrandName fromDate:self.reportFromDate toDate:self.reportToDate withSize:[NSNumber numberWithInt:10] withPageNo:[NSNumber numberWithInteger:pageNo] withFilterBy:filterString withQuery:self.searchText withFlag:@"" withLastArticleId:[self.articleIdArray lastObject]];
                    } else if([self.reportTypeId isEqualToNumber:[NSNumber numberWithInt:3]]) {
                        //Media types
                        [[FISharedResources sharedResourceManager]getMediaTypesArticleListFromMediaTypeField:@"mediaTypeId" mediaTypeValue:self.mediaTypesBrandName fromDate:self.reportFromDate toDate:self.reportToDate withSize:[NSNumber numberWithInt:10] withPageNo:[NSNumber numberWithInteger:pageNo] withFilterBy:filterString withQuery:self.searchText withFlag:@"" withLastArticleId:[self.articleIdArray lastObject]];
                    } else if([self.reportTypeId isEqualToNumber:[NSNumber numberWithInt:4]]) {
                        //sentiment and volume over time
                        [[FISharedResources sharedResourceManager]getSentimentOverTimeArticleListFromDate:self.clickedDate endDateIn:@"MONTH" field1:@"tonality.name" field2:@"fields.name" value1:self.sentimentChartTonalityValue value2:self.sentimentChartSelectedName fromDate:self.reportFromDate toDate:self.reportToDate withSize:[NSNumber numberWithInt:10] withPageNo:[NSNumber numberWithInteger:pageNo] withFilterBy:filterString withQuery:self.searchText withFlag:@"" withLastArticleId:[self.articleIdArray lastObject]];
                    } else if([self.reportTypeId isEqualToNumber:[NSNumber numberWithInt:5]]) {
                        //change over last quarter value
                        [[FISharedResources sharedResourceManager]getChangeOverLastQuarterArticleListFromDate:self.clickedDate endDateIn:@"MONTH" field1:@"fields.name" value1:self.changeOverSelectedValue fromDate:self.reportFromDate toDate:self.reportToDate withSize:[NSNumber numberWithInt:10] withPageNo:[NSNumber numberWithInteger:pageNo] withFilterBy:filterString withQuery:self.searchText withFlag:@"" withLastArticleId:[self.articleIdArray lastObject]];
                    } else if([self.reportTypeId isEqualToNumber:[NSNumber numberWithInt:6]]) {
                        //top sources
                        [[FISharedResources sharedResourceManager]getHorizontalLineBarChartArticleListFromField1:@"tonality.name" field2:@"outlet.name.sort" value1:self.horizontalBarChartTonalityValue value2:self.horizontalBarChartSelectedValue fromDate:self.reportFromDate toDate:self.reportToDate withSize:[NSNumber numberWithInt:10] withPageNo:[NSNumber numberWithInteger:pageNo] withFilterBy:filterString withQuery:self.searchText withFlag:@"" withLastArticleId:[self.articleIdArray lastObject]];
                    } else if([self.reportTypeId isEqualToNumber:[NSNumber numberWithInt:7]]) {
                        //top journalist
                        [[FISharedResources sharedResourceManager]getHorizontalLineBarChartArticleListFromField1:@"tonality.name" field2:@"contact.name.sort" value1:self.horizontalBarChartTonalityValue value2:self.horizontalBarChartSelectedValue fromDate:self.reportFromDate toDate:self.reportToDate withSize:[NSNumber numberWithInt:10] withPageNo:[NSNumber numberWithInteger:pageNo] withFilterBy:filterString withQuery:self.searchText withFlag:@"" withLastArticleId:[self.articleIdArray lastObject]];
                    } else if([self.reportTypeId isEqualToNumber:[NSNumber numberWithInt:8]]) {
                        //top influencers
                        [[FISharedResources sharedResourceManager]getHorizontalLineBarChartArticleListFromField1:@"tonality.name" field2:@"outlet.name.sort" value1:self.horizontalBarChartTonalityValue value2:self.horizontalBarChartSelectedValue fromDate:self.reportFromDate toDate:self.reportToDate withSize:[NSNumber numberWithInt:10] withPageNo:[NSNumber numberWithInteger:pageNo] withFilterBy:filterString withQuery:self.searchText withFlag:@"" withLastArticleId:[self.articleIdArray lastObject]];
                    }
                } else {
                    if([folderId isEqualToNumber:[NSNumber numberWithInt:0]] && [newsLetterId isEqualToNumber:[NSNumber numberWithInt:0]]) {
                        if([category isEqualToNumber:[NSNumber numberWithInt:-2]]) {
                            NSString *queryString;
                            if (self.isSearching) {
                                queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withQuery:self.searchText withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"" withActivityTypeID:[NSNumber numberWithInt:2]];
                            } else if (self.switchForFilter == 1){
                                queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withQuery:@"" withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"UNREAD" withActivityTypeID:[NSNumber numberWithInt:2]];
                                
                            } else if (self.switchForFilter == 2){
                                queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withQuery:@"" withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"RECENT" withActivityTypeID:[NSNumber numberWithInt:2]];
                                
                            } else {
                                queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withQuery:@"" withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"" withActivityTypeID:[NSNumber numberWithInt:2]];
                            }
                            [[FISharedResources sharedResourceManager]getCuratedNewsListWithAccessToken:queryString withCategoryId:category withContentTypeId:parentId withFlag:@"" withLastArticleId:[self.articleIdArray lastObject] withActivityTypeId:[NSNumber numberWithInt:2]];
                            
                        } else if([category isEqualToNumber:[NSNumber numberWithInt:-3]]) {
                            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"SavedForLaterIsNew"];
                            NSString *queryString;
                            if (self.isSearching) {
                                queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withQuery:self.searchText withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"" withActivityTypeID:[NSNumber numberWithInt:3]];
                            } else if (self.switchForFilter == 1){
                                queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withQuery:@"" withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"UNREAD" withActivityTypeID:[NSNumber numberWithInt:2]];
                                
                            } else if (self.switchForFilter == 2){
                                queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withQuery:@"" withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"RECENT" withActivityTypeID:[NSNumber numberWithInt:2]];
                                
                            }else {
                                queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withQuery:@"" withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"" withActivityTypeID:[NSNumber numberWithInt:3]];
                            }
                            
                            [[FISharedResources sharedResourceManager]getCuratedNewsListWithAccessToken:queryString withCategoryId:category withContentTypeId:parentId withFlag:@"" withLastArticleId:[self.articleIdArray lastObject] withActivityTypeId:[NSNumber numberWithInt:3]];
                            
                        } else {
                            NSString *queryString;
                            if (self.isSearching) {
                                queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:parentId withPageNumber:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withQuery:self.searchText withContentCategoryId:category withOrderBy:@"" withFilterBy:@"" withActivityTypeID:[NSNumber numberWithInt:0]];
                            } else if (self.switchForFilter == 1){
                                queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withQuery:@"" withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"UNREAD" withActivityTypeID:[NSNumber numberWithInt:2]];
                                
                            } else if (self.switchForFilter == 2){
                                queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:[NSNumber numberWithInt:1] withPageNumber:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withQuery:@"" withContentCategoryId:[NSNumber numberWithInt:-1] withOrderBy:@"" withFilterBy:@"RECENT" withActivityTypeID:[NSNumber numberWithInt:2]];
                                
                            }else {
                                queryString = [FIUtils formArticleListInuptFromSecurityToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withContentTypeId:parentId withPageNumber:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withQuery:@"" withContentCategoryId:category withOrderBy:@"" withFilterBy:@"" withActivityTypeID:[NSNumber numberWithInt:0]];
                            }
                            
                            [[FISharedResources sharedResourceManager]getCuratedNewsListWithAccessToken:queryString withCategoryId:category withContentTypeId:parentId withFlag:@"" withLastArticleId:[self.articleIdArray lastObject] withActivityTypeId:[NSNumber numberWithInt:0]];
                            
                        }
                        
                    } else if(![newsLetterId isEqualToNumber:[NSNumber numberWithInt:0]]) {
                        if (self.isSearching) {
                            [[FISharedResources sharedResourceManager]fetchArticleFromNewsLetterWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withNewsLetterId:newsLetterId withPageNo:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withUpFlag:NO withFlag:NO withQuery:self.searchText withFilterBy:@""];
                        } else if (self.switchForFilter == 1){
                            [[FISharedResources sharedResourceManager]fetchArticleFromNewsLetterWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withNewsLetterId:newsLetterId withPageNo:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withUpFlag:NO withFlag:NO withQuery:@"" withFilterBy:@"UNREAD"];
                            
                            
                        } else if (self.switchForFilter == 2){
                            [[FISharedResources sharedResourceManager]fetchArticleFromNewsLetterWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withNewsLetterId:newsLetterId withPageNo:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withUpFlag:NO withFlag:NO withQuery:@"" withFilterBy:@"RECENT"];
                            
                        } else {
                            [[FISharedResources sharedResourceManager]fetchArticleFromNewsLetterWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withNewsLetterId:newsLetterId withPageNo:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withUpFlag:NO withFlag:NO withQuery:@"" withFilterBy:@""];
                        }
                    }else if(![folderId isEqualToNumber:[NSNumber numberWithInt:0]]){
                        [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"FetchNextArticlesList"];
                        if (self.isSearching) {
                            [[FISharedResources sharedResourceManager]fetchArticleFromFolderWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withFolderId:folderId withPageNo:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withUpFlag:NO withQuery:self.searchText withFilterBy:@""];
                        } else if (self.switchForFilter == 1){
                            [[FISharedResources sharedResourceManager]fetchArticleFromFolderWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withFolderId:folderId withPageNo:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withUpFlag:NO withQuery:@"" withFilterBy:@"UNREAD"];
                        } else if (self.switchForFilter == 2){
                            [[FISharedResources sharedResourceManager]fetchArticleFromFolderWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withFolderId:folderId withPageNo:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withUpFlag:NO withQuery:@"" withFilterBy:@"RECENT"];
                            
                        } else {
                            [[FISharedResources sharedResourceManager]fetchArticleFromFolderWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withFolderId:folderId withPageNo:[NSNumber numberWithInteger:pageNo] withSize:[NSNumber numberWithInt:10] withUpFlag:NO withQuery:@"" withFilterBy:@""];
                        }
                        
                    }
                }
            }
            //[self getArticleIdListFromDB];
            
           //  [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"Test"];
            
        }
    }
}
//search highlight method
- (void)highlight:(UILabel *)isLabel withString:(NSString *)searchString{
    NSError *error;
    NSLog(@"%ld",(long)isLabel.tag);

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: searchString options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (!error)
    {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:isLabel.text];
        NSArray *allMatches = [regex matchesInString:isLabel.text options:0 range:NSMakeRange(0, [isLabel.text length])];
        for (NSTextCheckingResult *aMatch in allMatches)
        {
            UIColor *bgColors;
            
            if (isLabel.tag == 111 || isLabel.tag == 112) {
                bgColors = [FIUtils colorWithHexString:@"368DD7"];

            } else {
                bgColors = [FIUtils colorWithHexString:@"FFFF00"];

            }
            
            NSRange matchRange = [aMatch range];
            [attributedString setAttributes:@{NSBackgroundColorAttributeName:bgColors} range: matchRange];
        }
//        NSLog(@"%@",attributedString);

        [isLabel setAttributedText:attributedString];
        
    }
    
    
}

-(void)closeWebView {
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         innerWebView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-80);
                     }
                     completion:^(BOOL finished){
                         if (finished)
                             [innerWebView removeFromSuperview];
                         self.navigationItem.hidesBackButton = NO;
                         [self addCustomNavRightButton];
                     }];
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

-(void)showWebView:(id)sender {
    NSNotification *notification = sender;
    NSDictionary *userInfo = notification.userInfo;
    NSIndexPath *indexPath = [userInfo objectForKey:@"indexPath"];
    
    //NSLog(@"indexPath row:%ld",(long)indexPath.row);
    
    [self presentWebViewWithLink:indexPath];
    
}
-(void)presentWebViewWithLink :(NSIndexPath *)indexPath{
    
    
    NSString *urlString,*titleString;
    
    
    if(indexPath.row==0){
        
        urlString=@"https://www.linkedin.com/pub/john-maddox/7/ab5/18";
        titleString=@"John Maddox";
    }else if (indexPath.row==1){
        urlString=@"https://www.crunchbase.com/organization/a123systems";
        titleString=@"A123 Systems";
        
    }else if (indexPath.row==2){
        urlString=@"http://en.wikipedia.org/wiki/CarPlay";
        titleString=@"Apple Car Play";
        
    }else{
        
        urlString=@"https://www.youtube.com/embed/VQ0bUgAj_cw";
        titleString=@"The Apple Car";
    }
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];
    
    UINavigationController *modalController = [storyBoard instantiateViewControllerWithIdentifier:@"SocialWebView"];
    
    
    SocialWebView *SocialWebViewObj=(SocialWebView *)[[modalController viewControllers]objectAtIndex:0];
    SocialWebViewObj.titleStr=titleString;
    SocialWebViewObj.urlString=urlString;
    modalController.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:modalController animated:NO completion:nil];
}
@end
