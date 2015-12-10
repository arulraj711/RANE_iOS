//
//  IssueTweetCell.h
//  FullIntel
//
//  Created by cape start on 24/09/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IssueTweetCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *handle;
@property (weak, nonatomic) IBOutlet UITextView *tweetDesc;
@property (weak, nonatomic) IBOutlet UILabel *retweetCnt;
@property (weak, nonatomic) IBOutlet UILabel *favorateCnt;
@property (weak, nonatomic) IBOutlet UILabel *folowersCnt;

@end
