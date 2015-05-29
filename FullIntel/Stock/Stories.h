//
//  Stories.h
//  FullIntel
//
//  Created by cape start on 28/05/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stories : NSObject

@property (nonatomic,strong) NSString *image;
@property (nonatomic,strong) NSString *story;
@property (nonatomic,strong) NSString *resource;


-(void)getDetailsFromDictionary:(NSDictionary *)dict;
@end
