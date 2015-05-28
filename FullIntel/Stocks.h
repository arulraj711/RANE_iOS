//
//  Stocks.h
//  FullIntel
//
//  Created by cape start on 28/05/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stocks : NSObject

@property (nonatomic,strong) NSString *company_name;
@property (nonatomic,strong) NSString *firstName;
@property (nonatomic,strong) NSString *lastName;
@property (nonatomic,strong) NSString *secondValue;
@property (nonatomic,strong) NSString *value;
@property (nonatomic,strong) NSString *color;
@property (nonatomic,strong) NSString *firstValue;
@property (nonatomic,strong) NSString *company_id;


-(void)getDetailsFromDictionary:(NSDictionary *)dict;

@end
