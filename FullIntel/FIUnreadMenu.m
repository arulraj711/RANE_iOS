//
//  FIUnreadMenu.m
//  FullIntel
//
//  Created by cape start on 31/08/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "FIUnreadMenu.h"
#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })
@implementation FIUnreadMenu
-(void)setUnreadMenuObjectFromDic:(NSDictionary *)dictionary {
    self.nodeId = [dictionary objectForKey:@"id"];
    self.isParent = [dictionary objectForKey:@"isParent"];
    self.isSubscribed = [dictionary objectForKey:@"subscribed"];
    self.unreadCount = [dictionary objectForKey:@"unReadCount"];
    self.companyId = [dictionary objectForKey:@"companyId"];
    self.articleCount = [dictionary objectForKey:@"articleCount"];
}


+(FIUnreadMenu *)recursiveUnReadMenu:(NSDictionary *)dic {
     //NSLog(@"dic in model name:%@ and count:%@",[dic objectForKey:@"name"],[dic objectForKey:@"articleCount"]);
    FIUnreadMenu *menu = [[FIUnreadMenu alloc]init];
  
    menu.nodeId = [dic objectForKey:@"id"];
    menu.companyId = [dic objectForKey:@"companyId"];
    menu.unreadCount = [dic objectForKey:@"unReadCount"];
    menu.isParent = [dic objectForKey:@"isParent"];
    menu.isSubscribed = [dic objectForKey:@"subscribed"];
   menu.articleCount = [dic objectForKey:@"articleCount"];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSArray *menuArray = NULL_TO_NIL([dic objectForKey:@"subList"]);
    menu.subListAvailable = [dic objectForKey:@"subListAvailable"];
    //NSLog(@"unread menu list array:%@ and copunt:%d",menuArray,menuArray.count);
    if(menuArray.count != 0) {
        for(NSDictionary *dict in menuArray) {
            FIUnreadMenu *insideMenu = [self recursiveUnReadMenu:dict];
            [array addObject:insideMenu];
        }
    }
    menu.listArray = array;
   // NSLog(@"menu:%@",menu);
    return menu;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.listArray forKey:@"list"];
    [coder encodeObject:self.nodeId forKey:@"nodeid"];
    [coder encodeObject:self.companyId forKey:@"companyId"];
    [coder encodeObject:self.unreadCount forKey:@"unReadCount"];
    [coder encodeObject:self.isParent forKey:@"isParent"];
    [coder encodeObject:self.isSubscribed forKey:@"subscribed"];
    [coder encodeObject:self.articleCount forKey:@"articleCount"];
    [coder encodeObject:self.articleCount forKey:@"subListAvailable"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.listArray = [coder decodeObjectForKey:@"list"];
        self.nodeId = [coder decodeObjectForKey:@"nodeid"];
        self.companyId = [coder decodeObjectForKey:@"companyId"];
        self.unreadCount = [coder decodeObjectForKey:@"unReadCount"];
        self.isParent = [coder decodeObjectForKey:@"isParent"];
        self.isSubscribed = [coder decodeObjectForKey:@"subscribed"];
        self.articleCount = [coder decodeObjectForKey:@"articleCount"];
        self.subListAvailable = [coder decodeObjectForKey:@"subListAvailable"];
    }
    return self;
}



@end
