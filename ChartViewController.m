//
//  ChartViewController.m
//  FullIntel
//
//  Created by cape start on 24/02/16.
//  Copyright © 2016 CapeStart. All rights reserved.
//

#import "ChartViewController.h"
#import "ZRScrollableTabBar.h"
#import "ChartBaseViewController.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
@interface ChartViewController ()

@end

@implementation ChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    typeOfChart = 0;
    monthArray = [NSArray arrayWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun", nil];
    ValueArray = [NSArray arrayWithObjects:@"12",@"13",@"14",@"15",@"16",@"17", nil];
    widthOfChartViewOutline = self.chartViewOutline.frame.size.width;
    heightOfChartViewOutline = self.chartViewOutline.frame.size.height;

    // to add scrollable tab bar
    [self initScrollableTabbar];

    // Do any additional setup after loading the view.
}

- (void)plotPieChart:(int)count range:(double)range
{
    [_chartViewOutline.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];

    NSLog(@"%f,%f",widthOfChartViewOutline,heightOfChartViewOutline);
    PieChartView *pieViews = [[PieChartView alloc] initWithFrame:CGRectMake(0, 0, self.chartViewOutline.frame.size.width-10, self.chartViewOutline.frame.size.height-10)];
    pieViews.backgroundColor = [UIColor whiteColor];
    [_chartViewOutline addSubview:pieViews];
    [pieViews animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];

    pieViews.delegate = self;
    pieViews.descriptionText = @"Pie-Chart";
    pieViews.descriptionTextColor = [UIColor blackColor];
    pieViews.noDataText = @"Provide some data";

    double mult = range;
    
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    
    // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
    for (int i = 0; i < count; i++)
    {
        [yVals1 addObject:[[BarChartDataEntry alloc] initWithValue:(arc4random_uniform(mult) + mult / 5) xIndex:i]];
    }
    
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        [xVals addObject:monthArray[i % monthArray.count]];
    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithYVals:yVals1 label:@"Election Results"];
    dataSet.sliceSpace = 0;
    
    // add a lot of colors
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObject:[UIColor colorWithRed:49/255.f green:119/255.f blue:183/255.f alpha:1.f]];
    [colors addObject:[UIColor colorWithRed:117/255.f green:119/255.f blue:234/255.f alpha:1.f]];
    [colors addObject:[UIColor colorWithRed:247/255.f green:127/255.f blue:0/255.f alpha:1.f]];
    [colors addObject:[UIColor colorWithRed:250/255.f green:187/255.f blue:113/255.f alpha:1.f]];
    [colors addObject:[UIColor colorWithRed:66/255.f green:187/255.f blue:113/255.f alpha:1.f]];
    [colors addObject:[UIColor colorWithRed:201/255.f green:218/255.f blue:248/255.f alpha:1.f]];
    
    dataSet.colors = colors;
    
    PieChartData *data = [[PieChartData alloc] initWithXVals:xVals dataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:pFormatter];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
    [data setValueTextColor:UIColor.whiteColor];
    
    pieViews.data = data;
    if (typeOfChart == 4) {

    }
    else{
        [pieViews setDrawHoleEnabled:NO];

    }
    [pieViews highlightValues:nil];
}

- (void)plotBarChart:(int)count range:(double)range
{
    [_chartViewOutline.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    

    BarChartView *barViews = [[BarChartView alloc] initWithFrame:CGRectMake(0, 0, self.chartViewOutline.frame.size.width-10, self.chartViewOutline.frame.size.height-10)];
    barViews.backgroundColor = [UIColor whiteColor];
    barViews.descriptionText = @"Bar-Chart";
    
    barViews.drawBordersEnabled = NO;
    
    barViews.leftAxis.drawAxisLineEnabled = NO;
    barViews.leftAxis.drawGridLinesEnabled = NO;
    barViews.rightAxis.drawAxisLineEnabled = NO;
    barViews.rightAxis.drawGridLinesEnabled = NO;
    barViews.xAxis.drawAxisLineEnabled = NO;
    barViews.xAxis.drawGridLinesEnabled = NO;
    barViews.drawGridBackgroundEnabled = NO;
    barViews.dragEnabled = YES;
    barViews.rightAxis.drawLabelsEnabled = NO;

    [barViews setScaleEnabled:YES];
    barViews.pinchZoomEnabled = YES;
    [_chartViewOutline addSubview:barViews];
    [barViews animateWithYAxisDuration:3.0];

    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        double mult = (range + 1);
        double val = (double) (arc4random_uniform(mult)) + mult / 3.0;
        [yVals addObject:[[BarChartDataEntry alloc] initWithValue:val xIndex:i]];
    }
    
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++)
    {
        [xVals addObject:[@((int)((BarChartDataEntry *)yVals[i]).value) stringValue]];
    }
    
    BarChartDataSet *set1 = [[BarChartDataSet alloc] initWithYVals:yVals label:@"DataSet"];
    set1.colors = ChartColorTemplates.vordiplom;
    set1.drawValuesEnabled = NO;
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    BarChartData *data = [[BarChartData alloc] initWithXVals:xVals dataSets:dataSets];
    
    barViews.data = data;
}
- (void)plotLineChart:(int)count range:(double)range
{
    [_chartViewOutline.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    LineChartView *lineChartView = [[LineChartView alloc]initWithFrame:CGRectMake(0, 0, self.chartViewOutline.frame.size.width-10, self.chartViewOutline.frame.size.height-10)];
    lineChartView.delegate = self;
    lineChartView.backgroundColor = [UIColor whiteColor];
    lineChartView.descriptionText = @"Trend of Coverage";
    lineChartView.noDataTextDescription = @"You need to provide data for the chart.";
    
    lineChartView.drawBordersEnabled = YES;
    
    lineChartView.leftAxis.drawAxisLineEnabled = NO;
    lineChartView.leftAxis.drawGridLinesEnabled = NO;
    lineChartView.rightAxis.drawAxisLineEnabled = NO;
    lineChartView.rightAxis.drawGridLinesEnabled = NO;
    lineChartView.xAxis.drawAxisLineEnabled = NO;
    lineChartView.xAxis.drawGridLinesEnabled = NO;
    lineChartView.rightAxis.drawLabelsEnabled = NO;

    lineChartView.drawGridBackgroundEnabled = NO;
    lineChartView.dragEnabled = YES;
    [lineChartView setScaleEnabled:YES];
    lineChartView.pinchZoomEnabled = YES;
    
    lineChartView.legend.position = ChartLegendPositionRightOfChart;
    [_chartViewOutline addSubview:lineChartView];
    [lineChartView animateWithXAxisDuration:3.0];

    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++)
    {
        [xVals addObject:[@(i) stringValue]];
    }
    
    NSArray *colors = @[ChartColorTemplates.vordiplom[0], ChartColorTemplates.vordiplom[1], ChartColorTemplates.vordiplom[2]];
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    
    for (int z = 0; z < 2; z++)
    {
        NSMutableArray *values = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < count; i++)
        {
            double val = (double) (arc4random_uniform(range) + 3);
            [values addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];
        }
        
        LineChartDataSet *d = [[LineChartDataSet alloc] initWithYVals:values label:[NSString stringWithFormat:@"DataSet %d", z + 1]];
        d.lineWidth = 5.0;
        d.circleRadius = 4.0;
        
        UIColor *color = colors[z % colors.count];
        [d setColor:color];
        [d setCircleColor:color];
        [dataSets addObject:d];
    }
    
    ((LineChartDataSet *)dataSets[0]).lineDashLengths = @[@5.f, @5.f];
    ((LineChartDataSet *)dataSets[0]).colors = ChartColorTemplates.vordiplom;
    ((LineChartDataSet *)dataSets[0]).circleColors = ChartColorTemplates.vordiplom;
    
    LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSets:dataSets];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:7.f]];
    lineChartView.data = data;
}
#pragma mark - Scrollable Tab bar code

-(void)initScrollableTabbar
{
    // Tab bar
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:@"Trend of coverage" image:[UIImage imageNamed:@"test1"] tag:1];
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:@"Key" image:[UIImage imageNamed:@"test2"] tag:2];
    UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:@"Media" image:[UIImage imageNamed:@"test3"] tag:3];
    UITabBarItem *item4 = [[UITabBarItem alloc] initWithTitle:@"Sentiment" image:[UIImage imageNamed:@"test4"] tag:4];
    UITabBarItem *item5 = [[UITabBarItem alloc] initWithTitle:@"Change" image:[UIImage imageNamed:@"test1"] tag:5];
    UITabBarItem *item6 = [[UITabBarItem alloc] initWithTitle:@"Sources" image:[UIImage imageNamed:@"test1"] tag:6];
    UITabBarItem *item7 = [[UITabBarItem alloc] initWithTitle:@"Journalists" image:[UIImage imageNamed:@"test1"] tag:7];
  
    
    ZRScrollableTabBar *tabBar = [[ZRScrollableTabBar alloc] initWithItems:[NSArray arrayWithObjects: item1, item2, item3, item4, item5, item6, item7, nil]];
    tabBar.scrollableTabBarDelegate = self;
    
    [self.view addSubview:tabBar];
}

- (void)scrollableTabBar:(ZRScrollableTabBar *)tabBar didSelectItemWithTag:(int)tag
{
    typeOfChart = tag;
    if (tag == 1) {
        [self plotPieChart:6 range:6];
    }
    else if (tag == 2){
        [self plotLineChart:7 range:6];
    }
    else if (tag == 3){
        [self plotBarChart:6 range:6];

    }
    else if (tag == 4){
        [self plotPieChart:6 range:6];

    }
    else if (tag == 5){
    }
    else if (tag == 6){
    }
    else if (tag == 7){
    }
    else if (tag == 8){
    }
    else if (tag == 9){
    }

    else {
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
