//
//  Stocks.m
//  FullIntel
//
//  Created by cape start on 28/05/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "Stocks.h"

@implementation Stocks
-(void)getDetailsFromDictionary:(NSDictionary *)dict{
    
    
      _company_id=[dict objectForKey:@"company_id"];
      _company_name=[dict objectForKey:@"company_name"];
      _firstName=[dict objectForKey:@"firstName"];
      _lastName=[dict objectForKey:@"lastName"];
      _firstValue=[dict objectForKey:@"firstValue"];
      _secondValue=[dict objectForKey:@"secondValue"];
      _value=[dict objectForKey:@"value"];
      _color=[dict objectForKey:@"color"];
    
}
@end
