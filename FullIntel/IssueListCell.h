//
//  IssueListCell.h
//  FullIntel
//
//  Created by cape start on 24/09/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IssueListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *articleImage;
@property (weak, nonatomic) IBOutlet UILabel *articleTitle;
@property (weak, nonatomic) IBOutlet UILabel *articleData;
@property (weak, nonatomic) IBOutlet UILabel *articleOutlet;
@property (weak, nonatomic) IBOutlet UILabel *articleAuthor;
@property (weak, nonatomic) IBOutlet UITextView *articleDesc;
@end

