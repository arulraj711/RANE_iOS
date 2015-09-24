//
//  CICell.h
//  FullIntel
//
//  Created by cape start on 22/09/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CICell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *articleImage;
@property (weak, nonatomic) IBOutlet UILabel *artileTitle;
@property (weak, nonatomic) IBOutlet UITextView *articleDesc;
@property (weak, nonatomic) IBOutlet UILabel *articlesCount;
@property (weak, nonatomic) IBOutlet UILabel *outletsCount;
@property (weak, nonatomic) IBOutlet UILabel *commentsCount;

@end
