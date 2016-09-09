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
    self.apiLink = NULL_TO_NIL([dic objectForKey:@"apiLink"]);
    //set charttype info
    NSDictionary *chartInfoDic = NULL_TO_NIL([dic objectForKey:@"chartType"]);
    ChartTypeObject *chartTypeObj = [[ChartTypeObject alloc]init];
    [chartTypeObj setChartTypeFromDictionary:chartInfoDic];
    self.chartTypeObject = chartTypeObj;
    
    //set report chart type
    NSDictionary *reportChartInfoDic = NULL_TO_NIL([dic objectForKey:@"reportType"]);
    self.reportChartTyepId = NULL_TO_NIL([reportChartInfoDic objectForKey:@"id"]);
    
    //set reportContentTypesForCustomer
    self.reportContentTypesForCustomer = @"";
    NSArray *reportContentTypesForCustomerArray = NULL_TO_NIL([dic objectForKey:@"reportContentTypesForCustomer"]);
    for(NSDictionary *dictionary in reportContentTypesForCustomerArray) {
        if(self.reportContentTypesForCustomer.length != 0) {
            self.reportContentTypesForCustomer = [NSString stringWithFormat:@"%@,%@",self.reportContentTypesForCustomer,[[[dictionary objectForKey:@"contentTypeForCustomer"] objectForKey:@"contentType"] objectForKey:@"id"]];
        } else {
            self.reportContentTypesForCustomer = [NSString stringWithFormat:@"%@",[[[dictionary objectForKey:@"contentTypeForCustomer"] objectForKey:@"contentType"] objectForKey:@"id"]];
        }
        
    }
    NSLog(@"reportContentTypesForCustomerArray%@",self.reportContentTypesForCustomer);
    
    //set reportContentTypesForCustomer
    self.reportFields = @"";
    NSArray *reportFieldsArray = NULL_TO_NIL([dic objectForKey:@"reportFields"]);
    for(NSDictionary *dictionary in reportFieldsArray) {
        if(self.reportFields.length != 0) {
            self.reportFields = [NSString stringWithFormat:@"%@,%@",self.reportFields,[[dictionary objectForKey:@"field"] objectForKey:@"id"]];
        } else {
            self.reportFields = [NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"field"] objectForKey:@"id"]];
        }
        
    }
    NSLog(@"reportFields%@",self.reportFields);
    
}
@end
