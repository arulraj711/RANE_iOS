//
//  FIMenu.m
//  FullIntel
//
//  Created by Arul on 3/2/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "FIMenu.h"

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
    }
    return self;
}
@end
