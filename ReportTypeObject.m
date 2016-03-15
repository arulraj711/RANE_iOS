//
//  ReportTypeObject.m
//  FullIntel
//
//  Created by CapeStart Apple on 3/2/16.
//  Copyright © 2016 CapeStart. All rights reserved.
//

#import "ReportTypeObject.h"
#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })
@implementation ReportTypeObject
-(void)setReportTypeFromDictionary:(NSDictionary *)dic {
    self.reportTyepId = NULL_TO_NIL([dic objectForKey:@"id"]);
    self.reportName = NULL_TO_NIL([dic objectForKey:@"reportName"]);
    self.reportSummary = NULL_TO_NIL([dic objectForKey:@"reportSummary"]);
    self.createdBy = NULL_TO_NIL([dic objectForKey:@"createdBy"]);
    self.createdAt = NULL_TO_NIL([dic objectForKey:@"createdAt"]);
    self.modifiedBy = NULL_TO_NIL([dic objectForKey:@"modifiedBy"]);
    self.modifiedAt = NULL_TO_NIL([dic objectForKey:@"modifiedAt"]);
    self.isdeleted = NULL_TO_NIL([dic objectForKey:@"deleted"]);
    
    //set charttype info
    NSDictionary *chartInfoDic = NULL_TO_NIL([dic objectForKey:@"chartType"]);
    ChartTypeObject *chartTypeObj = [[ChartTypeObject alloc]init];
    [chartTypeObj setChartTypeFromDictionary:chartInfoDic];
    self.chartTypeObject = chartTypeObj;
    
    //set report chart type
    NSDictionary *reportChartInfoDic = NULL_TO_NIL([dic objectForKey:@"reportType"]);
    self.reportChartTyepId = NULL_TO_NIL([reportChartInfoDic objectForKey:@"id"]);
}
@end
