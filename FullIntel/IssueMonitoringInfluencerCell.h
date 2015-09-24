//
//  IssueMonitoringInfluencerCell.h
//  FullIntel
//
//  Created by cape start on 24/09/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IssueMonitoringInfluencerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *articleAuthorImage;
@property (weak, nonatomic) IBOutlet UILabel *articleTitle;
@property (weak, nonatomic) IBOutlet UILabel *articleDate;
@property (weak, nonatomic) IBOutlet UITextView *articleDesc;
@property (weak, nonatomic) IBOutlet UILabel *articleAuthor;
@property (weak, nonatomic) IBOutlet UILabel *articleAuthorTitle;

@property (weak, nonatomic) IBOutlet UILabel *articleOutlet;
@end
