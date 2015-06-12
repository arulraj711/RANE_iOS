//
//  FIUtils.h
//  FullIntel
//
//  Created by Arul on 3/30/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface FIUtils : NSObject
+(NSString*)getDateFromTimeStamp:(double)timeStamp;
+(NSString*)createInputJsonForContentWithToekn:(NSString *)securityToken lastArticleId:(NSString *)articleId contentTypeId:(NSString *)contentTypeId listSize:(NSInteger)listSize activityTypeId:(NSString*)activityTypeId categoryId:(NSNumber *)categoryId;
+(UIColor*)colorWithHexString:(NSString*)hex;
+(void)deleteExistingData;
+(void)showErrorToast;
+(void)showNoNetworkToast;
+(void)showRequestTimeOutError;
+(void)makeRoundedView:(UIView*)view;
+(void)callRequestionUpdateWithModuleId:(NSInteger)moduleId
                          withFeatureId:(NSInteger)featureId;
@end
