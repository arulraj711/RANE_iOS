//
//  DetailViewController.h
//  FullIntel
//
//  Created by Arul on 3/9/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "FISharedResources.h"
#import "AMRatingControl.h"
@interface CorporateNewsDetailsView : UIViewController<MFMailComposeViewControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource> {
    NSManagedObject *curatedNewsDetail;
    NSManagedObject *curatedNewsAuthorDetail;
    MFMailComposeViewController *mailComposer;
    UIView *innerWebView;
    
}
@property CGRect cachedImageViewSize;
@property NSManagedObject *curatedNews;
@property NSIndexPath *selectedIndexPath;
@property (nonatomic,strong) AMRatingControl *starRating;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagLabelTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationLabelTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *outletLabelTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *workTitleLabelTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationTop;
@property (strong, nonatomic) IBOutlet UIImageView *outletIconImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *workTitleTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *outletTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagTop;
@property (nonatomic,strong) NSMutableArray *socialLinksArray;
@property (weak, nonatomic) IBOutlet UIImageView *articleImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *outletIconWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *outletTextWidthConstraint;
@property (nonatomic,strong) NSMutableArray *legendsArray;
- (IBAction)mailButtonClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *legendsCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *socialLinkCollectionView;
- (IBAction)commentsButtonClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *widgetCollectionView;
- (IBAction)moreButtonClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIWebView *articleWebview;
@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UILabel *outletName;
- (IBAction)researchRequestButtonClick:(UIButton *)sender;
- (IBAction)savedListButtonClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *outletHeightConstraint;
- (IBAction)markedImpButtonClick:(UIButton *)sender;
- (IBAction)globeButtonClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *articleDate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *workTitleHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *authorImageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationImageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagImageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *socialLinkDivider;
@property (weak, nonatomic) IBOutlet UILabel *socialLinkLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *outletImageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *outletHorizontalConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *workTitleImageHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *bottomAuthorName;
@property (weak, nonatomic) IBOutlet UIImageView *authorOutletImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorTitle;
@property (weak, nonatomic) IBOutlet UILabel *authorOutletName;
@property (weak, nonatomic) IBOutlet UIImageView *authorWorkTitleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *authorTagImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorLocationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *authorLocationImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorWorkTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorTagLabel;
@property (nonatomic,strong) IBOutlet UIView *outerView;
@property (nonatomic,strong) NSString *titleStr;
@property (nonatomic,strong) NSString *articleDesc;
@property (nonatomic,strong) NSString *imageStr;
@property (nonatomic,strong) NSString *authorNameStr;
@property (nonatomic,strong) NSString *outletStr;
@property (nonatomic,strong) NSString *authorTitleStr;
@property (nonatomic,strong) NSString *authorImageStr;
@property (nonatomic,strong) NSString *dateStr;
@property (weak, nonatomic) IBOutlet UILabel *aboutAuthorName;
@property (weak, nonatomic) IBOutlet UIImageView *aboutAuthorImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollInViewVerticalSpace;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twitterLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollInViewHeight;
@property (strong, nonatomic) IBOutlet UIView *ratingControl;
- (IBAction)saveButtonClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *articleTitle;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *gradiantImage;
@property (nonatomic,strong) UIPopoverController *popOver;
@property (nonatomic,strong) NSString *selectedId;
@property (nonatomic,strong) NSManagedObject *author;
@property (nonatomic,strong) IBOutlet UIButton *markedImpButton;
@property (nonatomic,strong) IBOutlet UIImageView *influencerIconImage;
@end
