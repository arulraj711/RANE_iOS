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
#import "CorporateNewsListView.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })
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
    [chartIcon addObject:@"issue_chart6"];
    [chartIcon addObject:@"issue_chart6"];
    [chartIcon addObject:@"issue_chart6"];

    
    chartName = [[NSMutableArray alloc]init];
    [chartName addObject:@"Trend of Coverage"];
    [chartName addObject:@"Key Topics"];
    [chartName addObject:@"Media Types"];
    [chartName addObject:@"Sentiment and Volume over Time"];
    [chartName addObject:@"Change over Last Quarter"];
    [chartName addObject:@"Top Sources"];
    [chartName addObject:@"Top Journalists"];
    [chartName addObject:@"Top Influencers"];

    selectedChatIcon = [[NSMutableArray alloc]init];
    [selectedChatIcon addObject:@"selected_issue_chart3"];
    [selectedChatIcon addObject:@"selected_issue_chart2"];
    [selectedChatIcon addObject:@"selected_issue_chart4"];
    [selectedChatIcon addObject:@"selected_issue_chart1"];
    [selectedChatIcon addObject:@"selected_issue_chart1"];
    [selectedChatIcon addObject:@"selected_issue_chart6"];
    [selectedChatIcon addObject:@"selected_issue_chart6"];
    [selectedChatIcon addObject:@"selected_issue_chart6"];

    
  //  typeOfChart = 0;

    
  //  ipad methods for table
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"chart_story" ofType:@"json"];
//        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
//        NSError *error;
//        chartStoryList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
       // [self.storyTableView reloadData];
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

    NSLog(@"title string:%@",self.titleString);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Open Sans" size:16];
    // label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.text =self.titleString;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    
    fullName = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(afterFetchingReportObject:)
                                                 name:@"FetchedReportObject"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(afterFetchingTrendOfCoverageInfo:)
                                                 name:@"FetchedTrendOfCoverageInfo"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(afterFetchingKeyTopicsInfo:)
                                                 name:@"FetchedKeyTopicsInfo"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(afterFetchingMediaTypeInfo:)
                                                 name:@"FetchedMediaTypeInfo"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(afterFetchingSentimentAndVolumeOverTimeInfo:)
                                                 name:@"FetchedSentimentAndVolumeOverTimeInfo"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(afterFetchingChangeOverLastQuarterInfo:)
                                                 name:@"FetchedChangeOverLastQuarterInfo"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(afterFetchingTopSourcesInfo:)
                                                 name:@"FetchedTopSourcesInfo"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(afterFetchingTopJournalistInfo:)
                                                 name:@"FetchedTopJournalistInfo"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(afterFetchingTopInfluencerInfo:)
                                                 name:@"FetchedTopInfluencerInfo"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(afterFetchingTopStoriesInfo:)
                                                 name:@"FetchedTopStoriesInfo"
                                               object:nil];
    
    


    
    [[FISharedResources sharedResourceManager]getSingleReportDetailsForReportId:self.reportId];
    
    [[FISharedResources sharedResourceManager]getTopStoriesChartInfoFromDate:self.reportFromDate toDate:self.reportToDate withPageNo:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10]];
   // Do any additional setup after loading the view.

//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTap)];
//    [self.view addGestureRecognizer:tapGesture];
    
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}


- (void)deviceOrientationDidChange:(NSNotification *)notification {
    NSLog(@"device orientation changes");
    //Obtaining the current device orientation
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    NSLog(@"%ld",(long)orientation);
    //self.topStoriesViewLeadingConstraint.constant = self.view.frame.size.width;
    [self viewTap];
    [self redrawChartViewWhileRotate];
//    if(orientation == UIDeviceOrientationPortrait) {
//        NSLog(@"portrait mode");
//    } else if(orientation == UIDeviceOrientationLandscapeLeft) {
//        NSLog(@"landscape mode");
//    } else if(orientation == UIDeviceOrientationLandscapeRight) {
//        NSLog(@"landscape mode");
//    }
}

-(void)redrawChartViewWhileRotate {
    if([localReportTypeId isEqualToNumber:[NSNumber numberWithInt:1]]) {
        [self plotLineChart:(int)monthArray.count range:6];
    } else if([localReportTypeId isEqualToNumber:[NSNumber numberWithInt:2]]) {
        [self plotPieChart:(int)monthArray.count range:7 withType:1];
    } else if([localReportTypeId isEqualToNumber:[NSNumber numberWithInt:3]]) {
        [self plotPieChart:(int)monthArray.count range:7 withType:2];
    } else if([localReportTypeId isEqualToNumber:[NSNumber numberWithInt:4]]) {
        [self plotStackedBarChart:(int)monthArray.count range:(int)monthArray.count];
    } else if([localReportTypeId isEqualToNumber:[NSNumber numberWithInt:5]]) {
        [self plotMultipleBarChart:(int)monthArray.count range:8 withBrands:changeOverInputArray];
    } else if([localReportTypeId isEqualToNumber:[NSNumber numberWithInt:6]]) {
        [self plotStackedHorizontalBarChart:(int)monthArray.count range:(int)monthArray.count];
    } else if([localReportTypeId isEqualToNumber:[NSNumber numberWithInt:7]]) {
        [self plotStackedHorizontalBarChart:(int)monthArray.count range:(int)monthArray.count];
    } else if([localReportTypeId isEqualToNumber:[NSNumber numberWithInt:8]]) {
        [self plotStackedHorizontalBarChart:(int)monthArray.count range:(int)monthArray.count];
    }
}


-(void)viewTap {
    /* Tap to close the top stories view */
    [UIView animateWithDuration:0.4
                     animations:^{
                         [self.topStoriesButton setSelected:NO];
                         self.topStoriesButtonLabelWidthConstraint.constant = 9;
                         self.tableOuterView.layer.borderWidth = 0.0f;
                         self.tableOuterView.layer.borderColor = [UIColor lightGrayColor].CGColor;
                         isTopStoriesOpen = NO;
                         self.topStoriesViewLeadingConstraint.constant = self.view.frame.size.width;
                         [self.view layoutIfNeeded];
                         //  [self loadChartValuesWithReportType:localReportTypeId];
                         
                     }];
}


#pragma mark - service response handling
-(void)afterFetchingReportObject:(id)sender {
    NSNotification *notification = sender;
    reportObject = [[notification userInfo] objectForKey:@"reportObject"];
    NSLog(@"Report Object:%@",reportObject);
    ReportTypeObject *reportType = [reportObject.reportTypeArray objectAtIndex:0];

    [[FISharedResources sharedResourceManager]getTrendOfCoverageChartInfoFromDate:reportObject.reportFromDate toDate:reportObject.reportToDate withAPILink:reportType.apiLink];
    
    [self.chartIconCollectionView reloadData];
    [self collectionView:_chartIconCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
}

-(void)afterFetchingTrendOfCoverageInfo:(id)sender {
    NSNotification *notification = sender;
    NSDictionary *trendOfCoverageDic = [[notification userInfo] objectForKey:@"TrendOfCoverageInfo"];
    NSLog(@"INfo --->%@",trendOfCoverageDic);
    
    articleCirculationMap = [trendOfCoverageDic objectForKey:@"articleCirculationMap"];
    articleCountMap = [trendOfCoverageDic objectForKey:@"articleCountMap"];
    
    
    
    //Assigning values initially for axis------------------------------------------------------------------
    NSLog(@"%@",articleCirculationMap);
    
    NSArray *monthArrayS = [articleCirculationMap allKeys];
    NSArray *ValueArrayS = [articleCirculationMap allValues];
    NSArray *ValueArrayTwoS= [articleCountMap allValues];
    
    
    
    
    //sorting the array of keys----------------------------------------------------------------------------
    
    NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
    NSArray *descriptors=[NSArray arrayWithObject: descriptor];
    NSArray *reverseOrder=[monthArrayS sortedArrayUsingDescriptors:descriptors];   //contains the date in sorted form
    
    NSLog(@"%@",reverseOrder);
    
    dateArrayToGet =[NSMutableArray arrayWithArray:reverseOrder];
    //sorting the array of values based on keys------------------------------------------------------------
    
    NSMutableArray *reverseOrders = [[NSMutableArray alloc] init];                //contains the values of date in sorted form
    for (int i=0; i<reverseOrder.count; i++)
    {
        NSString *inpT = [reverseOrder objectAtIndex:i];
        NSString *value = [articleCirculationMap objectForKey:inpT];
        [reverseOrders addObject:value];
    }
    
    
    NSMutableArray *reverseOrdersTwo = [[NSMutableArray alloc] init];             //contains the valueset2 of date in sorted form
    for (int i=0; i<reverseOrder.count; i++)
    {
        NSString *inpT = [reverseOrder objectAtIndex:i];
        NSString *value = [articleCountMap objectForKey:inpT];
        [reverseOrdersTwo addObject:value];
    }
    
    NSArray *resultantArray = [self inputDateAndOutputXaxis:reverseOrder];
    NSLog(@"%@",resultantArray);
    //for pan gesture, getting weeknumber and monthnumber--------------------------------------------------------------------------------
    
    //    NSArray *coupledArray = [self FindWeekNumberOfDate:reverseOrder];
    //    NSLog(@"%@",coupledArray);
    
    //    NSArray *xValueArray = [coupledArray objectAtIndex:0];
    //    NSLog(@"%@",xValueArray);
    //
    //    NSArray *xvalueForMonth = [coupledArray objectAtIndex:1];
    //    NSLog(@"%@",xvalueForMonth);
    
    
    //    xInputForMonths = [self GetMonthNameFromNumber:xvalueForMonth];
    //    NSLog(@"%@",xInputForMonths);
    
    
    //Final array of values for x axis----------------------------------------------------------------------
    
    //    NSArray *xAxisFinalArray = [self createXaxisArray:coupledArray];
    //    NSLog(@"%@<--",xAxisFinalArray);
    
    
    //Assigning x axis in montharray and y axis in valuearray-----------------------------------------------
    
    scaledXvalue = [NSArray arrayWithArray:resultantArray];
    scaledYvalue = [NSArray arrayWithArray:reverseOrders];
    scaledYvalueTwo = [NSArray arrayWithArray:reverseOrdersTwo];
    
    
    
    
    
    //Trying out month based grouping------------------------------------------------------------------------------
    
    //
    //    NSLog(@"%@",articleCirculationMap);
    //
    //    NSArray *valueWithDates = [self FormatTheKeyValuesWith:reverseOrder];  //Calling this method to format the date in normal DF
    //
    //    NSMutableDictionary *resultSetOne = [self GetResultantDictWithArray:reverseOrders andDateArray:valueWithDates];
    //    NSMutableDictionary *resultSetTwo = [self GetResultantDictWithArray:reverseOrdersTwo andDateArray:valueWithDates];
    //
    //    unScaledXvalue =[NSArray arrayWithArray:[resultSetOne allKeys]];
    //    unScaledYvalue = [NSArray arrayWithArray:[resultSetOne allValues]];
    //
    //    unscaledYvalueTwo = [NSArray arrayWithArray:[resultSetTwo allValues]];
    //
    //
    //    monthArray = [NSArray arrayWithArray:unScaledXvalue];
    //    ValueArray = [NSArray arrayWithArray:unScaledYvalue];
    //    ValueArrayTwo = [NSArray arrayWithArray:unscaledYvalueTwo];
    //
    //Trying out month based grouping------------------------------------------------------------------------------
    
    
    
    monthArray = [NSArray arrayWithArray:scaledXvalue];
    ValueArray = [NSArray arrayWithArray:scaledYvalue];
    ValueArrayTwo = [NSArray arrayWithArray:scaledYvalueTwo];
    
    int countVal = (int)monthArray.count;
    [self plotLineChart:countVal range:6];
}

//Updating Key Topics Chart Details
-(void)afterFetchingKeyTopicsInfo:(id)sender {
    NSNotification *notification = sender;
    NSDictionary *keyTopicsInfoDic = [[notification userInfo] objectForKey:@"KeyTopicsInfo"];
    NSLog(@"Key Topics Info --->%@",keyTopicsInfoDic);
    NSDictionary *keyTopicsDic = [keyTopicsInfoDic objectForKey:@"categoryCountMap"];
    
    
    
    NSArray *getKeysAndValues = [self getDictionaryAndGiveOutKeysAndPercentagesArray:keyTopicsDic];


    if(keyTopicsDic.count != 0) {
        
        monthArray = [getKeysAndValues objectAtIndex:0];
        ValueArray = [getKeysAndValues objectAtIndex:1];

        
        int countVal = (int)monthArray.count;
        
        [self plotPieChart:countVal range:7 withType:1];//type 1 for pie chart

    }
}
//Updating Media Type Chart Details
-(void)afterFetchingMediaTypeInfo:(id)sender {
    NSNotification *notification = sender;
    NSDictionary *mediaTypeInfoDic = [[notification userInfo] objectForKey:@"MediaTypeInfo"];
    NSLog(@"MediaType Info --->%@",mediaTypeInfoDic);
    NSDictionary *keyTopicsDic = NULL_TO_NIL([mediaTypeInfoDic objectForKey:@"mediaCountMap"]);
    NSArray *getKeysAndValues = [self getDictionaryAndGiveOutKeysAndPercentagesArray:keyTopicsDic];
    
    
    if(keyTopicsDic.count != 0) {
        
        monthArray = [getKeysAndValues objectAtIndex:0];
        ValueArray = [getKeysAndValues objectAtIndex:1];
        
        
        int countVal = (int)monthArray.count;
        
        [self plotPieChart:countVal range:7 withType:2];//type 1 for pie chart
        
    }
}
//Updating Media Type Chart Details
-(void)afterFetchingSentimentAndVolumeOverTimeInfo:(id)sender {
    NSNotification *notification = sender;
    NSDictionary *mediaTypeInfoDic = [[notification userInfo] objectForKey:@"SentimentAndVolumeOverTimeInfo"];
    NSDictionary *keyTopicsDic = NULL_TO_NIL([mediaTypeInfoDic objectForKey:@"tagTonalityCountMap"]);

    
    NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
    NSArray *descriptors=[NSArray arrayWithObject: descriptor];
    NSArray *reverseOrder=[[keyTopicsDic allKeys] sortedArrayUsingDescriptors:descriptors];   //contains the date in sorted form
    
    
    NSArray *twoMemberArray = [self FindWeekNumberOfDate:reverseOrder];
    NSArray *finalFormattedMonthNam = [twoMemberArray objectAtIndex:1];
    
    
    
    //sorting the array of values based on keys------------------------------------------------------------
    
    NSMutableArray *reverseOrders = [[NSMutableArray alloc] init];                //contains the values of date in sorted form
    for (int i=0; i<reverseOrder.count; i++)
    {
        NSString *inpT = [reverseOrder objectAtIndex:i];
        NSString *value = [keyTopicsDic objectForKey:inpT];
        [reverseOrders addObject:value];
    }
    NSLog(@"%@",reverseOrder);

    NSLog(@"%@",reverseOrders);                                                  //the array with brand and its values
    reverseOrderBkUp = [NSMutableArray arrayWithArray:reverseOrder];
    //for pan gesture, getting weeknumber and monthnumber--------------------------------------------------------------------------------

    
    
    
    //month name based array----------------------------------------------------------------
    NSArray *keyMonthArray = [self GetMonthNameFromNumber:finalFormattedMonthNam];
    NSLog(@"%@",keyMonthArray);
    
   //to get x value-------------------------------------------------------------------------
    
    


    

    NSMutableArray *XValueWithBrands = [[NSMutableArray alloc]init];   //the final array with brands
    NSMutableArray *YValueForBrands = [[NSMutableArray alloc]init];    //the final array with brand's values

//loop to iterate untill all the brand names and its corresponding values are obtained-------------------------------------------------------------------------
    
    for (int m = 0; m<reverseOrders.count; m++) {
        
        NSDictionary *dataDictionary = [reverseOrders objectAtIndex:m];

        NSArray *initXValueWithBrands = [[self GetXvalueAndYvalueForStackedBarChart:dataDictionary] objectAtIndex:0];
        NSArray *initYValueForBrands  = [[self GetXvalueAndYvalueForStackedBarChart:dataDictionary] objectAtIndex:1];
        
        if (m>0) {
            [XValueWithBrands addObject:@" "];
            NSArray *array1 = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],nil];

            [YValueForBrands addObject:array1];
        }
        
        [XValueWithBrands addObjectsFromArray:initXValueWithBrands];
        [YValueForBrands addObjectsFromArray:initYValueForBrands];

    }

    NSLog(@"%@",XValueWithBrands);
    NSLog(@"%@",YValueForBrands);

//loop to iterate untill all the brand names and its corresponding values are obtained-------------------------------------------------------------------------


    if(keyTopicsDic.count != 0) {//defining the x and y values finally for plotting in the stacked bar chart
        monthArray = [NSArray arrayWithArray:XValueWithBrands];
        ValueArray = [NSArray arrayWithArray:YValueForBrands];
        int countVal = (int)monthArray.count;

        [self plotStackedBarChart:countVal range:countVal];
    }
    

    
}

-(void)afterFetchingChangeOverLastQuarterInfo:(id)sender
{
    NSNotification *notification = sender;
    NSDictionary *mediaTypeInfoDic = [[notification userInfo] objectForKey:@"ChangeOverLastQuarterInfo"];
    NSDictionary *keyTopicsDic = NULL_TO_NIL([mediaTypeInfoDic objectForKey:@"tagTonality"]);
    
    
    changeOverInputArray=[self sortKeysInOrder:keyTopicsDic];   //contains the keys in sorted form
    NSLog(@"%@",changeOverInputArray);
    
    
    reverseOrdersBkUp = [NSMutableArray arrayWithArray:changeOverInputArray];

    //----------------------------------------------------------------to get the brand names in firstkey

    NSString *firstKey = [NSString stringWithFormat:@"%@",[changeOverInputArray objectAtIndex:0]];    //contains the first key

    NSMutableDictionary *dictWithDate = [keyTopicsDic objectForKey:firstKey];                 //gets the dict value of the first key
    
    NSArray *firstArrayOfDates=[self sortKeysInOrder:dictWithDate];   //contains the dates of first key
    NSLog(@"%@",firstArrayOfDates);

    NSArray *twoMemberArray = [self FindWeekNumberOfDate:firstArrayOfDates];                        //to get the array of month number
    
    NSArray *finalFormattedMonthNam = [twoMemberArray objectAtIndex:1];                             //Contains the array of month number
    
    //month name based array----------------------------------------------------------------
    
    NSArray *keyMonthArray = [self GetMonthNameFromNumber:finalFormattedMonthNam];                  //Contains the array of month name

    NSArray *reverseOrders = [self sortValuesOfKeysInOrder:keyTopicsDic withArray:changeOverInputArray];
    NSLog(@"%@",reverseOrders);                                                  //the array with brand and its values
    reverseOrderBkUp = [NSMutableArray arrayWithArray:reverseOrders];
    NSMutableArray *trialArrayTwo = [[NSMutableArray alloc] init];                //contains the values of keys in sorted form

    for (int i =0;i<firstArrayOfDates.count;i++) {
    NSString *firstgey = [NSString stringWithFormat:@"%@",[firstArrayOfDates objectAtIndex:i]];
        NSMutableArray *arrayCodigos;
        @try {
            arrayCodigos = [NSMutableArray arrayWithArray:[reverseOrders valueForKey:firstgey]];

        }
        @catch (NSException *exception) {
            NSLog(@"");
        }
        @finally {
            NSLog(@"");

        }
    NSLog(@"arrayCodigos %@", arrayCodigos);
    [trialArrayTwo addObject:arrayCodigos];
    }
    
    
    
    NSLog(@"%@",trialArrayTwo);                                                  //the array with brand and its values
    NSLog(@"%@",keyTopicsDic);                                                   //the array with brand and its values

    
    
    
    
    
        NSMutableArray *XValueWithBrands = [[NSMutableArray alloc]init];   //the final array with brands
    
        //loop to iterate untill all the brand names and its corresponding values are obtained-------------------------------------------------------------------------
    
        for (int m = 0; m<finalFormattedMonthNam.count; m++) {
        
            NSArray *initXValueWithBrands = [NSArray arrayWithArray:changeOverInputArray];
            [XValueWithBrands addObjectsFromArray:initXValueWithBrands];
    
        }
        
        NSLog(@"%@",XValueWithBrands);

    NSMutableArray *finalValueArray = [[NSMutableArray alloc]init];
    for (NSDictionary *interMed in reverseOrders) {
        NSLog(@"%@",interMed);
        NSArray *firstArray=[self sortKeysInOrder:interMed];   //contains the keys in sorted form
        NSLog(@"%@",firstArray);

        NSArray *secArray = [self sortValuesOfKeysInOrder:interMed withArray:firstArray];
        NSLog(@"%@",secArray);                                                  //the array with brand and its values
//        [finalValueArray addObjectsFromArray:secArray];
        [finalValueArray addObject:secArray];
        
    }
    NSLog(@"%@",finalValueArray);                                                  //the array with brand and its values



    
    
    if(keyTopicsDic.count != 0) {//defining the x and y values finally for plotting in the stacked bar chart
        monthArray = [NSArray arrayWithArray:keyMonthArray];
        ValueArray = [NSArray arrayWithArray:finalValueArray];
        int countVal = (int)monthArray.count;
        NSLog(@"multiple chart reverse order:%@",changeOverInputArray);
        [self plotMultipleBarChart:countVal range:8 withBrands:changeOverInputArray];
    }

    
    
    
}

-(void)afterFetchingTopSourcesInfo:(id)sender{
    
    NSNotification *notification = sender;
    NSDictionary *mediaTypeInfoDic = [[notification userInfo] objectForKey:@"TopSourcesInfo"];
    NSLog(@"%@",mediaTypeInfoDic);
    NSDictionary *keyTopicsDic = NULL_TO_NIL([mediaTypeInfoDic objectForKey:@"outletMapTonality"]);
    
    NSMutableArray *XValueWithBrands = [[NSMutableArray alloc]init];   //the final array with brands
    NSMutableArray *YValueForBrands = [[NSMutableArray alloc]init];    //the final array with brand's values
    
    //loop to iterate untill all the brand names and its corresponding values are obtained-------------------------------------------------------------------------
        
        NSDictionary *dataDictionary = keyTopicsDic;
    
        NSArray *xyDictionary = [self GetSortedXvalueAndYvalueForStackedBarChart:dataDictionary];
        NSLog(@"%@",xyDictionary);

        NSArray *initXValueWithBrands = [xyDictionary objectAtIndex:0];
        NSArray *initYValueForBrands  = [xyDictionary objectAtIndex:1];
        [XValueWithBrands addObjectsFromArray:initXValueWithBrands];
        [YValueForBrands addObjectsFromArray:initYValueForBrands];
        
   // }
    
    NSLog(@"%@",XValueWithBrands);
    NSLog(@"%@",initYValueForBrands);


    //loop to iterate untill all the brand names and its corresponding values are obtained-------------------------------------------------------------------------
    if(keyTopicsDic.count != 0) {//defining the x and y values finally for plotting in the stacked bar chart
        monthArray = [NSArray arrayWithArray:XValueWithBrands];
        ValueArray = [NSArray arrayWithArray:YValueForBrands];
        int countVal = (int)monthArray.count;
        
        [self plotStackedHorizontalBarChart:countVal range:countVal];
    }

    

}

-(void)afterFetchingTopJournalistInfo:(id)sender{
    NSNotification *notification = sender;
    NSDictionary *mediaTypeInfoDic = [[notification userInfo] objectForKey:@"TopJournalistInfo"];
    NSLog(@"%@",mediaTypeInfoDic);
    NSDictionary *keyTopicsDic = NULL_TO_NIL([mediaTypeInfoDic objectForKey:@"contactMapTonality"]);
    
    NSMutableArray *XValueWithBrands = [[NSMutableArray alloc]init];   //the final array with brands
    NSMutableArray *YValueForBrands = [[NSMutableArray alloc]init];    //the final array with brand's values
    
    //loop to iterate untill all the brand names and its corresponding values are obtained-------------------------------------------------------------------------
    
    NSDictionary *dataDictionary = keyTopicsDic;
    
    NSArray *xyDictionary = [self GetSortedXvalueAndYvalueForStackedBarChart:dataDictionary];
    NSLog(@"%@",xyDictionary);

    NSArray *initXValueWithBrands = [xyDictionary objectAtIndex:0];
    NSArray *initYValueForBrands  = [xyDictionary objectAtIndex:1];
    [XValueWithBrands addObjectsFromArray:initXValueWithBrands];
    [YValueForBrands addObjectsFromArray:initYValueForBrands];
    
    // }
    
    NSLog(@"%@",XValueWithBrands);
    
    
    //loop to iterate untill all the brand names and its corresponding values are obtained-------------------------------------------------------------------------
    if(keyTopicsDic.count != 0) {//defining the x and y values finally for plotting in the stacked bar chart
        monthArray = [NSArray arrayWithArray:XValueWithBrands];
        ValueArray = [NSArray arrayWithArray:YValueForBrands];
        int countVal = (int)monthArray.count;
        
        [self plotStackedHorizontalBarChart:countVal range:countVal];
    }

}


-(void)afterFetchingTopInfluencerInfo:(id)sender{
    NSNotification *notification = sender;
    NSDictionary *mediaTypeInfoDic = [[notification userInfo] objectForKey:@"TopInfluencerInfo"];
    NSLog(@"%@",mediaTypeInfoDic);
    NSDictionary *keyTopicsDic = NULL_TO_NIL([mediaTypeInfoDic objectForKey:@"outletInfluencerTonalityMap"]);
    
    NSMutableArray *XValueWithBrands = [[NSMutableArray alloc]init];   //the final array with brands
    NSMutableArray *YValueForBrands = [[NSMutableArray alloc]init];    //the final array with brand's values
    
    //loop to iterate untill all the brand names and its corresponding values are obtained-------------------------------------------------------------------------
    
    NSDictionary *dataDictionary = keyTopicsDic;
    
    NSArray *xyDictionary = [self GetSortedXvalueAndYvalueForStackedBarChart:dataDictionary];
    NSLog(@"%@",xyDictionary);

    NSArray *initXValueWithBrands = [xyDictionary objectAtIndex:0];
    NSArray *initYValueForBrands  = [xyDictionary objectAtIndex:1];
    [XValueWithBrands addObjectsFromArray:initXValueWithBrands];
    [YValueForBrands addObjectsFromArray:initYValueForBrands];
    
    // }
    
    NSLog(@"%@",XValueWithBrands);
    
    
    //loop to iterate untill all the brand names and its corresponding values are obtained-------------------------------------------------------------------------
    if(keyTopicsDic.count != 0) {//defining the x and y values finally for plotting in the stacked bar chart
        monthArray = [NSArray arrayWithArray:XValueWithBrands];
        ValueArray = [NSArray arrayWithArray:YValueForBrands];
        int countVal = (int)monthArray.count;
        
        [self plotStackedHorizontalBarChart:countVal range:countVal];
    }
}


-(void)afterFetchingTopStoriesInfo:(id)sender{
    NSNotification *notification = sender;
    NSArray *topStoriesInfoArray = [[notification userInfo] objectForKey:@"TopStoriesInfo"];
    NSLog(@"afterFetchingTopStoriesInfo %@",topStoriesInfoArray);
    chartStoryList = [[NSMutableArray alloc]initWithArray:topStoriesInfoArray];
    articleIdArray =[chartStoryList valueForKeyPath:@"id"];
    [self.storyTableView reloadData];
    
}



-(void)settingsButtonFilter{


    UIStoryboard *storyboard;
    TopStoriesViewController *chartView;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        storyboard = [UIStoryboard storyboardWithName:@"ChartViewControlleriPhone" bundle:nil];
        chartView = [storyboard instantiateViewControllerWithIdentifier:@"TopStoriesViewController"];
        chartView.devices = [NSMutableArray arrayWithArray:chartStoryList];
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
    cell.titleLabel.text = NULL_TO_NIL([dic objectForKey:@"heading"]);
    headingArray = NULL_TO_NIL([dic objectForKey:@"heading"]);
    //Fetching contact details
    NSString *contactName;
    NSArray *contactArray = NULL_TO_NIL([dic objectForKey:@"contact"]);
    if(contactArray.count != 0){
        NSDictionary *contactDic = [contactArray objectAtIndex:0];
        contactName = [NSString stringWithFormat:@"%@,",NULL_TO_NIL([contactDic objectForKey:@"name"])];
    } else {
        contactName = @"";
    }
    
    //Fetching outlet details
    NSString *outletName;
    NSArray *outletArray = NULL_TO_NIL([dic objectForKey:@"outlet"]);
    if(outletArray.count != 0){
        NSDictionary *outletDic = [outletArray objectAtIndex:0];
        outletName = [NSString stringWithFormat:@"%@",NULL_TO_NIL([outletDic objectForKey:@"name"])];
    } else {
        outletName = @"";
    }
    
    NSString *contactOutletString = [NSString stringWithFormat:@"%@%@",contactName,outletName];
    
    cell.outletLabel.text = contactOutletString;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyBoard;
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        storyBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListViewPhone" bundle:nil];
        
    } else {
        storyBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];
        
    }
   
    
    NSDictionary *dic;
    
    dic = [chartStoryList objectAtIndex:indexPath.row];
    
    CorporateNewsDetailsView *testView;
    testView = [storyBoard instantiateViewControllerWithIdentifier:@"UpgradeView"];
    testView.forTopStories = [NSNumber numberWithInt:1];
   // testView.articleTitle = NULL_TO_NIL([dic objectForKey:@"heading"]);
    testView.currentIndex = indexPath.row;
    testView.selectedIndexPath = indexPath;
    testView.selectedNewsArticleId = [dic objectForKey:@"id"];
   // testView.articleIdFromSearchLst =[NSMutableArray arrayWithArray:articleIdArray];
    [self.navigationController pushViewController:testView animated:YES];
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
    
    
    //for default description text
    ReportTypeObject *reportTypeforFirstTime = [reportObject.reportTypeArray objectAtIndex:0];
    NSString *descriptionText = [NSString stringWithFormat:@"%@",reportTypeforFirstTime.reportSummary];
    descText = [[NSAttributedString alloc]initWithData:[descriptionText dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
  

    if ([chartType.chartTyepId isEqualToNumber:[NSNumber numberWithInt:1]]) {
        //Pie Chart - Key Topics
            cell.chartIconImage.image = [UIImage imageNamed:[chartIcon objectAtIndex:1]];
    }
    else if ([chartType.chartTyepId isEqualToNumber:[NSNumber numberWithInt:2]]){
        //Bar Chart - Sentiment and Volume Over Time
        cell.chartIconImage.image = [UIImage imageNamed:[chartIcon objectAtIndex:3]];

    }
    else if ([chartType.chartTyepId isEqualToNumber:[NSNumber numberWithInt:3]]){
        //Line Chart - Trend of Coverage
        cell.chartIconImage.image = [UIImage imageNamed:[chartIcon objectAtIndex:0]];

    }
    else if ([chartType.chartTyepId isEqualToNumber:[NSNumber numberWithInt:4]]){
        //Donut Chart - Media Types
        cell.chartIconImage.image = [UIImage imageNamed:[chartIcon objectAtIndex:2]];

    }
    else if ([chartType.chartTyepId isEqualToNumber:[NSNumber numberWithInt:5]]){
        //MutliBar Chart - Change Over Last Quarter
        cell.chartIconImage.image = [UIImage imageNamed:[chartIcon objectAtIndex:3]];

    }
    else if ([chartType.chartTyepId isEqualToNumber:[NSNumber numberWithInt:6]]){
        //Horizontal Bar Chart - Top Sources
        cell.chartIconImage.image = [UIImage imageNamed:[chartIcon objectAtIndex:5]];

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
    [reverseOrderBkUp removeAllObjects];
    [reverseOrdersBkUp removeAllObjects];
    ReportTypeObject *reportType = [reportObject.reportTypeArray objectAtIndex:indexPath.row];
    ChartTypeObject *chartType = reportType.chartTypeObject;

    NSString *descriptionText = [NSString stringWithFormat:@"%@",reportType.reportSummary];
    descText = [[NSAttributedString alloc]initWithData:[descriptionText dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    NSLog(@"%@",descText);
    NSLog(@"%@",[descText string]);


    ChartIconCell *cell = (ChartIconCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.chartIconImage.image = [UIImage imageNamed:[selectedChatIcon objectAtIndex:indexPath.row]];
    
    
  //  typeOfChart = (int) indexPath.row;
    NSLog(@"report type:%@",reportType.reportTyepId);
    NSLog(@"report chart type:%@",reportType.reportChartTyepId);
    NSLog(@"%@",chartType.chartTyepId);
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        self.chartNameLabel.text =[chartName objectAtIndex:indexPath.row];
    }
    else{
        _titleLabel.text =[chartName objectAtIndex:indexPath.row];
    }
    
    if([localReportTypeId isEqualToNumber:reportType.reportChartTyepId]) {
        
    } else {
        [self loadChartValuesWithReportType:reportType.reportChartTyepId withAPILink:reportType.apiLink];
    }
    
    localReportTypeId = reportType.reportChartTyepId;
    
}

-(void)loadChartValuesWithReportType:(NSNumber*)reportType withAPILink:(NSString *)apiLink{
    if ([reportType isEqualToNumber:[NSNumber numberWithInt:1]]) {
        // Select Trend of Coverage Chart
        [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"Click Trend of Coverage"];
        [[FISharedResources sharedResourceManager]getTrendOfCoverageChartInfoFromDate:reportObject.reportFromDate toDate:reportObject.reportToDate withAPILink:apiLink];
        
    } else if ([reportType isEqualToNumber:[NSNumber numberWithInt:2]]){
        // Select Key Types Chart
        [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"Click Key Topics"];
        [self collectionView:_chartIconCollectionView didDeselectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [[FISharedResources sharedResourceManager]getKeyTopicsChartInfoFromDate:reportObject.reportFromDate toDate:reportObject.reportToDate withAPILink:apiLink];
       
    } else if ([reportType isEqualToNumber:[NSNumber numberWithInt:3]]){
        // Select Media Types chart
        [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"Click Media Types"];
        [self collectionView:_chartIconCollectionView didDeselectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [[FISharedResources sharedResourceManager]getMediaTypeChartInfoFromDate:reportObject.reportFromDate toDate:reportObject.reportToDate withAPILink:apiLink];
    } else if ([reportType isEqualToNumber:[NSNumber numberWithInt:4]]){
        // Select Sentiment and Volume Over Time chart
        [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"Click Sentiment and Volume Over Time"];
        [self collectionView:_chartIconCollectionView didDeselectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [[FISharedResources sharedResourceManager]getSentimentAndVolumeOverTimeChartInfoFromDate:reportObject.reportFromDate toDate:reportObject.reportToDate withAPILink:apiLink];
    }else if ([reportType isEqualToNumber:[NSNumber numberWithInt:5]]){
        // Select change over last quarter chart
        [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"Click Change Over Last Quarter"];
        [self collectionView:_chartIconCollectionView didDeselectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [[FISharedResources sharedResourceManager]getChangeOverLastQuarterChartInfoFromDate:reportObject.reportFromDate toDate:reportObject.reportToDate withAPILink:apiLink];
    }else if ([reportType isEqualToNumber:[NSNumber numberWithInt:6]]){
        // Select top sources
        [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"Click Top Sources"];
        [self collectionView:_chartIconCollectionView didDeselectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [[FISharedResources sharedResourceManager]getTopSourcesChartInfoFromDate:reportObject.reportFromDate toDate:reportObject.reportToDate withAPILink:apiLink];
    } else if([reportType isEqualToNumber:[NSNumber numberWithInt:7]]) {
        //select top journalist
        [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"Click Top Journalists"];
        [self collectionView:_chartIconCollectionView didDeselectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [[FISharedResources sharedResourceManager]getTopJournalistChartInfoFromDate:reportObject.reportFromDate toDate:reportObject.reportToDate withAPILink:apiLink];
    } else if([reportType isEqualToNumber:[NSNumber numberWithInt:8]]) {
        //select top influencers
        [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"Click Top Influencers"];
        [self collectionView:_chartIconCollectionView didDeselectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [[FISharedResources sharedResourceManager]getTopInfluencerChartInfoFromDate:reportObject.reportFromDate toDate:reportObject.reportToDate withAPILink:apiLink];
    }
}

- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath
                     animated:(BOOL)animated
               scrollPosition:(UICollectionViewScrollPosition)scrollPosition{


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
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChartIconCell *cell = (ChartIconCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.chartIconImage.image = [UIImage imageNamed:[chartIcon objectAtIndex:indexPath.row]];

}


#pragma mark - Plot Chart

- (void)plotPieChart:(int)count range:(double)range withType:(int)typeOfPieChart
{
    [_chartViewOutline.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    NSLog(@"%f,%f",widthOfChartViewOutline,heightOfChartViewOutline);
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        pieViews = [[PieChartView alloc] initWithFrame:CGRectMake(30, 30, self.view.frame.size.width-30,  self.view.frame.size.height-260)];
        
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
    
    if (ValueArray.count == 0) {
        horizontalBarViews.noDataText = @"Chart Data not available";
        
    }
    else{

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
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithYVals:yVals label:@""];
    dataSet.sliceSpace = 0;
    
    // add a lot of colors
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
//    [colors addObject:[UIColor colorWithRed:49/255.f green:119/255.f blue:183/255.f alpha:1.f]];
//    [colors addObject:[UIColor colorWithRed:117/255.f green:119/255.f blue:234/255.f alpha:1.f]];
//    [colors addObject:[UIColor colorWithRed:247/255.f green:127/255.f blue:0/255.f alpha:1.f]];
//    [colors addObject:[UIColor colorWithRed:250/255.f green:187/255.f blue:113/255.f alpha:1.f]];
//    [colors addObject:[UIColor colorWithRed:66/255.f green:187/255.f blue:113/255.f alpha:1.f]];
//    [colors addObject:[UIColor colorWithRed:201/255.f green:218/255.f blue:248/255.f alpha:1.f]];
//    [colors addObject:[UIColor colorWithRed:247/255.f green:127/255.f blue:0/255.f alpha:1.f]];
    for(int i=0;i<count;i++) {
        [colors addObject:[self randomColor]];
        
    }
    
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
    if (typeOfPieChart == 1) {
        [pieViews setDrawHoleEnabled:NO];
        
    }
    else{
        [pieViews setDrawHoleEnabled:YES];
    }
    [pieViews highlightValues:nil];
    }
}
- (void)plotBarChart:(int)count range:(double)range
{
    [_chartViewOutline.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        barViews = [[BarChartView alloc] initWithFrame:CGRectMake(30, 30, self.view.frame.size.width-30,  self.view.frame.size.height-260)];
        
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
    barViews.delegate = self;
    [_chartViewOutline addSubview:barViews];
    
    [barViews animateWithYAxisDuration:1.0];
    if (ValueArray.count == 0) {
        horizontalBarViews.noDataText = @"Chart Data not available";
        
    }
    else{

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
}
- (void)plotMultipleBarChart:(int)count range:(double)range withBrands:(NSArray *)inputArray
{
    [_chartViewOutline.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        barViews = [[BarChartView alloc] initWithFrame:CGRectMake(30, 30, self.view.frame.size.width-30,  self.view.frame.size.height-260)];
        
    }
    else{
        barViews = [[BarChartView alloc] initWithFrame:CGRectMake(0, 0, self.chartViewOutline.frame.size.width-10, self.chartViewOutline.frame.size.height-10)];
    }
    barViews.backgroundColor = [UIColor whiteColor];
    
    barViews.drawBordersEnabled = NO;
    barViews.leftAxis.valueFormatter = [[NSNumberFormatter alloc]init];
    barViews.leftAxis.valueFormatter.minimumFractionDigits = 0;
//    barViews.leftAxis.drawAxisLineEnabled = NO;
    barViews.leftAxis.drawGridLinesEnabled = NO;
    barViews.rightAxis.drawAxisLineEnabled = NO;
    barViews.rightAxis.drawGridLinesEnabled = NO;
//    barViews.xAxis.drawAxisLineEnabled = NO;
    barViews.xAxis.drawGridLinesEnabled = NO;
    barViews.drawGridBackgroundEnabled = NO;
    barViews.dragEnabled = YES;
    barViews.rightAxis.drawLabelsEnabled = NO;
    barViews.descriptionText =@"";
    barViews.legend.position = ChartLegendPositionBelowChartCenter;
    [barViews setScaleEnabled:YES];
    barViews.pinchZoomEnabled = YES;
    barViews.xAxis.labelPosition = XAxisLabelPositionBottom;
    barViews.xAxis.labelRotationAngle =90;
    barViews.delegate = self;
    [_chartViewOutline addSubview:barViews];
    
    [barViews animateWithYAxisDuration:1.0];
    
    if (ValueArray.count == 0) {
        horizontalBarViews.noDataText = @"Chart Data not available";
        
    }
    else{

    NSLog(@"%@",ValueArray);
    NSLog(@"%@",monthArray);
    
    
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        [xVals addObject:monthArray[i % monthArray.count]];
    }
    
    NSLog(@"%@",xVals);

    
        NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
        NSArray *oneValArray = [ValueArray objectAtIndex:0];
        for (int i = 0; i < oneValArray.count; i++)
        {
            double secYVal = [[oneValArray objectAtIndex:i] doubleValue];
            [yVals1 addObject:[[BarChartDataEntry alloc] initWithValue:secYVal xIndex:i]];

        }

        NSMutableArray *yVals2 = [[NSMutableArray alloc] init];
        NSArray *oneValArray2 = [ValueArray objectAtIndex:1];
        for (int i = 0; i < oneValArray2.count; i++)
        {
            double secYVal = [[oneValArray2 objectAtIndex:i] doubleValue];
            [yVals2 addObject:[[BarChartDataEntry alloc] initWithValue:secYVal xIndex:i]];
        
        }

        NSMutableArray *yVals3 = [[NSMutableArray alloc] init];
        NSArray *oneValArray3 = [ValueArray objectAtIndex:2];
        for (int i = 0; i < oneValArray3.count; i++)
        {
            double secYVal = [[oneValArray3 objectAtIndex:i] doubleValue];
            [yVals3 addObject:[[BarChartDataEntry alloc] initWithValue:secYVal xIndex:i]];
        
        }
    
        NSMutableArray *yVals4 = [[NSMutableArray alloc] init];
        NSArray *oneValArray4 = [ValueArray objectAtIndex:3];
        for (int i = 0; i < oneValArray4.count; i++)
        {
            double secYVal = [[oneValArray4 objectAtIndex:i] doubleValue];
            [yVals4 addObject:[[BarChartDataEntry alloc] initWithValue:secYVal xIndex:i]];
        
        }
    
        NSMutableArray *yVals5 = [[NSMutableArray alloc] init];
        NSArray *oneValArray5 = [ValueArray objectAtIndex:4];
        for (int i = 0; i < oneValArray5.count; i++)
        {
            double secYVal = [[oneValArray5 objectAtIndex:i] doubleValue];
            [yVals5 addObject:[[BarChartDataEntry alloc] initWithValue:secYVal xIndex:i]];
            
        }
    
    NSMutableArray *yVals6 = [[NSMutableArray alloc] init];
    NSArray *oneValArray6 = [ValueArray objectAtIndex:5];
    for (int i = 0; i < oneValArray6.count; i++)
    {
        double secYVal = [[oneValArray6 objectAtIndex:i] doubleValue];
        [yVals6 addObject:[[BarChartDataEntry alloc] initWithValue:secYVal xIndex:i]];
        
    }
    
    NSMutableArray *yVals7 = [[NSMutableArray alloc] init];
    NSArray *oneValArray7 = [ValueArray objectAtIndex:6];
    for (int i = 0; i < oneValArray7.count; i++)
    {
        double secYVal = [[oneValArray7 objectAtIndex:i] doubleValue];
        [yVals7 addObject:[[BarChartDataEntry alloc] initWithValue:secYVal xIndex:i]];
        
    }
    
    NSLog(@"%@",yVals1);
    NSLog(@"%@",yVals2);
    NSLog(@"%@",yVals3);
    NSLog(@"%@",yVals4);
    NSLog(@"%@",yVals5);
    NSLog(@"%@",yVals6);
    NSLog(@"%@",yVals7);



    
    BarChartDataSet *set1 = [[BarChartDataSet alloc] initWithYVals:yVals1 label:[inputArray objectAtIndex:0]];
    [set1 setColor:[UIColor colorWithRed:98/255.f green:163/255.f blue:206/255.f alpha:1.f]];
    
    BarChartDataSet *set2 = [[BarChartDataSet alloc] initWithYVals:yVals2 label:[inputArray objectAtIndex:1]];
    [set2 setColor:[UIColor colorWithRed:201/255.f green:218/255.f blue:240/255.f alpha:1.f]];
    
    BarChartDataSet *set3 = [[BarChartDataSet alloc] initWithYVals:yVals3 label:[inputArray objectAtIndex:2]];
    [set3 setColor:[UIColor colorWithRed:255/255.f green:169/255.f blue:84/255.f alpha:1.f]];
    
    BarChartDataSet *set4 = [[BarChartDataSet alloc] initWithYVals:yVals4 label:[inputArray objectAtIndex:3]];
    [set4 setColor:[UIColor colorWithRed:255/255.f green:210/255.f blue:164/255.f alpha:1.f]];
    
    BarChartDataSet *set5 = [[BarChartDataSet alloc] initWithYVals:yVals5 label:[inputArray objectAtIndex:4]];
    [set5 setColor:[UIColor colorWithRed:108/255.f green:192/255.f blue:108/255.f alpha:1.f]];

    BarChartDataSet *set6 = [[BarChartDataSet alloc] initWithYVals:yVals6 label:[inputArray objectAtIndex:5]];
    [set6 setColor:[UIColor colorWithRed:186/255.f green:234/255.f blue:176/255.f alpha:1.f]];
    
    BarChartDataSet *set7 = [[BarChartDataSet alloc] initWithYVals:yVals7 label:[inputArray objectAtIndex:6]];
    [set7 setColor:[UIColor colorWithRed:228/255.f green:104/255.f blue:105/255.f alpha:1.f]];

    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    [dataSets addObject:set2];
    [dataSets addObject:set3];
    [dataSets addObject:set4];
    [dataSets addObject:set5];
    [dataSets addObject:set6];
    [dataSets addObject:set7];

    BarChartData *data = [[BarChartData alloc] initWithXVals:xVals dataSets:dataSets];    
    barViews.data = data;
    }
}



- (void)plotStackedBarChart:(int)count range:(double)range
{
    
    
    [_chartViewOutline.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        barViews = [[BarChartView alloc] initWithFrame:CGRectMake(30, 30, self.view.frame.size.width-30,  self.view.frame.size.height-260)];
        barViews.xAxis.labelRotationAngle =-50;
        [barViews.xAxis setLabelsToSkip:0];

    }
    else{
        barViews = [[BarChartView alloc] initWithFrame:CGRectMake(0, 0, self.chartViewOutline.frame.size.width-10, self.chartViewOutline.frame.size.height-10)];
        
    }
    barViews.backgroundColor = [UIColor whiteColor];
    
    barViews.drawBordersEnabled = NO;
    barViews.leftAxis.valueFormatter = [[NSNumberFormatter alloc]init];
    barViews.leftAxis.valueFormatter.minimumFractionDigits = 0;
//    barViews.leftAxis.drawAxisLineEnabled = NO;
    barViews.leftAxis.drawGridLinesEnabled = NO;
    barViews.rightAxis.drawAxisLineEnabled = NO;
    barViews.rightAxis.drawGridLinesEnabled = NO;
//    barViews.xAxis.drawAxisLineEnabled = NO;
    barViews.xAxis.drawGridLinesEnabled = NO;
    barViews.drawGridBackgroundEnabled = NO;
    barViews.dragEnabled = YES;
    barViews.rightAxis.drawLabelsEnabled = NO;
    barViews.descriptionText =@"";
    barViews.legend.position = ChartLegendPositionBelowChartCenter;
    [barViews setScaleEnabled:YES];
    barViews.pinchZoomEnabled = YES;
    barViews.xAxis.labelPosition = XAxisLabelPositionBottom;
    barViews.delegate = self;
    [_chartViewOutline addSubview:barViews];
    
    [barViews animateWithYAxisDuration:1.0];
    if (ValueArray.count == 0) {
        horizontalBarViews.noDataText = @"Chart Data not available";
        
    }
    else{

    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++){
        
        NSArray *oneValArray = [ValueArray objectAtIndex:i];
        NSLog(@"oneValArray:%@",oneValArray);
        NSArray* reversed = [[oneValArray reverseObjectEnumerator] allObjects];
        NSLog(@"reversed order:%@",reversed);
        [yVals addObject:[[BarChartDataEntry alloc] initWithValues:reversed xIndex:i]];
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
    
    BarChartDataSet *set1 = [[BarChartDataSet alloc] initWithYVals:yVals label:@"-Tonality"];
    set1.drawValuesEnabled = NO;
    set1.stackLabels = @[@"Positive", @"Neutral", @"Negative"];

    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
  
        [colors addObject:[UIColor colorWithRed:64/255.f green:211/255.f blue:133/255.f alpha:1.f]];
        [colors addObject:[UIColor colorWithRed:216/255.f green:216/255.f blue:216/255.f alpha:1.f]];
        [colors addObject:[UIColor colorWithRed:255/255.f green:64/255.f blue:64/255.f alpha:1.f]];

    set1.colors = colors;
    
    BarChartData *data = [[BarChartData alloc] initWithXVals:xVals dataSets:dataSets];
    barViews.data = data;
    }
}


- (void)plotStackedHorizontalBarChart:(int)count range:(double)range
{
    
    
    [_chartViewOutline.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        horizontalBarViews = [[HorizontalBarChartView alloc] initWithFrame:CGRectMake(30, 30, self.view.frame.size.width-30,  self.view.frame.size.height-260)];
        
    }
    else{
        horizontalBarViews = [[HorizontalBarChartView alloc] initWithFrame:CGRectMake(0, 0, self.chartViewOutline.frame.size.width-10, self.chartViewOutline.frame.size.height-10)];
    }
    horizontalBarViews.backgroundColor = [UIColor whiteColor];
    horizontalBarViews.drawBordersEnabled = NO;
    horizontalBarViews.rightAxis.valueFormatter = [[NSNumberFormatter alloc]init];
    horizontalBarViews.rightAxis.valueFormatter.minimumFractionDigits = 0;
    horizontalBarViews.leftAxis.drawGridLinesEnabled = NO;
    horizontalBarViews.leftAxis.drawAxisLineEnabled = NO;
    horizontalBarViews.rightAxis.drawAxisLineEnabled = YES;
    horizontalBarViews.rightAxis.drawGridLinesEnabled = NO;
    horizontalBarViews.xAxis.drawGridLinesEnabled = NO;
    horizontalBarViews.drawGridBackgroundEnabled = NO;
    horizontalBarViews.dragEnabled = YES;
    horizontalBarViews.leftAxis.drawLabelsEnabled = NO;
    //horizontalBarViews.rightAxis.drawLabelsEnabled = NO;
    horizontalBarViews.descriptionText =@"";
    [horizontalBarViews setScaleEnabled:YES];
    horizontalBarViews.pinchZoomEnabled = YES;
    horizontalBarViews.xAxis.wordWrapEnabled = YES;
    horizontalBarViews.delegate = self;
    horizontalBarViews.xAxis.labelPosition = XAxisLabelPositionBottomInside;
   
    [_chartViewOutline addSubview:horizontalBarViews];
    
    [horizontalBarViews animateWithYAxisDuration:1.0];
    NSLog(@"value array:%@",ValueArray);
    if (ValueArray.count == 0) {
        horizontalBarViews.noDataText = @"Chart Data not available";
        
    }
    else{
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++){
        
        NSArray *oneValArray = [ValueArray objectAtIndex:i];
        NSLog(@"for loop%@",oneValArray);
        NSArray* reversed = [[oneValArray reverseObjectEnumerator] allObjects];
        NSLog(@"reversed order:%@",reversed);
        [yVals addObject:[[BarChartDataEntry alloc] initWithValues:reversed xIndex:i]];
    }
    NSLog(@"value array:%@",monthArray);

    for (int i = 0; i < count; i++)
    {
        NSLog(@"%@",monthArray[i % monthArray.count]);

        [xVals addObject:monthArray[i % monthArray.count]];
    }

    BarChartDataSet *set1 = [[BarChartDataSet alloc] initWithYVals:yVals label:@"-Tonality"];
    set1.drawValuesEnabled = NO;
    set1.stackLabels = @[@"Positive", @"Neutral", @"Negative"];
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    
    [colors addObject:[UIColor colorWithRed:64/255.f green:211/255.f blue:133/255.f alpha:1.f]];
    [colors addObject:[UIColor colorWithRed:216/255.f green:216/255.f blue:216/255.f alpha:1.f]];
    [colors addObject:[UIColor colorWithRed:255/255.f green:64/255.f blue:64/255.f alpha:1.f]];
    
    set1.colors = colors;
    
    BarChartData *data = [[BarChartData alloc] initWithXVals:xVals dataSets:dataSets];
    horizontalBarViews.data = data;
    }
}




- (void)plotLineChart:(int)count range:(double)range
{
    [_chartViewOutline.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        lineChartView = [[LineChartView alloc] initWithFrame:CGRectMake(30, 30, self.topStoriesViewLeadingConstraint.constant-30,  self.view.frame.size.height-260)];
        
        NSLog(@"line chart view width:%f and %f",self.topStoriesViewLeadingConstraint.constant,self.topStoriesViewLeadingConstraint.constant-30);
        
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
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    [pFormatter setPositiveFormat:@"0K"];
    [pFormatter setMultiplier:[NSNumber numberWithDouble:0.001]];
    [lineChartView.rightAxis setValueFormatter:pFormatter];
    lineChartView.leftAxis.drawAxisLineEnabled = NO;
    //    lineChartView.rightAxis.drawAxisLineEnabled = NO;
    lineChartView.xAxis.drawAxisLineEnabled = NO;
    lineChartView.xAxis.drawGridLinesEnabled = NO;
    //    lineChartView.rightAxis.drawLabelsEnabled = NO;
    lineChartView.drawGridBackgroundEnabled = NO;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        lineChartView.xAxis.labelRotationAngle =90;
    }
    
    //set limit for left axis **************************************************
    //
    
    NSLog(@"%@",ValueArray);
    NSLog(@"%@",ValueArrayTwo);
    
    //    lineChartView.rightAxis.customAxisMax = [[ValueArrayTwo lastObject] doubleValue];
    //    lineChartView.rightAxis.customAxisMin = [[ValueArrayTwo firstObject] doubleValue];
    //
    //    NSLog(@"left max:%f and min:%f",[[ValueArray lastObject] doubleValue],[[ValueArray firstObject] doubleValue]);
    //    lineChartView.leftAxis.customAxisMax = [[ValueArray lastObject] doubleValue];
    //    lineChartView.leftAxis.customAxisMin = [[ValueArray firstObject] doubleValue];
    
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
    
    [lineChartView animateWithXAxisDuration:1.0];
    
    //animations------------------------------------------------------------------------
    if (ValueArray.count == 0) {
        horizontalBarViews.noDataText = @"Chart Data not available";
        
    }
    else{

    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        [xVals addObject:monthArray[i % monthArray.count]];
    }
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    ChartHighlight *chLightsOne;
    for (int i = 0; i < count; i++)
    {
        [values addObject:[[ChartDataEntry alloc] initWithValue:[[ValueArrayTwo objectAtIndex:i] doubleValue] xIndex:i]];
        chLightsOne = [[ChartHighlight alloc] initWithXIndex:i dataSetIndex:i];
        
    }
    
    NSLog(@"circulation values:%@",values);
    
    
    NSMutableArray *valuesTwo = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++)
    {
        [valuesTwo addObject:[[ChartDataEntry alloc] initWithValue:[[ValueArray objectAtIndex:i] doubleValue] xIndex:i]];
    }
    
    NSLog(@"%@",valuesTwo);
    NSLog(@"%@",ValueArray);
    NSLog(@"%@",ValueArrayTwo);
    
    
    
    LineChartDataSet *d = [[LineChartDataSet alloc] initWithYVals:values label:[NSString stringWithFormat:@"Circulation"]];
    d.lineWidth = 5.0;
    d.circleRadius = 4.0;
    
    [d setColor:[UIColor colorWithRed:74/255.f green:126/255.f blue:187/255.f alpha:1.f]];
    [d setCircleColor:[UIColor blackColor]];
    [dataSets addObject:d];
    
    LineChartDataSet *ds = [[LineChartDataSet alloc] initWithYVals:valuesTwo label:[NSString stringWithFormat:@"Articles"]];
    ds.axisDependency = AxisDependencyRight;
    ds.lineWidth = 5.0;
    ds.circleRadius = 4.0;
    [ds setColor:[UIColor colorWithRed:189/255.f green:74/255.f blue:71/255.f alpha:1.f]];
    
    [ds setCircleColor:[UIColor blackColor]];
    [dataSets addObject:ds];
    NSLog(@"%lu",(unsigned long)[dataSets count]);
    
    LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSets:dataSets];
    
    
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:7.f]];
    lineChartView.data = data;
    //    ChartHighlight *chLightsOne = [[ChartHighlight alloc] initWithXIndex:0 dataSetIndex:0];
    //ChartHighlight *chLightsTwo = [[ChartHighlight alloc] initWithXIndex:0 dataSetIndex:1];
    //ChartHighlight *chLightsThree = [[ChartHighlight alloc] initWithXIndex:0 dataSetIndex:2];
    
    [lineChartView highlightValues:@[chLightsOne]];
    }
    
}



- (void)chartScaled:(ChartViewBase * __nonnull)chartView scaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY;
{
    if ([localReportTypeId isEqualToNumber:[NSNumber numberWithInt:1]]) {
//        if(lineChartView.isFullyZoomedOut)
//        {
//            monthArray = [NSArray arrayWithArray:unScaledXvalue];
//            ValueArray = [NSArray arrayWithArray:unScaledYvalue];
//            ValueArrayTwo = [NSArray arrayWithArray:unscaledYvalueTwo];
//            
//            //Trying out month based grouping------------------------------------------------------------------------------
//            
//            
//            
//            int countVal = (int)monthArray.count;
//            [self plotLineChart:countVal range:6];
//            
//            
//        }
//        else{
//            monthArray = [NSArray arrayWithArray:scaledXvalue];
//            ValueArray = [NSArray arrayWithArray:scaledYvalue];
//            ValueArrayTwo = [NSArray arrayWithArray:scaledYvalueTwo];
//            
//            int countVal = (int)monthArray.count;
//            [self plotLineChart:countVal range:6];
//            
//        }
    }
}


-(NSString *)getFinalDateValueForWebService :(NSString *)inputDate{
    NSLog(@"%@",inputDate);
    
    inputDate = [inputDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    inputDate = [inputDate stringByReplacingOccurrencesOfString:@".000Z" withString:@""];
    //NSLog(@"%@",dateInput);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *inpuDateFormat = [dateFormatter dateFromString:inputDate];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    NSString *outputDateFormat = [dateFormatter stringFromDate:inpuDateFormat];
    NSLog(@"%@",outputDateFormat);
    
    return outputDateFormat;
}


- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}


-(void)chartValueSelected:(ChartViewBase *)chartView entry:(ChartDataEntry *)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight *)highlight{
   
    /* This is for close the top stories view */
    [UIView animateWithDuration:0.4
                     animations:^{
                         [self.topStoriesButton setSelected:NO];
                         self.topStoriesButtonLabelWidthConstraint.constant = 9;
                         self.tableOuterView.layer.borderWidth = 0.0f;
                         self.tableOuterView.layer.borderColor = [UIColor lightGrayColor].CGColor;
                         isTopStoriesOpen = NO;
                         self.topStoriesViewLeadingConstraint.constant = self.view.frame.size.width;
                         [self.view layoutIfNeeded];
                         //  [self loadChartValuesWithReportType:localReportTypeId];
                         
                     }];
    
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFolderClick"];//for showing back button
    
    [[FISharedResources sharedResourceManager]clearChartRelatedArticles:@"CuratedNews"];//
    
    NSLog(@"%@ %@ %ld %@",chartView,entry,(long)dataSetIndex,highlight);
    int resultPoint = (int)entry.value;
    NSUInteger indexEntry  = entry.xIndex;
    NSUInteger stackIndex  = highlight.stackIndex;
    NSString *tonalityValue = [[NSString alloc]init];
    NSUInteger dataSetIndexes  = dataSetIndex;
    NSString *clickedDate;
    NSString *nameOfIndexForSentimentChart;
    NSString *trendOfCoverageEndDateIn = @"MONTH";
    NSLog(@"%lu and %lu AND %lu",(unsigned long)indexEntry,(unsigned long)stackIndex,(unsigned long)dataSetIndexes);
    NSString *brandName;
    NSString *changeOverSelectedValue;
    
    if (stackIndex == 0) {
        tonalityValue = [NSString stringWithFormat:@"Positive"];
    }
    else if (stackIndex == 1){
        tonalityValue = [NSString stringWithFormat:@"Neutral"];
        
    }
    else if (stackIndex == 2){
        tonalityValue = [NSString stringWithFormat:@"Negative"];
        
    }
    if([localReportTypeId isEqualToNumber:[NSNumber numberWithInt:1]]) {
       
        //Trend of coverage chart selection
        //for Line chart----------------------------------------------------------------------
        
        NSLog(@"%@",[NSNumber numberWithInt:resultPoint]);
//        NSString *firstObj = [monthArray objectAtIndex:0];
//        if (firstObj.length > 3) {//for Line chart if its for month----------------------------------------------------------------------
//            
//            if ([ValueArray containsObject:[NSNumber numberWithInt:resultPoint]]) {
//                NSUInteger indexA = [ValueArray indexOfObject:[NSNumber numberWithInt:resultPoint]];
//                NSString *intFinals = [monthArray objectAtIndex:indexA];
//                
//                if ([xInputForMonths containsObject:intFinals]) {
//                    NSUInteger indexB = [xInputForMonths indexOfObject:intFinals];
//                    
//                    NSString *dateFinals = [dateArrayToGet objectAtIndex:indexB];
//                    clickedDate = [self getFinalDateValueForWebService:dateFinals];
//                }
//                
//            } else if ([ValueArrayTwo containsObject:[NSNumber numberWithInt:resultPoint]])
//            {
//                NSUInteger indexA = [ValueArrayTwo indexOfObject:[NSNumber numberWithInt:resultPoint]];
//                NSString *intFinals = [monthArray objectAtIndex:indexA];
//                
//                if ([xInputForMonths containsObject:intFinals]) {
//                    NSUInteger indexB = [xInputForMonths indexOfObject:intFinals];
//                    
//                    NSString *dateFinals = [dateArrayToGet objectAtIndex:indexB];
//                    clickedDate = [self getFinalDateValueForWebService:dateFinals];
//                }
//                
//            }
//            
//        }
//        else{                       //for Line chart if its for week----------------------------------------------------------------------
            NSString *dateFinals = [dateArrayToGet objectAtIndex:indexEntry];
            clickedDate = [self getFinalDateValueForWebService:dateFinals];
            
        //}
        [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"Trend of Coverage Article List"];
        //call article api list
        [[FISharedResources sharedResourceManager]getTrendOfCoverageArticleListFromDate:clickedDate endDateIn:trendOfCoverageEndDateIn fromDate:reportObject.reportFromDate toDate:reportObject.reportToDate withSize:[NSNumber numberWithInt:10] withPageNo:[NSNumber numberWithInt:0] withFilterBy:@"" withQuery:@"" withFlag:@"" withLastArticleId:@""];
        
        
    } else if([localReportTypeId isEqualToNumber:[NSNumber numberWithInt:2]]) {
        
        //Key topics chart selection
        
        //if ([ValueArray containsObject:[NSNumber numberWithInt:resultPoint]]) {
           // NSString *indexA = [ValueArray objectAtIndex:indexEntry];
            brandName = [monthArray objectAtIndex:indexEntry];
           
      //  }
    
        NSLog(@"selected brand name:%@",brandName);
        [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"Key Topics Article List"];
        [[FISharedResources sharedResourceManager]getKeyTopicsArticleListFromField1:@"fields.name" value1:brandName fromDate:reportObject.reportFromDate toDate:reportObject.reportToDate withSize:[NSNumber numberWithInt:10] withPageNo:[NSNumber numberWithInt:0] withFilterBy:@"" withQuery:@"" withFlag:@"" withLastArticleId:@""];
    
    } else if([localReportTypeId isEqualToNumber:[NSNumber numberWithInt:3]]) {
        
        //Media types chart selection
        
        if ([ValueArray containsObject:[NSNumber numberWithInt:resultPoint]]) {
            NSUInteger indexA = [ValueArray indexOfObject:[NSNumber numberWithInt:resultPoint]];
            brandName = [monthArray objectAtIndex:indexA];
            NSLog(@"%@",brandName);
        }
        [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"Media Types Article List"];
        [[FISharedResources sharedResourceManager]getMediaTypesArticleListFromMediaTypeField:@"mediaTypeId" mediaTypeValue:brandName fromDate:reportObject.reportFromDate toDate:reportObject.reportToDate withSize:[NSNumber numberWithInt:10] withPageNo:[NSNumber numberWithInt:0] withFilterBy:@"" withQuery:@"" withFlag:@"" withLastArticleId:@""];
        
    } else if([localReportTypeId isEqualToNumber:[NSNumber numberWithInt:4]]) {
        
        //Sentiment and volume over time chart
        NSString *arrayWithxIndex = [ValueArray objectAtIndex:indexEntry];
        NSLog(@"%@",arrayWithxIndex);
        nameOfIndexForSentimentChart = [monthArray objectAtIndex:indexEntry];           //contains name eg. iPhone
        NSString *dateOFIndex = [weaveDateArray objectAtIndex:indexEntry];
        clickedDate = [self getFinalDateValueForWebService:dateOFIndex];
        [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"Sentiment and Volume Over Time Article List"];
        [[FISharedResources sharedResourceManager]getSentimentOverTimeArticleListFromDate:clickedDate endDateIn:@"MONTH" field1:@"tonality.name" field2:@"fields.name" value1:tonalityValue value2:nameOfIndexForSentimentChart fromDate:reportObject.reportFromDate toDate:reportObject.reportToDate withSize:[NSNumber numberWithInt:10] withPageNo:[NSNumber numberWithInt:0] withFilterBy:@"" withQuery:@"" withFlag:@"" withLastArticleId:@""];
        
    } else if([localReportTypeId isEqualToNumber:[NSNumber numberWithInt:5]]) {
        
        //Change over last quarter chart info
        
        changeOverSelectedValue = [reverseOrdersBkUp objectAtIndex:dataSetIndexes];
        NSDictionary *valueArs = [reverseOrderBkUp objectAtIndex:dataSetIndexes];
        
        NSArray *firstArray=[self sortKeysInOrder:valueArs];
    
        NSString *dateAris = [firstArray objectAtIndex:indexEntry];
        clickedDate = [self getFinalDateValueForWebService:dateAris];
        [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"Change Over Last Quarter Article List"];
        [[FISharedResources sharedResourceManager]getChangeOverLastQuarterArticleListFromDate:clickedDate endDateIn:@"MONTH" field1:@"fields.name" value1:changeOverSelectedValue fromDate:reportObject.reportFromDate toDate:reportObject.reportToDate withSize:[NSNumber numberWithInt:10] withPageNo:[NSNumber numberWithInt:0] withFilterBy:@"" withQuery:@"" withFlag:@"" withLastArticleId:@""];
        
    } else if([localReportTypeId isEqualToNumber:[NSNumber numberWithInt:6]]) {
        
        //Top sources chart selection
        
        brandName = [monthArray objectAtIndex:indexEntry];
        NSLog(@"serial:%@",brandAndSerialNumber);
        NSLog(@"%@",[brandAndSerialNumber objectForKey:brandName]);
            NSLog(@"%@",brandName);
        
        NSRange oneRang = [brandName rangeOfString:@" ("];
        brandName = [brandName substringToIndex:oneRang.location];
        NSLog(@"brand name:%@",brandName);
        NSLog(@"values%@",[brandAndSerialNumber objectForKey:brandName]);
        NSArray *brandArray = [brandName componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"-"]];
        NSLog(@"first:%@",[brandArray objectAtIndex:0]);
        brandName = [brandArray objectAtIndex:0];
        [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"Top Source Article List"];
        [[FISharedResources sharedResourceManager]getHorizontalLineBarChartArticleListFromField1:@"tonality.name" field2:@"outlet.id" value1:tonalityValue value2:[brandAndSerialNumber objectForKey:brandName] fromDate:reportObject.reportFromDate toDate:reportObject.reportToDate withSize:[NSNumber numberWithInt:10] withPageNo:[NSNumber numberWithInt:0] withFilterBy:@"" withQuery:@"" withFlag:@"" withLastArticleId:@""];
        
    } else if([localReportTypeId isEqualToNumber:[NSNumber numberWithInt:7]]) {
        
        //Top journalist chart selection
        
        
        //if ([ValueArray containsObject:[NSNumber numberWithInt:resultPoint]]) {
            //NSUInteger indexA = [ValueArray indexOfObject:[NSNumber numberWithInt:resultPoint]];
            brandName = [monthArray objectAtIndex:indexEntry];
            NSLog(@"%@",brandName);
        //}
        
        NSRange oneRang = [brandName rangeOfString:@" ("];
        brandName = [brandName substringToIndex:oneRang.location];
        NSLog(@"brand name:%@",brandName);
        
        [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"Top Journalist Article List"];
        
        [[FISharedResources sharedResourceManager]getHorizontalLineBarChartArticleListFromField1:@"tonality.name" field2:@"contact.id" value1:tonalityValue value2:[brandAndSerialNumber objectForKey:brandName] fromDate:reportObject.reportFromDate toDate:reportObject.reportToDate withSize:[NSNumber numberWithInt:10] withPageNo:[NSNumber numberWithInt:0] withFilterBy:@"" withQuery:@"" withFlag:@"" withLastArticleId:@""];
        
    } else if([localReportTypeId isEqualToNumber:[NSNumber numberWithInt:8]]) {
        
        //Top influencer chart selection
        
       // if ([ValueArray containsObject:[NSNumber numberWithInt:resultPoint]]) {
         //   NSUInteger indexA = [ValueArray indexOfObject:[NSNumber numberWithInt:resultPoint]];
            brandName = [monthArray objectAtIndex:indexEntry];
            NSLog(@"%@",brandName);
        //}
        NSRange oneRang = [brandName rangeOfString:@" ("];
        brandName = [brandName substringToIndex:oneRang.location];
        NSLog(@"brand name:%@",brandName);
        
        [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"Top Influencer Article List"];
        
        [[FISharedResources sharedResourceManager]getHorizontalLineBarChartArticleListFromField1:@"tonality.name" field2:@"outlet.id" value1:tonalityValue value2:[brandAndSerialNumber objectForKey:brandName] fromDate:reportObject.reportFromDate toDate:reportObject.reportToDate withSize:[NSNumber numberWithInt:10] withPageNo:[NSNumber numberWithInt:0] withFilterBy:@"" withQuery:@"" withFlag:@"" withLastArticleId:@""];
        
    }

    UIStoryboard *centerStoryBoard;
    CorporateNewsListView *listView;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        centerStoryBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListViewPhone" bundle:nil];
        listView = [centerStoryBoard instantiateViewControllerWithIdentifier:@"CorporateNewsListViewPhone"];
    } else {
        centerStoryBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];
        listView = [centerStoryBoard instantiateViewControllerWithIdentifier:@"CorporateNewsListView"];
    }
    listView.reportTypeId = localReportTypeId;
    listView.clickedDate = clickedDate;
    listView.reportFromDate = reportObject.reportFromDate;
    listView.reportToDate = reportObject.reportToDate;
    listView.trendOfCoverageEndDateIn = trendOfCoverageEndDateIn;
    listView.keyTopicsBrandName = brandName;
    listView.mediaTypesBrandName = brandName;
    
    listView.sentimentChartTonalityValue = tonalityValue;
    listView.sentimentChartSelectedName = nameOfIndexForSentimentChart;
    
    listView.changeOverSelectedValue = changeOverSelectedValue;
    
    listView.horizontalBarChartTonalityValue = tonalityValue;
    listView.horizontalBarChartSelectedValue = brandName;
    
    [self.navigationController pushViewController:listView animated:YES];
    


//  id member = [ValueArray indexOfObject:vals];
}

//NSLog(@"%lu",(unsigned long)[ValueArray indexOfObject:[NSNumber numberWithDouble:entry.value]]);
//NSString *vals = [NSString stringWithFormat:@"%f",entry.value];
//NSUInteger anIndex=[ValueArray indexOfObject:vals];
//NSLog(@"%@",dateArrayToGet);
//int vali= (int)anIndex;
//NSLog(@"%@",[dateArrayToGet objectAtIndex:vali]);
#pragma mark - Rest of the Code




- (UIColor *)randomColor
{
    
    CGFloat red = arc4random() % 255 / 255.0;
    CGFloat green = arc4random() % 255 / 255.0;
    CGFloat blue = arc4random() % 255 / 255.0;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    UIColor *lightColor = [self darkerColorForColor:color];
    
    NSLog(@"Color:%@", color);
    return lightColor;
}

-(NSMutableArray *)createXaxisArray : (NSArray *)inputArray{
    NSMutableArray *weekAxisArray = [[ NSMutableArray alloc]init];
    for (int i = 0; i<inputArray.count; i++) {
        NSString *weekNam;
        weekNam = [NSString stringWithFormat:@"W%@",[inputArray objectAtIndex:i]];
        [weekAxisArray addObject:weekNam];
    }

    return weekAxisArray;
}
-(NSMutableArray *)FindWeekNumberOfDate :(NSArray *)inputDateArray {
    
    NSMutableArray *weekValueOfDateArray = [[ NSMutableArray alloc]init];
    NSMutableArray *monthValueOfDateArray = [[ NSMutableArray alloc]init];

    for (int i =0;i<inputDateArray.count;i++) {
        NSString *dateInput = [inputDateArray objectAtIndex:i];
        //NSLog(@"%@",dateInput);
        
        dateInput = [dateInput stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        dateInput = [dateInput stringByReplacingOccurrencesOfString:@".000Z" withString:@""];
        //NSLog(@"%@",dateInput);
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate *inpuDateFormat = [dateFormatter dateFromString:dateInput];
        //NSLog(@"%@",inpuDateFormat);
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comps = [calendar components:NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitMonth fromDate:inpuDateFormat];
       // NSLog(@"%ld",(long)comps.weekOfMonth);
        NSInteger weekComp = comps.weekOfMonth;
        NSInteger monthComp = comps.month;

        [weekValueOfDateArray addObject:[NSNumber numberWithInteger:weekComp]];
        [monthValueOfDateArray addObject:[NSNumber numberWithInteger:monthComp]];
     }
     NSMutableArray *outputArray=[[NSMutableArray alloc] initWithArray:@[weekValueOfDateArray,monthValueOfDateArray]];

     return outputArray;
}

-(NSMutableArray *)inputDateAndOutputXaxis :(NSArray *)inputDateArray {
    NSLog(@"%@",inputDateArray);
    NSMutableArray *dayComponentArray = [[ NSMutableArray alloc]init];
    NSMutableArray *monthComponentArray = [[ NSMutableArray alloc]init];
    NSMutableArray *nextDayCompArray = [[ NSMutableArray alloc]init];
    NSMutableArray *nextMonthCompArray = [[ NSMutableArray alloc]init];
    
    for (int i =0;i<inputDateArray.count;i++) {
        NSString *dateInput = [inputDateArray objectAtIndex:i];
        dateInput = [dateInput stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        dateInput = [dateInput stringByReplacingOccurrencesOfString:@".000Z" withString:@""];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate *inpuDateFormat = [dateFormatter dateFromString:dateInput]; //original date
        NSLog(@"%@",inpuDateFormat);
        
        
        //for original date--------------------------------------------------------------------------------------------------------------------------------------
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSDateComponents *comps = [calendar components:NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:inpuDateFormat];
        NSInteger dayComps = comps.day;
        NSInteger monthComps = comps.month;
        [dayComponentArray addObject:[NSNumber numberWithInteger:dayComps]];
        [monthComponentArray addObject:[NSNumber numberWithInteger:monthComps]];
        //for original date--------------------------------------------------------------------------------------------------------------------------------------
        
        
        //for added date------------------------------------------------------------------------------------------------------------------------------------------
        NSDateComponents *dayAddComponent = [[NSDateComponents alloc] init];
        dayAddComponent.day = 6;
        
        NSCalendar *calendars = [NSCalendar currentCalendar];
        NSDate *nextDate = [calendars dateByAddingComponents:dayAddComponent toDate:inpuDateFormat options:0];  //added date
        NSLog(@"nextDate: %@ ...", nextDate);
        
        
        
        NSDateComponents *compsTwo = [calendars components:NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:nextDate];
        NSInteger daysCompS = compsTwo.day;
        NSInteger monthsCompS = compsTwo.month;
        NSLog(@"nextDate: %@ ...", [NSNumber numberWithInteger:daysCompS]);
        
        [nextDayCompArray addObject:[NSNumber numberWithInteger:daysCompS]];
        [nextMonthCompArray addObject:[NSNumber numberWithInteger:monthsCompS]];
        
        //for added date------------------------------------------------------------------------------------------------------------------------------------------
        
        
    }
    NSMutableArray *outputsArray = [[ NSMutableArray alloc]init];
    NSLog(@"%@",inputDateArray);
    
    NSLog(@"%@",nextDayCompArray);
    NSLog(@"%@",nextMonthCompArray);
    
    NSLog(@"%@",dayComponentArray);
    NSLog(@"%@",monthComponentArray);
    
    fullName = 1;
    
    NSArray  *actualMonthName = [self GetMonthNameFromNumber:monthComponentArray];
    NSArray  *addedMonthName = [self GetMonthNameFromNumber:nextMonthCompArray];
    
    NSLog(@"%@",actualMonthName);
    NSLog(@"%@",addedMonthName);
    
    for (int k=0; k<actualMonthName.count; k++) {
        NSString *dt = [NSString stringWithFormat:@"%@ %@-%@ %@",[actualMonthName objectAtIndex:k],[dayComponentArray objectAtIndex:k],[addedMonthName objectAtIndex:k],[nextDayCompArray objectAtIndex:k]];
        
        [outputsArray addObject:dt];
    }
    
    NSLog(@"%@",outputsArray);
    
    
    fullName = 0;
    
    return outputsArray;
}

-(NSArray *)GetMonthNameFromNumber :(NSArray *)inputArray{
    //NSLog(@"%@",inputArray);
    
    NSMutableArray *outPutMonthArray = [[ NSMutableArray alloc]init];
    for (int i =0;i<inputArray.count;i++) {
        
        NSNumber *isIt = [inputArray objectAtIndex:i];
        
        NSString * dateString =[NSString stringWithFormat:@"%@", isIt];
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM"];
        NSDate* myDate = [dateFormatter dateFromString:dateString];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        if (fullName == 1) {
            [formatter setDateFormat:@"MMM"];
            
        }
        else{
            [formatter setDateFormat:@"MMMM"];
            
        }
        NSString *stringFromDate = [formatter stringFromDate:myDate];
        
        
        [outPutMonthArray addObject:stringFromDate];
    }
    return outPutMonthArray;
}
- (UIColor *)lighterColorForColor:(UIColor *)c
{
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MIN(r + 0.2, 1.0)
                               green:MIN(g + 0.2, 1.0)
                                blue:MIN(b + 0.2, 1.0)
                               alpha:a];
    return nil;
}

- (UIColor *)darkerColorForColor:(UIColor *)c
{
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.2, 0.0)
                               green:MAX(g - 0.2, 0.0)
                                blue:MAX(b - 0.2, 0.0)
                               alpha:a];
    return nil;
}


-(NSArray *)sortArrayWithArray:(NSArray *)incomingArray {
    NSArray *sortedArray = [incomingArray sortedArrayUsingDescriptors:
                            @[[NSSortDescriptor sortDescriptorWithKey:@"doubleValue"
                                                            ascending:YES]]];
    return sortedArray;
}
-(NSMutableDictionary *)GetResultantDictWithArray :(NSArray *)valuesArray andDateArray: (NSArray *)dateArray{
    
    NSDictionary *arrayOne = [[NSDictionary alloc]initWithObjects:valuesArray forKeys:dateArray]; //creating this dict with input formatted date and values contains reverseorders.
    
    //NSLog(@"%@",arrayOne);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMMM";
    // formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (NSDate *key in arrayOne.allKeys) {
        NSString *month = [formatter stringFromDate:key];
        if (result[month] == nil) {
            result[month] = arrayOne[key];
        } else {
            NSInteger value = [result[month] integerValue];
            result[month] = @(value + [arrayOne[key] integerValue]);
        }
    }
    //NSLog(@"%@", result);                                                       //resultant dict with month and sum of values corresponding.
    //NSLog(@"%@", [result allKeys]);
    //NSLog(@"%@", [result allValues]);
    
    return result;
}
-(NSMutableArray *)FormatTheKeyValuesWith :(NSArray *)inputDateArray {
    
    NSMutableArray *weekValueOfDateArray = [[ NSMutableArray alloc]init];
    
    for (int i =0;i<inputDateArray.count;i++) {
        NSString *dateInput = [inputDateArray objectAtIndex:i];
        // NSLog(@"%@",dateInput);
        
        dateInput = [dateInput stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        dateInput = [dateInput stringByReplacingOccurrencesOfString:@".000Z" withString:@""];
        //NSLog(@"%@",dateInput);
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate *inpuDateFormat = [dateFormatter dateFromString:dateInput];
        //NSLog(@"%@",inpuDateFormat);
        
        [weekValueOfDateArray addObject:inpuDateFormat];
    }
    
    return weekValueOfDateArray;
}
-(NSMutableArray *)getDictionaryAndGiveOutKeysAndPercentagesArray :(NSDictionary *)inputDictionary{
    
    NSSortDescriptor *descriptories=[[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
    NSArray *descriptoriess=[NSArray arrayWithObject: descriptories];
    NSArray *sortedValues=[[inputDictionary  allValues] sortedArrayUsingDescriptors:descriptoriess];
    NSLog(@"%@",sortedValues);
    
    NSArray *sortedKeys = [inputDictionary  keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(NSNumber*)obj2 compare:(NSNumber*)obj1];
    }];
    
    NSLog(@"%@",sortedKeys);
    
    
    // to get the percentage of the array***************************************************
    
    NSInteger totalOfArray = 0;                 //sum of array
    for (NSNumber *num in sortedValues)
    {
        totalOfArray += [num intValue];
    }
    
    NSMutableArray *percentValueArray = [[NSMutableArray alloc]init];
    for (int o= 0; o<sortedValues.count; o++) {
        int outOfValue = (int)totalOfArray;
        int oneByOne =  [(NSNumber *)[sortedValues objectAtIndex:o] intValue];
        int getNumerator = (100 * oneByOne);
        float secondDivide = (float)getNumerator/(float)outOfValue;
        int rounded = (secondDivide + 0.5);
        
        [percentValueArray addObject:[NSNumber numberWithInt:rounded]];
    }
    
    NSLog(@"%@",percentValueArray);
    
    
    
    // to get the percentage of the array***************************************************
    NSMutableArray *outputArray=[[NSMutableArray alloc] initWithArray:@[sortedKeys,percentValueArray]];
    
    return outputArray; //array returned with x and y values
}
-(NSArray *)sortKeysInOrder :(NSDictionary *)inputDictionary{
    NSSortDescriptor *descriptories=[[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
    NSArray *descriptoriess=[NSArray arrayWithObject: descriptories];
    NSArray *resultantArray=[[inputDictionary  allKeys] sortedArrayUsingDescriptors:descriptoriess];
    // NSLog(@"%@",resultantArray);
    
    return resultantArray;
    
}
-(NSArray *)sortValuesOfKeysInOrder :(NSDictionary *)inputDictionary withArray:(NSArray *)inputArray{
    NSMutableArray *valueOfDicts = [[NSMutableArray alloc] init];
    for (int i=0; i<inputArray.count; i++)
    {
        NSString *inpT = [inputArray objectAtIndex:i];
        NSString *value = [inputDictionary objectForKey:inpT];
        [valueOfDicts addObject:value];
    }
    
    // NSLog(@"%@",valueOfDicts);
    return valueOfDicts;
}

-(NSArray *)GetSortedXvalueAndYvalueForStackedBarChart :(NSDictionary *)inputDictionary{
    // Parsing from the dictionary
    NSLog(@"%@",inputDictionary);
    NSArray *firstArray=[self sortKeysInOrder:inputDictionary];   //contains the keys in sorted form
    NSLog(@"%@",firstArray);

    NSArray *secArray = [self sortValuesOfKeysInOrder:inputDictionary withArray:firstArray];
    NSLog(@"%@",secArray);

    NSDictionary *valueArrayDict = [secArray objectAtIndex:0];
    NSLog(@"%@",valueArrayDict);

    //only names of brands--------------------------------------------------------------------------------------------------------
    NSArray *serialNumbers = [self sortKeysInOrder:valueArrayDict];//only names of brands
    NSLog(@"%@",serialNumbers);
    NSMutableArray *valueArrayFrmDict = [[NSMutableArray alloc]init];

    for (int i = 0; i<serialNumbers.count; i++) {
        NSString *inputStr = [NSString stringWithFormat:@"%@",[serialNumbers objectAtIndex:i]];
        
        [valueArrayFrmDict addObject:[[valueArrayDict objectForKey:inputStr] objectForKey:@"name"]];

    }
    
//    NSArray *valueArrayFrmDict = [self sortKeysInOrder:valueArrayDict];//only names of brands
    NSLog(@"%@",valueArrayFrmDict);
    
    brandAndSerialNumber = [NSDictionary dictionaryWithObjects:serialNumbers forKeys:valueArrayFrmDict];
    //----------------------------------------------------------------------------------------required for other method-----------
    
    weaveDateArray = [[NSMutableArray alloc]init];
    for (int i=0; i<reverseOrderBkUp.count; i++) {
        if (i>0) {
            [weaveDateArray addObject:@" "];
        }
        for (int k=0; k<valueArrayFrmDict.count; k++) {
            [weaveDateArray addObject:[reverseOrderBkUp objectAtIndex:i]];
        }
        
    }
    
    
    NSArray *keyArrayTone = firstArray;
    
    //----------------------------------------------------------------------------------------required for other method------------

    
    //--------------------------------------------------------------------------------------------only values for brands-----------
    NSMutableArray *nameArrayFrmDict = [[NSMutableArray alloc]init];
    for (int k = 0; k<valueArrayFrmDict.count; k++) {
        NSMutableArray *innerArray = [[NSMutableArray alloc]init];
        NSString *dotValue = [serialNumbers objectAtIndex:k];
        
        for (int i = 0; i<keyArrayTone.count; i++) {
            NSString *inputStr = [NSString stringWithFormat:@"%@",[keyArrayTone objectAtIndex:i]];
            NSString *inputStr2 = [NSString stringWithFormat:@"%@",dotValue];
            NSString *inputStr3 = [NSString stringWithFormat:@"count"];

            [innerArray addObject:[[[inputDictionary objectForKey:inputStr] objectForKey:inputStr2] objectForKey:inputStr3 ]];

//          [innerArray addObject:[inputDictionary valueForKeyPath:inputStr]];
        }
        [nameArrayFrmDict addObject:innerArray];
        
    }
    
    NSLog(@"%@",nameArrayFrmDict);
    
        NSDictionary *dictInNeed = [NSDictionary dictionaryWithObjects:nameArrayFrmDict forKeys:valueArrayFrmDict];

    


    //--------------------------------------------------------------------------------------------Sorted value as in final form--------------
    
//    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"@sum.self" ascending:NO]; // @sum is an aggregate
//    NSArray *sortedResultantValues= [nameArrayFrmDict sortedArrayUsingDescriptors:@[sorter]];
    
    
    //--------------------------------------------------------------------------------------------Sorted value as in final form---------------

    //--------------------------------------------------------------------------------------------Sum of the multidim. array------------------

    NSMutableArray *addedArray = [[NSMutableArray alloc]init];
    for (int i=0; i<nameArrayFrmDict.count; i++) {
        NSArray *firstArrayOfArray = [ nameArrayFrmDict objectAtIndex:i];
        NSNumber *iSum = [firstArrayOfArray  valueForKeyPath:@"@sum.self"];

        [addedArray addObject:iSum];
    }
    
    //--------------------------------------------------------------------------------------------Sum of the multidim. array------------------

    
    NSDictionary *helperDictionary = [NSDictionary dictionaryWithObjects:addedArray forKeys:valueArrayFrmDict];

    
    NSArray *interMediateKeyS =[self sortKeysInOrder:helperDictionary];
    NSArray *interMediateValueS = [self sortValuesOfKeysInOrder:helperDictionary withArray:interMediateKeyS];

    
    
    
   
    NSSortDescriptor *descriptories=[[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
    NSArray *descriptoriess=[NSArray arrayWithObject: descriptories];
    NSArray *sortedValues=[interMediateValueS sortedArrayUsingDescriptors:descriptoriess];
    //-------------------------------------------------------------------------------------------sorted brand names according to sum of values
    NSArray *sortedKeys = [helperDictionary  keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(NSNumber*)obj2 compare:(NSNumber*)obj1];
    }];
    //-------------------------------------------------------------------------------------------sorted brand names according to sum of values

    
    

    NSMutableArray *finalSortedArrayOfValues = [[NSMutableArray alloc] init];
    for (int j = 0 ; j<sortedKeys.count; j++) {
        NSString *inputVl = [sortedKeys objectAtIndex:j];
        NSLog(@"%@",inputVl);
        NSLog(@"%@",sortedKeys);
        NSLog(@"%@",dictInNeed);
        NSLog(@"%@",[dictInNeed objectForKey:inputVl]);

        [finalSortedArrayOfValues addObject:[dictInNeed objectForKey:inputVl]];
    }
    NSLog(@"%@",finalSortedArrayOfValues);
    NSLog(@"%@",sortedKeys);

    
    //-------------------------------------------------------------------------------------------Adding values to the Brand names
    
    NSLog(@"%@",finalSortedArrayOfValues);
    NSMutableArray *overallGroupedName = [[NSMutableArray alloc]init];
    NSLog(@"%@",sortedKeys);
    for (int i=0; i<sortedKeys.count; i++) {
        NSArray *toGroupVals =[finalSortedArrayOfValues objectAtIndex:i];
        NSString *groupingText = [NSString stringWithFormat:@"%@ (%@-%@-%@)",[sortedKeys objectAtIndex:i],[toGroupVals objectAtIndex:2],[toGroupVals objectAtIndex:1],[toGroupVals objectAtIndex:0]];
        [overallGroupedName addObject:groupingText];
    }
    NSLog(@"%@",overallGroupedName);
    
    NSMutableArray *outputArray=[[NSMutableArray alloc] initWithArray:@[overallGroupedName,finalSortedArrayOfValues]];
  
   // NSMutableArray *outputArray=[[NSMutableArray alloc] initWithArray:@[sortedKeys,finalSortedArrayOfValues]];
    NSLog(@"%@",outputArray); //sorted values

    
    return outputArray; //array returned with x and y values
    
}

-(NSArray *)GetXvalueAndYvalueForStackedBarChart :(NSDictionary *)inputDictionary{
    // Parsing from the dictionary
    NSLog(@"input dic:%@",inputDictionary);
    NSArray *firstArray=[self sortKeysInOrder:inputDictionary];   //contains the keys in sorted form
    NSLog(@"firstArray %@",firstArray);
    
    NSArray *secArray = [self sortValuesOfKeysInOrder:inputDictionary withArray:firstArray];
    NSLog(@"secArray %@",secArray);                                                  //the array with brand and its values
    NSDictionary *valueArrayDict = [secArray objectAtIndex:0];
    // NSLog(@"%@",valueArrayDict);
    
    NSArray *valueArrayFrmDict = [self sortKeysInOrder:valueArrayDict];
    //    valueArrayFrmDict = [valueArrayFrmDict sortedArrayUsingComparator:^(id a, id b) {
    //        return [a compare:b options:NSNumericSearch];
    //    }];
    
    
    
    
    
    NSLog(@"valueArrayFrmDict %@",valueArrayFrmDict);//only names of brands
    weaveDateArray = [[NSMutableArray alloc]init];
    for (int i=0; i<reverseOrderBkUp.count; i++) {
        if (i>0) {
            [weaveDateArray addObject:@" "];
        }
        for (int k=0; k<valueArrayFrmDict.count; k++) {
            [weaveDateArray addObject:[reverseOrderBkUp objectAtIndex:i]];
        }
        
    }
    
    NSLog(@"%@",weaveDateArray);
    
    
    
    NSArray *keyArrayTone = firstArray;
    NSLog(@"keyArrayTone >%@",keyArrayTone);
    
    
    //    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //    for (int j =0 ; j<valueArrayFrmDict.count; j++) {
    //        NSString *someString = [valueArrayFrmDict objectAtIndex:j];
    //        [dict setObject:[NSMutableArray array] forKey:someString];
    //
    //    }
    // NSLog(@">%@",dict);
    
    
    
    NSMutableArray *outerArray = [[NSMutableArray alloc]init];
    for (int k = 0; k<valueArrayFrmDict.count; k++) {
        NSMutableArray *innerArray = [[NSMutableArray alloc]init];
        NSString *dotValue = [valueArrayFrmDict objectAtIndex:k];
        
        for (int i = 0; i<keyArrayTone.count; i++) {
            
            NSString *inputStr = [NSString stringWithFormat:@"%@",[keyArrayTone objectAtIndex:i]];
            NSString *inputStr2 = [NSString stringWithFormat:@"%@",dotValue];
            
            [innerArray addObject:[[inputDictionary objectForKey:inputStr] objectForKey:inputStr2]];

            
            NSLog(@"innerArray >%@",innerArray);
        }
        [outerArray addObject:innerArray];
        
    }
    
    
    //    NSLog(@"key--->%@",outerArray); // only values for brands
    
    NSMutableArray *outputArray=[[NSMutableArray alloc] initWithArray:@[valueArrayFrmDict,outerArray]];
    
    return outputArray; //array returned with x and y values
    
}
-(NSArray *)GetXvalueAndYvalueForStackedBarChartInIt :(NSDictionary *)inputDictionary{
    // Parsing from the dictionary
    NSLog(@"%@",inputDictionary);
    
    NSDictionary *valueArrayDict = [[inputDictionary allValues] objectAtIndex:0];
    // NSLog(@"%@",valueArrayDict);
    
    NSArray *valueArrayFrmDict = [self sortKeysInOrder:valueArrayDict];   //contains the keys in sorted form
    NSLog(@"%@",valueArrayFrmDict);
    
    NSArray *secArray = [self sortValuesOfKeysInOrder:valueArrayDict withArray:valueArrayFrmDict];
    NSLog(@"%@",secArray);                                                  //the array with its values

    
    
    
    
    // NSLog(@"%@",valueArrayFrmDict);//only names of brands
    
    
    
    
    //NSLog(@">%@",keyArrayTone);
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (int j =0 ; j<valueArrayFrmDict.count; j++) {
        NSString *someString = [valueArrayFrmDict objectAtIndex:j];
        [dict setObject:[NSMutableArray array] forKey:someString];
        
    }
    // NSLog(@">%@",dict);
    
    
    
    NSMutableArray *outerArray = [[NSMutableArray alloc]init];
    for (int k = 0; k<valueArrayFrmDict.count; k++) {
        NSMutableArray *innerArray = [[NSMutableArray alloc]init];
        NSString *dotValue = [valueArrayFrmDict objectAtIndex:k];
        
        for (int i = 0; i<secArray.count; i++) {
            NSString *inputStr = [NSString stringWithFormat:@"%@.%@",[secArray objectAtIndex:i],dotValue];
            // NSLog(@">%@",inputStr);
            [innerArray addObject:[inputDictionary valueForKeyPath:inputStr]];
            
            //            NSLog(@">%@",innerArray);
        }
        [outerArray addObject:innerArray];
        
    }
    
    NSLog(@"key--->%@",valueArrayFrmDict); // only values for brands

    NSLog(@"key--->%@",outerArray); // only values for brands
    
    NSMutableArray *outputArray=[[NSMutableArray alloc] initWithArray:@[valueArrayFrmDict,outerArray]];
    
    return outputArray; //array returned with x and y values
    
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
    
//    if (typeOfChart == 0) {
//        [lineChartView saveToCameraRoll];
//    }else if (typeOfChart ==1){
//        [pieViews saveToCameraRoll];
//    }else if (typeOfChart ==2){
//        [pieViews saveToCameraRoll];
//    }else if (typeOfChart ==3){
//        [barViews saveToCameraRoll];
//    }else if (typeOfChart ==4){
//        [lineChartView saveToCameraRoll];
//    }else if (typeOfChart ==5){
//        [lineChartView saveToCameraRoll];
//    }
    [self.view makeToast:@"Chart saved successfully" duration:1.0 position:CSToastPositionCenter];

}
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipViews
{
    //  [self.visiblePopTipViews removeObject:popTipView];
    popTipView = nil;
}

- (IBAction)infoButtonClick:(id)sender {
    [self AnimateButtonOnClick:sender];

    NSString *contentMessage = nil;
    if ([descText length]==0) {
        contentMessage = @"Description not available.";
    } else {
        contentMessage = [descText string];

    }
    
    
    
    if (nil == popTipView) {
        popTipView = [[CMPopTipView alloc] initWithMessage:contentMessage];
        popTipView.delegate = self;
        popTipView.backgroundColor = [UIColor whiteColor];
        popTipView.textColor = [UIColor darkTextColor];
        popTipView.textFont = [UIFont boldSystemFontOfSize:18.0];
        popTipView.dismissTapAnywhere = YES;
//       popTipView.animation = CMPopTipAnimationPop;
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
                             self.tableOuterView.layer.borderWidth = 1.0f;
                             self.tableOuterView.layer.borderColor = [UIColor lightGrayColor].CGColor;
                             isTopStoriesOpen = YES;
                             self.topStoriesViewLeadingConstraint.constant = self.view.frame.size.width-320;
                             [self.view layoutIfNeeded];
                             
                             //[self loadChartValuesWithReportType:localReportTypeId];
                             
                             
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
                           //  [self loadChartValuesWithReportType:localReportTypeId];
                             
                         }];
    }
    
}
@end
