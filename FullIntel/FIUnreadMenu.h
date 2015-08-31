//
//  FIUnreadMenu.h
//  FullIntel
//
//  Created by cape start on 31/08/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FIUnreadMenu : NSObject
@property (nonatomic,strong) NSNumber *nodeId;
@property (nonatomic,strong) NSNumber *isParent;
@property (nonatomic,strong) NSNumber *isSubscribed;
@property (nonatomic,strong) NSNumber *unreadCount;
-(void)setUnreadMenuObjectFromDic:(NSDictionary *)dictionary;
@end
