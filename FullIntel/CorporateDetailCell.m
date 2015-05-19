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
#import "SocialWebView.h"
#import "ResearchRequestPopoverView.h"
#import "UIView+Toast.h"
#import "CommentsPopoverView.h"
#import "FISharedResources.h"

@implementation CorporateDetailCell

- (void)awakeFromNib {
    // Initialization code
    self.authorImageView.layer.masksToBounds = YES;
    self.authorImageView.layer.cornerRadius = 25.0f;
   // self.socialLinksArray = [[NSMutableArray alloc]init];
}


- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(collectionView == self.widgetCollectionView) {
        if(indexPath.row == 0) {
            return CGSizeMake(320, 260);
        } else if(indexPath.row == 1) {
            return CGSizeMake(320, 200);
        } else if(indexPath.row == 2) {
            return CGSizeMake(320, 400);
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

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
     NSLog(@"imp collection view:%d",self.socialLinksArray.count);
    NSInteger itemCount;
//    if(view == self.legendsCollectionView) {
//        itemCount = self.legendsArray.count;
//    }else
    if(view == self.socialLinkCollectionView){
        itemCount = self.socialLinksArray.count;
    }else if(view == self.tweetsCollectionView) {
        itemCount = 10;
    }else {
        itemCount = 3;
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
        NSLog(@"inside social link collectionview cellfor item");
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
        tweetCell.contentView.layer.borderWidth = 1.0f;
        tweetCell.contentView.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
        collectionCell = tweetCell;
    }else {
        if(indexPath.row == 0) {
            [self.widgetCollectionView registerClass:[PersonalityWidgetCell class]
                          forCellWithReuseIdentifier:@"Personality"];
            [self.widgetCollectionView registerNib:[UINib nibWithNibName:@"PersonalityWidgetCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"Personality"];
            
            PersonalityWidgetCell * cell =(PersonalityWidgetCell*) [cv dequeueReusableCellWithReuseIdentifier:@"Personality" forIndexPath:indexPath];
            cell.contentView.layer.borderWidth = 1.0f;
            cell.contentView.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
            collectionCell = cell;
        } else if(indexPath.row == 1) {
            [self.widgetCollectionView registerClass:[StockWidgetCell class]
                          forCellWithReuseIdentifier:@"stock"];
            [self.widgetCollectionView registerNib:[UINib nibWithNibName:@"StockWidgetCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"stock"];
            
            PersonalityWidgetCell *cell =(PersonalityWidgetCell*) [cv dequeueReusableCellWithReuseIdentifier:@"stock" forIndexPath:indexPath];
            cell.contentView.layer.borderWidth = 1.0f;
            cell.contentView.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
            collectionCell = cell;
        } else if(indexPath.row == 2) {
            [self.widgetCollectionView registerClass:[ProductWidgetCell class]
                          forCellWithReuseIdentifier:@"product"];
            [self.widgetCollectionView registerNib:[UINib nibWithNibName:@"ProductWidgetCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"product"];
            
            ProductWidgetCell *cell =(ProductWidgetCell*) [cv dequeueReusableCellWithReuseIdentifier:@"product" forIndexPath:indexPath];
            cell.contentView.layer.borderWidth = 1.0f;
            cell.contentView.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
            collectionCell = cell;
        }
    }
    return collectionCell;
}

-(void)socialTap:(UITapGestureRecognizer *)tapGesture {
    NSInteger row = tapGesture.view.tag;
    NSLog(@"social tap working for row:%d",row);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did select social link");

    if(collectionView == self.socialLinkCollectionView) {
        
        NSManagedObject *socialLink = [self.socialLinksArray objectAtIndex:indexPath.row];
        NSString *titleStr = [NSString stringWithFormat:@"%@ in %@",self.authorNameStr,[socialLink valueForKey:@"mediatype"]];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"socialLinkSelected" object:nil userInfo:@{@"name":titleStr,@"link":[socialLink valueForKey:@"url"]}];
    }
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    
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
    self.webViewHeightConstraint.constant = webView.frame.size.height;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.webViewHeightConstraint.constant+1500);
    self.starRating = [[AMRatingControl alloc]initWithLocation:CGPointMake(0, 0) emptyColor:[UIColor colorWithRed:161/255.0 green:16/255.0 blue:27/255.0 alpha:1.0] solidColor:[UIColor colorWithRed:161/255.0 green:16/255.0 blue:27/255.0 alpha:1.0] andMaxRating:5];
    self.starRating.userInteractionEnabled = NO;
    [self.ratingControl addSubview:self.starRating];
}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//    CGFloat y = -scrollView.contentOffset.y;
//    NSLog(@"scroll y value:%f",y);
//    if (y > 64) {
//        self.articleImageView.frame = CGRectMake(0, scrollView.contentOffset.y, self.cachedImageViewSize.size.width+y, self.cachedImageViewSize.size.height+y);
//        self.articleImageView.center = CGPointMake(self.center.x, self.articleImageView.center.y);
//    }
//    
//}


- (IBAction)researchRequestButtonClick:(UIButton *)sender {
    ResearchRequestPopoverView *popOverView = [[ResearchRequestPopoverView alloc]initWithNibName:@"ResearchRequestPopoverView" bundle:nil];
    popOverView.articleId = [self.curatedNewsDetail valueForKey:@"articleId"];
    popOverView.articleTitle = [self.curatedNewsDetail valueForKey:@"articleHeading"];
    popOverView.articleUrl = [self.curatedNewsDetail valueForKey:@"articleUrl"];
    self.popOver =[[UIPopoverController alloc] initWithContentViewController:popOverView];
    self.popOver.popoverContentSize=CGSizeMake(400, 260);
    //self.popOver.delegate = self;
    [self.popOver presentPopoverFromRect:sender.frame inView:self.bottomView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}


- (IBAction)saveButtonClick:(UIButton *)sender {
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
    [resultDic setObject:[self.curatedNewsDetail valueForKey:@"articleId"] forKey:@"selectedArticleId"];
    [resultDic setObject:@"3" forKey:@"status"];
    
    
    
    if(sender.selected) {
        [sender setSelected:NO];
        [resultDic setObject:@"false" forKey:@"isSelected"];
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
        
        [self.curatedNewsDetail setValue:[NSNumber numberWithBool:NO] forKey:@"saveForLater"];
        
        [[FISharedResources sharedResourceManager]setUserActivitiesOnArticlesWithDetails:resultStr];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"saveForLaterUpdate" object:nil userInfo:@{@"indexPath":self.selectedIndexPath,@"status":[NSNumber numberWithBool:NO]}];
        [self.contentView makeToast:@"Removed from Saved List!" duration:1.5 position:CSToastPositionCenter];
    }else {
        [sender setSelected:YES];
        [resultDic setObject:@"true" forKey:@"isSelected"];
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
        
        [self.curatedNewsDetail setValue:[NSNumber numberWithBool:YES] forKey:@"saveForLater"];
        
        NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
        [[FISharedResources sharedResourceManager]setUserActivitiesOnArticlesWithDetails:resultStr];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"saveForLaterUpdate" object:nil userInfo:@{@"indexPath":self.selectedIndexPath,@"status":[NSNumber numberWithBool:YES]}];
        [self.contentView makeToast:@"Saved Successfully!" duration:1.5 position:CSToastPositionCenter];
    }
}


- (IBAction)mailButtonClick:(UIButton *)sender {
    NSString *mailBodyStr = [NSString stringWithFormat:@"%@\n\n%@",self.articleDesc,[self.curatedNewsDetail valueForKey:@"articleUrl"]];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"mailButtonClick" object:nil userInfo:@{@"title":[self.curatedNewsDetail valueForKey:@"articleHeading"],@"body":mailBodyStr}];

}

- (IBAction)commentsButtonClick:(UIButton *)sender {
    
    NSMutableDictionary *commentsDic = [[NSMutableDictionary alloc] init];
    [commentsDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
    [commentsDic setObject:[self.curatedNewsDetail valueForKey:@"articleId"] forKey:@"articleId"];
    [commentsDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"] forKey:@"userId"];
    [commentsDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"customerId"] forKey:@"customerId"];
    [commentsDic setObject:@"1" forKey:@"version"];
    NSData *commentsJsondata = [NSJSONSerialization dataWithJSONObject:commentsDic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *commentsResultStr = [[NSString alloc]initWithData:commentsJsondata encoding:NSUTF8StringEncoding];
    
    
    
    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@",[self.curatedNewsDetail valueForKey:@"articleId"]];
    [fetchRequest setPredicate:predicate];
    NSArray *filterArray =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if(filterArray.count != 0) {
        NSManagedObject *curatedNews = [filterArray objectAtIndex:0];
        NSLog(@"comments:%@",[curatedNews valueForKey:@"comments"]);
        NSManagedObject *userComments = [curatedNews valueForKey:@"comments"];
        if(userComments == nil) {
            [[FISharedResources sharedResourceManager]getCommentsWithDetails:commentsResultStr withArticleId:[self.curatedNewsDetail valueForKey:@"articleId"]];
        }
    }

    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Comments" bundle:nil];
    CommentsPopoverView *popOverView = [storyBoard instantiateViewControllerWithIdentifier:@"CommentsPopoverView"];
    popOverView.articleId = [self.curatedNewsDetail valueForKey:@"articleId"];
    self.popOver =[[UIPopoverController alloc] initWithContentViewController:popOverView];
    self.popOver.popoverContentSize=CGSizeMake(400, 300);
    //self.popOver.delegate = self;
    [self.popOver presentPopoverFromRect:sender.frame inView:self.bottomView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}


- (IBAction)markedImpButtonClick:(UIButton *)sender {
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
    [resultDic setObject:[self.curatedNewsDetail valueForKey:@"articleId"] forKey:@"selectedArticleId"];
    [resultDic setObject:@"2" forKey:@"status"];
    
    
    
    if(sender.selected) {
        [sender setSelected:NO];
        [resultDic setObject:@"false" forKey:@"isSelected"];
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
        
        [self.curatedNewsDetail setValue:[NSNumber numberWithBool:NO] forKey:@"markAsImportant"];
        
        [[FISharedResources sharedResourceManager]setUserActivitiesOnArticlesWithDetails:resultStr];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"markedImportantUpdate" object:nil userInfo:@{@"indexPath":self.selectedIndexPath,@"status":[NSNumber numberWithBool:NO]}];
        [self.contentView makeToast:@"Unchecked from Important List!" duration:1.5 position:CSToastPositionCenter];
    }else {
        [sender setSelected:YES];
        [resultDic setObject:@"true" forKey:@"isSelected"];
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
        
        [self.curatedNewsDetail setValue:[NSNumber numberWithBool:YES] forKey:@"markAsImportant"];
        
        NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
        [[FISharedResources sharedResourceManager]setUserActivitiesOnArticlesWithDetails:resultStr];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"markedImportantUpdate" object:nil userInfo:@{@"indexPath":self.selectedIndexPath,@"status":[NSNumber numberWithBool:YES]}];
        [self.contentView makeToast:@"Marked Important!" duration:1.5 position:CSToastPositionCenter];
    }
    
}

- (IBAction)globeButtonClick:(UIButton *)sender {
    NSLog(@"globe button click");
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"globeButtonClick" object:nil userInfo:@{@"url":[self.curatedNewsDetail valueForKey:@"articleUrl"]}];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat y = -scrollView.contentOffset.y;
    //NSLog(@"scroll y value:%f",y);
    if (y > 0) {
        self.articleImageView.frame = CGRectMake(0, scrollView.contentOffset.y, self.cachedImageViewSize.size.width+y, self.cachedImageViewSize.size.height+y);
        self.articleImageView.center = CGPointMake(self.contentView.center.x, self.articleImageView.center.y);
    }
    
}

@end
