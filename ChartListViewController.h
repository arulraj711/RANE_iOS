//
//  ChartListViewController.h
//  FullIntel
//
//  Created by cape start on 24/02/16.
//  Copyright © 2016 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FIUtils.h"
@interface ChartListViewController : UIViewController
{
    NSMutableArray  *reportListArray;
    UIActivityIndicatorView *activityIndicator;
}
@property (weak, nonatomic) IBOutlet UITableView *reportListTableView;
- (IBAction)navigateToChartView:(id)sender;

@property (nonatomic,strong) IBOutlet UICollectionView *reportCollectionView;
@end
