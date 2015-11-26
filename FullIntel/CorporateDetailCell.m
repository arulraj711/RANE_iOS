//
//  CorporateDetailCell.m
//  FullIntel
//
//  Created by Capestart on 5/13/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "CorporateDetailCell.h"
#import "PersonalityWidgetCell.h"
#import "StockWidgetCell.h"
#import "ProductWidgetCell.h"
#import "SocialLinkCell.h"
#import "TweetsCell.h"
#import "MZFormSheetController.h"
//#import "SocialWebView.h"
#import "ResearchRequestPopoverView.h"
#import "UIView+Toast.h"
#import "CommentsPopoverView.h"
#import "FISharedResources.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <TwitterKit/TwitterKit.h>
#import "FIUtils.h"
#import "SavedListPopoverView.h"
#import "MorePopoverView.h"
#import "VideoWidgetCell.h"
#import "SocialWebView.h"
#import "pop.h"
#import "FIWebService.h"
#import "TweetsCellPhone.h"
#import "SocialLinkCellPhone.h"
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
@implementation CorporateDetailCell

- (void)awakeFromNib {
    // Initialization code
    self.badgeTwo.hideWhenZero = YES;
    self.socialLinkCollectionView.hidden = YES;

    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        
        self.authorImageView.layer.masksToBounds = YES;
        self.authorImageView.layer.cornerRadius = 1.0f;
        self.overlayArticleImageView.layer.masksToBounds = YES;
        self.overlayArticleImageView.layer.cornerRadius = 10.0f;
        self.overlayArticleImageView.layer.borderColor = [UIColor colorWithRed:(237/255.0) green:(240/255.0) blue:(240/255.0) alpha:1].CGColor;
        self.overlayArticleImageView.layer.borderWidth = 0.5f;
        
        if (IS_IPHONE_6)
        {
            self.savedIconHorizontalConstraint.constant = 35;
            self.commentIconHorizontalConstraint.constant = 35;
            self.moreIconHorizontalConstraint.constant = 35;
            self.requestIconHorizontalConstraint.constant = 35;

        }
        else if (IS_IPHONE_6P)
        {
            self.savedIconHorizontalConstraint.constant = 35;
            self.commentIconHorizontalConstraint.constant = 35;
            self.moreIconHorizontalConstraint.constant = 35;
            self.requestIconHorizontalConstraint.constant = 35;

        }
        else if (IS_IPHONE_5)
        {

        }
    }
    else {
        self.authorImageView.layer.masksToBounds = YES;
        self.authorImageView.layer.cornerRadius = 25.0f;
        self.overlayArticleImageView.layer.masksToBounds = YES;
        self.overlayArticleImageView.layer.cornerRadius = 10.0f;
        self.overlayArticleImageView.layer.borderColor = [UIColor colorWithRed:(237/255.0) green:(240/255.0) blue:(240/255.0) alpha:1].CGColor;
        self.overlayArticleImageView.layer.borderWidth = 0.5f;
    }
    
    
    self.contents = [NSDictionary dictionaryWithObjectsAndKeys:
                     // Rounded rect buttons
                     @"A CMPopTipView will automatically position itself within the container view.", [NSNumber numberWithInt:11],
                     nil];
    
    // [progressView removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCuratedNewsDetails:) name:@"CuratedNewsDetails" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCuratedNewsAuthorDetails:) name:@"CuratedNewsAuthorDetails" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeWebView:) name:@"removeWebView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(afterSwipeDownTutorial) name:@"SwipeRightLeftTutorialTrigger" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(drillDownButtonClick:) name:@"DrillDownToolBoxTutorialNavigation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(coachMardRemoved) name:@"coachMardRemoved" object:nil];
    
    
    UITapGestureRecognizer *tapEvent = [[UITapGestureRecognizer alloc]initWithTarget:self action:nil];
    tapEvent.numberOfTapsRequired = 1;
    self.detailsWebview.tag =101;
    self.detailsWebview.userInteractionEnabled = YES;
    [self.detailsWebview addGestureRecognizer:tapEvent];
    
}
-(void)performAnimationForiPhoneButton:(NSTimer *)timer {
    NSString *indexString=timer.userInfo;
    if([indexString isEqualToString:@"0"]) {
        //Marked Important button animation
        [self performAnimationForView:self.markedImpButton];
        [self addBorderForButton:self.markedImpButton];
    } else if([indexString isEqualToString:@"1"]) {
        //Saved for later button animation
        [self performAnimationForView:self.savedForLaterButton];
        [self removeBorderForButton:self.markedImpButton];
        [self addBorderForButton:self.savedForLaterButton];
    } else if([indexString isEqualToString:@"2"]) {
        //Comments button animation
        [self performAnimationForView:self.commentBtn];
        [self removeBorderForButton:self.savedForLaterButton];
        [self addBorderForButton:self.commentBtn];
    } else if([indexString isEqualToString:@"3"]) {
        //Folder button animation
        [self performAnimationForView:self.folderBtn];
        [self removeBorderForButton:self.commentBtn];
        [self addBorderForButton:self.folderBtn];
    } else if([indexString isEqualToString:@"4"]) {
        //Research request button animation
        [self performAnimationForView:self.requestBtn];
        [self removeBorderForButton:self.folderBtn];
        [self addBorderForButton:self.requestBtn];
    } else if([indexString isEqualToString:@"5"]) {
        //More button animation
        [self performAnimationForView:self.moreButton];
        [self removeBorderForButton:self.requestBtn];
        [self addBorderForButton:self.moreButton];
    }
}

-(void)drillDownButtonClick:(id)sender {
    NSNotification *notification = sender;
    NSDictionary *userInfo = notification.userInfo;
    
    NSString *indexString=[userInfo objectForKey:@"index"];
    
    NSLog(@"index string in cell :%@",indexString);
    
    
    [popAnimationTimer invalidate];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        popAnimationTimer=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(performAnimationForiPhoneButton:) userInfo:indexString repeats:YES];
    } else {
        popAnimationTimer=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(performAnimationForButton:) userInfo:indexString repeats:YES];
    }
}

-(void)performAnimationForButton:(NSTimer *)timer{
    
    NSString *indexString=timer.userInfo;
    
    NSLog(@"index string:%@",indexString);
    
    
    if([indexString isEqualToString:@"0"]){
        
        [self performAnimationForView:_markedImpButton];
        
        [self addBorderForButton:_markedImpButton];
        
    }
    
    if([indexString isEqualToString:@"1"]){
        
        [self performAnimationForView:_commentBtn];
        
        [self removeBorderForButton:_markedImpButton];
        
        [self addBorderForButton:_commentBtn];
        
    }
    
    if([indexString isEqualToString:@"2"]){
        
        [self performAnimationForView:_messageBtn];
        
        [self removeBorderForButton:_commentBtn];
        
        [self addBorderForButton:_messageBtn];
        
    }
    
    if([indexString isEqualToString:@"3"]){
        
        [self performAnimationForView:_folderBtn];
        
        [self removeBorderForButton:_messageBtn];
        
        [self addBorderForButton:_folderBtn];
        
    }
    
    if([indexString isEqualToString:@"4"]){
        
        [self performAnimationForView:_savedForLaterButton];
        
        [self removeBorderForButton:_folderBtn];
        
        [self addBorderForButton:_savedForLaterButton];
        
    }
    
    if([indexString isEqualToString:@"5"]){
        
        [self performAnimationForView:_requestBtn];
        
        [self removeBorderForButton:_savedForLaterButton];
        
        [self addBorderForButton:_requestBtn];
        
    }
    
    if([indexString isEqualToString:@"6"]){
        
        [self performAnimationForView:_moreButton];
        
        [self removeBorderForButton:_requestBtn];
        
        [self addBorderForButton:_moreButton];
        
        
    }
    
}

-(void)addBorderForButton:(UIButton *)btn{
    
    btn.layer.borderWidth=1.0;
    btn.layer.borderColor=[UIColorFromRGB(0XA4131E) CGColor];
}

-(void)removeBorderForButton:(UIButton *)btn{
    
    btn.layer.borderColor=[[UIColor clearColor]CGColor];
    btn.layer.borderWidth=0.0f;
}
-(void)coachMardRemoved{
    
    
    [self removeBorderForButton:_moreButton];
    
    [popAnimationTimer invalidate];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"EndOfDrillDownTutorial" object:nil];
    
    
    
}
-(void)afterSwipeDownTutorial{
    
    
    CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height);
    [self.scrollView setContentOffset:bottomOffset animated:NO];
}

-(void)performAnimationForView:(UIButton *)btn{
    
    [btn.layer removeAllAnimations];
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue=[NSValue valueWithCGSize:CGSizeMake(0.0, 0.0)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1,1)];
    scaleAnimation.springBounciness = 20;
    scaleAnimation.springSpeed=1;
    [btn.layer  pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
}
-(void)removeWebView:(id)sender {
    [self.timer invalidate];
    // [progressView removeFromSuperview];
    NSNotification *notification = sender;
    NSDictionary *userInfo = notification.userInfo;
    NSNumber *number = [userInfo objectForKey:@"status"];
    //NSLog(@"selected number:%@",number);
    if([number isEqualToNumber:[NSNumber numberWithInt:1]]) {
        //[self.detailsWebview removeFromSuperview];
        self.detailsWebview.hidden = YES;
        self.overlayView.hidden = YES;
        self.isFIViewSelected = YES;
        NSMutableDictionary *gradedetails = [[NSMutableDictionary alloc] init];
        [gradedetails setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
        [gradedetails setObject:[NSNumber numberWithInt:1] forKey:@"appViewTypeId"];
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:gradedetails options:NSJSONWritingPrettyPrinted error:nil];
        NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
        [[FISharedResources sharedResourceManager]updateAppViewTypeWithDetails:resultStr];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFIViewSelected"];
    } else {
        self.detailsWebview.hidden = NO;
        self.isFIViewSelected = NO;
        self.overlayView.hidden = NO;
        NSMutableDictionary *gradedetails = [[NSMutableDictionary alloc] init];
        [gradedetails setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
        [gradedetails setObject:[NSNumber numberWithInt:2] forKey:@"appViewTypeId"];
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:gradedetails options:NSJSONWritingPrettyPrinted error:nil];
        NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
        [[FISharedResources sharedResourceManager]updateAppViewTypeWithDetails:resultStr];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isFIViewSelected"];
        //[self.contentView addSubview:self.detailsWebview];
    }
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    BOOL status =NO;
    if([_detailsWebview isFirstResponder]){
        if((long)otherGestureRecognizer.view.tag == 101){
            self.overlayView.hidden = YES;
        } else {
            // self.overlayView.hidden = NO;
        }
        status=YES;
    }
    //  [self.overlayView removeFromSuperview];
    self.overlayView.hidden = YES;
    return status;
}


-(void)loadTweetsFromPost {
    self.isTwitterAPICalled = YES;
    tweetIds= [[NSMutableArray alloc]init];
    NSLog(@"related post array:%@",self.relatedPostArray);
    if([[FISharedResources sharedResourceManager]serviceIsReachable]) {
        if(self.relatedPostArray.count != 0) {
            [lbl removeFromSuperview];
            lbl.hidden = YES;
            for(NSManagedObject *relatedPost in self.relatedPostArray) {
                [tweetIds addObject:[relatedPost valueForKey:@"postId"]];
                
            }
            NSLog(@"tweet ids:%@",tweetIds);
            // NSLog(@"tweeter share instance:%@",[Twitter sharedInstance].guestSession);
            if([[Twitter sharedInstance]session]) {
                //NSLog(@"twitter session exist");
            } else {
                //NSLog(@"no twitter session");
                [[Twitter sharedInstance] logInGuestWithCompletion:^(TWTRGuestSession *guestSession, NSError *error) {
                    // NSLog(@"tweet error:%@",error);
                    [[[Twitter sharedInstance] APIClient] loadTweetsWithIDs:tweetIds completion:^(NSArray *tweet, NSError *error) {
                        NSLog(@"Tweet array:%@",tweet);
                        if(tweet.count != 0) {
                            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void){
                                tweetArray = [[NSMutableArray alloc]initWithArray:tweet];
                                
                                tweetScreenNameArray= [[NSMutableArray alloc]init];
                                
                                for(TWTRTweet *tweetObj in tweetArray) {
                                    TWTRUser *author = tweetObj.author;
                                    [tweetScreenNameArray addObject:author.screenName];
                                }
                                
                                NSArray *followArray = [[FISharedResources sharedResourceManager]getTweetDetails:[tweetScreenNameArray componentsJoinedByString:@","]];
                                followersArray = [NSMutableArray arrayWithArray:followArray];
                                NSLog(@"Tweet follwers array:%@",followersArray);
                                dispatch_async(dispatch_get_main_queue(), ^(void){
                                    [self.activityIndicator removeFromSuperview];
                                    [self.activityIndicator stopAnimating];
                                    self.tweetsLocalCollectionView.hidden = NO;
                                    [self.tweetsLocalCollectionView reloadData];
                                });
                            });
                        }
                    }];
                }];
            }
            
        } else {
            lbl.hidden = NO;
            [self.activityIndicator removeFromSuperview];
            [self.activityIndicator stopAnimating];
            
            
            //        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            //        self.activityIndicator.center = CGPointMake(self.tweetsCollectionView.frame.size.width / 2, self.tweetsCollectionView.frame.size.height / 2);
            //        [self.activityIndicator startAnimating];
            
        }
    } else {
        lbl.hidden = NO;
        [self.activityIndicator removeFromSuperview];
        [self.activityIndicator stopAnimating];
    }
    
    
}






- (IBAction)infoButtonClick:(id)sender {
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
        contentMessage = @"This section has widgets that provide insight on people,companies and topics mentioned in the article";
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
    [popTipView presentPointingAtView:button inView:self.contentView animated:YES];
    self.currentPopTipViewTarget = sender;
}

#pragma mark - CMPopTipViewDelegate methods

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView
{
    //  [self.visiblePopTipViews removeObject:popTipView];
    self.currentPopTipViewTarget = nil;
}


- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(collectionView == self.widgetCollectionView) {
        if(indexPath.row == 0) {
            return CGSizeMake(400, 320);
        } else if(indexPath.row == 1) {
            return CGSizeMake(400, 320);
        } else if(indexPath.row == 2) {
            return CGSizeMake(400, 376);
        } else if(indexPath.row == 3) {
            return CGSizeMake(400, 300);
        }
        
    }
    else if(collectionView == self.socialcollectionView) {
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            return CGSizeMake(20, 20);

        } else {
            return CGSizeMake(50, 50);

        }
        //changestod
    } else if(collectionView == self.tweetsLocalCollectionView) {
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            return CGSizeMake(280, 244);
            
        } else {
            return CGSizeMake(320, 300);
            
        }
    }
    return CGSizeMake(30, 30);
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    // NSLog(@"imp collection view:%d",self.socialLinksArray.count);
    NSInteger itemCount;
    //    if(view == self.legendsCollectionView) {
    //        itemCount = self.legendsArray.count;
    //    }else
    if(view == self.socialcollectionView){
        NSLog(@"social collectionview loading");
        itemCount = self.socialLinksArray.count;
    }else if(view == self.tweetsLocalCollectionView) {
        itemCount = followersArray.count;
    }else {
        itemCount = 4;
    }
    NSLog(@"number of items :%d",itemCount);
    return itemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"collectionview cellfor item method");
    UICollectionViewCell *collectionCell;
    //    if(cv == self.legendsCollectionView) {
    //        [self.legendsCollectionView registerClass:[LegendCollectionViewCell class]
    //                       forCellWithReuseIdentifier:@"LegendCell"];
    //        LegendCollectionViewCell *cell =(LegendCollectionViewCell*) [cv dequeueReusableCellWithReuseIdentifier:@"LegendCell" forIndexPath:indexPath];
    //        UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    //        iconImage.backgroundColor = [UIColor clearColor];
    //        //        iconImage.layer.masksToBounds = YES;
    //        //        iconImage.layer.cornerRadius = 20.0f;
    //        iconImage.layer.masksToBounds = YES;
    //        iconImage.layer.cornerRadius = 15.0f;
    //        iconImage.layer.borderColor = [UIColor whiteColor].CGColor;
    //        iconImage.layer.borderWidth = 1.5f;
    //        // iconImage.image =  [UIImage imageNamed:@"circle30"];
    //        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(7.5, 7.5, 15, 15)];
    //        image.backgroundColor = [UIColor clearColor];
    //        NSString *imageName = [NSString stringWithFormat:@"%@_white",[self.legendsArray objectAtIndex:indexPath.row]];
    //        NSLog(@"detail view image name:%@",imageName);
    //        image.image = [UIImage imageNamed:imageName];
    //        [iconImage addSubview:image];
    //        [cell.contentView addSubview:iconImage];
    //        collectionCell = cell;
    //    } else
    
    if(cv == self.socialcollectionView) {
        NSLog(@"one");
        // NSLog(@"inside social link collectionview cellfor item");
        if ([UIDevice currentDevice].userInterfaceIdiom ==UIUserInterfaceIdiomPhone) {
            [self.socialcollectionView registerClass:[SocialLinkCellPhone class]
                          forCellWithReuseIdentifier:@"Cell"];
            [self.socialcollectionView registerNib:[UINib nibWithNibName:@"SocialLinkCellPhone" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"Cell"];
            NSManagedObject *socialLink = [self.socialLinksArray objectAtIndex:indexPath.row];
            
            SocialLinkCellPhone *socialCell =(SocialLinkCellPhone*) [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
            if([[socialLink valueForKey:@"mediatype"] isEqualToString:@"Twitter"]) {
                socialCell.iconImage.image = [UIImage imageNamed:@"Twitter-1"];
            } else {
                socialCell.iconImage.image = [UIImage imageNamed:[socialLink valueForKey:@"mediatype"]];
            }
            
            if([[socialLink valueForKey:@"isactive"]isEqualToNumber:[NSNumber numberWithInt:1]]) {
                socialCell.blueCircleView.hidden = NO;
            } else {
                socialCell.blueCircleView.hidden = YES;
            }
            socialCell.cellOuterView.layer.borderWidth = 1.0f;
            socialCell.cellOuterView.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
            socialCell.cellOuterView.layer.masksToBounds = YES;
            socialCell.cellOuterView.layer.cornerRadius = 10.0f;
            socialCell.blueCircleView.layer.masksToBounds = YES;
            socialCell.blueCircleView.layer.cornerRadius = 2.5f;
            
        
            
            //        UITapGestureRecognizer *socialCellTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(socialTap:)];
            //        socialCell.tag = indexPath.row;
            //        socialCell.iconImage.userInteractionEnabled = YES;
            //        [socialCell.iconImage addGestureRecognizer:socialCellTap];
            collectionCell = socialCell;

            
        } else {
            [self.socialcollectionView registerClass:[SocialLinkCell class]
                          forCellWithReuseIdentifier:@"Cell"];
            [self.socialcollectionView registerNib:[UINib nibWithNibName:@"SocialLinkCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"Cell"];
            NSManagedObject *socialLink = [self.socialLinksArray objectAtIndex:indexPath.row];
            
            SocialLinkCell *socialCell =(SocialLinkCell*) [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
            if([[socialLink valueForKey:@"mediatype"] isEqualToString:@"Twitter"]) {
                socialCell.iconImage.image = [UIImage imageNamed:@"Twitter-1"];
            } else {
                socialCell.iconImage.image = [UIImage imageNamed:[socialLink valueForKey:@"mediatype"]];
            }
            
            if([[socialLink valueForKey:@"isactive"]isEqualToNumber:[NSNumber numberWithInt:1]]) {
                socialCell.blueCircleView.hidden = NO;
            } else {
                socialCell.blueCircleView.hidden = YES;
            }
            socialCell.cellOuterView.layer.borderWidth = 1.0f;
            socialCell.cellOuterView.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
            socialCell.cellOuterView.layer.masksToBounds = YES;
            socialCell.cellOuterView.layer.cornerRadius = 20.0f;
            socialCell.blueCircleView.layer.masksToBounds = YES;
            socialCell.blueCircleView.layer.cornerRadius = 5.0f;
            
            
            //        UITapGestureRecognizer *socialCellTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(socialTap:)];
            //        socialCell.tag = indexPath.row;
            //        socialCell.iconImage.userInteractionEnabled = YES;
            //        [socialCell.iconImage addGestureRecognizer:socialCellTap];
            collectionCell = socialCell;

            
        }
        
    } else if(cv == self.tweetsLocalCollectionView) {
        NSLog(@"come inside tweets collecionview");
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            [self.tweetsLocalCollectionView registerClass:[TweetsCellPhone class]
                               forCellWithReuseIdentifier:@"Cell"];

            [self.tweetsLocalCollectionView registerNib:[UINib nibWithNibName:@"TweetsCellPhone" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"Cell"];
            TweetsCellPhone *tweetCell =(TweetsCellPhone*) [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
            TWTRTweet *tweetObj = [tweetArray objectAtIndex:indexPath.row];
            TWTRUser *author = tweetObj.author;
            tweetCell.author.text = author.name;
            // NSLog(@"tweet id:%@",tweetObj.tweetID);
            
            
            
            
            
            NSLog(@"screen name:%@",author.screenName);
            NSDictionary *followDic =[followersArray objectAtIndex:indexPath.row];
            
            NSString *follwersCnt= [NSString stringWithFormat:@"%@",[followDic objectForKey:@"formatted_followers_count"]];
            NSArray *splitValues=[follwersCnt componentsSeparatedByString:@" "];
            tweetCell.followers.text = [splitValues objectAtIndex:0];
            
            
            tweetCell.auhtor2.text = [NSString stringWithFormat:@"@%@",author.screenName];
            tweetCell.twitterText.text = tweetObj.text;
            if(tweetObj.retweetCount/1000 == 0) {
                tweetCell.retweet.text = [NSString stringWithFormat:@"%lld",tweetObj.retweetCount];
            } else {
                tweetCell.retweet.text = [NSString stringWithFormat:@"%lldK",tweetObj.retweetCount/1000];
            }
            
            if(tweetObj.favoriteCount/1000 == 0) {
                tweetCell.favourate.text = [NSString stringWithFormat:@"%lld",tweetObj.favoriteCount];
            } else {
                tweetCell.favourate.text = [NSString stringWithFormat:@"%lldK",tweetObj.favoriteCount/1000];
            }
            
            
            
            //   tweetCell.followers.text = [tweetDic objectForKey:@"followers_current"];
            tweetCell.contentView.layer.borderWidth = 1.0f;
            tweetCell.contentView.layer.borderColor = [[UIColor colorWithRed:237.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1] CGColor];
            collectionCell = tweetCell;
        }
        else{
            [self.tweetsLocalCollectionView registerClass:[TweetsCell class]
                               forCellWithReuseIdentifier:@"Cell"];
            [self.tweetsLocalCollectionView registerNib:[UINib nibWithNibName:@"TweetsCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"Cell"];
            TweetsCell *tweetCell =(TweetsCell*) [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
            TWTRTweet *tweetObj = [tweetArray objectAtIndex:indexPath.row];
            TWTRUser *author = tweetObj.author;
            tweetCell.author.text = author.name;
            // NSLog(@"tweet id:%@",tweetObj.tweetID);
            
            
            
            
            
            NSLog(@"screen name:%@",author.screenName);
            NSDictionary *followDic =[followersArray objectAtIndex:indexPath.row];
            
            NSString *follwersCnt= [NSString stringWithFormat:@"%@",[followDic objectForKey:@"formatted_followers_count"]];
            NSArray *splitValues=[follwersCnt componentsSeparatedByString:@" "];
            tweetCell.followers.text = [splitValues objectAtIndex:0];
            
            
            tweetCell.auhtor2.text = [NSString stringWithFormat:@"@%@",author.screenName];
            tweetCell.twitterText.text = tweetObj.text;
            if(tweetObj.retweetCount/1000 == 0) {
                tweetCell.retweet.text = [NSString stringWithFormat:@"%lld",tweetObj.retweetCount];
            } else {
                tweetCell.retweet.text = [NSString stringWithFormat:@"%lldK",tweetObj.retweetCount/1000];
            }
            
            if(tweetObj.favoriteCount/1000 == 0) {
                tweetCell.favourate.text = [NSString stringWithFormat:@"%lld",tweetObj.favoriteCount];
            } else {
                tweetCell.favourate.text = [NSString stringWithFormat:@"%lldK",tweetObj.favoriteCount/1000];
            }
            
            
            
            //   tweetCell.followers.text = [tweetDic objectForKey:@"followers_current"];
            tweetCell.contentView.layer.borderWidth = 1.0f;
            tweetCell.contentView.layer.borderColor = [[UIColor colorWithRed:237.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1] CGColor];
            collectionCell = tweetCell;
        }
        
    }else {
        NSLog(@"else part");
        //        [socialcollectionView registerClass:[SocialLinkCell class]
        //                 forCellWithReuseIdentifier:@"Cell"];
        //        [socialcollectionView registerNib:[UINib nibWithNibName:@"SocialLinkCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"Cell"];
        //        NSManagedObject *socialLink = [self.socialLinksArray objectAtIndex:indexPath.row];
        //
        //        SocialLinkCell *socialCell =(SocialLinkCell*) [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        //        if([[socialLink valueForKey:@"mediatype"] isEqualToString:@"Twitter"]) {
        //            socialCell.iconImage.image = [UIImage imageNamed:@"Twitter-1"];
        //        } else {
        //            socialCell.iconImage.image = [UIImage imageNamed:[socialLink valueForKey:@"mediatype"]];
        //        }
        //
        //        if([[socialLink valueForKey:@"isactive"]isEqualToNumber:[NSNumber numberWithInt:1]]) {
        //            socialCell.blueCircleView.hidden = NO;
        //        } else {
        //            socialCell.blueCircleView.hidden = YES;
        //        }
        //        socialCell.cellOuterView.layer.borderWidth = 1.0f;
        //        socialCell.cellOuterView.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
        //        socialCell.cellOuterView.layer.masksToBounds = YES;
        //        socialCell.cellOuterView.layer.cornerRadius = 20.0f;
        //        socialCell.blueCircleView.layer.masksToBounds = YES;
        //        socialCell.blueCircleView.layer.cornerRadius = 5.0f;
        //
        //
        //        //        UITapGestureRecognizer *socialCellTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(socialTap:)];
        //        //        socialCell.tag = indexPath.row;
        //        //        socialCell.iconImage.userInteractionEnabled = YES;
        //        //        [socialCell.iconImage addGestureRecognizer:socialCellTap];
        //        collectionCell = socialCell;
    }
    return collectionCell;
}

-(void)socialTap:(UITapGestureRecognizer *)tapGesture {
    NSInteger row = tapGesture.view.tag;
    // NSLog(@"social tap working for row:%d",row);
}


-(void)upgradeTap:(UITapGestureRecognizer *)sender{
    
    UIButton *btn=(UIButton *)sender.view;
    
    if(btn.tag == 0){
        //Personality Widget
        [btn setSelected:YES];
        [FIUtils callRequestionUpdateWithModuleId:1 withFeatureId:1];
        
        //[btn setEnabled:NO];
    }else if(btn.tag == 1){
        //Company Widget
        [btn setSelected:YES];
        [FIUtils callRequestionUpdateWithModuleId:1 withFeatureId:3];
        // [btn setEnabled:NO];
    }else if(btn.tag == 2){
        //Product Widget
        [btn setSelected:YES];
        [FIUtils callRequestionUpdateWithModuleId:1 withFeatureId:4];
        // [btn setEnabled:NO];
    }else if(btn.tag == 3) {
        //Video Widget
        [btn setSelected:YES];
        [FIUtils callRequestionUpdateWithModuleId:1 withFeatureId:7];
        // [btn setEnabled:NO];
    }
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did select social link");
    
    if(collectionView == self.socialcollectionView) {
        
        NSManagedObject *socialLink = [self.socialLinksArray objectAtIndex:indexPath.row];
        NSString *titleStr = [NSString stringWithFormat:@"%@ in %@",self.authorNameStr,[socialLink valueForKey:@"mediatype"]];
        
        if([[FISharedResources sharedResourceManager] serviceIsReachable]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"socialLinkSelected" object:nil userInfo:@{@"name":titleStr,@"link":[socialLink valueForKey:@"url"]}];
        } else {
            UIWindow *window = [[UIApplication sharedApplication]windows][0];
            NSArray *subViewArray = [window subviews];
            // NSLog(@"subview array count:%d",subViewArray.count);
            if(subViewArray.count == 1) {
                [[FISharedResources sharedResourceManager] showBannerView];
            }
            // [FIUtils showNoNetworkToast];
        }
    }
    
    if(collectionView==self.widgetCollectionView){
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"widgetSelected" object:nil userInfo:@{@"indexPath":indexPath}];
    }
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webview did finished");
    //    CGRect oldBounds = CGRectMake(self.articleWebview.frame.origin.x, self.articleWebview.frame.origin.y, self.articleWebview.frame.size.width, 200);
    //    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.height"] floatValue];
    //    NSLog(@"NEW HEIGHT %f", height);
    //    [webView setBounds:CGRectMake(oldBounds.origin.x, oldBounds.origin.y, oldBounds.size.width, height)];
    //self.scrollView.contentSize = webView.bounds.size;
    
    
    
    CGRect frame = webView.frame;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        if (IS_IPHONE_6) {
            frame.size.height = 380;
        }
        else if(IS_IPHONE_6P)
        {
            frame.size.height =450;
        }
        else{
            frame.size.height = 350;

        }

    } else {
        frame.size.height = 200;

    }
    webView.frame = frame;
    webView.scrollView.scrollEnabled = NO;
    webView.scrollView.bounces = NO;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        CGRect newBounds = self.articleWebview.bounds;
        NSLog(@"%@",NSStringFromCGRect(newBounds));

        newBounds.size.height =  self.articleWebview.scrollView.contentSize.height;
        NSLog(@"%@",NSStringFromCGRect(newBounds));
        NSLog(@"%@",NSStringFromCGSize(newBounds.size));
        
        NSLog(@"%f",self.webViewHeightConstraint.constant);
        NSLog(@"%@",self.webViewHeightConstraint);
        CGFloat pointOfWebview = newBounds.size.height;

        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, pointOfWebview+750);
        
    }
    else{

    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.webViewHeightConstraint.constant+1300);
    
    }
    //    self.starRating = [[AMRatingControl alloc]initWithLocation:CGPointMake(0, 0) emptyColor:[UIColor colorWithRed:161/255.0 green:16/255.0 blue:27/255.0 alpha:1.0] solidColor:[UIColor colorWithRed:161/255.0 green:16/255.0 blue:27/255.0 alpha:1.0] andMaxRating:5];
    //    self.starRating.userInteractionEnabled = NO;
    //    [self.ratingControl addSubview:self.starRating];
    
    [self.timer invalidate];
    //[progressView removeFromSuperview];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    NSLog(@"cell orientation");
}

-(void)loadTweetsAndSocialLink {
    self.isTwitterLoad = YES;
    lbl.hidden = YES;
    CGRect frame = self.articleWebview.frame;
    CGSize fittingSize = [self.articleWebview sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    self.articleWebview.frame = frame;
    //NSLog(@"size: %f, %f", fittingSize.width, fittingSize.height);
    self.webViewHeightConstraint.constant = self.articleWebview.frame.size.height;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
//        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, 20);
        
    }
    else{
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.webViewHeightConstraint.constant+1300);

    }
    UICollectionViewFlowLayout* tweetFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    tweetFlowLayout.itemSize = CGSizeMake(100, 100);
    [tweetFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.tweetsLocalCollectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(self.tweetsCollectionView.frame.origin.x, self.articleWebview.frame.size.height+self.articleWebview.frame.origin.y+45, self.tweetsCollectionView.frame.size.width, self.tweetsCollectionView.frame.size.height) collectionViewLayout:tweetFlowLayout];

        UINib *tweetCellNib = [UINib nibWithNibName:@"TweetsCellPhone" bundle:nil];
        [self.tweetsLocalCollectionView registerNib:tweetCellNib forCellWithReuseIdentifier:@"Cell"];
        [self.tweetsLocalCollectionView registerClass:[TweetsCellPhone class] forCellWithReuseIdentifier:@"Cell"];
        if(IS_IPHONE_6P)
        {
            self.tweetsLocalCollectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(self.tweetsCollectionView.frame.origin.x, self.articleWebview.frame.size.height+self.articleWebview.frame.origin.y+45, self.tweetsCollectionView.frame.size.width+35, self.tweetsCollectionView.frame.size.height) collectionViewLayout:tweetFlowLayout];

        }

    }
    else{
        self.tweetsLocalCollectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(self.tweetsCollectionView.frame.origin.x, self.articleWebview.frame.size.height+self.articleWebview.frame.origin.y+100, self.tweetsCollectionView.frame.size.width, self.tweetsCollectionView.frame.size.height) collectionViewLayout:tweetFlowLayout];

        UINib *tweetCellNib = [UINib nibWithNibName:@"TweetsCell" bundle:nil];
        [self.tweetsLocalCollectionView registerNib:tweetCellNib forCellWithReuseIdentifier:@"Cell"];
        [self.tweetsLocalCollectionView registerClass:[TweetsCell class] forCellWithReuseIdentifier:@"Cell"];

        
    }
    self.tweetsLocalCollectionView.delegate = self;
    self.tweetsLocalCollectionView.dataSource = self;
    //tweetsCollectionView.hidden = NO;
    self.tweetsLocalCollectionView.backgroundColor = [UIColor clearColor];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.center = CGPointMake(self.tweetsCollectionView.frame.size.width / 2, self.tweetsCollectionView.frame.size.height / 2);
    [self.activityIndicator startAnimating];
    [self.tweetsCollectionView addSubview:self.activityIndicator];
    lbl= [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tweetsCollectionView.frame.size.width, 300)];
    //    lbl.text = @"No Tweets found for this article";
    //    lbl.font = [UIFont fontWithName:@"Arial" size:20];
    //    lbl.textAlignment = NSTextAlignmentCenter;
    //    lbl.textColor = [UIColor lightGrayColor];
    // lbl.backgroundColor = [UIColor blackColor];
    UIImageView *tweetImg = [[UIImageView alloc]initWithFrame:CGRectMake((self.tweetsCollectionView.frame.size.width-80)/2, 80, 80, 80)];
    tweetImg.image = [UIImage imageNamed:@"notweet"];
    //tweetImg.backgroundColor = [UIColor greenColor];
    [lbl addSubview:tweetImg];
    
    UILabel *tweetText = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, self.tweetsCollectionView.frame.size.width, 50)];
    tweetText.text = @"No tweets available";
    tweetText.font = [UIFont fontWithName:@"Arial" size:20];
    tweetText.textAlignment = NSTextAlignmentCenter;
    tweetText.textColor = [UIColor lightGrayColor];
    [lbl addSubview:tweetText];
    
    [self.tweetsCollectionView addSubview:lbl];
    [self.scrollView addSubview:self.tweetsLocalCollectionView];
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(100, 100);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.tweetCollectionViewHeightConstraint.constant = 300;
    self.tweetLabelHeightConstraint.constant = 41;
    self.tweetLabel.hidden = NO;
    self.tweetDividerImageView.hidden = NO;
    self.tweetsCollectionView.hidden = NO;
    UINib *cellNib;
    if ([UIDevice currentDevice].userInterfaceIdiom ==UIUserInterfaceIdiomPhone) {
        self.socialcollectionView.translatesAutoresizingMaskIntoConstraints = YES;  //This part hung me up

        self.socialcollectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(self.socialLinkCollectionView.frame.origin.x, self.articleWebview.frame.size.height+self.articleWebview.frame.origin.y+self.tweetsLocalCollectionView.frame.size.height+178, self.socialLinkCollectionView.frame.size.width, self.socialLinkCollectionView.frame.size.height) collectionViewLayout:flowLayout];

        cellNib = [UINib nibWithNibName:@"SocialLinkCellPhone" bundle:nil];
        [self.socialcollectionView registerNib:cellNib forCellWithReuseIdentifier:@"Cell"];
        [self.socialcollectionView registerClass:[SocialLinkCellPhone class] forCellWithReuseIdentifier:@"Cell"];

    } else {
        self.socialcollectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(self.socialLinkCollectionView.frame.origin.x, self.articleWebview.frame.size.height+self.articleWebview.frame.origin.y+self.tweetsLocalCollectionView.frame.size.height+250, self.socialLinkCollectionView.frame.size.width, self.socialLinkCollectionView.frame.size.height) collectionViewLayout:flowLayout];

        cellNib = [UINib nibWithNibName:@"SocialLinkCell" bundle:nil];
        [self.socialcollectionView registerNib:cellNib forCellWithReuseIdentifier:@"Cell"];
        [self.socialcollectionView registerClass:[SocialLinkCell class] forCellWithReuseIdentifier:@"Cell"];

    }
    self.socialcollectionView.delegate = self;
    self.socialcollectionView.dataSource = self;
    //socialcollectionView.hidden = YES;
    
    if(self.socialLinksArray.count == 0){
        self.socialLinkLabel.hidden =YES;
        self.socialLinkDivider.hidden= YES;
        self.socialcollectionView.hidden= YES;
    } else {
        self.socialLinkLabel.hidden =NO;
        self.socialLinkDivider.hidden= NO;
        self.socialcollectionView.hidden = NO;
    }
    self.socialcollectionView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.socialcollectionView];
    positionOfCollectionViewInScrollView= [self.scrollView convertRect:self.tweetsLocalCollectionView.frame toView:nil];
    positionOfInfluencerTweetLblInScrollView = [self.scrollView convertRect:self.tweetLabel.frame toView:nil];
    
    NSLog(@"tweet frame:%f",positionOfCollectionViewInScrollView.origin.y);
    //    tweetsCollectionView.delegate = nil;
    //    tweetsCollectionView.dataSource = nil;
    //    socialcollectionView.delegate = nil;
    //    socialcollectionView.dataSource = nil;
    //    tweetsCollectionView.hidden = YES;
    //    socialcollectionView.hidden = YES;
    //    [self loadTweetsFromPost];
    
    
    
}

-(void)viewDidDisappear:(BOOL)animated {
    [self.timer invalidate];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.socialcollectionView.hidden = YES;
    self.tweetsLocalCollectionView.hidden = YES;
    [self.activityIndicator removeFromSuperview];
    [self.activityIndicator stopAnimating];
    //tweetsCollectionView.hidden = NO;
    // self.webViewHeightConstraint.constant = 200;
    //socialcollectionView.backgroundColor = [UIColor greenColor];
}


- (void)cancelWeb
{
    // [progressView removeFromSuperview];
    [self.timer invalidate];
    
    [FIUtils showRequestTimeOutError];
    // UIWindow *window = [[UIApplication sharedApplication]windows][0];
    // [self.view makeToast:@"Request Time out" duration:1 position:CSToastPositionCenter];
    
}



- (IBAction)researchRequestButtonClick:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showResearchView" object:nil userInfo:@{@"articleId":self.selectedArticleId,@"articleTitle":self.selectedArticleTitle,@"articleUrl":self.selectedArticleUrl}];
}


- (IBAction)saveButtonClick:(UIButton *)sender {
    POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    sprintAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.9, 1.9)];
    sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.9, 0.9)];
    sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
    sprintAnimation.springBounciness = 20.f;
    [sender pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
    [resultDic setObject:self.selectedArticleId forKey:@"selectedArticleId"];
    [resultDic setObject:@"3" forKey:@"status"];
    
    //if([[FISharedResources sharedResourceManager]serviceIsReachable]) {
    
    if(sender.selected) {
        
        if([[FISharedResources sharedResourceManager]serviceIsReachable]) {
            [sender setSelected:NO];
            [resultDic setObject:@"false" forKey:@"isSelected"];
            NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@ ",self.selectedArticleId];
            [fetchRequest setPredicate:predicate];
            NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
            if(newPerson.count != 0) {
                for(NSManagedObject *curatedNews in newPerson) {
                    // NSLog(@"for loop update");
                    [self.curatedNewsDetail setValue:[NSNumber numberWithBool:NO] forKey:@"saveForLater"];
                    [curatedNews setValue:[NSNumber numberWithBool:NO] forKey:@"saveForLater"];
                    
                    //if([[FISharedResources sharedResourceManager]serviceIsReachable]) {
                    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
                    
                    NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
                    [[FISharedResources sharedResourceManager]setUserActivitiesOnArticlesWithDetails:resultStr];
                    //                } else {
                    //                    [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"isSavedForLaterStatusSync"];
                    //                }
                }
            }
            [managedObjectContext save:nil];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"saveForLaterUpdate" object:nil userInfo:@{@"indexPath":self.selectedIndexPath,@"status":[NSNumber numberWithBool:NO]}];
            [self.contentView makeToast:@"Removed from \"Saved for Later\"" duration:1.0 position:CSToastPositionCenter];
            NSDictionary *dictionary = @{@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"], @"userName":[[NSUserDefaults standardUserDefaults]objectForKey:@"firstName"],@"article_Name":self.selectedArticleTitle};
            
            [Localytics tagEvent:@"Remove Save Later in Drill" attributes:dictionary];
        } else {
            UIWindow *window = [[UIApplication sharedApplication]windows][0];
            NSArray *subViewArray = [window subviews];
            NSLog(@"subview array count:%d",subViewArray.count);
            if(subViewArray.count == 1) {
                [[FISharedResources sharedResourceManager] showBannerView];
            }
        }
        // NSDictionary *dictionary = @{@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"], @"userName":[[NSUserDefaults standardUserDefaults]objectForKey:@"firstName"],@"article_Name":self.selectedArticleTitle};
        
        
        //[Localytics tagEvent:@"Remove Save Later in Drill" attributes:dictionary];
        
    }else {
        
        if([[FISharedResources sharedResourceManager]serviceIsReachable]) {
            [sender setSelected:YES];
            [resultDic setObject:@"true" forKey:@"isSelected"];
            NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@ ",self.selectedArticleId];
            [fetchRequest setPredicate:predicate];
            NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
            if(newPerson.count != 0) {
                for(NSManagedObject *curatedNews in newPerson) {
                    // NSLog(@"for loop update");
                    [self.curatedNewsDetail setValue:[NSNumber numberWithBool:YES] forKey:@"saveForLater"];
                    [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"saveForLater"];
                    
                    // if([[FISharedResources sharedResourceManager]serviceIsReachable]) {
                    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
                    
                    NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
                    [[FISharedResources sharedResourceManager]setUserActivitiesOnArticlesWithDetails:resultStr];
                    //                } else {
                    //                    [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"isSavedForLaterStatusSync"];
                    //                }
                }
            }
            [managedObjectContext save:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"saveForLaterUpdate" object:nil userInfo:@{@"indexPath":self.selectedIndexPath,@"status":[NSNumber numberWithBool:YES]}];
            [self.contentView makeToast:@"Added to \"Saved for Later\"" duration:1.0 position:CSToastPositionCenter];
            NSDictionary *dictionary = @{@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"], @"userName":[[NSUserDefaults standardUserDefaults]objectForKey:@"firstName"],@"article_Name":self.selectedArticleTitle};
            
            [Localytics tagEvent:@"Save Later in Drill" attributes:dictionary];
        } else {
            UIWindow *window = [[UIApplication sharedApplication]windows][0];
            NSArray *subViewArray = [window subviews];
            NSLog(@"subview array count:%d",subViewArray.count);
            if(subViewArray.count == 1) {
                [[FISharedResources sharedResourceManager] showBannerView];
            }
        }
        // NSDictionary *dictionary = @{@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"], @"userName":[[NSUserDefaults standardUserDefaults]objectForKey:@"firstName"],@"article_Name":self.selectedArticleTitle};
        
        
        //  [Localytics tagEvent:@"Save Later in Drill" attributes:dictionary];
    }
    //    } else {
    //        UIWindow *window = [[UIApplication sharedApplication]windows][0];
    //        NSArray *subViewArray = [window subviews];
    //        //NSLog(@"subview array count:%d",subViewArray.count);
    //        if(subViewArray.count == 1) {
    //            [[FISharedResources sharedResourceManager] showBannerView];
    //        }
    //        //[FIUtils showNoNetworkToast];
    //    }
}


- (IBAction)mailButtonClick:(UIButton *)sender {
    
    [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"MailButtonClick"];
    
    NSString *mailBodyStr;
    if(self.selectedArticleUrl.length != 0) {
        mailBodyStr = [NSString stringWithFormat:@"Forwarded from FullIntel\n\n%@\n\n%@\n\n%@",self.selectedArticleTitle,self.articleDesc,self.selectedArticleUrl];
    } else {
        mailBodyStr = [NSString stringWithFormat:@"Forwarded from FullIntel\n\n%@\n\n%@\n",self.selectedArticleTitle,self.articleDesc];
    }
    // NSLog(@"mail body string:%@ and title:%@",mailBodyStr,self.selectedArticleTitle);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"mailButtonClick" object:nil userInfo:@{@"articleId":self.selectedArticleId,@"title":self.selectedArticleTitle,@"body":mailBodyStr}];
    //}
}

- (IBAction)commentsButtonClick:(UIButton *)sender {
    
    [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"CommentButtonClick"];
    NSMutableDictionary *commentsDic = [[NSMutableDictionary alloc] init];
    [commentsDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
    [commentsDic setObject:self.selectedArticleId forKey:@"articleId"];
    [commentsDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"] forKey:@"userId"];
    [commentsDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"customerId"] forKey:@"customerId"];
    [commentsDic setObject:@"1" forKey:@"version"];
    NSData *commentsJsondata = [NSJSONSerialization dataWithJSONObject:commentsDic options:NSJSONWritingPrettyPrinted error:nil];    
    NSString *commentsResultStr = [[NSString alloc]initWithData:commentsJsondata encoding:NSUTF8StringEncoding];
    
    
    
    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@",self.selectedArticleId];
    [fetchRequest setPredicate:predicate];
    NSArray *filterArray =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if(filterArray.count != 0) {
        NSManagedObject *curatedNews = [filterArray objectAtIndex:0];
        //NSLog(@"comments:%@",[curatedNews valueForKey:@"comments"]);
        NSManagedObject *userComments = [curatedNews valueForKey:@"comments"];
        if(userComments == nil) {
            [[FISharedResources sharedResourceManager]getCommentsWithDetails:commentsResultStr withArticleId:self.selectedArticleId];
        }
    }
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        [self showCommentsViews];
    }
    else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"showCommentsView" object:nil userInfo:@{@"articleId":self.selectedArticleId,@"indexPath":self.selectedIndexPath}];

    }
}
-(void)showCommentsViews
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"CommentsPhone" bundle:nil];
    CommentsPopoverView *popOverView = [storyBoard instantiateViewControllerWithIdentifier:@"CommentsPopoverView"];
    popOverView.articleId = self.selectedArticleId;
    popOverView.commentsDelegate = self;
    popOverView.selectedIndexPath = self.selectedIndexPath;
    self.superview.alpha = 0.4;

    popover = [[FPPopoverController alloc] initWithViewController:popOverView];
    popover.border = NO;
    popover.delegate = self;
//    popover.title = nil;
    popover.tint = FPPopoverWhiteTint;
    //[popover setShadowsHidden:YES];
    popover.contentSize = CGSizeMake(340, 480);
    popover.arrowDirection = FPPopoverArrowDirectionDown;
    [popover presentPopoverFromView:_commentBtn];

}

- (void)popoverControllerDidDismissPopover:(FPPopoverController *)popoverController {
    self.superview.alpha = 1;

}

- (void)dismissCommentsView {
    [popover dismissPopoverAnimated:YES];
    self.superview.alpha = 1;

}

- (IBAction)markedImpButtonClick:(UIButton *)sender {
   

    POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    sprintAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.9, 1.9)];
    sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.9, 0.9)];
    sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
    sprintAnimation.springBounciness = 20.f;
    [sender pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
    
//
//        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
//            CGAffineTransform transform = sender.transform;
//            CGAffineTransform transform_new = CGAffineTransformRotate(transform,  M_PI);
//            sender.transform = transform_new;
//            
//        } completion:^(BOOL finished){[UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
//            CGAffineTransform transform = sender.transform;
//            CGAffineTransform transform_new = CGAffineTransformRotate(transform,  M_PI);
//            sender.transform = transform_new;
//            
//        } completion:^(BOOL finished){}];}];
//
//    
    
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
    [resultDic setObject:self.selectedArticleId forKey:@"selectedArticleId"];
    [resultDic setObject:@"2" forKey:@"status"];
    
    NSString *loginUserId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]];

        //if([[FISharedResources sharedResourceManager]serviceIsReachable]) {

        if(sender.selected) {
        if([self.markedImpUserId isEqualToString:@"-1"]) {
            //Analyst
            [self.contentView makeToast:@"A FullIntel analyst marked this as important. If you like to change, please request via Feedback" duration:2.0 position:CSToastPositionCenter];
        } else if([self.markedImpUserId isEqualToString:loginUserId]) {
            //LoginUser 
           
            
            if([[FISharedResources sharedResourceManager]serviceIsReachable]) {
                [sender setSelected:NO];
                [resultDic setObject:@"false" forKey:@"isSelected"];
                [_curatedNewsDetail setValue:[NSNumber numberWithBool:NO] forKey:@"markAsImportant"];
                NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@ ",self.selectedArticleId];
                [fetchRequest setPredicate:predicate];
                NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
                // NSLog(@"new person array count:%d",newPerson.count);
                if(newPerson.count != 0) {
                    //NSManagedObject *curatedNews = [newPerson objectAtIndex:0];
                    for(NSManagedObject *curatedNews in newPerson) {
                        // NSLog(@"for loop update");
                        [curatedNews setValue:[NSNumber numberWithBool:NO] forKey:@"markAsImportant"];
                        
                        // if([[FISharedResources sharedResourceManager]serviceIsReachable]) {
                        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
                        NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
                        [[FISharedResources sharedResourceManager]setUserActivitiesOnArticlesWithDetails:resultStr];
                        //                    } else {
                        //                        [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"isMarkedImpStatusSync"];
                        //                    }
                    }
                }
                [managedObjectContext save:nil];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"markedImportantUpdate" object:nil userInfo:@{@"indexPath":self.selectedIndexPath,@"status":[NSNumber numberWithBool:NO],@"articleId":self.selectedArticleId}];
                [self.contentView makeToast:@"Removed from \"Marked Important\"" duration:1.0 position:CSToastPositionCenter];
                NSDictionary *dictionary = @{@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"], @"userName":[[NSUserDefaults standardUserDefaults]objectForKey:@"firstName"],@"article_Name":self.selectedArticleTitle};
                
                [Localytics tagEvent:@"Remove Mark Important in Drill" attributes:dictionary];
            } else {
                UIWindow *window = [[UIApplication sharedApplication]windows][0];
                NSArray *subViewArray = [window subviews];
                NSLog(@"subview array count:%d",subViewArray.count);
                if(subViewArray.count == 1) {
                    [[FISharedResources sharedResourceManager] showBannerView];
                }
            }
            // NSDictionary *dictionary = @{@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"], @"userName":[[NSUserDefaults standardUserDefaults]objectForKey:@"firstName"],@"article_Name":self.selectedArticleTitle};
            
            
            //   [Localytics tagEvent:@"Remove Mark Important in Drill" attributes:dictionary];
            
            
        } else {
            //OtherUser
            NSString *messageStrings = [NSString stringWithFormat:@"If you like to change, please contact %@. who marked this article as important",self.markedImpUserName];
            [self.contentView makeToast:messageStrings duration:2.0 position:CSToastPositionCenter];
        }
        
    }else {
        
        if([[FISharedResources sharedResourceManager]serviceIsReachable]) {
            [sender setSelected:YES];
            [resultDic setObject:@"true" forKey:@"isSelected"];
            self.markedImpUserId = loginUserId;
            [_curatedNewsDetail setValue:[NSNumber numberWithBool:YES] forKey:@"markAsImportant"];
            NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@ ",self.selectedArticleId];
            [fetchRequest setPredicate:predicate];
            NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
            // NSLog(@"new person array count:%d",newPerson.count);
            if(newPerson.count != 0) {
                //NSManagedObject *curatedNews = [newPerson objectAtIndex:0];
                for(NSManagedObject *curatedNews in newPerson) {
                    // NSLog(@"for loop update");
                    [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"markAsImportant"];
                    
                    // if([[FISharedResources sharedResourceManager]serviceIsReachable]) {
                    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
                    NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
                    [[FISharedResources sharedResourceManager]setUserActivitiesOnArticlesWithDetails:resultStr];
                    //                } else {
                    //                    [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"isMarkedImpStatusSync"];
                    //                }
                }
            }
            [managedObjectContext save:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"markedImportantUpdate" object:nil userInfo:@{@"indexPath":self.selectedIndexPath,@"status":[NSNumber numberWithBool:YES],@"articleId":self.selectedArticleId}];
            [self.contentView makeToast:@"Marked Important." duration:1.0 position:CSToastPositionCenter];
            NSDictionary *dictionary = @{@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"], @"userName":[[NSUserDefaults standardUserDefaults]objectForKey:@"firstName"],@"article_Name":self.selectedArticleTitle};
            
            [Localytics tagEvent:@"Mark Important in Drill" attributes:dictionary];
        } else {
            UIWindow *window = [[UIApplication sharedApplication]windows][0];
            NSArray *subViewArray = [window subviews];
            NSLog(@"subview array count:%d",subViewArray.count);
            if(subViewArray.count == 1) {
                [[FISharedResources sharedResourceManager] showBannerView];
            }
        }
        //NSDictionary *dictionary = @{@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"], @"userName":[[NSUserDefaults standardUserDefaults]objectForKey:@"firstName"],@"article_Name":self.selectedArticleTitle};
        
        
        // [Localytics tagEvent:@"Mark Important in Drill" attributes:dictionary];
    }
    //    } else {
    //        UIWindow *window = [[UIApplication sharedApplication]windows][0];
    //        NSArray *subViewArray = [window subviews];
    //        //NSLog(@"subview array count:%d",subViewArray.count);
    //        if(subViewArray.count == 1) {
    //            [[FISharedResources sharedResourceManager] showBannerView];
    //        }
    //       // [FIUtils showNoNetworkToast];
    //    }
    
}

- (IBAction)globeButtonClick:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"globeButtonClick" object:nil userInfo:@{@"url":[self.curatedNewsDetail valueForKey:@"articleUrl"]}];
}

//-(void)loadCuratedNewsDetails:(id)sender {
//    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@",self.selectedArticleId];
//    [fetchRequest setPredicate:predicate];
//    NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
//    if(newPerson.count != 0) {
//        NSManagedObject *curatedNews = [newPerson objectAtIndex:0];
//
//        NSManagedObject *curatedNewsDetail = [curatedNews valueForKey:@"details"];
//        dispatch_async(dispatch_get_main_queue(), ^(void){
//
//            NSString *userAccountTypeId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userAccountTypeId"]];
//
//            //                if([userAccountTypeId isEqualToString:@"3"]) {
//            self.webViewHeightConstraint.constant = 200;
//            //                }else if([userAccountTypeId isEqualToString:@"2"] || [userAccountTypeId isEqualToString:@"1"]) {
//            //                    self.webViewHeightConstraint.constant = 400;
//            //                }
//
//            if([curatedNewsDetail valueForKey:@"article"] == nil){
//                [self.articleWebview loadHTMLString:@"" baseURL:nil];
//            } else {
//                NSString *htmlString = [NSString stringWithFormat:@"<body style='color:#666e73;font-family:Open Sans;line-height: 1.7;font-size: 16px;font-weight: 310;'>%@",[curatedNewsDetail valueForKey:@"article"]];
//                [self.articleWebview loadHTMLString:htmlString baseURL:nil];
//            }
//
//
//            NSNumber *unreadCnt = [curatedNewsDetail valueForKey:@"unReadComment"];
//            NSNumber *totalCnt = [curatedNewsDetail valueForKey:@"totalComments"];
//            if([unreadCnt isEqualToNumber:[NSNumber numberWithInt:0]]) {
//                self.badgeTwo.value = [totalCnt integerValue];
//                self.badgeTwo.fillColor = UIColorFromRGB(0xbcbcbc);
//            } else {
//                self.badgeTwo.value = [unreadCnt integerValue];
//                self.badgeTwo.fillColor = UIColorFromRGB(0xF55567);
//            }
//
//
//            NSNumber *markImpStatus = [curatedNewsDetail valueForKey:@"markAsImportant"];
//            if([markImpStatus isEqualToNumber:[NSNumber numberWithInt:1]]) {
//                // NSLog(@"mark selected");
//                [self.markedImpButton setSelected:YES];
//            } else {
//                //NSLog(@"mark not selected");
//                [self.markedImpButton setSelected:NO];
//            }
//
//            if([[curatedNewsDetail valueForKey:@"readStatus"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
//                NSNumber *markImpStatus = [curatedNewsDetail valueForKey:@"markAsImportant"];
//                if([markImpStatus isEqualToNumber:[NSNumber numberWithInt:1]]) {
//                    //                        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMenuCount" object:nil userInfo:@{@"type":@"-2",@"isSelected":[NSNumber numberWithBool:NO]}];
//                }
//            } else {
//
//            }
//
//
//            //                if([[curatedNews valueForKey:@"readStatus"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
//            //
//            //
//            //                    NSNumber *markImpStatus = [curatedNewsDetail valueForKey:@"markAsImportant"];
//            //                    if(markImpStatus == [NSNumber numberWithInt:1]) {
//            //                        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMenuCount" object:nil userInfo:@{@"type":@"-2",@"isSelected":[NSNumber numberWithBool:NO]}];
//            //                        [curatedNews setValue:[NSNumber numberWithBool:NO] forKey:@"markAsImportant"];
//            //                        [self.markedImpButton setSelected:YES];
//            //                    } else {
//            //                        NSLog(@"mark not selected");
//            //                        [self.markedImpButton setSelected:NO];
//            //                    }
//            //
//            //                }
//            //                   // if(number == [NSNumber numberWithInt:1]) {
//            //                        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMenuCount" object:nil userInfo:@{@"type":@"-2",@"isSelected":[NSNumber numberWithBool:NO]}];
//            //                      //  [curatedNews setValue:[NSNumber numberWithBool:NO] forKey:@"markAsImportant"];
//            //                    } else {
//            //                        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMenuCount" object:nil userInfo:@{@"type":@"-2",@"isSelected":[NSNumber numberWithBool:YES]}];
//            //                        //[curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"markAsImportant"];
//            //                    }
//            // }
//
//            if([[curatedNews valueForKey:@"saveForLater"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
//                [self.savedForLaterButton setSelected:YES];
//            } else {
//                [self.savedForLaterButton setSelected:NO];
//            }
//
//
//            NSSet *relatedPostSet = [curatedNewsDetail valueForKey:@"relatedPost"];
//            NSMutableArray *postArray = [[NSMutableArray alloc]initWithArray:[relatedPostSet allObjects]];
//            self.relatedPostArray = postArray;
//            [self loadTweetsFromPost];
//        });
//    }
//}
//
//
//
//
//
//-(void)loadCuratedNewsAuthorDetails:(id)sender {
//    NSNotification *notification = sender;
//    NSDictionary *userInfo = notification.userInfo;
//    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
//    //NSLog(@"passing article id:%@",[userInfo objectForKey:@"articleId"]);
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@",self.selectedArticleId];
//    [fetchRequest setPredicate:predicate];
//    NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
//    NSManagedObject *curatedNews;
//    if(newPerson.count != 0) {
//        curatedNews = [newPerson objectAtIndex:0];
//        dispatch_async(dispatch_get_main_queue(), ^(void){
//
//            NSSet *authorSet = [curatedNews valueForKey:@"authorDetails"];
//            NSMutableArray *legendsArray = [[NSMutableArray alloc]initWithArray:[authorSet allObjects]];
//            NSManagedObject *author;
//            if(legendsArray.count != 0) {
//                author  = [legendsArray objectAtIndex:0];
//            }
//            //  NSLog(@"single author:%@",author);
//
//            self.socialLinksArray = [[NSMutableArray alloc]init];
//            NSSet *socialMediaSet = [author valueForKey:@"authorSocialMedia"];
//            self.socialLinksArray = [[NSMutableArray alloc]initWithArray:[socialMediaSet allObjects]];
//            // NSLog(@"social list:%d",self.socialLinksArray.count);
//            if(self.socialLinksArray.count == 0) {
//                self.socialLinkLabel.hidden = YES;
//                self.socialLinkDivider.hidden = YES;
//                self.socialLinkCollectionView.hidden = YES;
//            } else {
//                self.socialLinksArray = self.socialLinksArray;
//                self.socialLinkLabel.hidden = NO;
//                self.socialLinkDivider.hidden = NO;
//                self.socialLinkCollectionView.hidden = NO;
//
//                [self.socialLinkCollectionView reloadData];
//            }
//
//            [self.aboutAuthorImageView sd_setImageWithURL:[NSURL URLWithString:[author valueForKey:@"imageURL"]] placeholderImage:[UIImage imageNamed:@"userIcon_150"]];
//            [self.aboutAuthorImageView setContentMode:UIViewContentModeScaleAspectFill];
//
//            // NSString *authorName = [NSString stringWithFormat:@"%@ %@",[author valueForKey:@"firstName"],[author valueForKey:@"lastName"]];
//            //self.aboutAuthorName.text = authorName;
//            self.authorNameStr = [author valueForKey:@"firstName"];
//
//            if([[author valueForKey:@"starRating"] integerValue] == 0) {
//                self.ratingControl.hidden = YES;
//            } else {
//                self.ratingControl.hidden = NO;
//                self.starRating.rating = [[author valueForKey:@"starRating"] integerValue];
//            }
//
//            if([[author valueForKey:@"isInfluencer"]isEqualToNumber:[NSNumber numberWithInt:1]]) {
//                self.influencerIconImage.hidden = NO;
//            } else {
//                self.influencerIconImage.hidden = YES;
//            }
//
//
//            NSSet *workTitleSet = [author valueForKey:@"authorWorkTitle"];
//            NSMutableArray *workTitleArray = [[NSMutableArray alloc]initWithArray:[workTitleSet allObjects]];
//            if(workTitleArray.count != 0) {
//                self.workTitleIcon.hidden = NO;
//                self.workTitleIconHeightConstraint.constant = 15;
//                self.workTitleLabelHeightConstraint.constant = 21;
//                self.outletImageTopConstraint.constant = 10;
//                self.outletLabelTopConstraint.constant = 4;
//                NSManagedObject *workTitle = [workTitleArray objectAtIndex:0];
//                self.authorWorkTitleLabel.text = [workTitle valueForKey:@"title"];
//            } else {
//                self.workTitleIcon.hidden = YES;
//                self.workTitleIconHeightConstraint.constant = 0;
//                self.workTitleLabelHeightConstraint.constant = 0;
//                self.outletImageTopConstraint.constant = 0;
//                self.outletLabelTopConstraint.constant = 0;
//            }
//
//
//            NSSet *outletSet = [author valueForKey:@"authorOutlet"];
//            NSMutableArray *outletArray = [[NSMutableArray alloc]initWithArray:[outletSet allObjects]];
//            if(outletArray.count != 0) {
//                self.outletIcon.hidden = NO;
//                self.locationImageTopConstarint.constant = 10;
//                self.outletIconHeightConstraint.constant = 15;
//                self.locationLabelTopConstraint.constant = 4;
//                self.outletLabelHeightConstraint.constant = 21;
//                NSManagedObject *outlet = [outletArray objectAtIndex:0];
//                self.authorOutletName.text = [outlet valueForKey:@"outletname"];
//            }else {
//                self.outletIcon.hidden = YES;
//                self.outletIconHeightConstraint.constant = 0;
//                self.locationImageTopConstarint.constant = 0;
//                self.locationLabelTopConstraint.constant = 0;
//                self.outletLabelHeightConstraint.constant = 0;
//            }
//
//
//            NSString *city = [author valueForKey:@"city"];
//            NSString *country = [author valueForKey:@"country"];
//            NSString *authorPlace;
//            if(city.length == 0 && country.length == 0) {
//                authorPlace = @"";
//            } else if(city.length == 0) {
//                authorPlace = [NSString stringWithFormat:@"%@",country];
//            } else if(country.length == 0) {
//                authorPlace = [NSString stringWithFormat:@"%@",city];
//            } else {
//                authorPlace = [NSString stringWithFormat:@"%@, %@",city,country];
//            }
//
//            if(authorPlace.length !=0 ){
//                self.locationIcon.hidden = NO;
//                self.locationIconHeightConstraint.constant = 15;
//                self.locationLabelHeightConstraint.constant = 21;
//                self.beatsImageTopConstraint.constant = 10;
//                self.beatsLabelTopConstraint.constant = 4;
//                self.authorLocationLabel.text = authorPlace;
//            } else {
//                self.locationIcon.hidden = YES;
//                self.locationIconHeightConstraint.constant = 0;
//                self.locationLabelHeightConstraint.constant = 0;
//                self.beatsImageTopConstraint.constant = 0;
//                self.beatsLabelTopConstraint.constant = 0;
//            }
//
//            NSSet *beatSet = [author valueForKey:@"authorBeat"];
//            NSMutableArray *beatsArray = [[NSMutableArray alloc]initWithArray:[beatSet allObjects]];
//            NSMutableArray *beats = [[NSMutableArray alloc]init];
//            for(NSManagedObject *beat in beatsArray) {
//                [beats addObject:[NSString stringWithFormat:@"#%@",[beat valueForKey:@"name"]]];
//            }
//            NSString *beatString = [beats componentsJoinedByString:@" "];
//            if(beatString.length != 0){
//                self.beatsIcon.hidden = NO;
//                self.beatsIconHeightConstraint.constant = 15;
//                self.beatsLabelHeightConstraint.constant = 21;
//                self.authorTagLabel.text = beatString;
//            } else {
//                self.beatsIcon.hidden = YES;
//                self.beatsIconHeightConstraint.constant = 0;
//                self.beatsLabelHeightConstraint.constant = 0;
//            }
//
//
//            NSString *bioString = [author valueForKey:@"bibliography"];
//
//            if(bioString.length != 0) {
//
//                self.bioTitleLabel.hidden = NO;
//                self.bioDivider.hidden = NO;
//                self.bioLabel.hidden = NO;
//                self.bioLabel.text = bioString;
//            } else {
//                self.bioTitleLabel.hidden = YES;
//                self.bioDivider.hidden = YES;
//                self.bioLabel.hidden = YES;
//            }
//
//
//        });
//    }
//
//
//
//}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    int cellSizeOfButton;
    if(collectionView == self.socialcollectionView)
    {
    cellSizeOfButton= 2;
    }
    return cellSizeOfButton;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView == self.scrollView) {
        //        tweetsCollectionView.delegate = nil;
        //        tweetsCollectionView.dataSource = nil;
        CGFloat y = -scrollView.contentOffset.y;
        //NSLog(@"scroll y value:%f",y);
        if (y > 0) {
            if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
            {
                self.articleImageView.frame = CGRectMake(0, scrollView.contentOffset.y, self.cachedImageViewSize.size.width+y, self.cachedImageViewSize.size.height+y);
                self.articleImageView.center = CGPointMake(self.contentView.center.x, self.articleImageView.center.y);
            }
            else
            {
                    self.articleImageView.frame = CGRectMake(0, scrollView.contentOffset.y, self.cachedImageViewSize.size.width+y+50, self.cachedImageViewSize.size.height+y);
                    self.articleImageView.center = CGPointMake(self.contentView.center.x, self.articleImageView.center.y);
            }
            
        } else {
            if(!self.isTwitterAPICalled) {
                self.tweetsLocalCollectionView.hidden = YES;
                lbl.hidden = YES;
            }
            
            
            
            //NSLog(@"collection view cell scroll:%f and %f and x:%f",y,-self.articleWebview.frame.size.height,scrollView.contentOffset.x);
            //if(y > -200 && scrollView.contentOffset.x==0) {
            
            
            if(!self.isTwitterLoad) {
                //                //followersArray=[[NSMutableArray alloc]init];
                //               // [followersArray removeAllObjects];
                
                [self loadTweetsAndSocialLink];
            }
            // }//hidden
// tweet api is called if the visibility of influencer tweet is true.
            if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
                if (CGRectIntersectsRect(scrollView.bounds, _tweetLabel.frame) == true  && !self.isTwitterAPICalled) {
                    NSLog(@"call twitter API");
                    
                    [self loadTweetsFromPost];
                }
//                if(y < -positionOfInfluencerTweetLblInScrollView.origin.y+30 && !self.isTwitterAPICalled) {
//                    
//                }
            
            }
            else
            {
            if(y < -positionOfCollectionViewInScrollView.origin.y+600 && !self.isTwitterAPICalled) {
                NSLog(@"call twitter API");
                
                [self loadTweetsFromPost];
            }
            }
        }
        
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(scrollView == self.scrollView) {
        float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (bottomEdge >= scrollView.contentSize.height) {
            // we are at the end
            
            
        }
    }
    
}

- (IBAction)savedListButtonClick:(UIButton *)sender {
    [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"FolderClick"];

    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"SavedListPopoverViewPhone" bundle:nil];
        SavedListPopoverView *popOverView = [storyBoard instantiateViewControllerWithIdentifier:@"SavedList"];
        self.superview.alpha = 0.4;
        popOverView.selectedArticleId = self.selectedArticleId;
        popover = [[FPPopoverController alloc] initWithViewController:popOverView];
        popover.border = NO;
        popover.delegate = self;
        
        //[popover setShadowsHidden:YES];
        popover.tint = FPPopoverWhiteTint;
        popover.contentSize = CGSizeMake(300, 260);
        popover.arrowDirection = FPPopoverArrowDirectionAny;
        [popover presentPopoverFromView:sender];
    }
    else{
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"SavedListPopoverView" bundle:nil];
        SavedListPopoverView *popOverView = [storyBoard instantiateViewControllerWithIdentifier:@"SavedList"];
        popOverView.selectedArticleId = self.selectedArticleId;
        self.popOver =[[UIPopoverController alloc] initWithContentViewController:popOverView];
        self.popOver.popoverContentSize=CGSizeMake(350, 267);
        //self.popOver.delegate = self;
        [self.popOver presentPopoverFromRect:sender.frame inView:self.bottomView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
}

- (IBAction)moreButtonClick:(UIButton *)sender {
    [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"SocialSharingButtonClick"];
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MorePopoverViewPhone" bundle:nil];
        MorePopoverView *popOverView = [storyBoard instantiateViewControllerWithIdentifier:@"MorePopoverView"];
        popOverView.articleTitle = self.selectedArticleTitle;
        popOverView.articleUrl = self.selectedArticleUrl;
        popOverView.articleDesc = self.articleDesc;
        popOverView.articleImageUrl = self.selectedArticleImageUrl;
        popOverView.articleId = self.selectedArticleId;
        self.superview.alpha = 0.4;
        popover = [[FPPopoverController alloc] initWithViewController:popOverView];
        popover.border = NO;
        popover.delegate = self;
        //[popover setShadowsHidden:YES];
        popover.tint = FPPopoverWhiteTint;
        popover.contentSize = CGSizeMake(300, 280);
        popover.arrowDirection = FPPopoverArrowDirectionAny;
        [popover presentPopoverFromView:sender];

    }
    
    else{
        
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MorePopoverView" bundle:nil];
    MorePopoverView *popOverView = [storyBoard instantiateViewControllerWithIdentifier:@"MorePopoverView"];
    popOverView.articleTitle = self.selectedArticleTitle;
    popOverView.articleUrl = self.selectedArticleUrl;
    popOverView.articleDesc = self.articleDesc;
    popOverView.articleImageUrl = self.selectedArticleImageUrl;
    self.popOver =[[UIPopoverController alloc] initWithContentViewController:popOverView];
    self.popOver.popoverContentSize=CGSizeMake(350, 150);
    //self.popOver.delegate = self;
    [self.popOver presentPopoverFromRect:sender.frame inView:self.bottomView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    //CAPTURE USER LINK-CLICK.
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        self.webViewHeightConstraint.constant = 200;
    //    });
    NSURL *url = [request URL];
    NSLog(@"select link:%@",url);
    if(webView == self.articleWebview) {
        // NSURL *url = [request URL];
        NSLog(@"select link:%@",url);
        NSString *urlString = url.absoluteString;
        if (![urlString isEqualToString: @"about:blank"]) {
           
            [[NSNotificationCenter defaultCenter]postNotificationName:@"widgetWebViewCalled" object:nil userInfo:@{@"name":@"More Info",@"link":urlString}];
            
            return NO;
        }
    }
    return YES;
}

@end
