//
//  CorporateNewsCell.h
//  FullIntel
//
//  Created by Arul on 3/18/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CorporateNewsCell : UITableViewCell
{
    NSArray *sizeArray;
}
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITextView *descTextView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *outletImageWidthConstraint;
@property (strong, nonatomic) IBOutlet UIImageView *outletIcon;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *outletHorizontalConstraint;
@property (weak, nonatomic) IBOutlet UILabel *articleDate;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *personalityHorizontalConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *selectionmageView;
@property (weak, nonatomic) IBOutlet UILabel *outlet;
@property (weak, nonatomic) IBOutlet UIImageView *articleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;
@property (weak, nonatomic) IBOutlet UIView *bookmarkView;
@property (weak, nonatomic) IBOutlet UICollectionView *legendCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *savedForLaterButton;
@property (weak, nonatomic) IBOutlet UIButton *checkMarkButton;
@property (weak, nonatomic) IBOutlet UIView *markedImpView;
@property (weak, nonatomic) IBOutlet UILabel *authorTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *outletWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *markedImpButton;
@property (weak, nonatomic) IBOutlet UILabel *articleNumber;
@property (strong, nonatomic) IBOutlet UIImageView *readStatusImageView;
@property (nonatomic,strong) NSMutableArray *legendsArray;
@property (strong, nonatomic) IBOutlet UIView *lastViewInTabl;
@property (weak, nonatomic) IBOutlet UILabel *messageCountText;
@property (weak, nonatomic) IBOutlet UIImageView *messageIcon;
@property (strong, nonatomic) IBOutlet UIView *messageView;

@property (strong, nonatomic) IBOutlet UIImageView *iconForAuthor;

@end
