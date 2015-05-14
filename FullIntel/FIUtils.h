//
//  FIUtils.h
//  FullIntel
//
//  Created by Arul on 3/30/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FIUtils : NSObject
+(NSString*)getDateFromTimeStamp:(double)timeStamp;
+(NSString*)createInputJsonForContentWithToekn:(NSString *)securityToken lastArticleId:(NSString *)articleId contentTypeId:(NSString *)contentTypeId listSize:(NSInteger)listSize activityTypeId:(NSString*)activityTypeId categoryId:(NSNumber *)categoryId;
+(void)deleteExistingData;
+(void)showErrorToast;
+(void)showNoNetworkToast;
@end
