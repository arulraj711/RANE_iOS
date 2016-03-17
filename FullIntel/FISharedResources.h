//
//  FISharedResources.h
//  FullIntel
//
//  Created by Arul on 2/26/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PKRevealController.h"
#import "UCZProgressView.h"
#import "Localytics.h"
@interface FISharedResources : NSObject {
    UCZProgressView *progressView;
    UIView *buttonBackView;
}
@property (nonatomic,strong) NSMutableArray *articleIdArray;
@property (nonatomic, strong, readwrite) PKRevealController *revealController;
+(FISharedResources*)sharedResourceManager;
-(void)getCuratedNewsListWithAccessToken:(NSString *)details withCategoryId:(NSNumber *)categoryId withContentTypeId:(NSNumber *)contentTypeId withFlag:(NSString *)updownFlag withLastArticleId:(NSString *)lastArticleId withActivityTypeId:(NSNumber *)activityTypeId;
-(void)getInfluencerListWithAccessToken:(NSString *)details;
-(void)getCuratedNewsDetailsWithDetails:(NSString *)details withSecurtityToken:(NSString *)securityToken;
-(void)getCuratedNewsAuthorDetailsWithDetails:(NSString *)details withArticleId:(NSString *)articleId;
-(void)getInfluencerDetailsWithDetails:(NSString *)details;
-(void)getMenuListWithAccessToken:(NSString *)accessToken;
-(void)getMenuUnreadCountWithAccessToken:(NSString *)accessToken;
-(void)getFolderListWithAccessToken:(NSString *)accessToken withFlag:(BOOL)flag withCreatedFlag:(BOOL)createdFlag;
-(void)getNewsLetterListWithAccessToken:(NSString *)accessToken;
-(void)sendMailWithAccessToken:(NSString *)accessToken withDetails:(NSString *)details;
-(void)createFolderWithDetails:(NSString *)details withAccessToken:(NSString *)accessToken;
-(void)pushNotificationWithDetails:(NSString *)details withAccessToken:(NSString *)accessToken;
-(void)updatePushNotificationWithDetails:(NSString *)details withAccessToken:(NSString *)accessToken;
-(void)fetchArticleFromFolderWithAccessToken:(NSString *)accessToken withFolderId:(NSNumber *)folderId withPageNo:(NSNumber *)pageNo withSize:(NSNumber *)size withUpFlag:(BOOL)flag withQuery:(NSString *)query withFilterBy:(NSString *)filterBy;
-(void)fetchArticleFromNewsLetterWithAccessToken:(NSString *)accessToken withNewsLetterId:(NSNumber *)newsletterId withPageNo:(NSNumber *)pageNo withSize:(NSNumber *)size withUpFlag:(BOOL)flag withFlag:(BOOL)test withQuery:(NSString *)query withFilterBy:(NSString *)filterBy;
-(void)saveArticleToFolderWithDetails:(NSString *)details withAccessToken:(NSString *)accessToken withArticleId:(NSString *)articleId;
-(void)addMultipleArticleToMultipleFolderWithDetails:(NSString *)details withAccessToken:(NSString *)accessToken;
-(void)removeArticleToFolderWithDetails:(NSString *)details withAccessToken:(NSString *)accessToken withArticleId:(NSString *)articleId;
-(void)renameFolderWithDetails:(NSString *)details withAccessToken:(NSString *)accessToken withFolderId:(NSNumber *)folderId;
-(void)updateUserActivitiesInBackgroundWithArticleId:(NSString *)articleId withStatus:(int)status withSelectedStatus:(BOOL)selectedStatus;
-(void)checkLoginUserWithDetails:(NSString *)details;
-(void)logoutUserWithDetails:(NSString *)details withFlag:(NSNumber*)authenticationFlag;
-(void)validateUserOnResumeWithDetails:(NSString *)details;
-(void)setUserActivitiesOnArticlesWithDetails:(NSString *)details withFlag :(BOOL)boolValue;
-(void)manageContentCategoryWithDetails:(NSString *)details withFlag:(NSInteger)flag;
-(void)sendResearchRequestWithDetails:(NSString *)details;
-(void)getCommentsWithDetails:(NSString *)details withArticleId:(NSString *)articleId;
-(void)addCommentsWithDetails:(NSString *)details;
-(void)updateAppViewTypeWithDetails:(NSString *)details;
-(void)featureAccessRequestWithDetails:(NSString *)details;
-(void)updateFolderId:(NSString *)entity withFolderId:(NSNumber *)folderId;
-(NSArray *)getTweetDetails:(NSString *)details;
-(void)markCommentAsReadWithDetails:(NSString *)details;
- (NSManagedObjectContext *)managedObjectContext;
- (void)showProgressView;
- (void)hideProgressView;
-(void)showBannerView;
-(void)closeBannerView;
- (BOOL)serviceIsReachable;
@property (nonatomic,strong) NSMutableArray *menuList;
@property (nonatomic,strong) NSMutableArray *menuUnReadCountArray;
@property (nonatomic,strong) NSMutableArray *folderList;
@property (nonatomic,strong) NSMutableArray *newsLetterList;
@property (nonatomic,strong) NSMutableArray *contentCategoryList;
@property (nonatomic,strong) NSMutableArray *contentTypeList;
@property (nonatomic,strong) NSString *getCommentArticleId;
@property (nonatomic,strong) NSString *getCommentDetailString;

-(void)saveDetailsInLocalyticsWithName:(NSString *)name;
- (void)tagScreenInLocalytics:(NSString *)name;

//Chart API
-(void)getReportList;//Get total report list
-(void)getSingleReportDetailsForReportId:(NSNumber *)reportId;
-(void)getTrendOfCoverageChartInfoFromDate:(NSNumber *)fromDate toDate:(NSNumber *)toDate;
-(void)getKeyTopicsChartInfoFromDate:(NSNumber *)fromDate toDate:(NSNumber *)toDate;
-(void)getMediaTypeChartInfoFromDate:(NSNumber *)fromDate toDate:(NSNumber *)toDate;
-(void)getSentimentAndVolumeOverTimeChartInfoFromDate:(NSNumber *)fromDate toDate:(NSNumber *)toDate;
-(void)getChangeOverLastQuarterChartInfoFromDate:(NSNumber *)fromDate toDate:(NSNumber *)toDate;
-(void)getTopSourcesChartInfoFromDate:(NSNumber *)fromDate toDate:(NSNumber *)toDate;
-(void)getTopJournalistChartInfoFromDate:(NSNumber *)fromDate toDate:(NSNumber *)toDate;
-(void)getTopInfluencerChartInfoFromDate:(NSNumber *)fromDate toDate:(NSNumber *)toDate;
-(void)getTopStoriesChartInfoFromDate:(NSNumber *)fromDate toDate:(NSNumber *)toDate withPageNo:(NSNumber *)pageNo withSize:(NSNumber *)size;

-(void)getTrendOfCoverageArticleListFromDate:(NSString *)clickedDate endDateIn:(NSString *)endDateIn fromDate:(NSNumber *)fromDate toDate:(NSNumber *)toDate withSize:(NSNumber *)size withPageNo:(NSNumber *)pageNo withFilterBy:(NSString *)filterBy withQuery:(NSString *)query withFlag:(NSString *)updownFlag withLastArticleId:(NSString *)lastArticleId;

-(BOOL)clearChartRelatedArticles:(NSString *)entity;//clear local chart article data


-(void)getKeyTopicsArticleListFromField1:(NSString *)field_1 value1:(NSString *)value_1 fromDate:(NSNumber *)fromDate toDate:(NSNumber *)toDate withSize:(NSNumber *)size withPageNo:(NSNumber *)pageNo withFilterBy:(NSString *)filterBy withQuery:(NSString *)query withFlag:(NSString *)updownFlag withLastArticleId:(NSString *)lastArticleId;

-(void)getMediaTypesArticleListFromMediaTypeField:(NSString *)mediaTypeId mediaTypeValue:(NSString *)mediaTypeValue fromDate:(NSNumber *)fromDate toDate:(NSNumber *)toDate withSize:(NSNumber *)size withPageNo:(NSNumber *)pageNo withFilterBy:(NSString *)filterBy withQuery:(NSString *)query withFlag:(NSString *)updownFlag withLastArticleId:(NSString *)lastArticleId;

@end
