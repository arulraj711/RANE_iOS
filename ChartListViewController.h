//
//  ChartListViewController.h
//  FullIntel
//
//  Created by cape start on 24/02/16.
//  Copyright © 2016 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartListViewController : UIViewController
{
    NSMutableArray  *reportListArray;
}
@property (weak, nonatomic) IBOutlet UITableView *reportListTableView;
- (IBAction)navigateToChartView:(id)sender;
@end
