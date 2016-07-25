//
//  FIMenu.h
//  FullIntel
//
//  Created by Arul on 3/2/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FIMenu : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSMutableArray *listArray;
@property (nonatomic,strong) NSNumber *nodeId;
@property (nonatomic,strong) NSNumber *companyId;
@property (nonatomic,strong) NSNumber *unreadCount;
@property (nonatomic,strong) NSNumber *isParent;
@property (nonatomic,strong) NSNumber *isSubscribed;
@property (nonatomic,strong) NSNumber *subListAvailable;
@property (nonatomic,strong) NSNumber *articleCount;
-(void)createMenuFromDic:(NSDictionary *)dic;
+(FIMenu *)recursiveMenu:(NSDictionary *)dic;
@end
