//
//  IpAndLegalViewController.m
//  FullIntel
//
//  Created by cape start on 01/06/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "IpAndLegalViewController.h"

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
#import <SDWebImage/UIImageView+WebCache.h>
#import <TwitterKit/TwitterKit.h>
#import "FIUtils.h"
#import "SavedListPopoverView.h"
#import "MorePopoverView.h"
#import "IpAndLegalCell.h"
#import "NumberOfPatternsCell.h"
#import "RecentPaternsCell.h"
@interface IpAndLegalViewController ()

@end

@implementation IpAndLegalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UICollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(collectionView == self.widgetCollectionView) {
        if(indexPath.row == 0) {
            return CGSizeMake(320, 560);
        } else if(indexPath.row == 1) {
            return CGSizeMake(320, 260);
        } else if(indexPath.row == 2) {
            return CGSizeMake(320, 260);
        }
        
    }
    else if(collectionView == self.socialCollectionView) {
        return CGSizeMake(50, 50);
    } else if(collectionView == self.twitterCollectionView) {
        return CGSizeMake(320, 300);
    }
    return CGSizeMake(30, 30);
}


- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    NSInteger itemCount;
    
    if(view == self.socialCollectionView){
        itemCount = 4;
    }else if(view == self.twitterCollectionView) {
        itemCount = 3;
    }else {
        itemCount = 3;
    }
    return itemCount;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *collectionCell;
    
    if(cv == self.socialCollectionView) {
        // NSLog(@"inside social link collectionview cellfor item");
        //        NSManagedObject *socialLink = [self.socialLinksArray objectAtIndex:indexPath.row];
        //
        SocialLinkCell *socialCell =(SocialLinkCell*) [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
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
        
        
        //        UITapGestureRecognizer *socialCellTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(socialTap:)];
        //        socialCell.tag = indexPath.row;
        //        socialCell.iconImage.userInteractionEnabled = YES;
        //        [socialCell.iconImage addGestureRecognizer:socialCellTap];
        
        socialCell.blueCircleView.hidden = YES;
        collectionCell = socialCell;
        
    } else if(cv == self.twitterCollectionView) {
        TweetsCell *tweetCell =(TweetsCell*) [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        //        TWTRTweet *tweetObj = [tweetArray objectAtIndex:indexPath.row];
        //        TWTRUser *author = tweetObj.author;
        //        NSLog(@"twitter authro:%@",author.name);
        //        NSLog(@"twitter text:%@",tweetObj.text);
        //        NSLog(@"twitter retweet cnt:%lld",tweetObj.retweetCount);
        //        NSLog(@"twitter favourate cnt:%lld",tweetObj.favoriteCount);
        //        tweetCell.author.text = author.name;
        //        tweetCell.auhtor2.text = [NSString stringWithFormat:@"@%@",author.name];
        //        tweetCell.twitterText.text = tweetObj.text;
        //        tweetCell.retweet.text = [NSString stringWithFormat:@"%lld",tweetObj.retweetCount];
        //        tweetCell.favourate.text = [NSString stringWithFormat:@"%lld",tweetObj.favoriteCount];
        tweetCell.contentView.layer.borderWidth = 1.0f;
        tweetCell.contentView.layer.borderColor = [[UIColor colorWithRed:237.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1] CGColor];
        collectionCell = tweetCell;
    }else {
        if(indexPath.row == 2) {
            [self.widgetCollectionView registerClass:[NumberOfPatternsCell class]
                          forCellWithReuseIdentifier:@"NumberOfPatternsCell"];
            [self.widgetCollectionView registerNib:[UINib nibWithNibName:@"NumberOfPatternsCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"NumberOfPatternsCell"];
            
            NumberOfPatternsCell * cell =(NumberOfPatternsCell*) [cv dequeueReusableCellWithReuseIdentifier:@"NumberOfPatternsCell" forIndexPath:indexPath];
            cell.contentView.layer.borderWidth = 1.0f;
            cell.contentView.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
            collectionCell = cell;
        } else if(indexPath.row == 0) {
            [self.widgetCollectionView registerClass:[IpAndLegalCell class]
                          forCellWithReuseIdentifier:@"IpAndLegalCell"];
            [self.widgetCollectionView registerNib:[UINib nibWithNibName:@"IpAndLegalCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"IpAndLegalCell"];
            
            IpAndLegalCell *cell =(IpAndLegalCell*) [cv dequeueReusableCellWithReuseIdentifier:@"IpAndLegalCell" forIndexPath:indexPath];
            cell.contentView.layer.borderWidth = 1.0f;
            cell.contentView.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
            collectionCell = cell;
        } else if(indexPath.row == 1) {
            [self.widgetCollectionView registerClass:[RecentPaternsCell class]
                          forCellWithReuseIdentifier:@"RecentPaternsCell"];
            [self.widgetCollectionView registerNib:[UINib nibWithNibName:@"RecentPaternsCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"RecentPaternsCell"];
            
            RecentPaternsCell *cell =(RecentPaternsCell*) [cv dequeueReusableCellWithReuseIdentifier:@"RecentPaternsCell" forIndexPath:indexPath];
            cell.contentView.layer.borderWidth = 1.0f;
            cell.contentView.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
            collectionCell = cell;
        }
    }
    return collectionCell;
    
}
- (IBAction)requestUpgradeButtonPressed:(id)sender {
    
    
}
@end
