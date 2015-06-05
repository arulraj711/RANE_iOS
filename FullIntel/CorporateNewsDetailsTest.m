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
#import "CommentsPopoverView.h"
#import "PresentingAnimator.h"
#import "DismissingAnimator.h"
#import "ResearchRequestPopoverView.h"

@interface CorporateNewsDetailsTest ()

@end

@implementation CorporateNewsDetailsTest

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socialLinkSelected:) name:@"socialLinkSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mailButtonClick:) name:@"mailButtonClick" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(globeButtonClick:) name:@"globeButtonClick" object:nil];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCommentsView:) name:@"showCommentsView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentStatusUpdate:) name:@"commentStatusUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showResearchView:) name:@"showResearchView" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWebView:) name:@"widgetSelected" object:nil];
    
    
    
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
    
}



-(void)addCustomNavRightButton {
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Open Sans" size:18];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.text = @"Article";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    
    
    UIView *addBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    addBtnView.backgroundColor = [UIColor clearColor];
    
    UIButton *addBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setFrame:CGRectMake(0.0f,0.0f,25.0f,25.0f)];
    
    BOOL isFIViewSelected = [[NSUserDefaults standardUserDefaults]boolForKey:@"isFIViewSelected"];
    if(isFIViewSelected) {
        [addBtn setBackgroundImage:[UIImage imageNamed:@"nav_globe"]  forState:UIControlStateNormal];
    } else {
        [addBtn setBackgroundImage:[UIImage imageNamed:@"nav_fi"]  forState:UIControlStateNormal];
    }
    [addBtn addTarget:self action:@selector(globeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [addBtnView addSubview:addBtn];
    UIBarButtonItem *addContentButton = [[UIBarButtonItem alloc] initWithCustomView:addBtnView];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:addContentButton,  nil]];
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
        if(self.articleIdArray.count != 0) {
            [self.collectionView reloadData];
        }
        
        [self.activityIndicator stopAnimating];
        [oneSecondTicker invalidate];
    } else {
        NSLog(@"test flag is FALSE");
    }
}

-(void)commentStatusUpdate:(id)sender {
    NSNotification *notification = sender;
    NSDictionary *userInfo = notification.userInfo;
    NSIndexPath *indexPath = [userInfo objectForKey:@"indexPath"];
    // NSNumber  = [userInfo objectForKey:@"status"];
   // NSManagedObject *curatedNews = [self.devices objectAtIndex:indexPath.row];
    [curatedNewsDetail setValue:0 forKey:@"unReadComment"];
    CorporateDetailCell *cell = (CorporateDetailCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.badgeTwo.value = 0;
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
    BOOL isFIViewSelected = [[NSUserDefaults standardUserDefaults]boolForKey:@"isFIViewSelected"];
    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@",[self.articleIdArray objectAtIndex:indexPath.row]];
    [fetchRequest setPredicate:predicate];
    NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if(newPerson.count != 0) {
        NSManagedObject *curatedNews = [newPerson objectAtIndex:0];
       // NSLog(@"selected curated news:%@",curatedNews);
        cell.articleTitle.text = [curatedNews valueForKey:@"title"];
        
        NSString *articleImageStr = [curatedNews valueForKey:@"image"];
        [cell.articleImageView sd_setImageWithURL:[NSURL URLWithString:articleImageStr] placeholderImage:nil];
        [cell.articleImageView setContentMode:UIViewContentModeScaleAspectFill];
        cell.cachedImageViewSize = cell.articleImageView.frame;
        cell.articleDate.text = [FIUtils getDateFromTimeStamp:[[curatedNews valueForKey:@"date"] doubleValue]];
        cell.overlayArticleDate.text = [FIUtils getDateFromTimeStamp:[[curatedNews valueForKey:@"date"] doubleValue]];
        cell.overlayArticleDesc.text = [curatedNews valueForKey:@"desc"];
        
        [cell.overlayArticleImageView sd_setImageWithURL:[NSURL URLWithString:articleImageStr] placeholderImage:[UIImage imageNamed:@"FI"]];
        [cell.overlayArticleImageView setContentMode:UIViewContentModeScaleAspectFill];
        cell.overlayArticleTitle.text = [curatedNews valueForKey:@"title"];
        
        
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
        cell.overlayArticleOutlet.text = [curatedNews valueForKey:@"outlet"];
        
        NSSet *authorSet = [curatedNews valueForKey:@"author"];
        NSMutableArray *authorArray = [[NSMutableArray alloc]initWithArray:[authorSet allObjects]];
        
        //NSLog(@"before author array:%@ and count:%d",authorArray,authorArray.count);
        
        NSMutableArray *multipleAuthorArray = [[NSMutableArray alloc]init];
        if(authorArray.count != 0) {
            if(authorArray.count > 1) {
                for(int i=0;i<2;i++) {
                    NSManagedObject *authorObject = [authorArray objectAtIndex:i];
                    [multipleAuthorArray addObject:[authorObject valueForKey:@"name"]];
                }
                cell.articleAuthor.text = [multipleAuthorArray componentsJoinedByString:@" and "];
                cell.overlayArticleAuthor.text = [multipleAuthorArray componentsJoinedByString:@" and "];
            } else {
                NSManagedObject *authorObject = [authorArray objectAtIndex:0];
                cell.articleAuthor.text = [authorObject valueForKey:@"name"];
                cell.overlayArticleAuthor.text = [authorObject valueForKey:@"name"];
            }
        }
        
        NSManagedObject *authors;
        if(authorArray.count != 0) {
            authors = [authorArray objectAtIndex:0];
        }
        
        //cell.articleAuthor.text = [authors valueForKey:@"name"];
        cell.aboutAuthorName.text = [authors valueForKey:@"name"];
        cell.authorName.text = [authors valueForKey:@"name"];
        cell.authorWorkTitle.text = [authors valueForKey:@"title"];
        [cell.authorImageView sd_setImageWithURL:[NSURL URLWithString:[authors valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"userIcon_150"]];
        [cell.authorImageView setContentMode:UIViewContentModeScaleAspectFill];
        
        curatedNewsDetail = [curatedNews valueForKey:@"details"];
        curatedNewsAuthorDetail = [curatedNews valueForKey:@"authorDetails"];
        
        if(isFIViewSelected) {
            cell.detailsWebview.hidden = YES;
            cell.overlayView.hidden = YES;
            [cell.timer invalidate];
        } else {
            cell.detailsWebview.hidden = NO;
            cell.overlayView.hidden = NO;
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                [cell.detailsWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
                if([curatedNews valueForKey:@"articleUrlData"] == nil) {
                    NSString *string = [NSString stringWithContentsOfURL:[NSURL URLWithString:[curatedNews valueForKey:@"articleUrl"]] encoding:NSASCIIStringEncoding error:nil];
                    [curatedNews setValue:string forKey:@"articleUrlData"];
                    [cell.detailsWebview loadHTMLString:string baseURL:nil];
                } else {
                    [cell.detailsWebview loadHTMLString:[curatedNews valueForKey:@"articleUrlData"] baseURL:nil];
                }
            });
        }
        
        
        NSNumber *unreadCnt = [curatedNewsDetail valueForKey:@"unReadComment"];
        cell.badgeTwo.value = [unreadCnt integerValue];
        
        NSNumber *number = [curatedNews valueForKey:@"readStatus"];
        NSString *categoryStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"categoryId"]];
        //NSLog(@"category id for read:%@",categoryStr);
         //BOOL isRead = [NSNumber numberWithBool:[curatedNews valueForKey:@"readStatus"]];
        if(number == [NSNumber numberWithInt:1]) {
            
        } else {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMenuCount" object:nil userInfo:@{@"type":categoryStr}];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"readStatusUpdate" object:nil userInfo:@{@"indexPath":indexPath,@"status":[NSNumber numberWithBool:YES]}];
        }
        
        
        cell.curatedNewsDetail = curatedNewsDetail;
        cell.selectedIndexPath = indexPath;
        cell.articleDesc = [curatedNews valueForKey:@"desc"];
        cell.selectedArticleTitle = [curatedNews valueForKey:@"title"];
        cell.selectedArticleUrl = [curatedNews valueForKey:@"articleUrl"];
        cell.selectedArticleId = [curatedNews valueForKey:@"articleId"];
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
                
                
                NSString *userAccountTypeId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userAccountTypeId"]];
                
                if([userAccountTypeId isEqualToString:@"3"]) {
                    cell.webViewHeightConstraint.constant = 400;
                }else if([userAccountTypeId isEqualToString:@"2"] || [userAccountTypeId isEqualToString:@"1"]) {
                    cell.webViewHeightConstraint.constant = 940;
                }
                
                
                
                
                NSString *htmlString = [NSString stringWithFormat:@"<body style='color:#666e73;font-family:Open Sans;line-height: 1.7;font-size: 16px;font-weight: 310;'>%@",[curatedNewsDetail valueForKey:@"article"]];
                [cell.articleWebview loadHTMLString:htmlString baseURL:nil];
                
                
                NSNumber *markImpStatus = [curatedNewsDetail valueForKey:@"markAsImportant"];
                if(markImpStatus == [NSNumber numberWithInt:1]) {
                  //  NSLog(@"mark selected");
                    [cell.markedImpButton setSelected:YES];
                } else {
                   // NSLog(@"mark not selected");
                    [cell.markedImpButton setSelected:NO];
                }
                
                if([[curatedNews valueForKey:@"saveForLater"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                    [cell.savedForLaterButton setSelected:YES];
                } else {
                    [cell.savedForLaterButton setSelected:NO];
                }
                
                NSSet *relatedPostSet = [curatedNewsDetail valueForKey:@"relatedPost"];
                NSMutableArray *postArray = [[NSMutableArray alloc]initWithArray:[relatedPostSet allObjects]];
                cell.relatedPostArray = postArray;
                [cell loadTweetsFromPost];
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
           // NSLog(@"social list:%d",self.socialLinksArray.count);
           
            
            
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
            
          //  NSString *authorName = [NSString stringWithFormat:@"%@ %@",[author valueForKey:@"firstName"],[author valueForKey:@"lastName"]];
            //cell.aboutAuthorName.text = authorName;
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
                
                NSString *bioString = [author valueForKey:@"bibliography"];
            
                if(bioString.length != 0) {
                    
                    cell.bioTitleLabel.hidden = NO;
                    cell.bioDivider.hidden = NO;
                    cell.bioLabel.hidden = NO;
                    cell.bioLabel.text = bioString;
                } else {
                    cell.bioTitleLabel.hidden = YES;
                    cell.bioDivider.hidden = YES;
                    cell.bioLabel.hidden = YES;
                }
            
                });
        }
    }
    return cell;
    
}




-(void)removeOverlay:(UITapGestureRecognizer *)gesture {
    NSLog(@"remove overlay working");
    
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


-(void)showCommentsView:(id)sender {
    NSNotification *notification = sender;
    NSDictionary *userInfo = notification.userInfo;
    NSString *articleId = [userInfo objectForKey:@"articleId"];
    NSIndexPath *indexPath = [userInfo objectForKey:@"indexPath"];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Comments" bundle:nil];
    UINavigationController *navCtlr = [storyBoard instantiateViewControllerWithIdentifier:@"commentNav"];
    
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
    
    
    UIStoryboard *centerStoryBoard = [UIStoryboard storyboardWithName:@"ResearchRequest" bundle:nil];
    UINavigationController *popOverView =[centerStoryBoard instantiateViewControllerWithIdentifier:@"requestNav"];
    
    ResearchRequestPopoverView *researchViewController=(ResearchRequestPopoverView *)[[popOverView viewControllers]objectAtIndex:0];
 //   ResearchRequestPopoverView *popOverView = [[ResearchRequestPopoverView alloc]initWithNibName:@"ResearchRequestPopoverView" bundle:nil];
    researchViewController.articleId = articleId;
    researchViewController.articleTitle = articleTitle;
    researchViewController.articleUrl = articleUrl;
//   popOverView.transitioningDelegate = self;
    popOverView.modalPresentationStyle = UIModalPresentationCustom;
    
    
    
    
    [self presentViewController:popOverView animated:NO completion:nil];
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
    NSLog(@"one");
    NSNotification *notification = sender;
    NSDictionary *userInfo = notification.userInfo;
    NSString *title = [userInfo objectForKey:@"title"];
    NSString *body = [userInfo objectForKey:@"body"];
    mailComposer = [[MFMailComposeViewController alloc]init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setSubject:title];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont
                                                                fontWithName:@"Open Sans" size:18], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    mailComposer.navigationBar.titleTextAttributes = attributes;
   // [mailComposer.navigationBar setTintColor:[UIColor whiteColor]];
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

-(void)globeButtonClick:(UIButton *)sender {
    
    if(sender.selected) {
        [sender setBackgroundImage:[UIImage imageNamed:@"nav_fi"] forState:UIControlStateNormal];
        [sender setSelected:NO];
       // [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFIViewSelected"];
    } else {
        [sender setBackgroundImage:[UIImage imageNamed:@"nav_globe"] forState:UIControlStateNormal];
        [sender setSelected:YES];
       // [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isFIViewSelected"];
    }
  //  [sender setSelected:YES];
//    if(sender.selected) {
//        [sender setSelected:NO];
//       // [sender setImage:[UIImage imageNamed:@"nav_fi"] forState:UIControlStateNormal];
//    } else {
//        [sender setSelected:YES];
//        //[sender ];
//       // [sender setImage:[UIImage imageNamed:@"nav_globe"] forState:(UIControlStateSelected | UIControlStateHighlighted)];
//       // [addBtn setImage:[UIImage imageNamed:@"nav_globe"] forState:UIControlStateHighlighted];
//    }
    //NSNotification *notification = sender;
   // NSDictionary *userInfo = notification.userInfo;
    //NSString *articleUrl = [curatedNewsDetail valueForKey:@"articleUrl"];
    
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button addTarget:self action:@selector(closeWebView)
//     forControlEvents:UIControlEventTouchUpInside];
//    [button setImage:[UIImage imageNamed:@"nav_globe"] forState:UIControlSelected];
//    // [button setTitle:@"Show View" forState:UIControlStateNormal];
//    button.frame = CGRectMake(0, 10, 28, 28);
//    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = customBarItem;
    BOOL isFIViewSelected = [[NSUserDefaults standardUserDefaults]boolForKey:@"isFIViewSelected"];
    if(isFIViewSelected) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"removeWebView" object:nil userInfo:@{@"status":[NSNumber numberWithBool:0]}];
    } else {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"removeWebView" object:nil userInfo:@{@"status":[NSNumber numberWithBool:1]}];
    }
    
    
    
    
    
    
//    [UIView animateWithDuration:0.2
//                          delay:0.1
//                        options: UIViewAnimationOptionCurveEaseIn
//                     animations:^{
//                         innerWebView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-80);
//                         
//                         
//                         UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, innerWebView.frame.size.width, innerWebView.frame.size.height)];
//                         webView.backgroundColor = [UIColor whiteColor];
//                         NSURL *url = [NSURL URLWithString:articleUrl];
//                         NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
//                         [webView loadRequest:requestObj];
//                         [innerWebView addSubview:webView];
//                         innerWebView.backgroundColor = [UIColor whiteColor];
//                         self.navigationItem.hidesBackButton = YES;
//                         UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//                         [button addTarget:self action:@selector(closeWebView)
//                          forControlEvents:UIControlEventTouchUpInside];
//                         [button setImage:[UIImage imageNamed:@"nav_globe"] forState:UIControlStateNormal];
//                         // [button setTitle:@"Show View" forState:UIControlStateNormal];
//                         button.frame = CGRectMake(0, 10, 28, 28);
//                         UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//                         self.navigationItem.rightBarButtonItem = customBarItem;
//                     }
//                     completion:^(BOOL finished){
//                     }];
//    [self.view addSubview:innerWebView];
}

-(void)scrollViewDidScroll: (UIScrollView*)scrollView
{
  //  NSLog(@"collection view scroll");
    int lastCount = self.articleIdArray.count-1;
    float scrollOffset = self.collectionView.contentOffset.x;
    
    
    
    
    if(scrollOffset > self.collectionView.frame.size.width*lastCount) {
       // NSLog(@"reached end");
        
        if(self.articleIdArray.count != 0) {
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
    
    NSLog(@"indexPath row:%ld",(long)indexPath.row);
    
    [self presentWebViewWithLink:indexPath];
    
}
-(void)presentWebViewWithLink :(NSIndexPath *)indexPath{
    
    
    NSString *urlString;
    
    
    if(indexPath.row==0){
        
        urlString=@"https://www.linkedin.com/pub/john-maddox/7/ab5/18";
    }else if (indexPath.row==1){
        urlString=@"https://www.crunchbase.com/organization/a123systems";
        
    }else if (indexPath.row==2){
         urlString=@"http://en.wikipedia.org/wiki/CarPlay";
        
    }else{
        
        urlString=@"https://www.youtube.com/embed/VQ0bUgAj_cw";
    }
    
    
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
            mzvc.urlString = urlString;
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
        
        navController.topViewController.title = @"";
        
        navController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        SocialWebView *mzvc = (SocialWebView *)navController.topViewController;
        mzvc.urlString = urlString;
    };
    formSheet.transitionStyle = MZFormSheetTransitionStyleCustom;
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
    
}
@end
