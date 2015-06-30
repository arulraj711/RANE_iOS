//
//  FIWebService.h
//  FullIntel
//
//  Created by Arul on 2/26/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface FIWebService : NSObject

+(NSString *) getServerURL;
+(void) setServerURL:(NSString *)url;
+(void)fetchCuratedNewsListWithAccessToken:(NSString*)details
               onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+(void)fetchInfluencerListWithAccessToken:(NSString*)details
                                 onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+(void)fetchMenuListWithAccessToken:(NSString*)accessToken
                                 onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)fetchFolderListWithAccessToken:(NSString*)accessToken
                            onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)createFolderWithDetails:(NSString*)details withSecurityToken:(NSString *)securityToken
                     onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)loginProcessWithDetails:(NSString*)details
              onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


+(void)forgotPasswordWithDetails:(NSString*)details
                     onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


+(void)fetchCuratedNewsDetailsWithDetails:(NSString *)details
                          onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)fetchCuratedNewsAuthorDetailsWithDetails:(NSString *)details
                                onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)fetchInfluencerDetailsWithDetails:(NSString *)details
                                onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)userActivitiesOnArticlesWithDetails:(NSString *)details
                               onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)logoutWithAccessToken:(NSString*)details
                                 onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)validateUserOnResumeWithAccessToken:(NSString*)details
                   onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)manageContentCategoryWithAccessToken:(NSString*)details
                                 onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)sendResearchRequestWithDetails:(NSString*)details
                                  onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                  onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)getCommentsWithDetails:(NSString*)details
                            onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)addCommentsWithDetails:(NSString*)details
                    onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)updateAppViewTypeWithDetails:(NSString*)details
                    onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+(void)featureAccessRequestWithDetails:(NSString*)details
                          onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)getStockListDetails:(NSString*)details
                 onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)getTweetDetails:(NSString*)withScreenName
                 onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)commentMarkAsReadWithDetails:(NSString*)details
                             onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
