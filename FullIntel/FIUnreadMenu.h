//
//  FIUnreadMenu.h
//  FullIntel
//
//  Created by cape start on 31/08/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FIUnreadMenu : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSNumber *nodeId;
@property (nonatomic,strong) NSNumber *isParent;
@property (nonatomic,strong) NSNumber *isSubscribed;
@property (nonatomic,strong) NSNumber *unreadCount;
@property (nonatomic,strong) NSNumber *articleCount;
@property (strong,nonatomic) NSNumber *companyId;
@property (nonatomic,strong) NSNumber *subListAvailable;
@property (nonatomic,strong) NSMutableArray *listArray;
-(void)setUnreadMenuObjectFromDic:(NSDictionary *)dictionary;
+(FIUnreadMenu *)recursiveUnReadMenu:(NSDictionary *)dic;
@end
