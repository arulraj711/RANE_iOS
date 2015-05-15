//
//  CorporateDetailCell.h
//  FullIntel
//
//  Created by Capestart on 5/13/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "FISharedResources.h"
#import "AMRatingControl.h"
#import "MZFormSheetController.h"

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
@property (strong, nonatomic) IBOutlet UICollectionView *tweetsCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *aboutAuthorImageView;
@property (weak, nonatomic) IBOutlet UILabel *aboutAuthorName;
@property (weak, nonatomic) IBOutlet UILabel *authorWorkTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorOutletName;
@property (weak, nonatomic) IBOutlet UILabel *authorLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (strong, nonatomic) IBOutlet UIView *ratingControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *outletTextWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic,strong) IBOutlet UIButton *markedImpButton;
@property (weak, nonatomic) IBOutlet UILabel *socialLinkLabel;
@property (weak, nonatomic) IBOutlet UIImageView *socialLinkDivider;

@property (nonatomic,strong) AMRatingControl *starRating;
@property (nonatomic,strong) NSMutableArray *socialLinksArray;
@property CGRect cachedImageViewSize;
@property NSIndexPath *selectedIndexPath;
@property (nonatomic,strong) NSString *authorNameStr;
@property (nonatomic,strong) UIPopoverController *popOver;
@property NSManagedObject *curatedNewsDetail;
@property (nonatomic,strong) NSString *articleDesc;

- (IBAction)researchRequestButtonClick:(UIButton *)sender;
- (IBAction)saveButtonClick:(UIButton *)sender;
- (IBAction)mailButtonClick:(UIButton *)sender;
- (IBAction)commentsButtonClick:(UIButton *)sender;
- (IBAction)markedImpButtonClick:(UIButton *)sender;
- (IBAction)globeButtonClick:(UIButton *)sender;
@end
