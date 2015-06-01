//
//  DealsViewController.m
//  FullIntel
//
//  Created by cape start on 29/05/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "DealsViewController.h"
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
#import "CompanyCell.h"
#import "TimeLineCell.h"
#import "CompetitorCell.h"


#define UIColorFromRGB(rgbValue)[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface DealsViewController ()

@end

@implementation DealsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _requestUpgradeButton.layer.borderColor=[[UIColor blackColor]CGColor];
    _requestUpgradeButton.layer.borderWidth=1.5;
    _requestUpgradeButton.layer.cornerRadius=5.0;
  
    
    NSMutableAttributedString *attriString=[[NSMutableAttributedString alloc]initWithString:@"DEALS provides stock market information and top stories on a list of companies that you are watching"];
    
    [attriString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Bold" size:20] range:NSMakeRange(0,5)];
    
    [attriString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0XA4131E) range:NSMakeRange(0,5)];
    
    _DealsLabel.attributedText=attriString;
    
    
       [_firstCompanyImageView sd_setImageWithURL:[NSURL URLWithString:@"http://archiveteam.org/images/thumb/b/bc/Verizon_Logo.png/800px-Verizon_Logo.png"] placeholderImage:[UIImage imageNamed:@"FI"]];
    
        [_secondCampanyImageView sd_setImageWithURL:[NSURL URLWithString:@"http://img4.wikia.nocookie.net/__cb20130101110037/logopedia/images/0/0c/1000px-AOL_logo.svg.png"] placeholderImage:[UIImage imageNamed:@"FI"]];
    
    
//    NSString *htmlString = [NSString stringWithFormat:@"<body style='color:#666e73;font-family:Open Sans;line-height: 1.7;font-size: 16px;font-weight: 310;'>%@",[curatedNewsDetail valueForKey:@"article"]];
    
    NSString *string=@"The deal aims to create a major new player in the digital media business by combining one of the biggest mobile network providers with a leading content producer.It's part of Verizon's (VZ, Tech30) plan to dominate a future in which all content -- from TV channels to publications -- are streamed over the Internet. By buying AOL, Verizon is getting much more than the 1990s dial-up Internet company that first introduced many Americans to the Web. Today AOL provides online video services, content and ads to 40,000 other publishers. It brings in $600 million in advertising. It has news sites such as The Huffington Post, TechCrunch and Engadget./n The deal aims to create a major new player in the digital media business by combining one of the biggest mobile network providers with a leading content producer.It's part of Verizon's (VZ, Tech30) plan to dominate a future in which all content -- from TV channels to publications -- are streamed over the Internet. By buying AOL, Verizon is getting much more than the 1990s dial-up Internet company that first introduced many Americans to the Web. Today AOL provides online video services, content and ads to 40,000 other publishers. It brings in $600 million in advertising. It has news sites such as The Huffington Post, TechCrunch and Engadget /n The deal aims to create a major new player in the digital media business by combining one of the biggest mobile network providers with a leading content producer.It's part of Verizon's (VZ, Tech30) plan to dominate a future in which all content -- from TV channels to publications -- are streamed over the Internet. By buying AOL, Verizon is getting much more than the 1990s dial-up Internet company that first introduced many Americans to the Web. Today AOL provides online video services, content and ads to 40,000 other publishers. It brings in $600 million in advertising. It has news sites such as The Huffington Post, TechCrunch and Engadget ";
    
    NSString *htmlString = [NSString stringWithFormat:@"<body style='color:#666e73;font-family:Open Sans;line-height: 1.7;font-size: 16px;font-weight: 310;'>%@",string];
    [self.dealsWebView loadHTMLString:htmlString baseURL:nil];
    
    
//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/184003479/fullIntel/testdata/dealsDril.html"]];
//    [_dealsWebView loadRequest:urlRequest];
    
            [_authorImageBigView sd_setImageWithURL:[NSURL URLWithString:@"https://pbs.twimg.com/profile_images/525460441502187520/52FB7IFR_400x400.jpeg"] placeholderImage:[UIImage imageNamed:@"FI"]];
    
            [_authorImageView sd_setImageWithURL:[NSURL URLWithString:@"https://pbs.twimg.com/profile_images/525460441502187520/52FB7IFR_400x400.jpeg"] placeholderImage:[UIImage imageNamed:@"FI"]];
    
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
            [self.widgetCollectionView registerClass:[CompanyCell class]
                          forCellWithReuseIdentifier:@"CompanyCell"];
            [self.widgetCollectionView registerNib:[UINib nibWithNibName:@"CompanyCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"CompanyCell"];
            
            CompanyCell * cell =(CompanyCell*) [cv dequeueReusableCellWithReuseIdentifier:@"CompanyCell" forIndexPath:indexPath];
            cell.contentView.layer.borderWidth = 1.0f;
            cell.contentView.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
            collectionCell = cell;
        } else if(indexPath.row == 0) {
            [self.widgetCollectionView registerClass:[TimeLineCell class]
                          forCellWithReuseIdentifier:@"TimeLineCell"];
            [self.widgetCollectionView registerNib:[UINib nibWithNibName:@"TimeLineCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"TimeLineCell"];
            
            TimeLineCell *cell =(TimeLineCell*) [cv dequeueReusableCellWithReuseIdentifier:@"TimeLineCell" forIndexPath:indexPath];
            cell.contentView.layer.borderWidth = 1.0f;
            cell.contentView.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
            collectionCell = cell;
        } else if(indexPath.row == 1) {
            [self.widgetCollectionView registerClass:[CompetitorCell class]
                          forCellWithReuseIdentifier:@"CompetitorCell"];
            [self.widgetCollectionView registerNib:[UINib nibWithNibName:@"CompetitorCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"CompetitorCell"];
            
            CompetitorCell *cell =(CompetitorCell*) [cv dequeueReusableCellWithReuseIdentifier:@"CompetitorCell" forIndexPath:indexPath];
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
