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
    
    //set module Ids
    self.moduleIds = [NSString stringWithFormat:@"%@",@""];
    NSArray *reportContentTypesForCustomerArray = NULL_TO_NIL([dic objectForKey:@"reportContentTypesForCustomer"]);
    if(reportContentTypesForCustomerArray.count != 0) {
        
        for(NSDictionary *dic in reportContentTypesForCustomerArray) {
            if(self.moduleIds.length == 0) {
                self.moduleIds = [NSString stringWithFormat:@"%@",NULL_TO_NIL([[[dic objectForKey:@"contentTypeForCustomer"] objectForKey:@"contentType"] objectForKey:@"id"])];
            } else {
                self.moduleIds = [NSString stringWithFormat:@"%@,%@",self.moduleIds,NULL_TO_NIL([[[dic objectForKey:@"contentTypeForCustomer"] objectForKey:@"contentType"] objectForKey:@"id"])];
            }
            
        }
        
        
    }
    
    //set tag Ids
    self.tagIds = [NSString stringWithFormat:@"%@",@""];
    NSArray *reportFieldsArray = NULL_TO_NIL([dic objectForKey:@"reportFields"]);
    if(reportFieldsArray.count != 0) {
        
        for(NSDictionary *dic in reportFieldsArray) {
            if(self.tagIds.length == 0) {
                self.tagIds = [NSString stringWithFormat:@"%@",NULL_TO_NIL([[dic objectForKey:@"field"] objectForKey:@"id"])];
            } else  {
                self.tagIds = [NSString stringWithFormat:@"%@,%@",self.tagIds,NULL_TO_NIL([[dic objectForKey:@"field"] objectForKey:@"id"])];
            }
            
        }
        
    }
    
}
@end
