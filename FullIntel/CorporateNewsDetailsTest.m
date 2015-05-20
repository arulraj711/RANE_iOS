//
//  CorporateNewsDetailsTest.m
//  FullIntel
//
//  Created by Capestart on 5/13/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "CorporateNewsDetailsTest.h"
#import "CorporateDetailCell.h"
#import "FISharedResources.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FIUtils.h"
#import "SocialWebView.h"
#import "MZFormSheetController.h"
#import <TwitterKit/TwitterKit.h>

@interface CorporateNewsDetailsTest ()

@end

@implementation CorporateNewsDetailsTest

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCuratedNewsDetails) name:@"CuratedNewsDetails" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCuratedNewsAuthorDetails) name:@"CuratedNewsAuthorDetails" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socialLinkSelected:) name:@"socialLinkSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mailButtonClick:) name:@"mailButtonClick" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(globeButtonClick:) name:@"globeButtonClick" object:nil];
    [self addCustomNavRightButton];
    oneSecondTicker = [[NSTimer alloc] init];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [self.collectionView setPagingEnabled:YES];
    [self.collectionView setCollectionViewLayout:flowLayout];
    [self.collectionView reloadData];
    
   // self.collectionView.contentOffset = CGPointMake(self.collectionView.frame.size.width*2, 0);
    
    innerWebView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-80)];
    
   // self.navigationItem.rightBarButtonItem =nil;
    
    [self getArticleIdListFromDB];
    
}

-(void)viewDidAppear:(BOOL)animated {

    CGSize currentSize = self.collectionView.bounds.size;
    float offset = self.currentIndex * currentSize.width;
    [self.collectionView setContentOffset:CGPointMake(offset, 0)];
    
    
    NSArray *tweetIds=@[@"20",@"21"];
    
    [[Twitter sharedInstance] logInGuestWithCompletion:^(TWTRGuestSession *guestSession, NSError *error) {
        [[[Twitter sharedInstance] APIClient] loadTweetsWithIDs:tweetIds completion:^(NSArray *tweet, NSError *error) {

            NSLog(@"Tweet array:%@",tweet);
            
        }];
    }];

    
}

-(void)addCustomNavRightButton {
    UIView *addBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    addBtnView.backgroundColor = [UIColor clearColor];
    
    UIButton *addBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setFrame:CGRectMake(0.0f,0.0f,25.0f,25.0f)];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"nav_globe"]  forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(globeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [addBtnView addSubview:addBtn];
    UIBarButtonItem *addContentButton = [[UIBarButtonItem alloc] initWithCustomView:addBtnView];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:addContentButton,  nil]];
}


-(void)loadCuratedNewsDetails {
    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@",[self.articleIdArray objectAtIndex:self.selectedIndex]];
    [fetchRequest setPredicate:predicate];
    NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if(newPerson.count != 0) {
        NSManagedObject *curatedNews = [newPerson objectAtIndex:0];
        curatedNewsDetail = [curatedNews valueForKey:@"details"];
    }
    [self.collectionView reloadData];
}

-(void)loadCuratedNewsAuthorDetails {
    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@",[self.articleIdArray objectAtIndex:self.selectedIndex]];
    [fetchRequest setPredicate:predicate];
    NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSManagedObject *curatedNews;
    if(newPerson.count != 0) {
        curatedNews = [newPerson objectAtIndex:0];
        curatedNewsAuthorDetail = [curatedNews valueForKey:@"authorDetails"];
    }
    NSLog(@"curated news author:%@",curatedNewsAuthorDetail);
    
    
    [self.collectionView reloadData];
}
-(void)getArticleIdListFromDB {
    //[oneSecondTicker invalidate];
    
    
    BOOL testFlag = [[NSUserDefaults standardUserDefaults]boolForKey:@"Test"];
    if(testFlag) {
        NSLog(@"test flag is TRUE");
        
        NSInteger categoryId = [[[NSUserDefaults standardUserDefaults]objectForKey:@"categoryId"] integerValue];
        NSLog(@"category id in curated news:%d",categoryId);
        
        self.collectionView.scrollEnabled = YES;
        NSManagedObjectContext *context = [[FISharedResources sharedResourceManager]managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"CuratedNews" inManagedObjectContext:context];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"categoryId == %d",categoryId];
        [fetchRequest setPredicate:predicate];
        [fetchRequest setEntity:entity];
        
        NSSortDescriptor *date = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
        
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:date, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
        
        NSMutableArray *elementsFromColumn = [[NSMutableArray alloc] init];
        for (NSManagedObject *fetchedObject in fetchedObjects) {
            [elementsFromColumn addObject:[fetchedObject valueForKey:@"articleId"]];
        }
        
        NSLog(@"elementsfrom column:%@",elementsFromColumn);
        self.articleIdArray = [[NSMutableArray alloc]initWithArray:elementsFromColumn];
        NSLog(@"article id array:%@",self.articleIdArray);
        [self.collectionView reloadData];
        [self.activityIndicator stopAnimating];
        [oneSecondTicker invalidate];
    } else {
        NSLog(@"test flag is FALSE");
    }
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
   // NSLog(@"cell indexpath:%@",indexPath);
    self.selectedIndex = indexPath.row;
    CorporateDetailCell *cell = (CorporateDetailCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [cell.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    cell.cachedImageViewSize = cell.articleImageView.frame;
    
    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@",[self.articleIdArray objectAtIndex:indexPath.row]];
    [fetchRequest setPredicate:predicate];
    NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if(newPerson.count != 0) {
        NSManagedObject *curatedNews = [newPerson objectAtIndex:0];
       // NSLog(@"selected curated news:%@",curatedNews);
        cell.articleTitle.text = [curatedNews valueForKey:@"title"];
        [cell.articleImageView sd_setImageWithURL:[NSURL URLWithString:[curatedNews valueForKey:@"image"]] placeholderImage:nil];
        [cell.articleImageView setContentMode:UIViewContentModeScaleAspectFill];
        cell.cachedImageViewSize = cell.articleImageView.frame;
        cell.articleDate.text = [FIUtils getDateFromTimeStamp:[[curatedNews valueForKey:@"date"] doubleValue]];
        
        NSString *outletString = [curatedNews valueForKey:@"outlet"];
        
        CGFloat width =  [outletString sizeWithFont:[UIFont fontWithName:@"OpenSans" size:14 ]].width;
        NSLog(@"outlet text width:%f",width);
        if(width == 0) {
            
        }
        else if(width < 59) {
            
            CGFloat value = width;
            cell.outletTextWidthConstraint.constant = value;
           // self.outletHorizontalConstraint.constant = value+10;
        }else {
            
            CGFloat value = width;
            cell.outletTextWidthConstraint.constant = value;
          //  self.outletHorizontalConstraint.constant = value+10;
        }
        
        cell.articleOutlet.text = [curatedNews valueForKey:@"outlet"];
        
        NSSet *authorSet = [curatedNews valueForKey:@"author"];
        NSMutableArray *authorArray = [[NSMutableArray alloc]initWithArray:[authorSet allObjects]];
        NSManagedObject *authors;
        if(authorArray.count != 0) {
            authors = [authorArray objectAtIndex:0];
        }
        cell.articleAuthor.text = [authors valueForKey:@"name"];
        cell.authorName.text = [authors valueForKey:@"name"];
        cell.authorWorkTitle.text = [authors valueForKey:@"title"];
        [cell.authorImageView sd_setImageWithURL:[NSURL URLWithString:[authors valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"userIcon_150"]];
        [cell.authorImageView setContentMode:UIViewContentModeScaleAspectFill];
        
        curatedNewsDetail = [curatedNews valueForKey:@"details"];
        curatedNewsAuthorDetail = [curatedNews valueForKey:@"authorDetails"];
        cell.curatedNewsDetail = curatedNewsDetail;
        cell.selectedIndexPath = indexPath;
        cell.articleDesc = [curatedNews valueForKey:@"desc"];
        
        if(curatedNewsDetail == nil) {
            // NSLog(@"details is null");
           
            [cell.articleWebview loadHTMLString:@"" baseURL:nil];
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
            
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                //Background Thread
                [[FISharedResources sharedResourceManager]getCuratedNewsDetailsWithDetails:resultStr];
                [[FISharedResources sharedResourceManager]getCuratedNewsAuthorDetailsWithDetails:authorResultStr withArticleId:[curatedNews valueForKey:@"articleId"]];
                
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                NSString *htmlString = [NSString stringWithFormat:@"<body style='color:#666e73;font-family:Open Sans;line-height: 1.7;font-size: 16px;font-weight: 310;'>%@",[curatedNewsDetail valueForKey:@"article"]];
                [cell.articleWebview loadHTMLString:htmlString baseURL:nil];
            });
        }
        
        
        
        if(curatedNewsAuthorDetail == nil) {
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
            
            NSSet *authorSet = [curatedNews valueForKey:@"authorDetails"];
            NSMutableArray *legendsArray = [[NSMutableArray alloc]initWithArray:[authorSet allObjects]];
            NSManagedObject *author;
            if(legendsArray.count != 0) {
                author  = [legendsArray objectAtIndex:0];
            }
          //  NSLog(@"single author:%@",author);
            
            self.socialLinksArray = [[NSMutableArray alloc]init];
            NSSet *socialMediaSet = [author valueForKey:@"authorSocialMedia"];
            self.socialLinksArray = [[NSMutableArray alloc]initWithArray:[socialMediaSet allObjects]];
            NSLog(@"social list:%d",self.socialLinksArray.count);
           
            
            
            if(self.socialLinksArray.count == 0) {
                cell.socialLinkLabel.hidden = YES;
                cell.socialLinkDivider.hidden = YES;
                cell.socialLinkCollectionView.hidden = YES;
            } else {
                cell.socialLinksArray = self.socialLinksArray;
                cell.socialLinkLabel.hidden = NO;
                cell.socialLinkDivider.hidden = NO;
                cell.socialLinkCollectionView.hidden = NO;
                
                [cell.socialLinkCollectionView reloadData];
            }
            
            [cell.aboutAuthorImageView sd_setImageWithURL:[NSURL URLWithString:[author valueForKey:@"imageURL"]] placeholderImage:[UIImage imageNamed:@"userIcon_150"]];
            [cell.aboutAuthorImageView setContentMode:UIViewContentModeScaleAspectFill];
            
            NSString *authorName = [NSString stringWithFormat:@"%@ %@",[author valueForKey:@"firstName"],[author valueForKey:@"lastName"]];
            cell.aboutAuthorName.text = authorName;
            cell.authorNameStr = [author valueForKey:@"firstName"];
            
            if([[author valueForKey:@"starRating"] integerValue] == 0) {
                cell.ratingControl.hidden = YES;
            } else {
                cell.ratingControl.hidden = NO;
                cell.starRating.rating = [[author valueForKey:@"starRating"] integerValue];
            }
            
            if([[author valueForKey:@"isInfluencer"]isEqualToNumber:[NSNumber numberWithInt:1]]) {
                cell.influencerIconImage.hidden = NO;
            } else {
                cell.influencerIconImage.hidden = YES;
            }
            
            
            NSSet *workTitleSet = [author valueForKey:@"authorWorkTitle"];
            NSMutableArray *workTitleArray = [[NSMutableArray alloc]initWithArray:[workTitleSet allObjects]];
            if(workTitleArray.count != 0) {
                cell.workTitleIcon.hidden = NO;
                cell.workTitleIconHeightConstraint.constant = 15;
                cell.workTitleLabelHeightConstraint.constant = 21;
                cell.outletImageTopConstraint.constant = 10;
                cell.outletLabelTopConstraint.constant = 4;
                NSManagedObject *workTitle = [workTitleArray objectAtIndex:0];
                cell.authorWorkTitleLabel.text = [workTitle valueForKey:@"title"];
            } else {
                cell.workTitleIcon.hidden = YES;
                cell.workTitleIconHeightConstraint.constant = 0;
                cell.workTitleLabelHeightConstraint.constant = 0;
                cell.outletImageTopConstraint.constant = 0;
                cell.outletLabelTopConstraint.constant = 0;
            }
            
            
            NSSet *outletSet = [author valueForKey:@"authorOutlet"];
            NSMutableArray *outletArray = [[NSMutableArray alloc]initWithArray:[outletSet allObjects]];
            if(outletArray.count != 0) {
                cell.outletIcon.hidden = NO;
                cell.locationImageTopConstarint.constant = 10;
                cell.outletIconHeightConstraint.constant = 15;
                cell.locationLabelTopConstraint.constant = 4;
                cell.outletLabelHeightConstraint.constant = 21;
                NSManagedObject *outlet = [outletArray objectAtIndex:0];
                cell.authorOutletName.text = [outlet valueForKey:@"outletname"];
            }else {
                cell.outletIcon.hidden = YES;
                cell.outletIconHeightConstraint.constant = 0;
                cell.locationImageTopConstarint.constant = 0;
                cell.locationLabelTopConstraint.constant = 0;
                cell.outletLabelHeightConstraint.constant = 0;
            }
            
            
            NSString *city = [author valueForKey:@"city"];
            NSString *country = [author valueForKey:@"country"];
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
                cell.locationIconHeightConstraint.constant = 15;
                cell.locationLabelHeightConstraint.constant = 21;
                cell.beatsImageTopConstraint.constant = 10;
                cell.beatsLabelTopConstraint.constant = 4;
                cell.authorLocationLabel.text = authorPlace;
            } else {
                cell.locationIcon.hidden = YES;
                cell.locationIconHeightConstraint.constant = 0;
                cell.locationLabelHeightConstraint.constant = 0;
                cell.beatsImageTopConstraint.constant = 0;
                cell.beatsLabelTopConstraint.constant = 0;
            }
            
            NSSet *beatSet = [author valueForKey:@"authorBeat"];
            NSMutableArray *beatsArray = [[NSMutableArray alloc]initWithArray:[beatSet allObjects]];
            NSMutableArray *beats = [[NSMutableArray alloc]init];
            for(NSManagedObject *beat in beatsArray) {
                [beats addObject:[NSString stringWithFormat:@"#%@",[beat valueForKey:@"name"]]];
            }
            NSString *beatString = [beats componentsJoinedByString:@" "];
            if(beatString.length != 0){
                cell.beatsIcon.hidden = NO;
                cell.beatsIconHeightConstraint.constant = 15;
                cell.beatsLabelHeightConstraint.constant = 21;
                cell.authorTagLabel.text = beatString;
            } else {
                cell.beatsIcon.hidden = YES;
                cell.beatsIconHeightConstraint.constant = 0;
                cell.beatsLabelHeightConstraint.constant = 0;
            }
            
            cell.bioLabel.text = [author valueForKey:@"bibliography"];
                });
        }
    }
    
    return cell;
    
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
    [self.collectionView.collectionViewLayout invalidateLayout];
    
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
    }];
    
}


- (void)socialLinkSelected:(id)sender
{
    NSNotification *notification = sender;
    NSDictionary *userInfo = notification.userInfo;
    NSString *title = [userInfo objectForKey:@"name"];
    NSString *link = [userInfo objectForKey:@"link"];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];
    
    UINavigationController *modalController = [storyBoard instantiateViewControllerWithIdentifier:@"SocialWebView"];
    // UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"modal"];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:modalController];
    
    formSheet.presentedFormSheetSize = CGSizeMake(850, 700);
    //    formSheet.transitionStyle = MZFormSheetTransitionStyleSlideFromTop;
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    // formSheet.keyboardMovementStyle = MZFormSheetKeyboardMovementStyleMoveToTop;
    // formSheet.keyboardMovementStyle = MZFormSheetKeyboardMovementStyleMoveToTopInset;
    // formSheet.landscapeTopInset = 50;
    // formSheet.portraitTopInset = 100;
    
    __weak MZFormSheetController *weakFormSheet = formSheet;
    
    
    // If you want to animate status bar use this code
    formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
        UINavigationController *navController = (UINavigationController *)weakFormSheet.presentedFSViewController;
        if ([navController.topViewController isKindOfClass:[SocialWebView class]]) {
            SocialWebView *mzvc = (SocialWebView *)navController.topViewController;
            mzvc.urlString = link;
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
        
        navController.topViewController.title = title;
        
        navController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        SocialWebView *mzvc = (SocialWebView *)navController.topViewController;
        mzvc.urlString = link;
    };
    formSheet.transitionStyle = MZFormSheetTransitionStyleCustom;
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
    
}

-(void)mailButtonClick:(id)sender {
    NSNotification *notification = sender;
    NSDictionary *userInfo = notification.userInfo;
    NSString *title = [userInfo objectForKey:@"title"];
    NSString *body = [userInfo objectForKey:@"body"];
    mailComposer = [[MFMailComposeViewController alloc]init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setSubject:title];
    [mailComposer setMessageBody:body isHTML:NO];
    [self presentViewController:mailComposer animated:YES completion:nil];
}

#pragma mark - mail compose delegate
-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (result) {
        NSLog(@"Result : %d",result);
    }
    if (error) {
        NSLog(@"Error : %@",error);
    }
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)globeButtonClick {
    //NSNotification *notification = sender;
   // NSDictionary *userInfo = notification.userInfo;
    NSString *articleUrl = [curatedNewsDetail valueForKey:@"articleUrl"];
    
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         innerWebView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-80);
                         
                         
                         UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, innerWebView.frame.size.width, innerWebView.frame.size.height)];
                         webView.backgroundColor = [UIColor whiteColor];
                         NSURL *url = [NSURL URLWithString:articleUrl];
                         NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
                         [webView loadRequest:requestObj];
                         [innerWebView addSubview:webView];
                         innerWebView.backgroundColor = [UIColor whiteColor];
                         self.navigationItem.hidesBackButton = YES;
                         UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                         [button addTarget:self action:@selector(closeWebView)
                          forControlEvents:UIControlEventTouchUpInside];
                         [button setImage:[UIImage imageNamed:@"nav_fi"] forState:UIControlStateNormal];
                         // [button setTitle:@"Show View" forState:UIControlStateNormal];
                         button.frame = CGRectMake(0, 10, 28, 28);
                         UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
                         self.navigationItem.rightBarButtonItem = customBarItem;
                     }
                     completion:^(BOOL finished){
                     }];
    [self.view addSubview:innerWebView];
}

-(void)scrollViewDidScroll: (UIScrollView*)scrollView
{
    int lastCount = self.articleIdArray.count-1;
    float scrollOffset = self.collectionView.contentOffset.x;
    //NSLog(@"scrollview offset:%f and collectionview width:%f",scrollOffset,self.collectionView.frame.size.width*lastCount);
    if(scrollOffset > self.collectionView.frame.size.width*lastCount) {
       // NSLog(@"reached end");
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.view addSubview:self.activityIndicator];
        self.activityIndicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
        [self.activityIndicator startAnimating];
        
        self.collectionView.scrollEnabled = NO;
        NSString *inputJson = [FIUtils createInputJsonForContentWithToekn:[[NSUserDefaults standardUserDefaults] valueForKey:@"accesstoken"] lastArticleId:[self.articleIdArray lastObject] contentTypeId:@"1" listSize:10 activityTypeId:@"" categoryId:[[NSUserDefaults standardUserDefaults] valueForKey:@"categoryId"]];
        dispatch_async(dispatch_get_main_queue(), ^(void){
        [[FISharedResources sharedResourceManager]getCuratedNewsListWithAccessToken:inputJson withCategoryId:[[[NSUserDefaults standardUserDefaults] valueForKey:@"categoryId"] integerValue] withFlag:@""];
        oneSecondTicker = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self
                                       selector:@selector(getArticleIdListFromDB) userInfo:nil repeats:YES];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"Test"];
        });
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




@end
