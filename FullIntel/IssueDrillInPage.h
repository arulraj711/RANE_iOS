//
//  IssueDrillInPage.h
//  FullIntel
//
//  Created by cape start on 24/09/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IssueDrillInPage : UIViewController {
    NSArray *socialLinkArray,*tweetArray;
}
@property (weak, nonatomic) IBOutlet UIImageView *articleImage;
@property (weak, nonatomic) IBOutlet UILabel *articleTitle;
@property (weak, nonatomic) IBOutlet UILabel *articleDate;
@property (weak, nonatomic) IBOutlet UILabel *articleOutlet;
@property (weak, nonatomic) IBOutlet UILabel *articleAuthor;
@property (weak, nonatomic) IBOutlet UIWebView *articleWebView;
@property (weak, nonatomic) IBOutlet UIImageView *authorImage;
@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UILabel *workTitle;
@property (weak, nonatomic) IBOutlet UILabel *outlet;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UICollectionView *socialLinkCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *tweetsCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *bioText;

@end
