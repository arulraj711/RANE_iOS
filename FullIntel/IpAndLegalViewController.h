//
//  IpAndLegalViewController.h
//  FullIntel
//
//  Created by cape start on 01/06/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IpAndLegalViewController : UIViewController


@property (weak, nonatomic) IBOutlet UICollectionView *widgetCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *twitterCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *socialCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *requestUpgradeButton;
- (IBAction)requestUpgradeButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *DealsLabel;


@property (weak, nonatomic) IBOutlet UIWebView *dealsWebView;
@end
