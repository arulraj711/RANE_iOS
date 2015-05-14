//
//  InfluencersTableViewCell.h
//  FullIntel
//
//  Created by Arul on 2/25/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfluencersTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *articleDate;
@property (weak, nonatomic) IBOutlet UIImageView *selectionmageView;
@property (weak, nonatomic) IBOutlet UILabel *outlet;
@property (weak, nonatomic) IBOutlet UIImageView *articleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *legendCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UILabel *authorTitle;
@property (weak, nonatomic) IBOutlet UILabel *articleNumber;
@property (nonatomic,strong) NSMutableArray *legendsArray;
@end
