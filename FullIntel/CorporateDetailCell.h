//
//  CorporateDetailCell.h
//  FullIntel
//
//  Created by Capestart on 5/13/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CorporateDetailCell : UICollectionViewCell
@property (nonatomic,strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) IBOutlet UILabel *articleTitle;
@property (nonatomic,strong) IBOutlet UIImageView *articleImageView;
@end
