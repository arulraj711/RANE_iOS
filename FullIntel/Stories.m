//
//  Stories.m
//  FullIntel
//
//  Created by cape start on 28/05/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "Stories.h"

@implementation Stories
-(void)getDetailsFromDictionary:(NSDictionary *)dict{
    
    
    _image=[dict objectForKey:@"image"];
    _resource=[dict objectForKey:@"resource_name"];
    _story=[dict objectForKey:@"story"];
}
@end
