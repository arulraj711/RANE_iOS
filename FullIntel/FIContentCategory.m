//
//  FIContentCategory.m
//  FullIntel
//
//  Created by Capestart on 5/4/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "FIContentCategory.h"

@implementation FIContentCategory
+(FIContentCategory *)recursiveMenu:(NSDictionary *)dic {
  //  NSLog(@"dic in model name:%@ and count:%@",[dic objectForKey:@"name"],[dic objectForKey:@"unReadCount"]);
    FIContentCategory *menu = [[FIContentCategory alloc]init];
    menu.name = [dic objectForKey:@"name"];
    menu.categoryId = [dic objectForKey:@"id"];
    menu.imageUrl = [dic objectForKey:@"imageURL"];
    menu.isSubscribed = [[dic objectForKey:@"isSubscribed"] boolValue];
    menu.isCompanySubscribed = [[dic objectForKey:@"isUnsubscribedByCompany"] boolValue];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSArray *menuArray = [dic objectForKey:@"list"];
    for(NSDictionary *dict in menuArray) {
        FIContentCategory *insideMenu = [self recursiveMenu:dict];
        [array addObject:insideMenu];
    }
    menu.listArray = array;
    return menu;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.listArray forKey:@"list"];
    [coder encodeObject:self.categoryId forKey:@"id"];
    [coder encodeObject:self.imageUrl forKey:@"imageURL"];
    [coder encodeObject:[NSNumber numberWithBool:self.isSubscribed] forKey:@"isSubscribed"];
    [coder encodeObject:[NSNumber numberWithBool:self.isCompanySubscribed] forKey:@"isUnsubscribedByCompany"];
    
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.name = [coder decodeObjectForKey:@"name"];
        self.listArray = [coder decodeObjectForKey:@"list"];
        self.categoryId = [coder decodeObjectForKey:@"id"];
        self.imageUrl = [coder decodeObjectForKey:@"imageURL"];
        self.isSubscribed = [[coder decodeObjectForKey:@"isSubscribed"] boolValue];
        self.isCompanySubscribed = [[coder decodeObjectForKey:@"isUnsubscribedByCompany"] boolValue];
        
    }
    return self;
}


@end
