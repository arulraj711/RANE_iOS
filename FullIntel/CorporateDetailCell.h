//
//  CorporateDetailCell.h
//  FullIntel
//
//  Created by Capestart on 5/13/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FISharedResources.h"

@interface CorporateDetailCell : UICollectionViewCell
@property (nonatomic,strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) IBOutlet UILabel *articleTitle;
@property (nonatomic,strong) IBOutlet UIImageView *articleImageView;
@property (nonatomic,strong) IBOutlet UILabel *articleDate;
@property (nonatomic,strong) IBOutlet UILabel *articleOutlet;
@property (nonatomic,strong) IBOutlet UILabel *articleAuthor;
@property (nonatomic,strong) IBOutlet UIImageView *authorImageView;
@property (nonatomic,strong) IBOutlet UILabel *authorName;
@property (nonatomic,strong) IBOutlet UILabel *authorWorkTitle;
@property (weak, nonatomic) IBOutlet UIWebView *articleWebview;
@property (weak, nonatomic) IBOutlet UICollectionView *widgetCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *socialLinkCollectionView;
@property (nonatomic,strong) NSMutableArray *socialLinksArray;
@end
