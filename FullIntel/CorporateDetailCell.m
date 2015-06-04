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


@implementation CorporateDetailCell

- (void)awakeFromNib {
    // Initialization code
    self.authorImageView.layer.masksToBounds = YES;
    self.authorImageView.layer.cornerRadius = 25.0f;
   // self.socialLinksArray = [[NSMutableArray alloc]init];
    
    
    self.overlayArticleImageView.layer.masksToBounds = YES;
    self.overlayArticleImageView.layer.cornerRadius = 10.0f;
    self.overlayArticleImageView.layer.borderColor = [UIColor colorWithRed:(237/255.0) green:(240/255.0) blue:(240/255.0) alpha:1].CGColor;
    self.overlayArticleImageView.layer.borderWidth = 0.5f;
    
    self.contents = [NSDictionary dictionaryWithObjectsAndKeys:
                     // Rounded rect buttons
                     @"A CMPopTipView will automatically position itself within the container view.", [NSNumber numberWithInt:11],
                     nil];
    
    [progressView removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCuratedNewsDetails:) name:@"CuratedNewsDetails" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCuratedNewsAuthorDetails:) name:@"CuratedNewsAuthorDetails" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeWebView:) name:@"removeWebView" object:nil];
    UITapGestureRecognizer *tapEvent = [[UITapGestureRecognizer alloc]initWithTarget:self action:nil];
    tapEvent.numberOfTapsRequired = 1;
    self.detailsWebview.tag =101;
    self.detailsWebview.userInteractionEnabled = YES;
    [self.detailsWebview addGestureRecognizer:tapEvent];
    
    
}

-(void)removeWebView:(id)sender {
    [self.timer invalidate];
    [progressView removeFromSuperview];
    NSNotification *notification = sender;
    NSDictionary *userInfo = notification.userInfo;
    NSNumber *number = [userInfo objectForKey:@"status"];
    NSLog(@"selected number:%@",number);
    if([number isEqualToNumber:[NSNumber numberWithInt:1]]) {
       // [self.detailsWebview removeFromSuperview];
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
    NSLog(@"gesture working in cell:%ld and %ld",(long)otherGestureRecognizer.view.tag,(long)gestureRecognizer.view.tag);
    if((long)otherGestureRecognizer.view.tag == 101){
        self.overlayView.hidden = YES;
    } else {
       // self.overlayView.hidden = NO;
    }
  //  [self.overlayView removeFromSuperview];
    return YES;
}


-(void)loadTweetsFromPost {
    NSMutableArray *tweetIds = [[NSMutableArray alloc]init];
    
    for(NSManagedObject *relatedPost in self.relatedPostArray) {
        [tweetIds addObject:[relatedPost valueForKey:@"postId"]];
    }
    NSLog(@"tweet ids:%@",tweetIds);
   // NSArray *tweetIds=@[@"20",@"21"];
    
    [[Twitter sharedInstance] logInGuestWithCompletion:^(TWTRGuestSession *guestSession, NSError *error) {
        [[[Twitter sharedInstance] APIClient] loadTweetsWithIDs:tweetIds completion:^(NSArray *tweet, NSError *error) {
            NSLog(@"Tweet array:%@",tweet);
            tweetArray = [[NSMutableArray alloc]initWithArray:tweet];
            if(tweetArray.count == 0) {
                self.tweetCollectionViewHeightConstraint.constant = 0;
                self.tweetLabelHeightConstraint.constant = 0;
                self.tweetLabel.hidden = YES;
                self.tweetDividerImageView.hidden = YES;
               // self.aboutAuthorVerticalConstraint.constant = 0;
            }else {
                self.tweetCollectionViewHeightConstraint.constant = 300;
                self.tweetLabelHeightConstraint.constant = 41;
                self.tweetLabel.hidden = NO;
                self.tweetDividerImageView.hidden = NO;
               // self.aboutAuthorVerticalConstraint.constant = 44;
                
            }
            [self.tweetsCollectionView reloadData];
        }];
    }];
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
    else if(collectionView == self.socialLinkCollectionView) {
        return CGSizeMake(50, 50);
    } else if(collectionView == self.tweetsCollectionView) {
        return CGSizeMake(320, 300);
    }
    return CGSizeMake(30, 30);
}

#pragma mark - UICollectionView Datasource

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    // NSLog(@"imp collection view:%d",self.socialLinksArray.count);
    NSInteger itemCount;
//    if(view == self.legendsCollectionView) {
//        itemCount = self.legendsArray.count;
//    }else
    if(view == self.socialLinkCollectionView){
        itemCount = self.socialLinksArray.count;
    }else if(view == self.tweetsCollectionView) {
        itemCount = tweetArray.count;
    }else {
        itemCount = 4;
    }
    return itemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
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
    
    if(cv == self.socialLinkCollectionView) {
       // NSLog(@"inside social link collectionview cellfor item");
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
        
    } else if(cv == self.tweetsCollectionView) {
        TweetsCell *tweetCell =(TweetsCell*) [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        TWTRTweet *tweetObj = [tweetArray objectAtIndex:indexPath.row];
        TWTRUser *author = tweetObj.author;
        tweetCell.author.text = author.name;
       // NSLog(@"tweet id:%@",tweetObj.tweetID);
        NSDictionary *tweetDic = [[FISharedResources sharedResourceManager]getTweetDetails:author.screenName];
        NSLog(@"user id:%@ and tweet id:%@ and dic:%@",author.userID,tweetObj.tweetID,tweetDic);
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
        
        int followersCount = [[tweetDic objectForKey:@"followers_count"] intValue];
        NSLog(@"single followers count:%d",followersCount);
        if(followersCount/1000 == 0) {
            tweetCell.followers.text = [NSString stringWithFormat:@"%d",followersCount];
        } else {
            float followersFloatValue = (float)followersCount;
            tweetCell.followers.text = [NSString stringWithFormat:@"%.01fK",followersFloatValue/1000];
        }
        
     //   tweetCell.followers.text = [tweetDic objectForKey:@"followers_current"];
        tweetCell.contentView.layer.borderWidth = 1.0f;
        tweetCell.contentView.layer.borderColor = [[UIColor colorWithRed:237.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1] CGColor];
        collectionCell = tweetCell;
    }else {
        if(indexPath.row == 0) {
            [self.widgetCollectionView registerClass:[PersonalityWidgetCell class]
                          forCellWithReuseIdentifier:@"Personality"];
            [self.widgetCollectionView registerNib:[UINib nibWithNibName:@"PersonalityWidgetCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"Personality"];
            
            PersonalityWidgetCell * cell =(PersonalityWidgetCell*) [cv dequeueReusableCellWithReuseIdentifier:@"Personality" forIndexPath:indexPath];
            cell.contentView.layer.borderWidth = 1.0f;
            cell.contentView.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
            
            UITapGestureRecognizer *socialCellTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upgradeTap:)];
            socialCellTap.numberOfTapsRequired=1;
            cell.requestUpgradeButton.tag=indexPath.row;
            [cell.requestUpgradeButton addGestureRecognizer:socialCellTap];
            collectionCell = cell;
        } else if(indexPath.row == 1) {
            [self.widgetCollectionView registerClass:[StockWidgetCell class]
                          forCellWithReuseIdentifier:@"stock"];
            [self.widgetCollectionView registerNib:[UINib nibWithNibName:@"StockWidgetCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"stock"];
            
            StockWidgetCell *cell =(StockWidgetCell*) [cv dequeueReusableCellWithReuseIdentifier:@"stock" forIndexPath:indexPath];
            cell.contentView.layer.borderWidth = 1.0f;
            cell.contentView.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
            UITapGestureRecognizer *socialCellTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upgradeTap:)];
            socialCellTap.numberOfTapsRequired=1;
            cell.requestUpgradeButton.tag=indexPath.row;
            [cell.requestUpgradeButton addGestureRecognizer:socialCellTap];
            
            collectionCell = cell;
        } else if(indexPath.row == 2) {
            [self.widgetCollectionView registerClass:[ProductWidgetCell class]
                          forCellWithReuseIdentifier:@"product"];
            [self.widgetCollectionView registerNib:[UINib nibWithNibName:@"ProductWidgetCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"product"];
            
            ProductWidgetCell *cell =(ProductWidgetCell*) [cv dequeueReusableCellWithReuseIdentifier:@"product" forIndexPath:indexPath];
            cell.contentView.layer.borderWidth = 1.0f;
            cell.contentView.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
            UITapGestureRecognizer *socialCellTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upgradeTap:)];
            socialCellTap.numberOfTapsRequired=1;
            cell.requestUpgradeButton.tag=indexPath.row;
            [cell.requestUpgradeButton addGestureRecognizer:socialCellTap];
            
            collectionCell = cell;
        } else if(indexPath.row == 3) {
            [self.widgetCollectionView registerClass:[VideoWidgetCell class]
                          forCellWithReuseIdentifier:@"video"];
            [self.widgetCollectionView registerNib:[UINib nibWithNibName:@"VideoWidgetCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"video"];
            
            VideoWidgetCell *cell =(VideoWidgetCell*) [cv dequeueReusableCellWithReuseIdentifier:@"video" forIndexPath:indexPath];
            cell.contentView.layer.borderWidth = 1.0f;
            cell.contentView.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
            UITapGestureRecognizer *socialCellTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upgradeTap:)];
            socialCellTap.numberOfTapsRequired=1;
            cell.requestUpgradeButton.tag=indexPath.row;
            [cell.requestUpgradeButton addGestureRecognizer:socialCellTap];
            
            collectionCell = cell;
        }
    }
    return collectionCell;
}

-(void)socialTap:(UITapGestureRecognizer *)tapGesture {
    NSInteger row = tapGesture.view.tag;
    NSLog(@"social tap working for row:%d",row);
}


-(void)upgradeTap:(UITapGestureRecognizer *)sender{
    
    UIButton *btn=(UIButton *)sender.view;
    
    if(btn.tag == 0){
        //Personality Widget
        [btn setSelected:YES];
        [FIUtils callRequestionUpdateWithModuleId:1 withFeatureId:1];
      
        [btn setEnabled:NO];
    }else if(btn.tag == 1){
        //Company Widget
        [btn setSelected:YES];
        [FIUtils callRequestionUpdateWithModuleId:1 withFeatureId:3];
        [btn setEnabled:NO];
    }else if(btn.tag == 2){
        //Product Widget
        [btn setSelected:YES];
        [FIUtils callRequestionUpdateWithModuleId:1 withFeatureId:4];
        [btn setEnabled:NO];
    }else if(btn.tag == 3) {
        //Video Widget
        [btn setSelected:YES];
        [FIUtils callRequestionUpdateWithModuleId:1 withFeatureId:7];
        [btn setEnabled:NO];
    }
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did select social link");

    if(collectionView == self.socialLinkCollectionView) {
        
        NSManagedObject *socialLink = [self.socialLinksArray objectAtIndex:indexPath.row];
        NSString *titleStr = [NSString stringWithFormat:@"%@ in %@",self.authorNameStr,[socialLink valueForKey:@"mediatype"]];
        
        if([[FISharedResources sharedResourceManager] serviceIsReachable]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"socialLinkSelected" object:nil userInfo:@{@"name":titleStr,@"link":[socialLink valueForKey:@"url"]}];
        } else {
            [FIUtils showNoNetworkToast];
        }
    }
    
    if(collectionView==self.widgetCollectionView){
        
            [[NSNotificationCenter defaultCenter]postNotificationName:@"widgetSelected" object:nil userInfo:@{@"indexPath":indexPath}];
    }
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
   // NSLog(@"heihgt:%f",webView.scrollView.contentSize.height);
    CGSize mWebViewTextSize = [webView sizeThatFits:CGSizeMake(1.0f, 1.0f)];  // Pass about any size
    CGRect mWebViewFrame = webView.frame;
    mWebViewFrame.size.height = mWebViewTextSize.height;
    webView.frame = mWebViewFrame;
    //Disable bouncing in webview
    for (id subview in webView.subviews)
    {
        if ([[subview class] isSubclassOfClass: [UIScrollView class]])
        {
            [subview setBounces:NO];
        }
    }
   // NSLog(@"webview height:%f",webView.frame.size.height);
    if(webView.frame.size.height > 1400) {
//        self.articleWebview.frame = CGRectMake(self.articleWebview.frame.origin.x, self.articleWebview.frame.origin.y, self.articleWebview.frame.size.width, webView.frame.size.height);
        self.webViewHeightConstraint.constant = webView.frame.size.height;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.webViewHeightConstraint.constant+1300);
    } else {
        self.webViewHeightConstraint.constant = 1400;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.webViewHeightConstraint.constant+1300);
    }
    self.socialLinkCollectionView.delegate = self;
    
    self.starRating = [[AMRatingControl alloc]initWithLocation:CGPointMake(0, 0) emptyColor:[UIColor colorWithRed:161/255.0 green:16/255.0 blue:27/255.0 alpha:1.0] solidColor:[UIColor colorWithRed:161/255.0 green:16/255.0 blue:27/255.0 alpha:1.0] andMaxRating:5];
    self.starRating.userInteractionEnabled = NO;
    [self.ratingControl addSubview:self.starRating];
    
    [self.timer invalidate];
    [progressView removeFromSuperview];
}


-(void)viewDidDisappear:(BOOL)animated {
    [self.timer invalidate];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(cancelWeb) userInfo:nil repeats:NO];
    progressView = [[UCZProgressView alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width/2-50, self.contentView.frame.size.height/2-50, 100, 100)];
    progressView.translatesAutoresizingMaskIntoConstraints = NO;
    progressView.backgroundColor = [UIColor clearColor];
  //  [self.contentView addSubview:progressView];
}


- (void)cancelWeb
{
    [progressView removeFromSuperview];
    [self.timer invalidate];
    
    [FIUtils showRequestTimeOutError];
    // UIWindow *window = [[UIApplication sharedApplication]windows][0];
    // [self.view makeToast:@"Request Time out" duration:1 position:CSToastPositionCenter];
    
}


- (IBAction)researchRequestButtonClick:(UIButton *)sender {
//    ResearchRequestPopoverView *popOverView = [[ResearchRequestPopoverView alloc]initWithNibName:@"ResearchRequestPopoverView" bundle:nil];
//    popOverView.articleId = self.selectedArticleId;
//    popOverView.articleTitle = self.selectedArticleTitle;
//    popOverView.articleUrl = self.selectedArticleUrl;
//    self.popOver =[[UIPopoverController alloc] initWithContentViewController:popOverView];
//    self.popOver.popoverContentSize=CGSizeMake(400, 260);
//    //self.popOver.delegate = self;
//    [self.popOver presentPopoverFromRect:sender.frame inView:self.bottomView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    
     [[NSNotificationCenter defaultCenter]postNotificationName:@"showResearchView" object:nil userInfo:@{@"articleId":self.selectedArticleId,@"articleTitle":self.selectedArticleTitle,@"articleUrl":self.selectedArticleUrl}];
}


- (IBAction)saveButtonClick:(UIButton *)sender {
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
    [resultDic setObject:self.selectedArticleId forKey:@"selectedArticleId"];
    [resultDic setObject:@"3" forKey:@"status"];
    
    if([[FISharedResources sharedResourceManager]serviceIsReachable]) {
    
    if(sender.selected) {
        [sender setSelected:NO];
        [resultDic setObject:@"false" forKey:@"isSelected"];
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
        
        [self.curatedNewsDetail setValue:[NSNumber numberWithBool:NO] forKey:@"saveForLater"];
        
        [[FISharedResources sharedResourceManager]setUserActivitiesOnArticlesWithDetails:resultStr];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"saveForLaterUpdate" object:nil userInfo:@{@"indexPath":self.selectedIndexPath,@"status":[NSNumber numberWithBool:NO]}];
        [self.contentView makeToast:@"Removed from \"Saved for Later\"" duration:1.0 position:CSToastPositionCenter];
    }else {
        [sender setSelected:YES];
        [resultDic setObject:@"true" forKey:@"isSelected"];
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
        
        [self.curatedNewsDetail setValue:[NSNumber numberWithBool:YES] forKey:@"saveForLater"];
        
        NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
        [[FISharedResources sharedResourceManager]setUserActivitiesOnArticlesWithDetails:resultStr];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"saveForLaterUpdate" object:nil userInfo:@{@"indexPath":self.selectedIndexPath,@"status":[NSNumber numberWithBool:YES]}];
        [self.contentView makeToast:@"Added to \"Saved for Later\"" duration:1.0 position:CSToastPositionCenter];
    }
    } else {
        [FIUtils showNoNetworkToast];
    }
}


- (IBAction)mailButtonClick:(UIButton *)sender {
    //NSLog(@"mail article url:%@",[self.curatedNewsDetail valueForKey:@"articleUrl"]);
    NSString *articleUrl = [self.curatedNewsDetail valueForKey:@"articleUrl"];
    NSString *mailBodyStr;
    if(articleUrl.length != 0) {
        mailBodyStr = [NSString stringWithFormat:@"Forwarded from FullIntel\n\n%@\n\n%@",self.articleDesc,[self.curatedNewsDetail valueForKey:@"articleUrl"]];
    } else {
        mailBodyStr = [NSString stringWithFormat:@"Forwarded from FullIntel\n\n%@\n",self.articleDesc];
    }
    NSLog(@"mail body string:%@ and title:%@",mailBodyStr,self.selectedArticleTitle);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"mailButtonClick" object:nil userInfo:@{@"title":self.selectedArticleTitle,@"body":mailBodyStr}];
    //}
}

- (IBAction)commentsButtonClick:(UIButton *)sender {
    NSLog(@"selected article id for comment:%@",self.selectedArticleId);
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
        NSLog(@"comments:%@",[curatedNews valueForKey:@"comments"]);
        NSManagedObject *userComments = [curatedNews valueForKey:@"comments"];
        if(userComments == nil) {
            [[FISharedResources sharedResourceManager]getCommentsWithDetails:commentsResultStr withArticleId:self.selectedArticleId];
        }
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showCommentsView" object:nil userInfo:@{@"articleId":self.selectedArticleId}];

//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Comments" bundle:nil];
//    CommentsPopoverView *popOverView = [storyBoard instantiateViewControllerWithIdentifier:@"CommentsPopoverView"];
//    popOverView.articleId = self.selectedArticleId;
//    self.popOver =[[UIPopoverController alloc] initWithContentViewController:popOverView];
//    self.popOver.popoverContentSize=CGSizeMake(400, 300);
//    //self.popOver.delegate = self;
//    [self.popOver presentPopoverFromRect:sender.frame inView:self.bottomView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    
    
    
    
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Comments" bundle:nil];
//    CommentsPopoverView *popOverView = [storyBoard instantiateViewControllerWithIdentifier:@"CommentsPopoverView"];
//    popOverView.articleId = self.selectedArticleId;
//    self.popOver =[[UIPopoverController alloc] initWithContentViewController:popOverView];
//    self.popOver.popoverContentSize=CGSizeMake(400, 600);
//    //self.popOver.delegate = self;
//    NSLog(@"heightttt:%f",self.contentView.frame.size.height);
//    //   UIWindow *window = [[UIApplication sharedApplication]windows][0];
//    CGRect rect = CGRectMake(self.contentView.frame.size.width/2, (self.contentView.frame.size.height-64)/2, 1, 1);
//    //[popOverController presentPopoverFromRect:rect inView:view permittedArrowDirections:0 animated:YES];
//    
//    // [self.popOver presentPopoverFromBarButtonItem:sender
//    //  permittedArrowDirections:0
//    //    animated:YES];
//    [self.popOver presentPopoverFromRect:sender.frame inView:self.contentView permittedArrowDirections:0 animated:YES];
}


- (IBAction)markedImpButtonClick:(UIButton *)sender {
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
    [resultDic setObject:self.selectedArticleId forKey:@"selectedArticleId"];
    [resultDic setObject:@"2" forKey:@"status"];
    
    if([[FISharedResources sharedResourceManager]serviceIsReachable]) {
    
    if(sender.selected) {
        [sender setSelected:NO];
        [resultDic setObject:@"false" forKey:@"isSelected"];
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
        
        [self.curatedNewsDetail setValue:[NSNumber numberWithBool:NO] forKey:@"markAsImportant"];
        
        [[FISharedResources sharedResourceManager]setUserActivitiesOnArticlesWithDetails:resultStr];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"markedImportantUpdate" object:nil userInfo:@{@"indexPath":self.selectedIndexPath,@"status":[NSNumber numberWithBool:NO]}];
        [self.contentView makeToast:@"Removed from \"Marked Important\"" duration:1.0 position:CSToastPositionCenter];
    }else {
        [sender setSelected:YES];
        [resultDic setObject:@"true" forKey:@"isSelected"];
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
        
        [self.curatedNewsDetail setValue:[NSNumber numberWithBool:YES] forKey:@"markAsImportant"];
        
        NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
        [[FISharedResources sharedResourceManager]setUserActivitiesOnArticlesWithDetails:resultStr];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"markedImportantUpdate" object:nil userInfo:@{@"indexPath":self.selectedIndexPath,@"status":[NSNumber numberWithBool:YES]}];
        [self.contentView makeToast:@"Marked Important." duration:1.0 position:CSToastPositionCenter];
    }
    } else {
        [FIUtils showNoNetworkToast];
    }
    
}

- (IBAction)globeButtonClick:(UIButton *)sender {
    NSLog(@"globe button click");
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"globeButtonClick" object:nil userInfo:@{@"url":[self.curatedNewsDetail valueForKey:@"articleUrl"]}];
}

-(void)loadCuratedNewsDetails:(id)sender {
    NSNotification *notification = sender;
    NSDictionary *userInfo = notification.userInfo;
    //self.selectedArticleId = [userInfo objectForKey:@"articleId"];
        NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@",[userInfo objectForKey:@"articleId"]];
        [fetchRequest setPredicate:predicate];
        NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        if(newPerson.count != 0) {
            NSManagedObject *curatedNews = [newPerson objectAtIndex:0];
            NSManagedObject *curatedNewsDetail = [curatedNews valueForKey:@"details"];
            NSLog(@"cell post notification is working:%@",curatedNewsDetail);
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                 NSString *userAccountTypeId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userAccountTypeId"]];
                
                if([userAccountTypeId isEqualToString:@"3"]) {
                    self.webViewHeightConstraint.constant = 400;
                }else if([userAccountTypeId isEqualToString:@"2"] || [userAccountTypeId isEqualToString:@"1"]) {
                    self.webViewHeightConstraint.constant = 940;
                }
                
                NSString *htmlString = [NSString stringWithFormat:@"<body style='color:#666e73;font-family:Open Sans;line-height: 1.7;font-size: 16px;font-weight: 310;'>%@",[curatedNewsDetail valueForKey:@"article"]];
                [self.articleWebview loadHTMLString:htmlString baseURL:nil];
                
                
                NSNumber *markImpStatus = [curatedNewsDetail valueForKey:@"markAsImportant"];
                if(markImpStatus == [NSNumber numberWithInt:1]) {
                    NSLog(@"mark selected");
                    [self.markedImpButton setSelected:YES];
                } else {
                    NSLog(@"mark not selected");
                    [self.markedImpButton setSelected:NO];
                }
                
                    if([[curatedNews valueForKey:@"saveForLater"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                        [self.savedForLaterButton setSelected:YES];
                    } else {
                        [self.savedForLaterButton setSelected:NO];
                    }
                
                
                NSSet *relatedPostSet = [curatedNewsDetail valueForKey:@"relatedPost"];
                NSMutableArray *postArray = [[NSMutableArray alloc]initWithArray:[relatedPostSet allObjects]];
                self.relatedPostArray = postArray;
                [self loadTweetsFromPost];
            });
        }
}


-(void)loadCuratedNewsAuthorDetails:(id)sender {
    NSNotification *notification = sender;
    NSDictionary *userInfo = notification.userInfo;
        NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@",[userInfo objectForKey:@"articleId"]];
        [fetchRequest setPredicate:predicate];
        NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        NSManagedObject *curatedNews;
        if(newPerson.count != 0) {
            curatedNews = [newPerson objectAtIndex:0];
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
                    self.socialLinkLabel.hidden = YES;
                    self.socialLinkDivider.hidden = YES;
                    self.socialLinkCollectionView.hidden = YES;
                } else {
                    self.socialLinksArray = self.socialLinksArray;
                    self.socialLinkLabel.hidden = NO;
                    self.socialLinkDivider.hidden = NO;
                    self.socialLinkCollectionView.hidden = NO;
                    
                    [self.socialLinkCollectionView reloadData];
                }
                
                [self.aboutAuthorImageView sd_setImageWithURL:[NSURL URLWithString:[author valueForKey:@"imageURL"]] placeholderImage:[UIImage imageNamed:@"userIcon_150"]];
                [self.aboutAuthorImageView setContentMode:UIViewContentModeScaleAspectFill];
                
               // NSString *authorName = [NSString stringWithFormat:@"%@ %@",[author valueForKey:@"firstName"],[author valueForKey:@"lastName"]];
                //self.aboutAuthorName.text = authorName;
                self.authorNameStr = [author valueForKey:@"firstName"];
                
                if([[author valueForKey:@"starRating"] integerValue] == 0) {
                    self.ratingControl.hidden = YES;
                } else {
                    self.ratingControl.hidden = NO;
                    self.starRating.rating = [[author valueForKey:@"starRating"] integerValue];
                }
                
                if([[author valueForKey:@"isInfluencer"]isEqualToNumber:[NSNumber numberWithInt:1]]) {
                    self.influencerIconImage.hidden = NO;
                } else {
                    self.influencerIconImage.hidden = YES;
                }
                
                
                NSSet *workTitleSet = [author valueForKey:@"authorWorkTitle"];
                NSMutableArray *workTitleArray = [[NSMutableArray alloc]initWithArray:[workTitleSet allObjects]];
                if(workTitleArray.count != 0) {
                    self.workTitleIcon.hidden = NO;
                    self.workTitleIconHeightConstraint.constant = 15;
                    self.workTitleLabelHeightConstraint.constant = 21;
                    self.outletImageTopConstraint.constant = 10;
                    self.outletLabelTopConstraint.constant = 4;
                    NSManagedObject *workTitle = [workTitleArray objectAtIndex:0];
                    self.authorWorkTitleLabel.text = [workTitle valueForKey:@"title"];
                } else {
                    self.workTitleIcon.hidden = YES;
                    self.workTitleIconHeightConstraint.constant = 0;
                    self.workTitleLabelHeightConstraint.constant = 0;
                    self.outletImageTopConstraint.constant = 0;
                    self.outletLabelTopConstraint.constant = 0;
                }
                
                
                NSSet *outletSet = [author valueForKey:@"authorOutlet"];
                NSMutableArray *outletArray = [[NSMutableArray alloc]initWithArray:[outletSet allObjects]];
                if(outletArray.count != 0) {
                    self.outletIcon.hidden = NO;
                    self.locationImageTopConstarint.constant = 10;
                    self.outletIconHeightConstraint.constant = 15;
                    self.locationLabelTopConstraint.constant = 4;
                    self.outletLabelHeightConstraint.constant = 21;
                    NSManagedObject *outlet = [outletArray objectAtIndex:0];
                    self.authorOutletName.text = [outlet valueForKey:@"outletname"];
                }else {
                    self.outletIcon.hidden = YES;
                    self.outletIconHeightConstraint.constant = 0;
                    self.locationImageTopConstarint.constant = 0;
                    self.locationLabelTopConstraint.constant = 0;
                    self.outletLabelHeightConstraint.constant = 0;
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
                    self.locationIcon.hidden = NO;
                    self.locationIconHeightConstraint.constant = 15;
                    self.locationLabelHeightConstraint.constant = 21;
                    self.beatsImageTopConstraint.constant = 10;
                    self.beatsLabelTopConstraint.constant = 4;
                    self.authorLocationLabel.text = authorPlace;
                } else {
                    self.locationIcon.hidden = YES;
                    self.locationIconHeightConstraint.constant = 0;
                    self.locationLabelHeightConstraint.constant = 0;
                    self.beatsImageTopConstraint.constant = 0;
                    self.beatsLabelTopConstraint.constant = 0;
                }
                
                NSSet *beatSet = [author valueForKey:@"authorBeat"];
                NSMutableArray *beatsArray = [[NSMutableArray alloc]initWithArray:[beatSet allObjects]];
                NSMutableArray *beats = [[NSMutableArray alloc]init];
                for(NSManagedObject *beat in beatsArray) {
                    [beats addObject:[NSString stringWithFormat:@"#%@",[beat valueForKey:@"name"]]];
                }
                NSString *beatString = [beats componentsJoinedByString:@" "];
                if(beatString.length != 0){
                    self.beatsIcon.hidden = NO;
                    self.beatsIconHeightConstraint.constant = 15;
                    self.beatsLabelHeightConstraint.constant = 21;
                    self.authorTagLabel.text = beatString;
                } else {
                    self.beatsIcon.hidden = YES;
                    self.beatsIconHeightConstraint.constant = 0;
                    self.beatsLabelHeightConstraint.constant = 0;
                }
                
                
                NSString *bioString = [author valueForKey:@"bibliography"];
                
                if(bioString.length != 0) {
                    
                    self.bioTitleLabel.hidden = NO;
                    self.bioDivider.hidden = NO;
                    self.bioLabel.hidden = NO;
                    self.bioLabel.text = bioString;
                } else {
                    self.bioTitleLabel.hidden = YES;
                    self.bioDivider.hidden = YES;
                    self.bioLabel.hidden = YES;
                }
                
                
            });
        }
    
    
    
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat y = -scrollView.contentOffset.y;
    //NSLog(@"scroll y value:%f",y);
    if (y > 0) {
        self.articleImageView.frame = CGRectMake(0, scrollView.contentOffset.y, self.cachedImageViewSize.size.width+y+50, self.cachedImageViewSize.size.height+y);
        self.articleImageView.center = CGPointMake(self.contentView.center.x, self.articleImageView.center.y);
    } else {
       // NSLog(@"collection view cell scroll");
        

    }
    
}

- (IBAction)savedListButtonClick:(UIButton *)sender {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"SavedListPopoverView" bundle:nil];
    
    SavedListPopoverView *popOverView = [storyBoard instantiateViewControllerWithIdentifier:@"SavedList"];
    self.popOver =[[UIPopoverController alloc] initWithContentViewController:popOverView];
    self.popOver.popoverContentSize=CGSizeMake(350, 267);
    //self.popOver.delegate = self;
    [self.popOver presentPopoverFromRect:sender.frame inView:self.bottomView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

- (IBAction)moreButtonClick:(UIButton *)sender {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MorePopoverView" bundle:nil];
    
    MorePopoverView *popOverView = [storyBoard instantiateViewControllerWithIdentifier:@"MorePopoverView"];
    //popOverView.articleTitle = [curatedNewsDetail valueForKey:@"articleHeading"];
   // popOverView.articleUrl = [curatedNewsDetail valueForKey:@"articleUrl"];
    //popOverView.articleImageUrl = [curatedNewsDetail valueForKey:@"articleImageURL"];
    self.popOver =[[UIPopoverController alloc] initWithContentViewController:popOverView];
    self.popOver.popoverContentSize=CGSizeMake(350, 250);
    //self.popOver.delegate = self;
    [self.popOver presentPopoverFromRect:sender.frame inView:self.bottomView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}


@end
