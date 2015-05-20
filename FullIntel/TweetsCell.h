//
//  TweetsCell.h
//  FullIntel
//
//  Created by Capestart on 5/15/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetsCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *auhtor2;
@property (weak, nonatomic) IBOutlet UITextView *twitterText;
@property (weak, nonatomic) IBOutlet UILabel *retweet;
@property (weak, nonatomic) IBOutlet UILabel *favourate;
@property (weak, nonatomic) IBOutlet UILabel *followers;

@end
