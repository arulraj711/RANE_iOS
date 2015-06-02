//
//  StockViewController.h
//  FullIntel
//
//  Created by cape start on 27/05/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StockViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *stockCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *topStoriesTableView;

@property (nonatomic,strong) NSMutableArray *stockWatchList;
@property (nonatomic) int currentIndex;
@property (nonatomic,strong) NSMutableArray *topStoriesList;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;

@property (weak, nonatomic) IBOutlet UIButton *requestUpgradeButton;

- (IBAction)requestUpgradeButtonPressed:(id)sender;

@end
