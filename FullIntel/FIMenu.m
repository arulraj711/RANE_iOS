//
//  FIMenu.m
//  FullIntel
//
//  Created by Arul on 3/2/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "FIMenu.h"
#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })
@implementation FIMenu
-(void)createMenuFromDic:(NSDictionary *)dic {
    
}

+(FIMenu *)recursiveMenu:(NSDictionary *)dic {
    NSLog(@"dic in model name:%@ and count:%@",[dic objectForKey:@"name"],[dic objectForKey:@"unReadCount"]);
    FIMenu *menu = [[FIMenu alloc]init];
    menu.name = [dic objectForKey:@"name"];
    menu.nodeId = [dic objectForKey:@"id"];
    menu.unreadCount = [dic objectForKey:@"unReadCount"];
    menu.isParent = [dic objectForKey:@"isParent"];
    menu.isSubscribed = [dic objectForKey:@"subscribed"];
    menu.subListAvailable = [dic objectForKey:@"subListAvailable"];
    menu.menuIconURL = NULL_TO_NIL([dic objectForKey:@"iconUrl"]);
    menu.companyId = NULL_TO_NIL([dic objectForKey:@"companyId"]);
    menu.articleCount = [NSNumber numberWithInt:0];
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSArray *menuArray = [dic objectForKey:@"subList"];
    
    for(NSDictionary *dict in menuArray) {
        FIMenu *insideMenu = [self recursiveMenu:dict];
        [array addObject:insideMenu];
    }
    
    
    menu.listArray = array;
    return menu;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.listArray forKey:@"list"];
    [coder encodeObject:self.nodeId forKey:@"nodeid"];
    [coder encodeObject:self.unreadCount forKey:@"unReadCount"];
    [coder encodeObject:self.isParent forKey:@"isParent"];
    [coder encodeObject:self.isSubscribed forKey:@"subscribed"];
    [coder encodeObject:self.menuIconURL forKey:@"iconUrl"];
    [coder encodeObject:self.subListAvailable forKey:@"subListAvailable"];
    [coder encodeObject:self.companyId forKey:@"companyId"];
    [coder encodeObject:self.articleCount forKey:@"articleCount"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.name = [coder decodeObjectForKey:@"name"];
        self.listArray = [coder decodeObjectForKey:@"list"];
        self.nodeId = [coder decodeObjectForKey:@"nodeid"];
        self.unreadCount = [coder decodeObjectForKey:@"unReadCount"];
        self.isParent = [coder decodeObjectForKey:@"isParent"];
        self.isSubscribed = [coder decodeObjectForKey:@"subscribed"];
        self.menuIconURL = [coder decodeObjectForKey:@"iconUrl"];
        self.subListAvailable = [coder decodeObjectForKey:@"subListAvailable"];
        self.companyId = [coder decodeObjectForKey:@"companyId"];
        self.articleCount = [coder decodeObjectForKey:@"articleCount"];
    }
    return self;
}
@end
