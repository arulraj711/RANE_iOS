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
+(void)fetchCuratedNewsListWithAccessToken:(NSString*)details withActivityTypeID:(NSNumber *)activityTypeId
               onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+(void)fetchInfluencerListWithAccessToken:(NSString*)details
                                 onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+(void)fetchMenuListWithAccessToken:(NSString*)accessToken
                                 onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)fetchMenuUnreadCountWithAccessToken:(NSString*)accessToken
                                 onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)fetchAddContentWithAccessToken:(NSString*)accessToken
                            onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)fetchFolderListWithAccessToken:(NSString*)accessToken
                            onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)fetchNewsLetterListWithAccessToken:(NSString*)accessToken
                            onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)sendMailWithAccessToken:(NSString*)accessToken withDetails:(NSString *)details
                     onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)createFolderWithDetails:(NSString*)details withSecurityToken:(NSString *)securityToken
                     onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)saveArticlesToFolderWithDetails:(NSString*)details withSecurityToken:(NSString *)    securityToken withFolderId:(NSString *)articleId
                             onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)addMultipleArticlesToMultipleFolderWithDetails:(NSString*)details withSecurityToken:(NSString *)securityToken onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)pushNotificationWithDetails:(NSString*)details withSecurityToken:(NSString *)securityToken
                         onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)updatePushNotificationWithDetails:(NSString*)details withSecurityToken:(NSString *)securityToken
                               onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)removeArticlesFromFolderWithDetails:(NSString*)details withSecurityToken:(NSString *)    securityToken withArticleId:(NSString *)articleId
                                 onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)renameFolderWithDetails:(NSString*)details withSecurityToken:(NSString *)    securityToken withFolderId:(NSNumber *)folderId
                     onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+(void)fetchArticlesFromFolderWithSecurityToken:(NSString *)securityToken withFolderId:(NSString *)folderId withPageNo:(NSNumber *)pageNo withSize:(NSNumber *)sizeVal withQuery:(NSString*)query withFilterBy:(NSString *)filterBy onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)fetchArticlesFromNewsLetterWithSecurityToken:(NSString *)securityToken withNewsLetterId:(NSNumber *)newsletterId withPageNo:(NSNumber *)pageNo withSize:(NSNumber *)sizeVal withQuery:(NSString *)query withFilterBy:(NSString *)filterBy onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


+(void)loginProcessWithDetails:(NSString*)details
              onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


+(void)forgotPasswordWithDetails:(NSString*)details
                     onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


+(void)fetchCuratedNewsDetailsWithDetails:(NSString *)details withSecurtityToken:(NSString *)securityToken
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
//Chart API
+(void)getReportListonSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+(void)getSingleReportDetailsForReportId:(NSNumber*)reportId
             onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//Get trend of coverage chart info
+(void)getTrendOfCoverageInfoFromDate:(NSNumber*)fromDate toDate:(NSNumber *)toDate withAPILink:(NSString*)apiLink onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//Get Key Topics Chart Info
+(void)getKeyTopicsInfoFromDate:(NSNumber*)fromDate toDate:(NSNumber *)toDate withAPILink:(NSString*)apiLink onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//Get Media Type Chart Info
+(void)getMediaTypeInfoFromDate:(NSNumber*)fromDate toDate:(NSNumber *)toDate withAPILink:(NSString*)apiLink onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//Get getSentimentAndVolumeOverTime Chart Info
+(void)getSentimentAndVolumeOverTimeInfoFromDate:(NSNumber*)fromDate toDate:(NSNumber *)toDate withAPILink:(NSString*)apiLink onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//Get ChangeOverLastQuarter Chart Info
+(void)getChangeOverLastQuarterInfoFromDate:(NSNumber*)fromDate toDate:(NSNumber *)toDate withAPILink:(NSString*)apiLink onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//Get TopSources Chart Info
+(void)getTopSourcesInfoFromDate:(NSNumber*)fromDate toDate:(NSNumber *)toDate withAPILink:(NSString*)apiLink onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//Get TopJournalist Chart Info
+(void)getTopJournalistInfoFromDate:(NSNumber*)fromDate toDate:(NSNumber *)toDate withAPILink:(NSString*)apiLink onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//Get TopInfluencer Chart Info
+(void)getTopInfluencerInfoFromDate:(NSNumber*)fromDate toDate:(NSNumber *)toDate withAPILink:(NSString*)apiLink onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//Get TopStories Info
+(void)getTopStoriesInfoFromDate:(NSNumber*)fromDate toDate:(NSNumber *)toDate withPageNumber:(NSNumber *)pageNo withSize:(NSNumber *)size onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//Get articles list from Trend of coverage chart selection
+(void)fetchTrendOfCoverageArticleListWithClickedDate:(NSString*)clickedDate EndDateIn:(NSString *)endDateIn fromDate:(NSNumber *)fromDate toDate:(NSNumber *)toDate withModules:(NSString *)modules withTags:(NSString *)tags withPageNo:(NSNumber *)pageNo withSize:(NSNumber *)size withFilterBy:(NSString *)filterBy withQuery:(NSString *)query onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//Get articles list from key topics chart selection
+(void)fetchKeyTopicsArticleListWithField1:(NSString*)field_1 value1:(NSString *)value_1 fromDate:(NSNumber *)fromDate toDate:(NSNumber *)toDate withModules:(NSString *)modules withTags:(NSString *)tags withPageNo:(NSNumber *)pageNo withSize:(NSNumber *)size withFilterBy:(NSString *)filterBy withQuery:(NSString *)query onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//Get articles list from key topics chart selection
+(void)fetchMediaTypeArticleListWithMediaTypeField:(NSString*)mediaType_field mediaTypeValue:(NSString *)mediaType_value fromDate:(NSNumber *)fromDate toDate:(NSNumber *)toDate withModules:(NSString *)modules withTags:(NSString *)tags withPageNo:(NSNumber *)pageNo withSize:(NSNumber *)size withFilterBy:(NSString *)filterBy withQuery:(NSString *)query onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//Get articles list from sentiment and volume over time
+(void)fetchSentimentAndVolumeOverTimeArticleListWithClickedDate:(NSString*)clickedDate EndDateIn:(NSString *)endDateIn field1:(NSString *)field_1 field2:(NSString *)field_2 value1:(NSString *)value_1 value2:(NSString *)value_2 fromDate:(NSNumber *)fromDate toDate:(NSNumber *)toDate withModules:(NSString *)modules withTags:(NSString *)tags withPageNo:(NSNumber *)pageNo withSize:(NSNumber *)size withFilterBy:(NSString *)filterBy withQuery:(NSString *)query onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//Get article list from change over last quarter
+(void)fetchChangeOverLastQuarterArticleListWithClickedDate:(NSString*)clickedDate EndDateIn:(NSString *)endDateIn field1:(NSString *)field_1 value1:(NSString *)value_1 fromDate:(NSNumber *)fromDate toDate:(NSNumber *)toDate withModules:(NSString *)modules withTags:(NSString *)tags withPageNo:(NSNumber *)pageNo withSize:(NSNumber *)size withFilterBy:(NSString *)filterBy withQuery:(NSString *)query onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


//Get articles list from horizontal line bar chart
+(void)fetchHorizontalLineBarChartArticleListWithField1:(NSString *)field_1 field2:(NSString *)field_2 value1:(NSString *)value_1 value2:(NSString *)value_2 fromDate:(NSNumber *)fromDate toDate:(NSNumber *)toDate withModules:(NSString *)modules withTags:(NSString *)tags withPageNo:(NSNumber *)pageNo withSize:(NSNumber *)size withFilterBy:(NSString *)filterBy withQuery:(NSString *)query onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//Report download functionality
+(void)downloadReportForReportId:(NSNumber*)reportId
                               onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
