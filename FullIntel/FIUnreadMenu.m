//
//  FIUnreadMenu.m
//  FullIntel
//
//  Created by cape start on 31/08/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "FIUnreadMenu.h"

@implementation FIUnreadMenu
-(void)setUnreadMenuObjectFromDic:(NSDictionary *)dictionary {
    self.nodeId = [dictionary objectForKey:@"id"];
    self.isParent = [dictionary objectForKey:@"isParent"];
    self.isSubscribed = [dictionary objectForKey:@"subscribed"];
    self.unreadCount = [dictionary objectForKey:@"unReadCount"];
}
@end
