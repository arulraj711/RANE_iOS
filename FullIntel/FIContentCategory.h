//
//  FIContentCategory.h
//  FullIntel
//
//  Created by Capestart on 5/4/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FIContentCategory : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSMutableArray *listArray;
@property (nonatomic,strong) NSNumber *categoryId;
@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,strong) NSNumber *companyId;
@property (nonatomic,strong) NSNumber *contentTypeForCustomerId;
@property (assign) BOOL isSubscribed;
@property (assign) BOOL isCompanySubscribed;
@property (nonatomic,strong) NSNumber *subListAvailable;
//-(void)createMenuFromDic:(NSDictionary *)dic;
+(FIContentCategory *)recursiveMenu:(NSDictionary *)dic;
@end
