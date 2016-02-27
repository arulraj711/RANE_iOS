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

@interface ChartViewController : UIViewController<ChartViewDelegate>{
    NSArray *monthArray;
    NSArray *ValueArray;
    int typeOfChart;
    CGFloat widthOfChartViewOutline;
    CGFloat heightOfChartViewOutline;

}

@property (strong, nonatomic) IBOutlet UIView *chartViewOutline;



@end

