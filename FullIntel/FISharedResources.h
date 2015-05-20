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
@interface FISharedResources : NSObject {
    UCZProgressView *progressView;
}
@property (nonatomic,strong) NSMutableArray *articleIdArray;
@property (nonatomic, strong, readwrite) PKRevealController *revealController;
+(FISharedResources*)sharedResourceManager;
-(void)getCuratedNewsListWithAccessToken:(NSString *)details withCategoryId:(NSInteger)categoryId withFlag:(NSString *)updownFlag;
-(void)getInfluencerListWithAccessToken:(NSString *)details;
-(void)getCuratedNewsDetailsWithDetails:(NSString *)details;
-(void)getCuratedNewsAuthorDetailsWithDetails:(NSString *)details withArticleId:(NSString *)articleId;
-(void)getInfluencerDetailsWithDetails:(NSString *)details;
-(void)getMenuListWithAccessToken:(NSString *)accessToken;
-(void)checkLoginUserWithDetails:(NSString *)details;
-(void)logoutUserWithDetails:(NSString *)details withFlag:(NSNumber*)authenticationFlag;
-(void)validateUserOnResumeWithDetails:(NSString *)details;
-(void)setUserActivitiesOnArticlesWithDetails:(NSString *)details;
-(void)manageContentCategoryWithDetails:(NSString *)details withFlag:(NSInteger)flag;
-(void)sendResearchRequestWithDetails:(NSString *)details;
-(void)getCommentsWithDetails:(NSString *)details withArticleId:(NSString *)articleId;
-(void)addCommentsWithDetails:(NSString *)details;
- (NSManagedObjectContext *)managedObjectContext;
- (void)showProgressView;
- (void)hideProgressView;
@property (nonatomic,strong) NSMutableArray *menuList;
@property (nonatomic,strong) NSMutableArray *contentCategoryList;
@property (nonatomic,strong) NSMutableArray *contentTypeList;
@property (nonatomic,strong) NSString *getCommentArticleId;
@property (nonatomic,strong) NSString *getCommentDetailString;
@end
