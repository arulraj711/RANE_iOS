//
//  ExecutiveMovesController.m
//  FullIntel
//
//  Created by Capestart on 6/1/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "ExecutiveMovesController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PersonalityWidgetCell.h"
#import "StockWidgetCell.h"
#import "ProductWidgetCell.h"
#import "SocialLinkCell.h"
#import "TweetsCell.h"
#import "CompanyCell.h"
#import "TimeLineCell.h"
#import "CompetitorCell.h"
#import "PKRevealController.h"
#import "ExecutiveMoveCell.h"
#import "ExecutiveTimeLineCell.h"
#import "FIUtils.h"
#import "PersonalityExecutiveCell.h"
#import "FISharedResources.h"

#define UIColorFromRGB(rgbValue)[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface ExecutiveMovesController ()

@end

@implementation ExecutiveMovesController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _requestUpgradeButton.layer.borderColor=[[UIColor blackColor]CGColor];
    _requestUpgradeButton.layer.borderWidth=1.5;
    _requestUpgradeButton.layer.cornerRadius=5.0;
    
    UIButton *Btn =[UIButton buttonWithType:UIButtonTypeCustom];
    
    [Btn setFrame:CGRectMake(0.0f,0.0f,16.0f,15.0f)];
    [Btn setBackgroundImage:[UIImage imageNamed:@"navmenu"]  forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(backBtnPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    [self.navigationItem setLeftBarButtonItem:addButton];
    
    
    NSMutableAttributedString *attriString=[[NSMutableAttributedString alloc]initWithString:@"EXECUTIVE MOVES provides insight on key personnel changes in the industry that are relevant to you."];
    
    [attriString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Bold" size:20] range:NSMakeRange(0,15)];
    
    [attriString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0XA4131E) range:NSMakeRange(0,15)];
    
    _DealsLabel.attributedText=attriString;
    
    
    [_firstCompanyImageView sd_setImageWithURL:[NSURL URLWithString:@"http://archiveteam.org/images/thumb/b/bc/Verizon_Logo.png/800px-Verizon_Logo.png"] placeholderImage:[UIImage imageNamed:@"FI"]];
    
    [_secondCampanyImageView sd_setImageWithURL:[NSURL URLWithString:@"http://img4.wikia.nocookie.net/__cb20130101110037/logopedia/images/0/0c/1000px-AOL_logo.svg.png"] placeholderImage:[UIImage imageNamed:@"FI"]];
    
    
    //    NSString *htmlString = [NSString stringWithFormat:@"<body style='color:#666e73;font-family:Open Sans;line-height: 1.7;font-size: 16px;font-weight: 310;'>%@",[curatedNewsDetail valueForKey:@"article"]];
    
//    NSString *string=@"The deal aims to create a major new player in the digital media business by combining one of the biggest mobile network providers with a leading content producer.It's part of Verizon's (VZ, Tech30) plan to dominate a future in which all content -- from TV channels to publications -- are streamed over the Internet. By buying AOL, Verizon is getting much more than the 1990s dial-up Internet company that first introduced many Americans to the Web. Today AOL provides online video services, content and ads to 40,000 other publishers. It brings in $600 million in advertising. It has news sites such as The Huffington Post, TechCrunch and Engadget./n The deal aims to create a major new player in the digital media business by combining one of the biggest mobile network providers with a leading content producer.It's part of Verizon's (VZ, Tech30) plan to dominate a future in which all content -- from TV channels to publications -- are streamed over the Internet. By buying AOL, Verizon is getting much more than the 1990s dial-up Internet company that first introduced many Americans to the Web. Today AOL provides online video services, content and ads to 40,000 other publishers. It brings in $600 million in advertising. It has news sites such as The Huffington Post, TechCrunch and Engadget /n The deal aims to create a major new player in the digital media business by combining one of the biggest mobile network providers with a leading content producer.It's part of Verizon's (VZ, Tech30) plan to dominate a future in which all content -- from TV channels to publications -- are streamed over the Internet. By buying AOL, Verizon is getting much more than the 1990s dial-up Internet company that first introduced many Americans to the Web. Today AOL provides online video services, content and ads to 40,000 other publishers. It brings in $600 million in advertising. It has news sites such as The Huffington Post, TechCrunch and Engadget ";
//    
//    NSString *htmlString = [NSString stringWithFormat:@"<body style='color:#666e73;font-family:Open Sans;line-height: 1.7;font-size: 16px;font-weight: 310;'>%@",string];
//    [self.dealsWebView loadHTMLString:htmlString baseURL:nil];
    
    
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/184003479/fullIntel/testdata/movesDrill.html"]];
        [_dealsWebView loadRequest:urlRequest];
    
    [_authorImageBigView sd_setImageWithURL:[NSURL URLWithString:@"https://pbs.twimg.com/profile_images/525460441502187520/52FB7IFR_400x400.jpeg"] placeholderImage:[UIImage imageNamed:@"FI"]];
    
    [_authorImageView sd_setImageWithURL:[NSURL URLWithString:@"https://pbs.twimg.com/profile_images/525460441502187520/52FB7IFR_400x400.jpeg"] placeholderImage:[UIImage imageNamed:@"FI"]];
    
     [FIUtils makeRoundedView:_authorImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backBtnPress {
    
    
    if(self.revealController.state == PKRevealControllerShowsLeftViewControllerInPresentationMode) {
        NSLog(@"left view opened");
        [self.revealController showViewController:self.revealController.frontViewController];
    } else {
        NSLog(@"left view closed");
        [self.revealController showViewController:self.revealController.leftViewController];
    }
    
}

#pragma mark - UICollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(collectionView == self.widgetCollectionView) {
        if(indexPath.row == 0) {
            return CGSizeMake(400, 320);
        } else if(indexPath.row == 1) {
            return CGSizeMake(400, 230);
        } else if(indexPath.row == 2) {
            return CGSizeMake(400, 800);
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
        itemCount = 1;
    }else if(view == self.twitterCollectionView) {
        itemCount = 1;
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
        
        socialCell.iconImage.image = [UIImage imageNamed:@"Twitter-1"];
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
            [self.widgetCollectionView registerClass:[ExecutiveTimeLineCell class]
                          forCellWithReuseIdentifier:@"ExecutiveTimeLineCell"];
            [self.widgetCollectionView registerNib:[UINib nibWithNibName:@"ExecutiveTimeLineCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"ExecutiveTimeLineCell"];
            
            ExecutiveTimeLineCell *cell =(ExecutiveTimeLineCell*) [cv dequeueReusableCellWithReuseIdentifier:@"ExecutiveTimeLineCell" forIndexPath:indexPath];
            cell.contentView.layer.borderWidth = 1.0f;
            cell.contentView.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
            collectionCell = cell;
        } else if(indexPath.row == 0) {
            [self.widgetCollectionView registerClass:[PersonalityExecutiveCell class]
                          forCellWithReuseIdentifier:@"PersonalityExecutiveCell"];
            [self.widgetCollectionView registerNib:[UINib nibWithNibName:@"PersonalityExecutiveCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"PersonalityExecutiveCell"];
            
            PersonalityExecutiveCell * cell =(PersonalityExecutiveCell*) [cv dequeueReusableCellWithReuseIdentifier:@"PersonalityExecutiveCell" forIndexPath:indexPath];
            
           // cell.pageName=@"Executive";
            cell.contentView.layer.borderWidth = 1.0f;
            cell.contentView.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
            collectionCell = cell;
        } else if(indexPath.row == 1) {
            [self.widgetCollectionView registerClass:[ExecutiveMoveCell class]
                          forCellWithReuseIdentifier:@"ExecutiveMoveCell"];
            [self.widgetCollectionView registerNib:[UINib nibWithNibName:@"ExecutiveMoveCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"ExecutiveMoveCell"];
            
            ExecutiveMoveCell *cell =(ExecutiveMoveCell*) [cv dequeueReusableCellWithReuseIdentifier:@"ExecutiveMoveCell" forIndexPath:indexPath];
            [cell.leftImage sd_setImageWithURL:[NSURL URLWithString:@"http://www.micarmenia.am/Images/partner1.jpg"] placeholderImage:nil];
            [cell.leftImage setContentMode:UIViewContentModeScaleAspectFit];
            [cell.rightImage sd_setImageWithURL:[NSURL URLWithString:@"http://www.adweek.com/socialtimes/wp-content/uploads/sites/2/2013/05/Adobe-Logo-1.jpg"] placeholderImage:nil];
            [cell.rightImage setContentMode:UIViewContentModeScaleAspectFit];
            
            
//            cell.leftImage.layer.masksToBounds = YES;
//            cell.leftImage.layer.cornerRadius = 5.0f;
//            cell.rightImage.layer.masksToBounds = YES;
//            cell.rightImage.layer.cornerRadius = 5.0f;
//            cell.leftImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
//            cell.rightImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
            
            
            cell.contentView.layer.borderWidth = 1.0f;
            cell.contentView.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
            collectionCell = cell;
        }
    }
    return collectionCell;
    
}

- (IBAction)requestUpgradeButtonPressed:(id)sender {
    
    NSMutableDictionary *gradedetails = [[NSMutableDictionary alloc] init];
    [gradedetails setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
    [gradedetails setObject:[NSNumber numberWithInt:5] forKey:@"moduleId"];
    [gradedetails setObject:[NSNumber numberWithInt:12] forKey:@"featureId"];
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:gradedetails options:NSJSONWritingPrettyPrinted error:nil];
    NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
    [[FISharedResources sharedResourceManager]featureAccessRequestWithDetails:resultStr];
}


@end
