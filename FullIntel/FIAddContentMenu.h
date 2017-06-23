//
//  FIAddContentMenu.h
//  RANE
//
//  Created by Arul on 23/06/17.
//  Copyright © 2017 CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FIAddContentMenu : NSObject
@property (nonatomic,strong) NSNumber *nodeId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSNumber *companyId;
@property BOOL isSubscribed;
@property BOOL isUnsubscribedByCompany;
@property BOOL forResearch;
@property BOOL isShared;
@property (nonatomic,strong) NSMutableArray *subList;
@property (nonatomic,strong) NSNumber *contentTypeForCustomerId;
+(FIAddContentMenu *)recursiveAddContentMenu:(NSDictionary *)dic;
@end
