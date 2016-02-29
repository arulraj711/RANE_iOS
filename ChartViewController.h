//
//  ChartViewController.h
//  FullIntel
//
//  Created by cape start on 24/02/16.
//  Copyright © 2016 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FullIntel-Bridging-Header.h"
#import "ChartBaseViewController.h"
#import "ChartIconCell.h"
@interface ChartViewController : UIViewController<ChartViewDelegate>{
    NSArray *monthArray;
    NSArray *ValueArray;
    int typeOfChart;
    CGFloat widthOfChartViewOutline;
    CGFloat heightOfChartViewOutline;
    
    NSMutableArray *chartIcon;
    NSMutableArray *chartName;

    
    PieChartView *pieViews;
    BarChartView *barViews;
    LineChartView *lineChartView;
}

@property (strong, nonatomic) IBOutlet UIView *chartViewOutline;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;


- (IBAction)saveChartButton:(id)sender;

@end

