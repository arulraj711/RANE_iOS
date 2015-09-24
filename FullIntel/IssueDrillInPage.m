//
//  IssueDrillInPage.m
//  FullIntel
//
//  Created by cape start on 24/09/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "IssueDrillInPage.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "IssueSocialCell.h"
#import "IssueTweetCell.h"
@interface IssueDrillInPage ()

@end

@implementation IssueDrillInPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated {
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/276740356/FullIntel/CI/drillin.json"]];
    NSError *error;
    NSDictionary *articleDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"article dic:%@",articleDic);
    
    self.articleTitle.text = [articleDic objectForKey:@"title"];
    self.articleDate.text = [articleDic objectForKey:@"date"];
    self.articleOutlet.text = [articleDic objectForKey:@"outlet"];
    self.articleAuthor.text = [articleDic objectForKey:@"authorname"];
    [self.articleImage sd_setImageWithURL:[NSURL URLWithString:[articleDic valueForKey:@"articleImage"]] placeholderImage:[UIImage imageNamed:@"FI"]];
    [self.articleImage setContentMode:UIViewContentModeScaleAspectFill];
   
    NSString *htmlString = [NSString stringWithFormat:@"<body style='color:#666e73;font-family:Open Sans;line-height: 1.7;font-size: 16px;font-weight: 310;'>%@",[articleDic valueForKey:@"desc"]];
    [self.articleWebView loadHTMLString:htmlString baseURL:nil];
    
    [self.authorImage sd_setImageWithURL:[NSURL URLWithString:[articleDic valueForKey:@"authorImage"]] placeholderImage:[UIImage imageNamed:@"FI"]];
    [self.authorImage setContentMode:UIViewContentModeScaleAspectFill];
    self.authorName.text = [articleDic objectForKey:@"authorname"];
    self.outlet.text = [articleDic objectForKey:@"authorOultlet"];
    self.location.text = [articleDic objectForKey:@"authorLocation"];
    self.workTitle.text = [articleDic objectForKey:@"authorTitle"];
    self.bioText.text = [articleDic objectForKey:@"bio"];
    socialLinkArray = [articleDic objectForKey:@"socialMedia"];
    [self.socialLinkCollectionView reloadData];
    tweetArray = [articleDic objectForKey:@"articleRelatedPost"];
    [self.tweetsCollectionView reloadData];
}


- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    // NSLog(@"imp collection view:%d",self.socialLinksArray.count);
    NSInteger itemCount;
  
    if(view == self.socialLinkCollectionView){
        NSLog(@"social collectionview loading");
        itemCount = socialLinkArray.count;
    }else {
        itemCount = 4;
    }
   
    return itemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"collectionview cellfor item method");
    UICollectionViewCell *collectionCell;
    if(cv == self.socialLinkCollectionView) {
        IssueSocialCell *socialCell =(IssueSocialCell*) [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        NSDictionary *socialLink = [socialLinkArray objectAtIndex:indexPath.row];
        if([[socialLink valueForKey:@"mediaType"] isEqualToString:@"Twitter"]) {
            socialCell.iconImage.image = [UIImage imageNamed:@"Twitter-1"];
        } else {
            socialCell.iconImage.image = [UIImage imageNamed:[socialLink valueForKey:@"mediaType"]];
        }
        
//        if([[socialLink valueForKey:@"isactive"]isEqualToNumber:[NSNumber numberWithInt:1]]) {
//            socialCell.blueCircleView.hidden = NO;
//        } else {
//            socialCell.blueCircleView.hidden = YES;
//        }
        socialCell.cellOuterView.layer.borderWidth = 1.0f;
        socialCell.cellOuterView.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
        socialCell.cellOuterView.layer.masksToBounds = YES;
        socialCell.cellOuterView.layer.cornerRadius = 20.0f;
//        socialCell.blueCircleView.layer.masksToBounds = YES;
//        socialCell.blueCircleView.layer.cornerRadius = 5.0f;
        collectionCell = socialCell;
    }else {
        IssueTweetCell *tweetCell =(IssueTweetCell*) [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        NSDictionary *tweetsDic = [tweetArray objectAtIndex:indexPath.row];
        tweetCell.title.text = [tweetsDic objectForKey:@"title"];
        tweetCell.handle.text = [tweetsDic objectForKey:@"handle"];
        tweetCell.tweetDesc.text = [tweetsDic objectForKey:@"desc"];
        tweetCell.retweetCnt.text = [tweetsDic objectForKey:@"retweetCnt"];
        tweetCell.favorateCnt.text = [tweetsDic objectForKey:@"favorateCnt"];
        tweetCell.folowersCnt.text = [tweetsDic objectForKey:@"followersCnt"];
        tweetCell.contentView.layer.borderWidth = 1.0f;
        tweetCell.contentView.layer.borderColor = [[UIColor colorWithRed:237.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1] CGColor];
        collectionCell = tweetCell;
    }
    return collectionCell;
}

@end
