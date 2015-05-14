//
//  MarkedImportantCell.h
//  FullIntel
//
//  Created by Arul on 4/9/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarkedImportantCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITextView *descTextView;
@property (weak, nonatomic) IBOutlet UILabel *articleDate;
@property (weak, nonatomic) IBOutlet UIImageView *selectionmageView;
@property (weak, nonatomic) IBOutlet UILabel *outlet;
@property (weak, nonatomic) IBOutlet UIImageView *articleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;
@property (weak, nonatomic) IBOutlet UIView *bookmarkView;
@property (weak, nonatomic) IBOutlet UICollectionView *legendCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UIButton *savedForLaterButton;
@property (weak, nonatomic) IBOutlet UIButton *checkMarkButton;
@property (weak, nonatomic) IBOutlet UIView *markedImpView;
@property (weak, nonatomic) IBOutlet UILabel *authorTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *outletWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *markedImpButton;
@property (weak, nonatomic) IBOutlet UILabel *articleNumber;
@property (nonatomic,strong) NSMutableArray *legendsArray;
@end