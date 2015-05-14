//
//  InfluencerDetailsView.h
//  FullIntel
//
//  Created by Arul on 3/30/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfluencerDetailsView : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *articleImageView;
@property (nonatomic,strong) NSMutableArray *legendsArray;
- (IBAction)mailButtonClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *legendsCollectionView;
- (IBAction)commentsButtonClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *widgetCollectionView;
- (IBAction)moreButtonClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIWebView *articleWebview;
- (IBAction)researchRequestButtonClick:(UIButton *)sender;
- (IBAction)savedListButtonClick:(UIButton *)sender;
- (IBAction)markedImpButtonClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twitterLabelTopConstraint;
- (IBAction)saveButtonClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *articleTitle;
@property (nonatomic,strong) UIPopoverController *popOver;
@property (nonatomic,strong) NSString *selectedId;
@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UILabel *outletName;
@property (weak, nonatomic) IBOutlet UILabel *articleDate;
@end
