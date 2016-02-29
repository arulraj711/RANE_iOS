//
//  ChartViewController.m
//  FullIntel
//
//  Created by cape start on 24/02/16.
//  Copyright © 2016 CapeStart. All rights reserved.
//

#import "ChartViewController.h"
#import "ChartBaseViewController.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
@interface ChartViewController ()

@end

@implementation ChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *Btns =[UIButton buttonWithType:UIButtonTypeCustom];
    [Btns setFrame:CGRectMake(0.0f,0.0f,115,20.0f)];
    [Btns setTitle:@"Top Stories" forState:UIControlStateNormal];
    [Btns addTarget:self action:@selector(settingsButtonFilter) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addButtons = [[UIBarButtonItem alloc] initWithCustomView:Btns];
    [self.navigationItem setRightBarButtonItem:addButtons];

    
    chartIcon = [[NSMutableArray alloc]init];
    [chartIcon addObject:@"issue_chart3"];
    [chartIcon addObject:@"issue_chart2"];
    [chartIcon addObject:@"issue_chart4"];
    [chartIcon addObject:@"issue_chart1"];
    [chartIcon addObject:@"issue_chart1"];
    [chartIcon addObject:@"issue_chart1"];
    [chartIcon addObject:@"issue_chart1"];
    
    chartName = [[NSMutableArray alloc]init];
    [chartName addObject:@"Trend of Coverage"];
    [chartName addObject:@"Key Topics"];
    [chartName addObject:@"Media Types"];
    [chartName addObject:@"Sentiment and Volume over Time"];
    [chartName addObject:@"Change over Last Quarter"];
    [chartName addObject:@"Top Sources"];
    [chartName addObject:@"Top Journalists"];
    

    
    
    typeOfChart = 0;
    monthArray = [NSArray arrayWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun", nil];
    ValueArray = [NSArray arrayWithObjects:@"12",@"13",@"14",@"15",@"16",@"17", nil];
    widthOfChartViewOutline = self.chartViewOutline.frame.size.width;
    heightOfChartViewOutline = self.chartViewOutline.frame.size.height;

    // to add scrollable tab bar
   // [self initScrollableTabbar];

    // Do any additional setup after loading the view.
}
-(void)settingsButtonFilter{
    
}


#pragma mark - UICollectionView Datasource


- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return chartIcon.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // NSLog(@"collectionview cell for item");
    ChartIconCell *cell = (ChartIconCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.chartNameLabel.text = [chartName objectAtIndex:indexPath.row];
    cell.chartIconImage.image = [UIImage imageNamed:[chartIcon objectAtIndex:indexPath.row]];
    [cell setBackgroundColor:[UIColor colorWithRed:246.0/255 green:246.0/255 blue:246.0/255 alpha:1.0]];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    typeOfChart = (int) indexPath.row;

    if(indexPath.row == 0) {
        [self plotLineChart:7 range:6];
    } else if(indexPath.row == 1) {
        [self plotPieChart:6 range:6];
    } else if (indexPath.row == 2) {
        [self plotPieChart:6 range:6];
    } else if (indexPath.row == 3) {
        [self plotBarChart:6 range:6];
    } else{
        [self plotLineChart:7 range:6];

    }
    
    
}

- (void)plotPieChart:(int)count range:(double)range
{
    [_chartViewOutline.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];

    NSLog(@"%f,%f",widthOfChartViewOutline,heightOfChartViewOutline);
    pieViews = [[PieChartView alloc] initWithFrame:CGRectMake(0, 0, self.chartViewOutline.frame.size.width-10, self.chartViewOutline.frame.size.height-10)];
    pieViews.backgroundColor = [UIColor whiteColor];
    [_chartViewOutline addSubview:pieViews];
    [pieViews animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];

    
    pieViews.delegate = self;

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
    if (typeOfChart == 1) {
        [pieViews setDrawHoleEnabled:NO];
        _titleLabel.text =[chartName objectAtIndex:1];

    }
    else{
        _titleLabel.text =[chartName objectAtIndex:2];

    }
    [pieViews highlightValues:nil];
}

- (void)plotBarChart:(int)count range:(double)range
{
    [_chartViewOutline.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    

    barViews = [[BarChartView alloc] initWithFrame:CGRectMake(0, 0, self.chartViewOutline.frame.size.width-10, self.chartViewOutline.frame.size.height-10)];
    barViews.backgroundColor = [UIColor whiteColor];
    _titleLabel.text =[chartName objectAtIndex:3];
    
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
    lineChartView = [[LineChartView alloc]initWithFrame:CGRectMake(0, 0, self.chartViewOutline.frame.size.width-10, self.chartViewOutline.frame.size.height-10)];
    lineChartView.delegate = self;
    lineChartView.backgroundColor = [UIColor whiteColor];
    _titleLabel.text =[chartName objectAtIndex:0];
    
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


- (IBAction)saveChartButton:(id)sender {
    if (typeOfChart == 0) {
        [lineChartView saveToCameraRoll];
    }else if (typeOfChart ==1){
        [pieViews saveToCameraRoll];
    }else if (typeOfChart ==2){
        [pieViews saveToCameraRoll];
    }else if (typeOfChart ==3){
        [barViews saveToCameraRoll];
    }else if (typeOfChart ==4){
        [lineChartView saveToCameraRoll];
    }else if (typeOfChart ==5){
        [lineChartView saveToCameraRoll];
    }
}
@end
