//
//  ReportObject.h
//  FullIntel
//
//  Created by CapeStart Apple on 3/2/16.
//  Copyright © 2016 CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportObject : NSObject
@property (nonatomic,strong) NSNumber *reportId;
@property (nonatomic,strong) NSNumber *createdBy;
@property (nonatomic,strong) NSString *reportTitle;
@property (nonatomic,strong) NSString *reportSubTitle;
@property (nonatomic,strong) NSString *reportSummary;
@property (nonatomic,strong) NSNumber *reportFromDate;
@property (nonatomic,strong) NSNumber *reportToDate;
@property (nonatomic,strong) NSNumber *status;
@property (nonatomic,strong) NSNumber *createdDate;
@property (nonatomic,strong) NSNumber *modifiedBy;
@property (nonatomic,strong) NSNumber *modifiedDate;
@property (nonatomic,strong) NSNumber *isdeleted;
@property (nonatomic,strong) NSMutableArray *reportTypeArray;

-(void)setReportObjectFromDictionary:(NSDictionary *)dic;
@end
