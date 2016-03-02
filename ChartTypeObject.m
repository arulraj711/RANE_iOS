//
//  ChartTypeObject.m
//  FullIntel
//
//  Created by CapeStart Apple on 3/2/16.
//  Copyright © 2016 CapeStart. All rights reserved.
//

#import "ChartTypeObject.h"
#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })
@implementation ChartTypeObject

-(void)setChartTypeFromDictionary:(NSDictionary *)dic {
    self.chartTyepId = NULL_TO_NIL([dic objectForKey:@"id"]);
    self.chartName = NULL_TO_NIL([dic objectForKey:@"name"]);
    self.createdAt = NULL_TO_NIL([dic objectForKey:@"createdAt"]);
    self.modifiedAt = NULL_TO_NIL([dic objectForKey:@"modifiedAt"]);
    self.isdeleted = NULL_TO_NIL([dic objectForKey:@"deleted"]);
}

@end
