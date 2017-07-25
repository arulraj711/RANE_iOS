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
//#import "AMPopTip.h"
#import "CMPopTipView.h"
#import "UCZProgressView.h"
#import "MKNumberBadgeView.h"
#import "FPPopoverController.h"
#import "CommentsPopoverView.h"
#import "FPPopoverController.h"
@interface CorporateDetailCell : UICollectionViewCell<CMPopTipViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,FPPopoverControllerDelegate,CommentsDelegate> {
    NSMutableArray *tweetArray;
    UCZProgressView *progressView;
    // UICollectionView *tweetsLocalCollectionView;
    NSMutableArray *tweetIds,*followersArray,*tweetScreenNameArray;
    CGRect positionOfCollectionViewInScrollView;
    CGRect positionOfInfluencerTweetLblInScrollView;
    UIView *lbl;
    UIView *noTweetView;
    NSTimer *popAnimationTimerTwo,*popAnimationTimer;
    FPPopoverController *popover;
    CGFloat initialPositions;

}
@property (weak, nonatomic) IBOutlet UIImageView *topAuthorImageView;
@property UICollectionView *tweetsLocalCollectionView;
@property UICollectionView *socialcollectionView;
@property UILabel *bioInfoLabel;
@property BOOL isTwitterLoad;
@property BOOL isTwitterAPICalled;
@property BOOL isFIViewSelected;
@property UIActivityIndicatorView *activityIndicator;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) IBOutlet UILabel *articleTitle;
@property (nonatomic,strong) IBOutlet UIImageView *articleImageView;
@property (nonatomic,strong) IBOutlet UIImageView *overlayArticleImageView;
@property (nonatomic,strong) IBOutlet UILabel *overlayArticleTitle;
@property (nonatomic,strong) IBOutlet UILabel *articleDate;
@property (nonatomic,strong) IBOutlet UILabel *articleOutlet;
@property (nonatomic,strong) IBOutlet UILabel *articleAuthor;
@property (nonatomic,strong) IBOutlet UILabel *overlayArticleDate;
@property (nonatomic,strong) IBOutlet UILabel *overlayArticleOutlet;
@property (nonatomic,strong) IBOutlet UILabel *overlayArticleAuthor;
@property (nonatomic,strong) IBOutlet UITextView *overlayArticleDesc;
@property (nonatomic,strong) IBOutlet UIImageView *authorImageView;
@property (nonatomic,strong) IBOutlet UILabel *authorName;
@property (nonatomic,strong) IBOutlet UILabel *authorWorkTitle;
@property (weak, nonatomic) IBOutlet UIWebView *articleWebview;
@property (weak, nonatomic) IBOutlet UIWebView *detailsWebview;
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
@property (strong, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *outletTextWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic,strong) IBOutlet UIButton *markedImpButton;
@property (weak, nonatomic) IBOutlet UIButton *savedForLaterButton;
@property (weak, nonatomic) IBOutlet UILabel *socialLinkLabel;
@property (weak, nonatomic) IBOutlet UIImageView *socialLinkDivider;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *outletIconHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *outletLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *outletIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationImageTopConstarint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationLabelTopConstraint;
@property (nonatomic,strong) IBOutlet UIImageView *influencerIconImage;


@property (weak, nonatomic) IBOutlet UIImageView *workTitleIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *outletImageTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *outletLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *workTitleIconHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *workTitleLabelHeightConstraint;


@property (weak, nonatomic) IBOutlet UIImageView *locationIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *beatsImageTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *beatsLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationIconHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationLabelHeightConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *beatsIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *beatsIconHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *beatsLabelHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aboutAuthorVerticalConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tweetCollectionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tweetDividerImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tweetLabelHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerImageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gradientImageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *articleWebViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *articleWebViewTrailingConstraint;


@property (weak, nonatomic) IBOutlet UILabel *bioTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bioDivider;

//@property (nonatomic, strong) AMPopTip *popTip;
@property (nonatomic, strong) id currentPopTipViewTarget;
@property (nonatomic, strong)	NSDictionary	*contents;

@property (retain) IBOutlet MKNumberBadgeView* badgeTwo;
@property (nonatomic,strong) NSString *markedImpUserId;
@property (nonatomic,strong) NSString *markedImpUserName;
@property (nonatomic,strong) AMRatingControl *starRating;
@property (nonatomic,strong) NSMutableArray *socialLinksArray;
@property CGRect cachedImageViewSize;
@property NSIndexPath *selectedIndexPath;
@property (nonatomic,strong) NSString *authorNameStr;
@property (nonatomic,strong) UIPopoverController *popOver;
@property NSManagedObject *curatedNewsDetail;
@property (nonatomic,strong) NSString *articleDesc;
@property (nonatomic,strong) NSString *selectedArticleId;
@property (nonatomic,strong) NSString *selectedArticleTitle;
@property (nonatomic,strong) NSString *selectedArticleUrl;
@property (nonatomic,strong) NSString *selectedArticleImageUrl;
@property (nonatomic,strong) NSMutableArray *relatedPostArray;
- (IBAction)researchRequestButtonClick:(UIButton *)sender;
- (IBAction)saveButtonClick:(UIButton *)sender;
- (IBAction)mailButtonClick:(UIButton *)sender;
- (IBAction)commentsButtonClick:(UIButton *)sender;
- (IBAction)markedImpButtonClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *articleTitleHeightConstraint;
- (IBAction)globeButtonClick:(UIButton *)sender;
- (IBAction)savedListButtonClick:(UIButton *)sender;
- (IBAction)moreButtonClick:(UIButton *)sender;
-(void)loadTweetsFromPost;
-(void)loadCuratedNewsDetails;
- (IBAction)infoButtonClick:(UIButton *)sender;
@property (weak,nonatomic) IBOutlet UIButton *commentBtn;
@property (weak,nonatomic) IBOutlet UIButton *folderBtn;
@property (weak,nonatomic) IBOutlet UIButton *messageBtn;
@property (weak,nonatomic) IBOutlet UIButton *requestBtn;
@property (strong, nonatomic) IBOutlet UIImageView *bottomImagevws;
@property (weak,nonatomic) IBOutlet UIButton *moreButton;
@property (strong, nonatomic) IBOutlet UIImageView *gradButtonTops;
@property (strong, nonatomic) IBOutlet UIView *starButtnView;
@property (strong, nonatomic) IBOutlet UIView *bookmarkButtonView;
@property (strong, nonatomic) IBOutlet UIView *messageButtonView;
@property (strong, nonatomic) IBOutlet UIView *folderButtonViews;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *requestIconHorizontalConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentIconHorizontalConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreIconHorizontalConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *savedIconHorizontalConstraint;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *biolabelWidthConstraint;

@property (strong,nonatomic) IBOutlet UILabel *aboutAuthorTitleView;
@property (strong,nonatomic) IBOutlet UIImageView *aboutAuthorLineImage;

@end
