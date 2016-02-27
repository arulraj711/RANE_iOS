//
//  DemoBaseViewController.m
//  ChartsDemo
//
//  Created by Daniel Cohen Gindi on 13/3/15.
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/ios-charts
//

#import "ChartBaseViewController.h"

@interface ChartBaseViewController ()


@end

@implementation ChartBaseViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    months = @[
        @"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep",
        @"Oct", @"Nov", @"Dec"
        ];
    
    parties = @[
        @"Party A", @"Party B", @"Party C", @"Party D", @"Party E", @"Party F",
        @"Party G", @"Party H", @"Party I", @"Party J", @"Party K", @"Party L",
        @"Party M", @"Party N", @"Party O", @"Party P", @"Party Q", @"Party R",
        @"Party S", @"Party T", @"Party U", @"Party V", @"Party W", @"Party X",
        @"Party Y", @"Party Z"
    ];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Stubs for chart view

- (void)setupPieChartView:(PieChartView *)chartView
{
    chartView.usePercentValuesEnabled = YES;
    chartView.holeTransparent = YES;
    chartView.holeRadiusPercent = 0.58;
    chartView.transparentCircleRadiusPercent = 0.61;
    chartView.descriptionText = @"";
    [chartView setExtraOffsetsWithLeft:5.f top:10.f right:5.f bottom:5.f];
    
    chartView.drawCenterTextEnabled = YES;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:@"PieChart Demo for FullIntel"];
    [centerText setAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f],
                                NSParagraphStyleAttributeName: paragraphStyle
                                } range:NSMakeRange(0, centerText.length)];
    [centerText addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:10.f],
                                NSForegroundColorAttributeName: UIColor.grayColor
                                } range:NSMakeRange(10, centerText.length - 10)];
    [centerText addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:10.f],
                                NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]
                                } range:NSMakeRange(centerText.length - 19, 19)];
    chartView.centerAttributedText = centerText;
    
    chartView.drawHoleEnabled = YES;
    chartView.rotationAngle = 0.0;
    chartView.rotationEnabled = YES;
    chartView.highlightPerTapEnabled = YES;
    
    ChartLegend *l = chartView.legend;
    l.position = ChartLegendPositionRightOfChart;
    l.xEntrySpace = 7.0;
    l.yEntrySpace = 0.0;
    l.yOffset = 0.0;
}

- (void)setupRadarChartView:(RadarChartView *)chartView
{
    chartView.descriptionText = @"";
    chartView.noDataTextDescription = @"You need to provide data for the chart.";
}

- (void)setupBarLineChartView:(BarLineChartViewBase *)chartView
{
    chartView.descriptionText = @"";
    chartView.noDataTextDescription = @"You need to provide data for the chart.";
    
    chartView.drawGridBackgroundEnabled = NO;
    
    chartView.dragEnabled = YES;
    [chartView setScaleEnabled:YES];
    chartView.pinchZoomEnabled = NO;
    
    // ChartYAxis *leftAxis = chartView.leftAxis;
    
    ChartXAxis *xAxis = chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    
    chartView.rightAxis.enabled = NO;
}

@end
