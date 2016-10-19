//
//  ReportListObject.m
//  FullIntel
//
//  Created by CapeStart Apple on 3/2/16.
//  Copyright © 2016 CapeStart. All rights reserved.
//

#import "ReportListObject.h"
#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

@implementation ReportListObject

-(void)setReportListObjectFromDictionary:(NSDictionary *)dic {
    self.reportId =  NULL_TO_NIL([dic objectForKey:@"id"]);
    self.createdBy = NULL_TO_NIL([dic objectForKey:@"createdBy"]);
    self.reportTitle = NULL_TO_NIL([dic objectForKey:@"title"]);
    self.reportSubTitle = NULL_TO_NIL([dic objectForKey:@"subTitle"]);
    self.reportSummary = NULL_TO_NIL([dic objectForKey:@"summary"]);
    self.reportFromDate = NULL_TO_NIL([dic objectForKey:@"reportFromDate"]);
    self.reportToDate = NULL_TO_NIL([dic objectForKey:@"reportToDate"]);
    self.status = NULL_TO_NIL([dic objectForKey:@"status"]);
    self.createdDate = NULL_TO_NIL([dic objectForKey:@"createdDate"]);
    self.modifiedBy = NULL_TO_NIL([dic objectForKey:@"modifiedBy"]);
    self.modifiedDate = NULL_TO_NIL([dic objectForKey:@"modifiedDate"]);
    self.isdeleted =NULL_TO_NIL([dic objectForKey:@"deleted"]);
    self.articleCount = NULL_TO_NIL([dic objectForKey:@"articleCount"]);
    self.numberOfMonth = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"reportDateRange"] objectForKey:@"months"]];
}

@end
