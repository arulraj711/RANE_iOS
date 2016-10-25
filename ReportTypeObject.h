//
//  ReportTypeObject.h
//  FullIntel
//
//  Created by CapeStart Apple on 3/2/16.
//  Copyright © 2016 CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChartTypeObject.h"

@interface ReportTypeObject : NSObject
@property (nonatomic,strong) NSNumber *reportTyepId;
@property (nonatomic,strong) NSString *reportName;
@property (nonatomic,strong) NSString *reportSummary;
@property (nonatomic,strong) NSNumber *createdBy;
@property (nonatomic,strong) NSNumber *createdAt;
@property (nonatomic,strong) NSNumber *modifiedBy;
@property (nonatomic,strong) NSNumber *modifiedAt;
@property (nonatomic,strong) NSNumber *isdeleted;
@property (nonatomic,strong) NSNumber *reportChartTyepId;
@property (nonatomic,strong) NSString *apiLink;
@property (nonatomic,strong) NSString *moduleIds;
@property (nonatomic,strong) NSString *tagIds;
@property (nonatomic,strong) ChartTypeObject *chartTypeObject;
@property (nonatomic,strong) NSString *chartIcon;
@property (nonatomic,strong) NSString *chartSelectedIcon;
-(void)setReportTypeFromDictionary:(NSDictionary *)dic;
@end
