//
//  MarkedImportantDetailsView.h
//  FullIntel
//
//  Created by Arul on 4/9/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FISharedResources.h"
@interface MarkedImportantDetailsView : UIViewController {
    NSManagedObject *curatedNewsDetail;
}
@property (weak, nonatomic) IBOutlet UIImageView *articleImageView;
@property (nonatomic,strong) NSMutableArray *legendsArray;
- (IBAction)mailButtonClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *legendsCollectionView;
- (IBAction)commentsButtonClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *widgetCollectionView;
- (IBAction)moreButtonClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIWebView *articleWebview;
@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UILabel *outletName;
- (IBAction)researchRequestButtonClick:(UIButton *)sender;
- (IBAction)savedListButtonClick:(UIButton *)sender;
- (IBAction)markedImpButtonClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *articleDate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;
@property (weak, nonatomic) IBOutlet UILabel *bottomAuthorName;
@property (weak, nonatomic) IBOutlet UILabel *authorTitle;
@property (nonatomic,strong) NSString *titleStr;
@property (nonatomic,strong) NSString *imageStr;
@property (nonatomic,strong) NSString *authorNameStr;
@property (nonatomic,strong) NSString *outletStr;
@property (nonatomic,strong) NSString *authorTitleStr;
@property (nonatomic,strong) NSString *authorImageStr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twitterLabelTopConstraint;
- (IBAction)saveButtonClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *articleTitle;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *gradiantImage;
@property (nonatomic,strong) UIPopoverController *popOver;
@property (nonatomic,strong) NSString *selectedId;
@property (nonatomic,strong) NSManagedObject *author;
@property (nonatomic,strong) IBOutlet UIButton *markedImpButton;
@end
