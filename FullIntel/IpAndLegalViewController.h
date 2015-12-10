//
//  IpAndLegalViewController.h
//  FullIntel
//
//  Created by cape start on 01/06/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKRevealController.h"

@interface IpAndLegalViewController : UIViewController<UIGestureRecognizerDelegate,PanDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *widgetCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *twitterCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *socialCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *requestUpgradeButton;
- (IBAction)requestUpgradeButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *DealsLabel;


@property (weak, nonatomic) IBOutlet UIWebView *dealsWebView;

@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;

@property (weak, nonatomic) IBOutlet UIImageView *authorImageBigView;


@property (weak, nonatomic) IBOutlet UITextView *sampleDataText;

@property (nonatomic,strong) NSString *titleName;

@property (weak, nonatomic) IBOutlet UIView *rotateView;


@end
