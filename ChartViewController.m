//
//  ChartViewController.m
//  FullIntel
//
//  Created by cape start on 24/02/16.
//  Copyright © 2016 CapeStart. All rights reserved.
//

#import "ChartViewController.h"
#import "FISharedResources.h"
#import "ReportTypeObject.h"
#import "ChartTypeObject.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define kWeekWithFormatSpecifier @"week%@"
@interface ChartViewController ()

@end

@implementation ChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
 
    
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
    
    selectedChatIcon = [[NSMutableArray alloc]init];
    [selectedChatIcon addObject:@"selected_issue_chart3"];
    [selectedChatIcon addObject:@"selected_issue_chart2"];
    [selectedChatIcon addObject:@"selected_issue_chart4"];
    [selectedChatIcon addObject:@"selected_issue_chart1"];
    [selectedChatIcon addObject:@"selected_issue_chart1"];
    [selectedChatIcon addObject:@"selected_issue_chart1"];
    [selectedChatIcon addObject:@"selected_issue_chart1"];
    
    
    typeOfChart = 0;
    
    
    
    

    
    //ipad methods for table
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"chart_story" ofType:@"json"];
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSError *error;
        chartStoryList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        [self.storyTableView reloadData];
        isTopStoriesOpen = NO;
        selectedChartIndex = 0;
        
        self.topStoriesViewLeadingConstraint.constant = self.view.frame.size.width;
        self.chartNameLabel.text =[chartName objectAtIndex:0];
        
        //[self plotLineChart:6 range:6];


    }else{
        
        widthOfChartViewOutline = self.chartViewOutline.frame.size.width;
        heightOfChartViewOutline = self.chartViewOutline.frame.size.height;

        
        //for navigation bar button
        UIButton *Btns =[UIButton buttonWithType:UIButtonTypeCustom];
        [Btns setFrame:CGRectMake(0.0f,0.0f,115,20.0f)];
        [Btns setTitle:@"Top Stories" forState:UIControlStateNormal];
        [Btns addTarget:self action:@selector(settingsButtonFilter) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *addButtons = [[UIBarButtonItem alloc] initWithCustomView:Btns];
        [self.navigationItem setRightBarButtonItem:addButtons];

        
        _titleLabel.text =[chartName objectAtIndex:0];
        

    }

 //   [self selectItemAtIndexPath:0 animated:YES scrollPosition:UICollectionViewScrollPositionNone];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(afterFetchingReportObject:)
                                                 name:@"FetchedReportObject"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(afterFetchingTrendOfCoverageInfo:)
                                                 name:@"FetchedTrendOfCoverageInfo"
                                               object:nil];

    
    [[FISharedResources sharedResourceManager]getSingleReportDetailsForReportId:self.reportId];
   // Do any additional setup after loading the view.
}


-(void)afterFetchingReportObject:(id)sender {
    NSNotification *notification = sender;
    reportObject = [[notification userInfo] objectForKey:@"reportObject"];
    NSLog(@"Report Object:%@",reportObject);
    [self.chartIconCollectionView reloadData];
}

-(void)afterFetchingTrendOfCoverageInfo:(id)sender {
    NSNotification *notification = sender;
    NSDictionary *trendOfCoverageDic = [[notification userInfo] objectForKey:@"TrendOfCoverageInfo"];
    NSLog(@"INfo --->%@",trendOfCoverageDic);
    
    NSDictionary *articleCirculationMap = [trendOfCoverageDic objectForKey:@"articleCirculationMap"];
    NSDictionary *articleCountMap = [trendOfCoverageDic objectForKey:@"articleCountMap"];
    
    monthArray = [articleCirculationMap allKeys];
    ValueArray = [articleCirculationMap allValues];
    ValueArrayTwo = [articleCountMap allValues];
    


    NSLog(@"%@",articleCirculationMap);
    NSLog(@"%@",[articleCirculationMap allKeys]);
    NSLog(@"%@",[articleCirculationMap allValues]);

    NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
    NSArray *descriptors=[NSArray arrayWithObject: descriptor];
    NSArray *reverseOrder=[monthArray sortedArrayUsingDescriptors:descriptors];
    NSLog(@"%@",reverseOrder);
    
    NSMutableArray *reverseOrders = [[NSMutableArray alloc] init];
    for (int i=0; i<reverseOrder.count; i++)
    {
        NSLog(@"%@",[reverseOrder objectAtIndex:i]);
        NSString *inpT = [reverseOrder objectAtIndex:i];
                NSString *value = [articleCirculationMap objectForKey:inpT];
                [reverseOrders addObject:value];
    }
    NSLog(@"%@",reverseOrders);


    
    
    NSArray *xValueArray = [self FindWeekNumberOfDate:monthArray];
    NSLog(@"%@",xValueArray);
    
    NSArray *xAxisFinalArray = [self createXaxisArray:xValueArray];
    NSLog(@"%@",xAxisFinalArray);
    
    monthArray = [NSArray arrayWithArray:xAxisFinalArray];
    ValueArray = [NSArray arrayWithArray:reverseOrders];
    
    NSLog(@"%@",monthArray);
    NSLog(@"%@",ValueArray);
    int countVal = (int)monthArray.count;
    NSLog(@"%d",countVal);

    [self plotLineChart:countVal range:6];
}

//for iPhone

//    for (int i=0; i<=monthArray.count; i++) {
//        NSDate *dateInput = [monthArray objectAtIndex:0];
//        NSLog(@"dates --->%@",dateInput);
//
//        NSCalendar *calendar = [NSCalendar currentCalendar];
//        NSDateComponents *dateComponent = [calendar components:(NSWeekOfYearCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[NSDate date]];
//        NSLog(@"%@",dateComponent);
//        NSLog(@"%ld",(long)dateComponent.weekOfMonth);
//
//    }
//

-(void)settingsButtonFilter{
    

    UIStoryboard *storyboard;
    TopStoriesViewController *chartView;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        storyboard = [UIStoryboard storyboardWithName:@"ChartViewControlleriPhone" bundle:nil];
        chartView = [storyboard instantiateViewControllerWithIdentifier:@"TopStoriesViewController"];
    } else {
        
        
    }
    
    [self.navigationController pushViewController:chartView animated:YES];


}
#pragma mark - UITableview Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [chartStoryList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoryTableViewCell *cell = (StoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    int cnt = indexPath.row+1;
    cell.numberLabel.text = [NSString stringWithFormat:@"%d",cnt];
    NSDictionary *dic;
    
    dic = [chartStoryList objectAtIndex:indexPath.row];
    cell.titleLabel.text = [dic objectForKey:@"title"];
    cell.outletLabel.text = [dic objectForKey:@"outlet"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UICollectionView Datasource


- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return reportObject.reportTypeArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // NSLog(@"collectionview cell for item");
    ChartIconCell *cell = (ChartIconCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    ReportTypeObject *reportType = [reportObject.reportTypeArray objectAtIndex:indexPath.row];
    cell.chartNameLabel.text = reportType.reportName;
     ChartTypeObject *chartType = reportType.chartTypeObject;
    if ([chartType.chartTyepId isEqualToNumber:[NSNumber numberWithInt:1]]) {
            cell.chartIconImage.image = [UIImage imageNamed:[chartIcon objectAtIndex:1]];

    }
    else if ([chartType.chartTyepId isEqualToNumber:[NSNumber numberWithInt:2]]){
        cell.chartIconImage.image = [UIImage imageNamed:[chartIcon objectAtIndex:3]];

    }
    else if ([chartType.chartTyepId isEqualToNumber:[NSNumber numberWithInt:3]]){
        cell.chartIconImage.image = [UIImage imageNamed:[chartIcon objectAtIndex:0]];

    }
    else if ([chartType.chartTyepId isEqualToNumber:[NSNumber numberWithInt:4]]){
        cell.chartIconImage.image = [UIImage imageNamed:[chartIcon objectAtIndex:0]];

    }
    else if ([chartType.chartTyepId isEqualToNumber:[NSNumber numberWithInt:5]]){
        cell.chartIconImage.image = [UIImage imageNamed:[chartIcon objectAtIndex:3]];

    }
    else if ([chartType.chartTyepId isEqualToNumber:[NSNumber numberWithInt:6]]){
        cell.chartIconImage.image = [UIImage imageNamed:[chartIcon objectAtIndex:3]];

    }
    else if ([chartType.chartTyepId isEqualToNumber:[NSNumber numberWithInt:7]]){
        cell.chartIconImage.image = [UIImage imageNamed:[chartIcon objectAtIndex:0]];

    }
    else if ([chartType.chartTyepId isEqualToNumber:[NSNumber numberWithInt:8]]){
        cell.chartIconImage.image = [UIImage imageNamed:[chartIcon objectAtIndex:0]];

    }
    
    else {
        cell.chartIconImage.image = [UIImage imageNamed:[chartIcon objectAtIndex:0]];
    }

//    cell.chartIconImage.image = [UIImage imageNamed:[chartIcon objectAtIndex:indexPath.row]];
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){
        [cell setBackgroundColor:[UIColor colorWithRed:246.0/255 green:246.0/255 blue:246.0/255 alpha:1.0]];

    }
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",(long)indexPath.row);
    NSLog(@"%ld",(long)indexPath.item);

    ChartIconCell *cell = (ChartIconCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.chartIconImage.image = [UIImage imageNamed:[selectedChatIcon objectAtIndex:indexPath.row]];
    [[FISharedResources sharedResourceManager]getTrendOfCoverageChartInfoFromDate:reportObject.reportFromDate toDate:reportObject.reportToDate];
    
    typeOfChart = (int) indexPath.row;
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        self.chartNameLabel.text =[chartName objectAtIndex:indexPath.row];
    }
    else{
        _titleLabel.text =[chartName objectAtIndex:indexPath.row];
    }
    
//    if(indexPath.row == 0) {
//        [self plotLineChart:6 range:6];
//    } else if(indexPath.row == 1) {
//        [self plotPieChart:6 range:6];
//    } else if (indexPath.row == 2) {
//        [self plotPieChart:6 range:6];
//    } else if (indexPath.row == 3) {
//        [self plotBarChart:6 range:6];
//    } else{
//        [self plotLineChart:6 range:6];
//    }
    
    
}

- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath
                     animated:(BOOL)animated
               scrollPosition:(UICollectionViewScrollPosition)scrollPosition{

    if(indexPath.row == 0) {
        [self plotLineChart:6 range:6];
    } else if(indexPath.row == 1) {
        [self plotPieChart:6 range:6];
    } else if (indexPath.row == 2) {
        [self plotPieChart:6 range:6];
    } else if (indexPath.row == 3) {
        [self plotBarChart:6 range:6];
    } else{
        [self plotLineChart:6 range:6];
    }

    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChartIconCell *cell = (ChartIconCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.chartIconImage.image = [UIImage imageNamed:[chartIcon objectAtIndex:indexPath.row]];

}


#pragma mark - Plot Chart

ter
- (void)plotPieChart:(int)count range:(double)range
{
    [_chartViewOutline.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    NSLog(@"%f,%f",widthOfChartViewOutline,heightOfChartViewOutline);
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        pieViews = [[PieChartView alloc] initWithFrame:CGRectMake(30, 30, self.topStoriesViewLeadingConstraint.constant-30,  self.view.frame.size.height-260)];
        
    }
    else{
        pieViews = [[PieChartView alloc] initWithFrame:CGRectMake(0, 0, self.chartViewOutline.frame.size.width-10, self.chartViewOutline.frame.size.height-10)];
    }
    pieViews.backgroundColor = [UIColor whiteColor];
    [_chartViewOutline addSubview:pieViews];
    [pieViews animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
    pieViews.descriptionText =@"";
    pieViews.legend.position = ChartLegendPositionBelowChartCenter;
    pieViews.delegate = self;
    
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++){
        [yVals addObject:[[BarChartDataEntry alloc] initWithValue:[[ValueArray objectAtIndex:i] doubleValue] xIndex:i]];
        
    }
    
    
    NSLog(@"%@",yVals);
    
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        [xVals addObject:monthArray[i % monthArray.count]];
    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithYVals:yVals label:@"Outlet reach"];
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
        
    }
    else{
        
    }
    [pieViews highlightValues:nil];
}
- (void)plotBarChart:(int)count range:(double)range
{
    [_chartViewOutline.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        barViews = [[BarChartView alloc] initWithFrame:CGRectMake(30, 30, self.topStoriesViewLeadingConstraint.constant-30,  self.view.frame.size.height-260)];
        
    }
    else{
        barViews = [[BarChartView alloc] initWithFrame:CGRectMake(0, 0, self.chartViewOutline.frame.size.width-10, self.chartViewOutline.frame.size.height-10)];
    }
    barViews.backgroundColor = [UIColor whiteColor];
    
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
    barViews.descriptionText =@"";
    barViews.legend.position = ChartLegendPositionBelowChartCenter;
    [barViews setScaleEnabled:YES];
    barViews.pinchZoomEnabled = YES;
    barViews.xAxis.labelPosition = XAxisLabelPositionBottom;
    
    [_chartViewOutline addSubview:barViews];
    
    [barViews animateWithYAxisDuration:3.0];
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++){
        [yVals addObject:[[BarChartDataEntry alloc] initWithValue:[[ValueArray objectAtIndex:i] doubleValue] xIndex:i]];
    }
    
    
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        [xVals addObject:monthArray[i % monthArray.count]];
    }
    
    //    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    //    for (int i = 0; i < count; i++)
    //    {
    //        [xVals addObject:[@((int)((BarChartDataEntry *)yVals[i]).value) stringValue]];
    //    }
    
    BarChartDataSet *set1 = [[BarChartDataSet alloc] initWithYVals:yVals label:@"Brands"];
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
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        lineChartView = [[LineChartView alloc] initWithFrame:CGRectMake(30, 30, self.topStoriesViewLeadingConstraint.constant-30,  self.view.frame.size.height-260)];
    }
    else{
        lineChartView = [[LineChartView alloc]initWithFrame:CGRectMake(0, 0, self.chartViewOutline.frame.size.width-10, self.chartViewOutline.frame.size.height-10)];
    }
    lineChartView.delegate = self;
    lineChartView.backgroundColor = [UIColor whiteColor];
    
    //set properties--------------------------------------------------------------------
    
    lineChartView.drawBordersEnabled = YES;
    lineChartView.descriptionText =@"";
    
    lineChartView.rightAxis.enabled = true;
    lineChartView.leftAxis.drawGridLinesEnabled = NO;
    lineChartView.rightAxis.drawGridLinesEnabled = NO;
    
    
    lineChartView.leftAxis.drawAxisLineEnabled = NO;
    //    lineChartView.rightAxis.drawAxisLineEnabled = NO;
    lineChartView.xAxis.drawAxisLineEnabled = NO;
    lineChartView.xAxis.drawGridLinesEnabled = NO;
    //    lineChartView.rightAxis.drawLabelsEnabled = NO;
    lineChartView.drawGridBackgroundEnabled = NO;
    
    //set limit for left axis **************************************************
    //
    
    lineChartView.rightAxis.customAxisMax = [[[self sortArrayWithArray:ValueArrayTwo] lastObject] doubleValue];
    lineChartView.rightAxis.customAxisMin = [[[self sortArrayWithArray:ValueArrayTwo] firstObject] doubleValue];
    
    
    lineChartView.leftAxis.customAxisMax = [[[self sortArrayWithArray:ValueArray] lastObject] doubleValue];
    lineChartView.leftAxis.customAxisMin = [[[self sortArrayWithArray:ValueArray] firstObject] doubleValue];
    
//    lineChartView.rightAxis.customAxisMax = 10;
//    lineChartView.rightAxis.customAxisMin = 0;
    
    
    lineChartView.xAxis.spaceBetweenLabels =0;
    
//    lineChartView.xAxis.labelRotationAngle =45;
    
    //set limit for left axis **************************************************
    
    //    lineChartView.dragEnabled = YES;
    //    [lineChartView setScaleEnabled:YES];
    //    lineChartView.pinchZoomEnabled = YES;
    
    lineChartView.legend.position = ChartLegendPositionBelowChartCenter;
    lineChartView.xAxis.labelPosition = XAxisLabelPositionBottom;
    
    //set properties--------------------------------------------------------------------
    
    [_chartViewOutline addSubview:lineChartView];
    
    //animations------------------------------------------------------------------------
    
    [lineChartView animateWithXAxisDuration:3.0];
    
    //animations------------------------------------------------------------------------
    
    
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        [xVals addObject:monthArray[i % monthArray.count]];
    }
    
    
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++)
    {
        [values addObject:[[ChartDataEntry alloc] initWithValue:[[ValueArray objectAtIndex:i] doubleValue] xIndex:i]];
    }
    
    
    
    NSMutableArray *valuesTwo = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++)
    {
        [valuesTwo addObject:[[ChartDataEntry alloc] initWithValue:[[ValueArrayTwo objectAtIndex:i] doubleValue] xIndex:i]];
    }
    
    
    
    
    LineChartDataSet *d = [[LineChartDataSet alloc] initWithYVals:values label:[NSString stringWithFormat:@"Articles"]];
    d.lineWidth = 5.0;
    d.circleRadius = 4.0;
    
    [d setColor:[UIColor colorWithRed:189/255.f green:74/255.f blue:71/255.f alpha:1.f]];
    [d setCircleColor:[UIColor blackColor]];
    [dataSets addObject:d];
    
    //
            LineChartDataSet *ds = [[LineChartDataSet alloc] initWithYVals:valuesTwo label:[NSString stringWithFormat:@"Circulation"]];
            ds.axisDependency = AxisDependencyRight;
            ds.lineWidth = 5.0;
            ds.circleRadius = 4.0;
    
            [ds setColor:[UIColor colorWithRed:74/255.f green:126/255.f blue:187/255.f alpha:1.f]];
            [ds setCircleColor:[UIColor blackColor]];
            [dataSets addObject:ds];
            NSLog(@"%lu",(unsigned long)[dataSets count]);
    
    LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSets:dataSets];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:7.f]];
    lineChartView.data = data;
    
    
}





-(void)chartValueSelected:(ChartViewBase *)chartView entry:(ChartDataEntry *)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight *)highlight{
    
    NSLog(@"%@ %@ %ld %@",chartView,entry,(long)dataSetIndex,highlight);
    
    NSLog(@"%f",entry.value);
    
    
}
#pragma mark - Rest of the Code
-(NSMutableArray *)createXaxisArray : (NSArray *)inputArray{
    NSMutableArray *weekAxisArray = [[ NSMutableArray alloc]init];
    for (int i = 0; i<inputArray.count; i++) {
        NSString *weekNam = [NSString stringWithFormat:@"Week %@",[inputArray objectAtIndex:i]];
        [weekAxisArray addObject:weekNam];
    }
    return weekAxisArray;
}
-(NSMutableArray *)FindWeekNumberOfDate :(NSArray *)inputDateArray{
    
    NSMutableArray *weekValueOfDateArray = [[ NSMutableArray alloc]init];
    
    for (int i =0;i<inputDateArray.count;i++) {
        NSString *dateInput = [monthArray objectAtIndex:i];
        NSLog(@"%@",dateInput);
        
        dateInput = [dateInput stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        dateInput = [dateInput stringByReplacingOccurrencesOfString:@".000Z" withString:@""];
        NSLog(@"%@",dateInput);
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate *inpuDateFormat = [dateFormatter dateFromString:dateInput];
        NSLog(@"%@",inpuDateFormat);
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comps = [calendar components:NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear fromDate:inpuDateFormat];
        NSLog(@"%ld",(long)comps.weekOfMonth);
        NSInteger weekComp = comps.weekOfMonth;

        [weekValueOfDateArray addObject:[NSNumber numberWithInteger:weekComp]];

    }
    

    return weekValueOfDateArray;
}

-(NSArray *)sortArrayWithArray:(NSArray *)incomingArray {
    NSArray *sortedArray = [incomingArray sortedArrayUsingDescriptors:
                            @[[NSSortDescriptor sortDescriptorWithKey:@"doubleValue"
                                                            ascending:YES]]];
    
    return sortedArray;
}

#pragma mark - Custom Methods

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

#pragma mark - Button Methods


-(void)AnimateButtonOnClick :(id)sender{
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){
        POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        sprintAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.9, 1.9)];
        sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.9, 0.9)];
        sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
        sprintAnimation.springBounciness = 15.f;
        [sender pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
    }
    
}


- (IBAction)savecharttodevice:(id)sender {
    
    [self AnimateButtonOnClick:sender];
    
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
    [self.view makeToast:@"Chart saved successfully" duration:1.0 position:CSToastPositionCenter];

}
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipViews
{
    //  [self.visiblePopTipViews removeObject:popTipView];
    popTipViews = nil;
}

- (IBAction)infoButtonClick:(id)sender {
    [self AnimateButtonOnClick:sender];

    NSString *contentMessage = nil;
    contentMessage = @"\tA senior Apple executive said the company policy has been to produce information to the government when there is a lawful order to do so, but that in New York the judge never issued the order, and instead asked attorneys to file briefs addressing the constitutionality of the request for Apple to bypass its security protocols under the 1789 All Writs Act. The executive spoke on condition of anonymity to discuss a pending legal matter.";
    
    
    
    if (nil == popTipView) {
        popTipView = [[CMPopTipView alloc] initWithMessage:contentMessage];
        popTipView.delegate = self;
        popTipView.backgroundColor = [UIColor whiteColor];
        popTipView.textColor = [UIColor darkTextColor];
        popTipView.dismissTapAnywhere = YES;
        UIButton *button = (UIButton *)sender;
        
        [popTipView presentPointingAtView:button inView:_chartViewOutline animated:YES];
        
    }
    else {
        // Dismiss
        [popTipView dismissAnimated:YES];
        popTipView = nil;
    }
}


//for iPad
- (IBAction)topStoriesButtonClick:(id)sender {
    NSLog(@"constraint:%f",self.topStoriesViewLeadingConstraint.constant);
    if(!isTopStoriesOpen) {
        [UIView animateWithDuration:0.4
                         animations:^{
                             [self.topStoriesButton setSelected:YES];
                             self.topStoriesButtonLabelWidthConstraint.constant = 0;
                             self.tableOuterView.layer.borderWidth = 0.0f;
                             self.tableOuterView.layer.borderColor = [UIColor lightGrayColor].CGColor;
                             isTopStoriesOpen = YES;
                             self.topStoriesViewLeadingConstraint.constant = self.view.frame.size.width-320;
                             [self.view layoutIfNeeded];
                             
                             if(typeOfChart == 0) {
                                 [self plotLineChart:6 range:6];
                             } else if(typeOfChart == 1) {
                                 [self plotPieChart:6 range:6];
                             } else if (typeOfChart == 2) {
                                 [self plotPieChart:6 range:6];
                             } else if (typeOfChart == 3) {
                                 [self plotBarChart:6 range:6];
                             } else{
                                 [self plotLineChart:6 range:6];
                             }
                             
                             
                         }];
    } else {
        [UIView animateWithDuration:0.4
                         animations:^{
                             [self.topStoriesButton setSelected:NO];
                             self.topStoriesButtonLabelWidthConstraint.constant = 9;
                             self.tableOuterView.layer.borderWidth = 0.0f;
                             self.tableOuterView.layer.borderColor = [UIColor lightGrayColor].CGColor;
                             isTopStoriesOpen = NO;
                             self.topStoriesViewLeadingConstraint.constant = self.view.frame.size.width;
                             [self.view layoutIfNeeded];
                             if(typeOfChart == 0) {
                                 [self plotLineChart:6 range:6];
                             } else if(typeOfChart == 1) {
                                 [self plotPieChart:6 range:6];
                             } else if (typeOfChart == 2) {
                                 [self plotPieChart:6 range:6];
                             } else if (typeOfChart == 3) {
                                 [self plotBarChart:6 range:6];
                             } else{
                                 [self plotLineChart:6 range:6];
                             }
                             
                         }];
    }
    
}
@end
