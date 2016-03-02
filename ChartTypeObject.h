//
//  ChartTypeObject.h
//  FullIntel
//
//  Created by CapeStart Apple on 3/2/16.
//  Copyright © 2016 CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChartTypeObject : NSObject
@property (nonatomic,strong) NSNumber *chartTyepId;
@property (nonatomic,strong) NSString *chartName;
@property (nonatomic,strong) NSNumber *createdAt;
@property (nonatomic,strong) NSNumber *modifiedAt;
@property (nonatomic,strong) NSNumber *isdeleted;
-(void)setChartTypeFromDictionary:(NSDictionary *)dic;
@end
