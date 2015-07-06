//
//  FISharedResources.m
//  FullIntel
//
//  Created by Arul on 2/26/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "FISharedResources.h"
#import "FIWebService.h"
#import "FIMenu.h"
#import "Reachability.h"
#import "LeftViewController.h"
//#import "MBProgressHUD.h"
#import "FIUtils.h"
#import "FIContentCategory.h"
#import "UIView+Toast.h"
#import "AppDelegate.h"
#import "FIFolder.h"
#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

@implementation FISharedResources
+(FISharedResources*)sharedResourceManager
{
    
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
        [_sharedObject initDefaults];
        
    });
    return _sharedObject;
}

-(void)initDefaults {
    _menuList = [[NSMutableArray alloc]init];
    _folderList = [[NSMutableArray alloc]init];
    _contentCategoryList = [[NSMutableArray alloc]init];
    _articleIdArray = [[NSMutableArray alloc]init];
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(void)checkLoginUserWithDetails:(NSString *)details{
    UIWindow *window = [[UIApplication sharedApplication]windows][0];
    window.userInteractionEnabled = NO;
    if([self serviceIsReachable]) {
       // [self showProgressHUDForView];
        [FIWebService loginProcessWithDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

            NSDictionary *preferenceDic = NULL_TO_NIL([responseObject objectForKey:@"preferences"]);
            [[NSUserDefaults standardUserDefaults]setObject:NULL_TO_NIL([preferenceDic objectForKey:@"headerColor"]) forKey:@"headerColor"];
            [[NSUserDefaults standardUserDefaults]setObject:NULL_TO_NIL([preferenceDic objectForKey:@"highlightColor"]) forKey:@"highlightColor"];
            [[NSUserDefaults standardUserDefaults]setObject:NULL_TO_NIL([preferenceDic objectForKey:@"menuBgColor"]) forKey:@"menuBgColor"];
            [[NSUserDefaults standardUserDefaults]setObject:NULL_TO_NIL([responseObject objectForKey:@"securityToken"]) forKey:@"accesstoken"];
            [[NSUserDefaults standardUserDefaults]setObject:NULL_TO_NIL([responseObject valueForKey:@"companyLogoURL"]) forKey:@"companyLogo"];
            [[NSUserDefaults standardUserDefaults]setObject:NULL_TO_NIL([responseObject valueForKey:@"companyName"]) forKey:@"companyName"];
            [[NSUserDefaults standardUserDefaults]setObject:NULL_TO_NIL([responseObject valueForKey:@"customerid"]) forKey:@"customerId"];
            [[NSUserDefaults standardUserDefaults]setObject:NULL_TO_NIL([responseObject valueForKey:@"userid"]) forKey:@"userId"];
            [[NSUserDefaults standardUserDefaults]setObject:NULL_TO_NIL([responseObject valueForKey:@"firstName"]) forKey:@"firstName"];
            [[NSUserDefaults standardUserDefaults]setObject:NULL_TO_NIL([responseObject valueForKey:@"photoUrl"]) forKey:@"photoUrl"];
            [[NSUserDefaults standardUserDefaults]setObject:NULL_TO_NIL([responseObject valueForKey:@"userAccountTypeId"]) forKey:@"userAccountTypeId"];
            NSString *appViewType = [NSString stringWithFormat:@"%@",NULL_TO_NIL([responseObject valueForKey:@"appViewTypeId"])];
            
            if([appViewType isEqualToString:@"1"]) {
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFIViewSelected"];
            } else if([appViewType isEqualToString:@"2"]) {
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isFIViewSelected"];
            }
            
            
            //[[NSUserDefaults standardUserDefaults]setObject:[responseObject valueForKey:@"appViewTypeId"] forKey:@"appViewTypeId"];
            NSString *username = [NSString stringWithFormat:@"%@ %@",NULL_TO_NIL([responseObject valueForKey:@"firstName"]),NULL_TO_NIL([responseObject valueForKey:@"lastName"])];
            [[NSUserDefaults standardUserDefaults]setObject:username forKey:@"username"];
            window.userInteractionEnabled = YES;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Login" object:responseObject];

        } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
            window.userInteractionEnabled = YES;
            [FIUtils showErrorToast];
            //[self hideProgressHUDForView];
        }];
        
    } else {
        window.userInteractionEnabled = YES;
        [FIUtils showNoNetworkToast];
        //[self hideProgressHUDForView];
    }
    
}


-(void)logoutUserWithDetails:(NSString *)details withFlag:(NSNumber*)authenticationFlag {
    
    if([self serviceIsReachable]) {
        
        [FIWebService logoutWithAccessToken:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if([authenticationFlag isEqualToNumber:[NSNumber numberWithInt:1]]) {
                
                UIWindow *window = [[UIApplication sharedApplication]windows][0];
                [window makeToast:[responseObject objectForKey:@"message"] duration:1 position:CSToastPositionCenter];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"logoutSuccess" object:nil];
            }else {
                
                
                //NSString *errMsg = [NSString stringWithFormat:@"%@"];
                
                UIWindow *window = [[UIApplication sharedApplication]windows][0];
                [window makeToast:@"Seems like your session may have expired. This could also happen if the same credentials are used to login using another device. Please login again." duration:2 position:CSToastPositionCenter];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"AddContentExpire" object:responseObject];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"CommentsExpire" object:responseObject];
            }
            
            
        } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [FIUtils showErrorToast];
        }];
        
    } else {
        [FIUtils showNoNetworkToast];
    }
}


-(void)validateUserOnResumeWithDetails:(NSString *)details {
    if([self serviceIsReachable]) {
        // [self showProgressHUDForView];
        [FIWebService validateUserOnResumeWithAccessToken:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if([[responseObject objectForKey:@"isAuthenticated"]isEqualToNumber:[NSNumber numberWithInt:1]]) {
                //Update read/unread status in DB
                NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
                NSPredicate *predicate  = [NSPredicate predicateWithFormat:@"isReadStatusSync == %@",[NSNumber numberWithBool:YES]];
                [fetchRequest setPredicate:predicate];
                NSArray *syncArray =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
                NSLog(@"sync array count:%lu",(unsigned long)syncArray.count);
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    for(NSManagedObject *curatedNews in syncArray) {
                        [self updateReadStatusInBackgroundWithArticleId:[curatedNews valueForKey:@"articleId"] withStatus:1];
                        NSFetchRequest *fetchRequest1 = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
                        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"articleId == %@",[curatedNews valueForKey:@"articleId"]];
                        [fetchRequest1 setPredicate:predicate1];
                        NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest1 error:nil] mutableCopy];
                        if(newPerson.count != 0) {
                            NSManagedObject *curatedNews = [newPerson objectAtIndex:0];
                            [curatedNews setValue:[NSNumber numberWithBool:NO] forKey:@"isReadStatusSync"];
                        }
                        [managedObjectContext save:nil];
                    }
                });
            } else {
                [self showLoginView:[responseObject objectForKey:@"isAuthenticated"]];
            }
        } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [FIUtils showErrorToast];
        }];
        
    } else {
        [FIUtils showNoNetworkToast];
    }
}


-(void)updateReadStatusInBackgroundWithArticleId:(NSString *)articleId withStatus:(int)status {
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
    [resultDic setObject:articleId forKey:@"selectedArticleId"];
    [resultDic setObject:@"1" forKey:@"status"];
    [resultDic setObject:@"true" forKey:@"isSelected"];
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
    [[FISharedResources sharedResourceManager]setUserActivitiesOnArticlesWithDetails:resultStr];
}

-(void)showLoginView:(NSNumber *)authFlag {
    NSMutableDictionary *logoutDic = [[NSMutableDictionary alloc] init];
    [logoutDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:logoutDic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
    [self logoutUserWithDetails:resultStr withFlag:authFlag];
    [FIUtils deleteExistingData];
    
    [self.menuList removeAllObjects];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"accesstoken"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"authenticationFailed" object:nil];
}

- (BOOL)clearEntity:(NSString *)entity withCategoryId:(NSNumber *)categoryId{
    NSManagedObjectContext *myContext = [self managedObjectContext];
    NSFetchRequest *fetchAllObjects = [[NSFetchRequest alloc] init];
    [fetchAllObjects setEntity:[NSEntityDescription entityForName:entity inManagedObjectContext:myContext]];
    [fetchAllObjects setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"categoryId == %@",categoryId];
    [fetchAllObjects setPredicate:predicate];
    NSError *error = nil;
    NSArray *allObjects = [myContext executeFetchRequest:fetchAllObjects error:&error];
    for (NSManagedObject *object in allObjects) {
        [myContext deleteObject:object];
    }

    NSError *saveError = nil;
    if (![myContext save:&saveError]) {
    
    }

    return (saveError == nil);
}

-(BOOL)clearEntity:(NSString *)entity {
    NSManagedObjectContext *myContext = [self managedObjectContext];
    NSFetchRequest *fetchAllObjects = [[NSFetchRequest alloc] init];
    [fetchAllObjects setEntity:[NSEntityDescription entityForName:entity inManagedObjectContext:myContext]];
    [fetchAllObjects setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    NSError *error = nil;
    NSArray *allObjects = [myContext executeFetchRequest:fetchAllObjects error:&error];
    for (NSManagedObject *object in allObjects) {
        [myContext deleteObject:object];
    }
    
    NSError *saveError = nil;
    if (![myContext save:&saveError]) {
        
    }
    
    return (saveError == nil);
}


-(void)getCuratedNewsListWithAccessToken:(NSString *)details withCategoryId:(NSNumber *)categoryId withFlag:(NSString *)updownFlag withLastArticleId:(NSString *)lastArticleId {
   // [self showProgressView];
    
    if([self serviceIsReachable]) {
    [FIWebService fetchCuratedNewsListWithAccessToken:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([[responseObject objectForKey:@"isAuthenticated"]isEqualToNumber:[NSNumber numberWithInt:1]]) {
        [self hideProgressView];
        NSArray *curatedNewsArray = [responseObject objectForKey:@"articleList"];
            
            //Handle Pagination
            if(curatedNewsArray.count == 0) {
                if(lastArticleId.length != 0){
                    UIWindow *window = [[UIApplication sharedApplication]windows][0];
                    [window makeToast:@"No more articles to display" duration:1 position:CSToastPositionCenter];
                }
            }
            
            //Handle pull down to refresh
            if([updownFlag isEqualToString:@"up"]) {
                if([categoryId isEqualToNumber:[NSNumber numberWithInt:-2]]) {
                    [self clearEntity:@"CuratedNews" withCategoryId:categoryId];
                }
            }
            
        for(NSDictionary *dic in curatedNewsArray) {
            
            NSManagedObjectContext *context;
            // Create a new managed object
            NSManagedObject *curatedNews;
            NSManagedObject *curatedNewsDrillIn;
            context = [self managedObjectContext];
            
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@ AND categoryId == %@",[dic objectForKey:@"id"],categoryId];
            [fetchRequest setPredicate:predicate];
            NSArray *existingArray = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
            
            if(existingArray.count != 0) {
                //Excisting Object
                curatedNews = [existingArray objectAtIndex:0];
            } else {
                //Create new object
                curatedNews = [NSEntityDescription insertNewObjectForEntityForName:@"CuratedNews" inManagedObjectContext:context];
                
                [curatedNews setValue:categoryId forKey:@"categoryId"];
                [curatedNews setValue:[dic objectForKey:@"readStatus"] forKey:@"readStatus"];
                [_articleIdArray addObject:[dic objectForKey:@"id"]];
            }
            
            //Set values in local db
            
            [curatedNews setValue:[NSNumber numberWithBool:NO] forKey:@"isFolder"];
            [curatedNews setValue:[NSNumber numberWithInt:0] forKey:@"folderId"];
            [curatedNews setValue:[dic objectForKey:@"id"] forKey:@"articleId"];
            [curatedNews setValue:[dic objectForKey:@"articleHeading"] forKey:@"title"];
            [curatedNews setValue:[dic objectForKey:@"articleDescription"] forKey:@"desc"];
            [curatedNews setValue:[dic objectForKey:@"articleModifiedDate"] forKey:@"date"];
            [curatedNews setValue:[dic objectForKey:@"articlePublishedDate"] forKey:@"publishedDate"];
            [curatedNews setValue:[dic objectForKey:@"articleImageURL"] forKey:@"image"];
            [curatedNews setValue:[dic objectForKey:@"articleUrl"] forKey:@"articleUrl"];
            [curatedNews setValue:[dic objectForKey:@"articleTypeId"] forKey:@"articleTypeId"];
            [curatedNews setValue:[dic objectForKey:@"articleType"] forKey:@"articleType"];
            [curatedNews setValue:[dic objectForKey:@"markAsImportant"] forKey:@"markAsImportant"];
            
            
            NSNumber *markImp = [dic valueForKey:@"markAsImportant"];
            if([markImp isEqualToNumber:[NSNumber numberWithInt:1]]){
                NSDictionary *markedImpDictionary = [dic objectForKey:@"markAsImportantUserDetail"];
                [curatedNews setValue:[markedImpDictionary objectForKey:@"name"] forKey:@"markAsImportantUserName"];
                [curatedNews setValue:[markedImpDictionary objectForKey:@"userId"] forKey:@"markAsImportantUserId"];
            }
            [curatedNews setValue:[dic objectForKey:@"saveForLater"] forKey:@"saveForLater"];
            
            //Fetch saved for later data in background
            NSNumber *activityTypeId = [dic valueForKey:@"saveForLater"];
            if([activityTypeId isEqualToNumber:[NSNumber numberWithInt:1]]) {
                NSString *str = [dic objectForKey:@"articleUrl"];
                if(str.length != 0) {
                    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                        NSString *string = [NSString stringWithContentsOfURL:[NSURL URLWithString:str] encoding:NSASCIIStringEncoding error:nil];
                        [curatedNews setValue:string forKey:@"articleUrlData"];
                    });
                }
            }
            
            //Set outlet info
            NSArray *outletArray = [dic objectForKey:@"outlet"];
            if(outletArray.count != 0){
                NSDictionary *outletDic = [outletArray objectAtIndex:0];
                 [curatedNews setValue:[outletDic objectForKey:@"outletname"] forKey:@"outlet"];
            }
            //Set author info
            NSArray *authorArray = [dic objectForKey:@"author"];
            NSMutableArray *authorList = [[NSMutableArray alloc]init];
            for(NSDictionary *dict in authorArray) {
                NSManagedObject *author;
                author = [NSEntityDescription insertNewObjectForEntityForName:@"CuratedAuthor" inManagedObjectContext:context];
                [author setValue:[dict objectForKey:@"name"] forKey:@"name"];
                [author setValue:[dict objectForKey:@"title"] forKey:@"title"];
                [author setValue:[dict objectForKey:@"image"] forKey:@"image"];
                [authorList addObject:author];
                
            }
            NSOrderedSet *Obj = [[NSOrderedSet alloc]initWithArray:authorList];
            [curatedNews setValue:Obj forKey:@"author"];
          //Set legend list info
            NSSet *legendsSet1 = [curatedNews valueForKey:@"legends"];
            if(legendsSet1.count == 0) {
                NSArray *legendsArray = [dic objectForKey:@"legendList"];
                NSMutableArray *legendsList = [[NSMutableArray alloc]init];
                //[self clearEntity:@"CuratedLegends"];
                for(NSDictionary *dict in legendsArray) {
                    NSManagedObject *legends;
                    legends = [NSEntityDescription insertNewObjectForEntityForName:@"CuratedLegends" inManagedObjectContext:context];
                    
                    [legends setValue:[dict objectForKey:@"name"] forKey:@"name"];
                    [legends setValue:[dict objectForKey:@"flag"] forKey:@"flag"];
                    [legends setValue:[dict objectForKey:@"url"] forKey:@"url"];
                    
                    [legendsList addObject:legends];
                    
                }
                NSSet *legendsSet = [NSSet setWithArray:legendsList];
                [curatedNews setValue:legendsSet forKey:@"legends"];
            }
            
            
            //Set CuratedNewsDetails
            curatedNewsDrillIn = [NSEntityDescription insertNewObjectForEntityForName:@"CuratedNewsDetail" inManagedObjectContext:context];
            [curatedNewsDrillIn setValue:[dic objectForKey:@"id"] forKey:@"articleId"];
//            [curatedNewsDrillIn setValue:[[responseObject objectForKey:@"articleDetail"] objectForKey:@"totalComments"] forKey:@"totalComments"];
//            [curatedNewsDrillIn setValue:[[responseObject objectForKey:@"articleDetail"] objectForKey:@"unReadComment"] forKey:@"unReadComment"];
            [curatedNewsDrillIn setValue:[dic objectForKey:@"articleDetailedDescription"] forKey:@"article"];
            //Set Related Post
            NSArray *relatedPostArray = [dic objectForKey:@"articleRelatedPosts"];
            NSMutableArray *postArray = [[NSMutableArray alloc]init];
            for(NSDictionary *postDic in relatedPostArray) {
                NSManagedObject *relatedPost = [NSEntityDescription insertNewObjectForEntityForName:@"RelatedPost" inManagedObjectContext:context];
                [relatedPost setValue:[postDic valueForKey:@"postId"] forKey:@"postId"];
                [relatedPost setValue:[postDic valueForKey:@"socialMediaUsername"] forKey:@"socialMediaUsername"];
                [relatedPost setValue:[postDic valueForKey:@"tweetURL"] forKey:@"tweetURL"];
                [postArray addObject:relatedPost];
            }
            
            NSOrderedSet *outletObj = [[NSOrderedSet alloc]initWithArray:postArray];
            [curatedNewsDrillIn setValue:outletObj forKey:@"relatedPost"];
            [curatedNews setValue:curatedNewsDrillIn forKey:@"details"];
            
            
            //Set CuratedNews Author Details
            NSArray *authorDetailsArray = [dic objectForKey:@"articleContact"];
            //NSLog(@"before author count:%lu",(unsigned long)authorDetailsArray.count);
            NSMutableArray *authorDetailsList = [[NSMutableArray alloc]init];
            for(NSDictionary *dic in authorDetailsArray) {
                NSManagedObject *authorDetails;
                authorDetails = [NSEntityDescription insertNewObjectForEntityForName:@"CuratedNewsDetailAuthor" inManagedObjectContext:context];
                [authorDetails setValue:[dic valueForKey:@"id"] forKey:@"id"];
                [authorDetails setValue:[dic valueForKey:@"firstName"] forKey:@"firstName"];
                [authorDetails setValue:[dic valueForKey:@"lastName"] forKey:@"lastName"];
                [authorDetails setValue:[dic valueForKey:@"city"] forKey:@"city"];
                [authorDetails setValue:[dic valueForKey:@"country"] forKey:@"country"];
                [authorDetails setValue:[dic valueForKey:@"imageURL"] forKey:@"imageURL"];
                [authorDetails setValue:[dic valueForKey:@"bibliography"] forKey:@"bibliography"];
                [authorDetails setValue:[dic valueForKey:@"isInfluencer"] forKey:@"isInfluencer"];
                [authorDetails setValue:[dic valueForKey:@"starRating"] forKey:@"starRating"];
                
                
                NSArray *authorOutletArray = [dic valueForKey:@"outlet"];
                NSMutableArray *outletArray = [[NSMutableArray alloc]init];
                for(NSDictionary *outletDic in authorOutletArray) {
                    NSManagedObject *authorOutlet = [NSEntityDescription insertNewObjectForEntityForName:@"AuthorOutlet" inManagedObjectContext:context];
                    [authorOutlet setValue:[outletDic valueForKey:@"id"] forKey:@"id"];
                    [authorOutlet setValue:[outletDic valueForKey:@"outletname"] forKey:@"outletname"];
                    [outletArray addObject:authorOutlet];
                }
                NSOrderedSet *outletObj = [[NSOrderedSet alloc]initWithArray:outletArray];
                [authorDetails setValue:outletObj forKey:@"authorOutlet"];
                
                NSArray *authorWorkTitleArray = [dic valueForKey:@"worktitle"];
                NSMutableArray *workTitleArray = [[NSMutableArray alloc]init];
                for(NSDictionary *workTitleDic in authorWorkTitleArray) {
                    NSManagedObject *authorWorkTitle = [NSEntityDescription insertNewObjectForEntityForName:@"AuthorWorkTitle" inManagedObjectContext:context];
                    [authorWorkTitle setValue:[workTitleDic valueForKey:@"id"] forKey:@"id"];
                    [authorWorkTitle setValue:[workTitleDic valueForKey:@"title"] forKey:@"title"];
                    [workTitleArray addObject:authorWorkTitle];
                }
                NSOrderedSet *worktitleObj = [[NSOrderedSet alloc]initWithArray:workTitleArray];
                [authorDetails setValue:worktitleObj forKey:@"authorWorkTitle"];
                
                
                NSArray *authorBeatArray = [dic valueForKey:@"beats"];
                NSMutableArray *beatArray = [[NSMutableArray alloc]init];
                for(NSDictionary *beatDic in authorBeatArray) {
                    NSManagedObject *authorBeat = [NSEntityDescription insertNewObjectForEntityForName:@"AuthorBeat" inManagedObjectContext:context];
                    [authorBeat setValue:[beatDic valueForKey:@"id"] forKey:@"id"];
                    [authorBeat setValue:[beatDic valueForKey:@"name"] forKey:@"name"];
                    [beatArray addObject:authorBeat];
                }
                NSOrderedSet *beatObj = [[NSOrderedSet alloc]initWithArray:beatArray];
                [authorDetails setValue:beatObj forKey:@"authorBeat"];
                
                NSArray *authorSocialMediaArray = [dic valueForKey:@"socialmedia"];
                NSMutableArray *socialMediaArray = [[NSMutableArray alloc]init];
                for(NSDictionary *socialMediaDic in authorSocialMediaArray) {
                    NSManagedObject *authorSocialMedia = [NSEntityDescription insertNewObjectForEntityForName:@"AuthorSocialMedia" inManagedObjectContext:context];
                    // NSLog(@"social isactive:%@",[socialMediaDic valueForKey:@"isactive"]);
                    [authorSocialMedia setValue:[socialMediaDic valueForKey:@"isactive"] forKey:@"isactive"];
                    [authorSocialMedia setValue:[socialMediaDic valueForKey:@"mediatype"] forKey:@"mediatype"];
                    [authorSocialMedia setValue:[socialMediaDic valueForKey:@"mediatypeId"] forKey:@"mediatypeId"];
                    [authorSocialMedia setValue:[socialMediaDic valueForKey:@"url"] forKey:@"url"];
                    [authorSocialMedia setValue:[socialMediaDic valueForKey:@"username"] forKey:@"username"];
                    [socialMediaArray addObject:authorSocialMedia];
                }
                NSOrderedSet *socialMediaObj = [[NSOrderedSet alloc]initWithArray:socialMediaArray];
                [authorDetails setValue:socialMediaObj forKey:@"authorSocialMedia"];
                
                [authorDetailsList addObject:authorDetails];
            }
            
            
          //  [curatedNews setValue:curatedNewsDrillIn forKey:@"details"];
            
            
           // NSLog(@"author list count:%lu",(unsigned long)authorDetailsList.count);
            NSOrderedSet *authorObj = [[NSOrderedSet alloc]initWithArray:authorDetailsList];
            [curatedNews setValue:authorObj forKey:@"authorDetails"];
            
            
            NSError *error = nil;
            // Save the object to persistent store
            if (![context save:&error]) {
               // NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
                NSLog(@"one");
            }else {
              //  NSLog(@"else part:%@",error);
                NSLog(@"two");
            }

        }
        [self hideProgressView];
       // NSLog(@"reached end");
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"Test"];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"firstTimeFlag"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CuratedNews" object:nil];
        } else {
            [self hideProgressView];
            [self showLoginView:[responseObject objectForKey:@"isAuthenticated"]];
        }
        
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [FIUtils showErrorToast];
    }];
    } else {
        [FIUtils showNoNetworkToast];
    }
}


-(void)getInfluencerListWithAccessToken:(NSString *)details {
    if([self serviceIsReachable]) {
    [FIWebService fetchInfluencerListWithAccessToken:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([[responseObject objectForKey:@"isAuthenticated"]isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [self clearEntity:@"Influencer"];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isInfluencerLoad"];
        NSArray *influencerArray = [responseObject objectForKey:@"influencerArray"];
        for(NSDictionary *dic in influencerArray) {
            
            NSManagedObjectContext *context = [self managedObjectContext];
            // Create a new managed object
            NSManagedObject *influencer = [NSEntityDescription insertNewObjectForEntityForName:@"Influencer" inManagedObjectContext:context];
            [influencer setValue:[dic objectForKey:@"articleId"] forKey:@"articleId"];
            [influencer setValue:[dic objectForKey:@"title"] forKey:@"title"];
            [influencer setValue:[dic objectForKey:@"desc"] forKey:@"desc"];
            [influencer setValue:[dic objectForKey:@"image"] forKey:@"image"];
            [influencer setValue:[dic objectForKey:@"date"] forKey:@"date"];
            NSArray *authorArray = [dic objectForKey:@"author"];
            NSMutableArray *authorList = [[NSMutableArray alloc]init];
            for(NSDictionary *dict in authorArray) {
                NSManagedObject *author = [NSEntityDescription insertNewObjectForEntityForName:@"InfluencerAuthor" inManagedObjectContext:context];
                [author setValue:[dict objectForKey:@"name"] forKey:@"name"];
                [author setValue:[dict objectForKey:@"title"] forKey:@"title"];
                [author setValue:[dict objectForKey:@"image"] forKey:@"image"];
                [authorList addObject:author];
                
            }
            NSOrderedSet *Obj = [[NSOrderedSet alloc]initWithArray:authorList];
            [influencer setValue:Obj forKey:@"author"];
            
            
            NSArray *outletArray = [dic objectForKey:@"outlet"];
            if(outletArray.count != 0){
                NSDictionary *outletDic = [outletArray objectAtIndex:0];
                [influencer setValue:[outletDic objectForKey:@"outletname"] forKey:@"outlet"];
            }
            
            
            NSArray *legendsArray = [dic objectForKey:@"legendList"];
            NSMutableArray *legendsList = [[NSMutableArray alloc]init];
            for(NSDictionary *dict in legendsArray) {
                NSManagedObject *legends = [NSEntityDescription insertNewObjectForEntityForName:@"InfluencerLegends" inManagedObjectContext:context];
                [legends setValue:[dict objectForKey:@"name"] forKey:@"name"];
                [legends setValue:[dict objectForKey:@"flag"] forKey:@"flag"];
                [legends setValue:[dict objectForKey:@"image"] forKey:@"url"];
                [legendsList addObject:legends];
                
            }
            NSOrderedSet *legendsSet = [[NSOrderedSet alloc]initWithArray:legendsList];
            [influencer setValue:legendsSet forKey:@"legends"];
            
            NSError *error = nil;
            // Save the object to persistent store
            if (![context save:&error]) {
                //NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            }else {
                //  NSLog(@"else part:%@",error);
            }
            
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"InfluencerList" object:nil];
        } else {
            [self hideProgressView];
            [self showLoginView:[responseObject objectForKey:@"isAuthenticated"]];
        }
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [FIUtils showErrorToast];
    }];
    } else {
        [FIUtils showNoNetworkToast];
    }
}

-(void)getCuratedNewsAuthorDetailsWithDetails:(NSString *)details withArticleId:(NSString *)articleId {
    //if([self serviceIsReachable]) {
    [FIWebService fetchCuratedNewsAuthorDetailsWithDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if([[responseObject objectForKey:@"isAuthenticated"]isEqualToNumber:[NSNumber numberWithInt:1]]) {
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        NSFetchRequest *fetchRequest;
        fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@", articleId];
        [fetchRequest setPredicate:predicate];
        NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        NSManagedObject *curatedNews;
        if(newPerson.count != 0) {
            curatedNews = [newPerson objectAtIndex:0];
        }
        
        NSArray *authorArray = [responseObject objectForKey:@"articleContact"];
         NSMutableArray *authorList = [[NSMutableArray alloc]init];
        for(NSDictionary *dic in authorArray) {
            NSManagedObject *authorDetails;
            authorDetails = [NSEntityDescription insertNewObjectForEntityForName:@"CuratedNewsDetailAuthor" inManagedObjectContext:managedObjectContext];
            [authorDetails setValue:[dic valueForKey:@"id"] forKey:@"id"];
            [authorDetails setValue:[dic valueForKey:@"firstName"] forKey:@"firstName"];
            [authorDetails setValue:[dic valueForKey:@"lastName"] forKey:@"lastName"];
            [authorDetails setValue:[dic valueForKey:@"city"] forKey:@"city"];
            [authorDetails setValue:[dic valueForKey:@"country"] forKey:@"country"];
            [authorDetails setValue:[dic valueForKey:@"imageURL"] forKey:@"imageURL"];
            [authorDetails setValue:[dic valueForKey:@"bibliography"] forKey:@"bibliography"];
            [authorDetails setValue:[dic valueForKey:@"isInfluencer"] forKey:@"isInfluencer"];
            [authorDetails setValue:[dic valueForKey:@"starRating"] forKey:@"starRating"];
            
            
            NSArray *authorOutletArray = [dic valueForKey:@"outlet"];
            NSMutableArray *outletArray = [[NSMutableArray alloc]init];
            for(NSDictionary *outletDic in authorOutletArray) {
                NSManagedObject *authorOutlet = [NSEntityDescription insertNewObjectForEntityForName:@"AuthorOutlet" inManagedObjectContext:managedObjectContext];
                [authorOutlet setValue:[outletDic valueForKey:@"id"] forKey:@"id"];
                [authorOutlet setValue:[outletDic valueForKey:@"outletname"] forKey:@"outletname"];
                [outletArray addObject:authorOutlet];
            }
            NSOrderedSet *outletObj = [[NSOrderedSet alloc]initWithArray:outletArray];
            [authorDetails setValue:outletObj forKey:@"authorOutlet"];
            
            NSArray *authorWorkTitleArray = [dic valueForKey:@"worktitle"];
            NSMutableArray *workTitleArray = [[NSMutableArray alloc]init];
            for(NSDictionary *workTitleDic in authorWorkTitleArray) {
                NSManagedObject *authorWorkTitle = [NSEntityDescription insertNewObjectForEntityForName:@"AuthorWorkTitle" inManagedObjectContext:managedObjectContext];
                [authorWorkTitle setValue:[workTitleDic valueForKey:@"id"] forKey:@"id"];
                [authorWorkTitle setValue:[workTitleDic valueForKey:@"title"] forKey:@"title"];
                [workTitleArray addObject:authorWorkTitle];
            }
            NSOrderedSet *worktitleObj = [[NSOrderedSet alloc]initWithArray:workTitleArray];
            [authorDetails setValue:worktitleObj forKey:@"authorWorkTitle"];
            
            
            NSArray *authorBeatArray = [dic valueForKey:@"beats"];
            NSMutableArray *beatArray = [[NSMutableArray alloc]init];
            for(NSDictionary *beatDic in authorBeatArray) {
                NSManagedObject *authorBeat = [NSEntityDescription insertNewObjectForEntityForName:@"AuthorBeat" inManagedObjectContext:managedObjectContext];
                [authorBeat setValue:[beatDic valueForKey:@"id"] forKey:@"id"];
                [authorBeat setValue:[beatDic valueForKey:@"name"] forKey:@"name"];
                [beatArray addObject:authorBeat];
            }
            NSOrderedSet *beatObj = [[NSOrderedSet alloc]initWithArray:beatArray];
            [authorDetails setValue:beatObj forKey:@"authorBeat"];
            
            NSArray *authorSocialMediaArray = [dic valueForKey:@"socialmedia"];
            NSMutableArray *socialMediaArray = [[NSMutableArray alloc]init];
            for(NSDictionary *socialMediaDic in authorSocialMediaArray) {
                NSManagedObject *authorSocialMedia = [NSEntityDescription insertNewObjectForEntityForName:@"AuthorSocialMedia" inManagedObjectContext:managedObjectContext];
               // NSLog(@"social isactive:%@",[socialMediaDic valueForKey:@"isactive"]);
                [authorSocialMedia setValue:[socialMediaDic valueForKey:@"isactive"] forKey:@"isactive"];
                [authorSocialMedia setValue:[socialMediaDic valueForKey:@"mediatype"] forKey:@"mediatype"];
                [authorSocialMedia setValue:[socialMediaDic valueForKey:@"mediatypeId"] forKey:@"mediatypeId"];
                [authorSocialMedia setValue:[socialMediaDic valueForKey:@"url"] forKey:@"url"];
                [authorSocialMedia setValue:[socialMediaDic valueForKey:@"username"] forKey:@"username"];
                [socialMediaArray addObject:authorSocialMedia];
            }
            NSOrderedSet *socialMediaObj = [[NSOrderedSet alloc]initWithArray:socialMediaArray];
            [authorDetails setValue:socialMediaObj forKey:@"authorSocialMedia"];
            
            [authorList addObject:authorDetails];
        }
        
        NSOrderedSet *Obj = [[NSOrderedSet alloc]initWithArray:authorList];
        [curatedNews setValue:Obj forKey:@"authorDetails"];
        NSError *error = nil;
        // Save the object to persistent store
        if (![managedObjectContext save:&error]) {
            //NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }else {
            //  NSLog(@"else part:%@",error);
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CuratedNewsAuthorDetails" object:nil userInfo:@{@"articleId":articleId}];
        
//        } else {
//            [self hideProgressView];
//            [self showLoginView:[responseObject objectForKey:@"isAuthenticated"]];
//        }
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [FIUtils showErrorToast];
    }];
//    } else {
//        [FIUtils showNoNetworkToast];
//    }
}



-(void)getCuratedNewsDetailsWithDetails:(NSString *)details {
    if([self serviceIsReachable]) {
    [FIWebService fetchCuratedNewsDetailsWithDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([[responseObject objectForKey:@"isAuthenticated"]isEqualToNumber:[NSNumber numberWithInt:1]]) {
        
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        NSFetchRequest *fetchRequest;
        NSManagedObject *curatedNewsDrillIn;
            fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
            curatedNewsDrillIn = [NSEntityDescription insertNewObjectForEntityForName:@"CuratedNewsDetail" inManagedObjectContext:managedObjectContext];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@", [[responseObject objectForKey:@"articleDetail"] objectForKey:@"id"]];
        [fetchRequest setPredicate:predicate];
        NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        NSManagedObject *curatedNews;
        if(newPerson.count != 0) {
            curatedNews = [newPerson objectAtIndex:0];
        }
        
      //  NSLog(@"curated result:%@",[curatedNews valueForKey:@"details"]);
        
        [curatedNewsDrillIn setValue:[[responseObject objectForKey:@"articleDetail"] objectForKey:@"id"] forKey:@"articleId"];
            [curatedNewsDrillIn setValue:[[responseObject objectForKey:@"articleDetail"] objectForKey:@"totalComments"] forKey:@"totalComments"];
            [curatedNewsDrillIn setValue:[[responseObject objectForKey:@"articleDetail"] objectForKey:@"unReadComment"] forKey:@"unReadComment"];
        [curatedNewsDrillIn setValue:[[responseObject objectForKey:@"articleDetail"] objectForKey:@"articleImageURL"] forKey:@"articleImageURL"];
        [curatedNewsDrillIn setValue:[[responseObject objectForKey:@"articleDetail"] objectForKey:@"articleDetailedDescription"] forKey:@"article"];
        [curatedNewsDrillIn setValue:[[responseObject objectForKey:@"articleDetail"] objectForKey:@"publisheddate"] forKey:@"articlePublisheddate"];
        [curatedNewsDrillIn setValue:[[responseObject objectForKey:@"articleDetail"] objectForKey:@"articleType"] forKey:@"articleType"];
        [curatedNewsDrillIn setValue:[[responseObject objectForKey:@"articleDetail"] objectForKey:@"url"] forKey:@"articleUrl"];
         [curatedNewsDrillIn setValue:[[responseObject objectForKey:@"articleDetail"] objectForKey:@"heading"] forKey:@"articleHeading"];
        [curatedNewsDrillIn setValue:[[responseObject objectForKey:@"articleDetail"] objectForKey:@"markAsImportant"] forKey:@"markAsImportant"];
        NSArray *outletArray = [[responseObject objectForKey:@"articleDetail"] objectForKey:@"outlet"];
        if(outletArray.count != 0) {
            NSDictionary *outletDic = [outletArray objectAtIndex:0];
            [curatedNewsDrillIn setValue:[outletDic objectForKey:@"outletname"] forKey:@"outletname"];
        }
        
        [curatedNewsDrillIn setValue:[[responseObject objectForKey:@"articleDetail"] objectForKey:@"readStatus"] forKey:@"readStatus"];
        [curatedNewsDrillIn setValue:[[responseObject objectForKey:@"articleDetail"] objectForKey:@"saveForLater"] forKey:@"saveForLater"];
            
            NSArray *relatedPostArray = [[responseObject objectForKey:@"articleDetail"] objectForKey:@"articleRelatedPosts"];
            NSMutableArray *postArray = [[NSMutableArray alloc]init];
            for(NSDictionary *postDic in relatedPostArray) {
                NSManagedObject *relatedPost = [NSEntityDescription insertNewObjectForEntityForName:@"RelatedPost" inManagedObjectContext:managedObjectContext];
                [relatedPost setValue:[postDic valueForKey:@"postId"] forKey:@"postId"];
                [relatedPost setValue:[postDic valueForKey:@"socialMediaUsername"] forKey:@"socialMediaUsername"];
                [relatedPost setValue:[postDic valueForKey:@"tweetURL"] forKey:@"tweetURL"];
                [postArray addObject:relatedPost];
            }
            
            NSOrderedSet *outletObj = [[NSOrderedSet alloc]initWithArray:postArray];
            [curatedNewsDrillIn setValue:outletObj forKey:@"relatedPost"];
        [curatedNews setValue:curatedNewsDrillIn forKey:@"details"];
        NSError *error = nil;
        // Save the object to persistent store
        if (![managedObjectContext save:&error]) {
            //NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }else {
            //  NSLog(@"else part:%@",error);
        }
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CuratedNewsDetails" object:nil userInfo:@{@"articleId":[[responseObject objectForKey:@"articleDetail"] objectForKey:@"id"]}];
        } else {
            [self hideProgressView];
            [self showLoginView:[responseObject objectForKey:@"isAuthenticated"]];
        }
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [FIUtils showErrorToast];
    }];
    } else {
        [FIUtils showNoNetworkToast];
    }
}

-(void)getCommentsWithDetails:(NSString *)details withArticleId:(NSString *)articleId {
    if([self serviceIsReachable]) {
        self.getCommentArticleId = articleId;
        self.getCommentDetailString = details;
        [FIWebService getCommentsWithDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if([[responseObject objectForKey:@"success"]isEqualToNumber:[NSNumber numberWithInt:1]]) {
                //need to write code
                NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
                NSFetchRequest *fetchRequest;
                NSManagedObject *userComments;
                fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
                userComments = [NSEntityDescription insertNewObjectForEntityForName:@"UserComments" inManagedObjectContext:managedObjectContext];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@", articleId];
                [fetchRequest setPredicate:predicate];
                NSArray *filterArray =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
                NSManagedObject *curatedNews;
                if(filterArray.count != 0) {
                    curatedNews = [filterArray objectAtIndex:0];
                }
                [userComments setValue:[responseObject valueForKey:@"customerId"] forKey:@"customerId"];
                [userComments setValue:[responseObject valueForKey:@"securityToken"] forKey:@"securityToken"];
                [userComments setValue:[responseObject valueForKey:@"userId"] forKey:@"userId"];
                [userComments setValue:[responseObject valueForKey:@"version"] forKey:@"version"];
                
                NSArray *commentsArray = [responseObject valueForKey:@"commentList"];
               // NSLog(@"comment array:%@",commentsArray);
                NSMutableArray *userCommentsArray = [[NSMutableArray alloc]init];
                for(NSDictionary *commentsDic in commentsArray) {
                    NSManagedObject *comments = [NSEntityDescription insertNewObjectForEntityForName:@"Comments" inManagedObjectContext:managedObjectContext];
                    [comments setValue:[commentsDic valueForKey:@"comment"] forKey:@"comment"];
                   // [comments setValue:[commentsDic valueForKey:@"createdDate"] forKey:@"createdDate"];
                    [comments setValue:[commentsDic valueForKey:@"id"] forKey:@"id"];
                    [comments setValue:[commentsDic valueForKey:@"likeCount"] forKey:@"likeCount"];
                    [comments setValue:[commentsDic valueForKey:@"parentId"] forKey:@"parentId"];
                    [comments setValue:[commentsDic valueForKey:@"unLikeCount"] forKey:@"unLikeCount"];
                    [comments setValue:[commentsDic valueForKey:@"userId"] forKey:@"userId"];
                    [comments setValue:[commentsDic valueForKey:@"userName"] forKey:@"userName"];
                    [comments setValue:[commentsDic valueForKey:@"photoUrl"] forKey:@"photoUrl"];
                    [userCommentsArray addObject:comments];
                }
                NSOrderedSet *commentsObj = [[NSOrderedSet alloc]initWithArray:userCommentsArray];
                [userComments setValue:commentsObj forKey:@"comments"];
                [curatedNews setValue:userComments forKey:@"comments"];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"FetchingComments" object:nil];
                
            } else {
                [self hideProgressView];
                [self showLoginView:[responseObject objectForKey:@"success"]];
            }
        } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [FIUtils showErrorToast];
        }];
    } else {
        [FIUtils showNoNetworkToast];
    }
}

-(void)getInfluencerDetailsWithDetails:(NSString *)details {
    if([self serviceIsReachable]) {
    [FIWebService fetchInfluencerDetailsWithDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([[responseObject objectForKey:@"isAuthenticated"]isEqualToNumber:[NSNumber numberWithInt:1]]) {
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Influencer"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@", [[responseObject objectForKey:@"influencerdetails"] objectForKey:@"articleId"]];
        [fetchRequest setPredicate:predicate];
        NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
       // NSLog(@"resulting person details:%@",newPerson);
            NSManagedObject *influencer;
            if(newPerson.count != 0) {
               influencer  = [newPerson objectAtIndex:0];
            }
        
       // NSLog(@"curated result:%@",[influencer valueForKey:@"details"]);
        NSManagedObject *influencerDrillIn = [NSEntityDescription insertNewObjectForEntityForName:@"InfluencerDetail" inManagedObjectContext:managedObjectContext];
        [influencerDrillIn setValue:[[responseObject objectForKey:@"influencerdetails"] objectForKey:@"articleId"] forKey:@"articleId"];
        [influencerDrillIn setValue:[[responseObject objectForKey:@"influencerdetails"] objectForKey:@"desc"] forKey:@"desc"];
        [influencerDrillIn setValue:[[responseObject objectForKey:@"influencerdetails"] objectForKey:@"articleUrl"] forKey:@"articleUrl"];
        [influencerDrillIn setValue:[[responseObject objectForKey:@"influencerdetails"] objectForKey:@"title"] forKey:@"title"];
      //  [influencerDrillIn setValue:[[responseObject objectForKey:@"influencerdetails"] objectForKey:@"outlet"] forKey:@"outlet"];
       // [influencerDrillIn setValue:[[responseObject objectForKey:@"influencerdetails"] objectForKey:@"date"] forKey:@"date"];
        [influencerDrillIn setValue:[[responseObject objectForKey:@"influencerdetails"] objectForKey:@"image"] forKey:@"image"];
        [influencerDrillIn setValue:[[responseObject objectForKey:@"influencerdetails"] objectForKey:@"markAsImportant"] forKey:@"markAsImportant"];
        [influencerDrillIn setValue:[[responseObject objectForKey:@"influencerdetails"] objectForKey:@"readStatus"] forKey:@"readStatus"];
        [influencerDrillIn setValue:[[responseObject objectForKey:@"influencerdetails"] objectForKey:@"saveForLater"] forKey:@"saveForLater"];
        [influencer setValue:influencerDrillIn forKey:@"details"];
        NSError *error = nil;
        // Save the object to persistent store
        if (![managedObjectContext save:&error]) {
           // NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }else {
            //  NSLog(@"else part:%@",error);
        }
        } else {
            [self hideProgressView];
            [self showLoginView:[responseObject objectForKey:@"isAuthenticated"]];
        }
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [FIUtils showErrorToast];
    }];
    } else {
        [FIUtils showNoNetworkToast];
    }
}

-(void)getMenuListWithAccessToken:(NSString *)accessToken {
    if([self serviceIsReachable]) {
   // _menuList = [[NSMutableArray alloc]init];
    [FIWebService fetchMenuListWithAccessToken:accessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([[responseObject objectForKey:@"isAuthenticated"]isEqualToNumber:[NSNumber numberWithInt:1]]) {
        NSArray *menuArray = [responseObject objectForKey:@"menuList"];
        [_menuList removeAllObjects];
        for(NSDictionary *dic in menuArray) {
            FIMenu *menu = [FIMenu recursiveMenu:dic];
            [_menuList addObject:menu];
        }
        [[NSUserDefaults standardUserDefaults]setObject:[NSKeyedArchiver archivedDataWithRootObject:_menuList] forKey:@"MenuList"];
        
        } else {
            [self hideProgressView];
            [self showLoginView:[responseObject objectForKey:@"isAuthenticated"]];
        }
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [FIUtils showErrorToast];
    }];
    } else {
        [FIUtils showNoNetworkToast];
    }
}

-(void)getFolderListWithAccessToken:(NSString *)accessToken withFlag:(BOOL)flag {
    if([self serviceIsReachable]) {
        
        [FIWebService fetchFolderListWithAccessToken:accessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if([responseObject isKindOfClass:[NSArray class]]){
                NSArray *folderArray = responseObject;
                [_folderList removeAllObjects];
                for(NSDictionary *dic in folderArray) {
                    FIFolder *folder = [[FIFolder alloc]init];
                    [folder createFolderFromDic:dic];
                    [_folderList addObject:folder];
                }
                [[NSUserDefaults standardUserDefaults]setObject:[NSKeyedArchiver archivedDataWithRootObject:_folderList] forKey:@"FolderList"];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"MenuList" object:nil];
                if(flag) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"StopFolderLoading" object:nil];
                }
            } else if([responseObject isKindOfClass:[NSDictionary class]]){
                if([[responseObject valueForKey:@"statusCode"]isEqualToNumber:[NSNumber numberWithInt:401]]) {
                    [self showLoginView:[responseObject objectForKey:@"isAuthenticated"]];
                }
            }
            
        } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [FIUtils showErrorToast];
        }];
    } else {
        [FIUtils showNoNetworkToast];
    }
}

-(void)fetchArticleFromFolderWithAccessToken:(NSString *)accessToken withFolderId:(NSNumber *)folderId {
    if([self serviceIsReachable]) {
        [FIWebService fetchArticlesFromFolderWithSecurityToken:accessToken withFolderId:[folderId stringValue] onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if([responseObject isKindOfClass:[NSArray class]]){
                NSArray *curatedNewsArray = responseObject;
                //Handle Pagination
//                if(curatedNewsArray.count == 0) {
//                    //if(lastArticleId.length != 0){
//                    UIWindow *window = [[UIApplication sharedApplication]windows][0];
//                    [window makeToast:@"No more articles to display" duration:1 position:CSToastPositionCenter];
//                    //}
//                }
                //NSLog(@"incoming category id:%@",categoryId);
                
                for(NSDictionary *dic in curatedNewsArray) {
                    
                    NSManagedObjectContext *context;
                    // Create a new managed object
                    NSManagedObject *curatedNews;
                   // NSManagedObject *curatedNewsDrillIn;
                    context = [self managedObjectContext];
                    
                    NSDictionary *articleDic = [dic objectForKey:@"articleDTO"];
                    //NSLog(@"article dic:%@",articleDic);
                    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@",[articleDic objectForKey:@"id"]];
                    [fetchRequest setPredicate:predicate];
                    NSArray *existingArray = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
                    //NSLog(@"existing array:%@",existingArray);
                    if(existingArray.count != 0) {
                        NSLog(@"yes");
                        //Excisting Object
                        curatedNews = [existingArray objectAtIndex:0];
                    } else {
                        NSLog(@"no");
                        //Create new object
                        curatedNews = [NSEntityDescription insertNewObjectForEntityForName:@"CuratedNews" inManagedObjectContext:context];
                        [_articleIdArray addObject:[articleDic objectForKey:@"id"]];
                    }
                    
                    //Set values in local db
                    [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"isFolder"];
                    [curatedNews setValue:folderId forKey:@"folderId"];
                    [curatedNews setValue:NULL_TO_NIL([articleDic objectForKey:@"id"]) forKey:@"articleId"];
                    [curatedNews setValue:NULL_TO_NIL([articleDic objectForKey:@"heading"]) forKey:@"title"];
                    [curatedNews setValue:NULL_TO_NIL([articleDic objectForKey:@"articleDescription"]) forKey:@"desc"];
                    [curatedNews setValue:NULL_TO_NIL([articleDic objectForKey:@"modifiedDate"]) forKey:@"date"];
                    [curatedNews setValue:NULL_TO_NIL([articleDic objectForKey:@"publishedDate"]) forKey:@"publishedDate"];
                    [curatedNews setValue:NULL_TO_NIL([articleDic objectForKey:@"articleImage"]) forKey:@"image"];
                    [curatedNews setValue:NULL_TO_NIL([articleDic objectForKey:@"articleURL"]) forKey:@"articleUrl"];
                    [curatedNews setValue:NULL_TO_NIL([articleDic objectForKey:@"articleTypeId"]) forKey:@"articleTypeId"];
                    [curatedNews setValue:NULL_TO_NIL([articleDic objectForKey:@"articleType"]) forKey:@"articleType"];
                    [curatedNews setValue:NULL_TO_NIL([articleDic objectForKey:@"markAsImportant"]) forKey:@"markAsImportant"];
                    
                    NSNumber *markImp = NULL_TO_NIL([articleDic valueForKey:@"markAsImportant"]);
                    if([markImp isEqualToNumber:[NSNumber numberWithInt:1]]){
                        NSDictionary *markedImpDictionary = [dic objectForKey:@"markAsImportantUserDetail"];
                        [curatedNews setValue:NULL_TO_NIL([markedImpDictionary objectForKey:@"name"]) forKey:@"markAsImportantUserName"];
                        [curatedNews setValue:NULL_TO_NIL([markedImpDictionary objectForKey:@"userId"]) forKey:@"markAsImportantUserId"];
                    }
                    [curatedNews setValue:NULL_TO_NIL([articleDic objectForKey:@"saveForLater"]) forKey:@"saveForLater"];
                    
                    //Set outlet info
                    NSArray *outletArray = NULL_TO_NIL([articleDic objectForKey:@"outlets"]);
                    if(outletArray.count != 0){
                        NSDictionary *outletDic = [outletArray objectAtIndex:0];
                        [curatedNews setValue:NULL_TO_NIL([outletDic objectForKey:@"outletName"]) forKey:@"outlet"];
                    }
                    
                    
                    //Set CuratedNews Author Details
                    NSArray *authorDetailsArray = NULL_TO_NIL([articleDic objectForKey:@"contacts"]);
                    //NSLog(@"before author count:%lu",(unsigned long)authorDetailsArray.count);
                    NSMutableArray *authorDetailsList = [[NSMutableArray alloc]init];
                    for(NSDictionary *dic in authorDetailsArray) {
                        NSManagedObject *authorDetails;
                        authorDetails = [NSEntityDescription insertNewObjectForEntityForName:@"CuratedNewsDetailAuthor" inManagedObjectContext:context];
                        [authorDetails setValue:NULL_TO_NIL([dic valueForKey:@"id"]) forKey:@"id"];
                        [authorDetails setValue:NULL_TO_NIL([dic valueForKey:@"firstName"]) forKey:@"firstName"];
                        [authorDetails setValue:NULL_TO_NIL([dic valueForKey:@"lastName"]) forKey:@"lastName"];
                        [authorDetails setValue:NULL_TO_NIL([dic valueForKey:@"cityName"]) forKey:@"city"];
                        [authorDetails setValue:NULL_TO_NIL([dic valueForKey:@"countryName"]) forKey:@"country"];
                        [authorDetails setValue:NULL_TO_NIL([dic valueForKey:@"image"]) forKey:@"imageURL"];
                        [authorDetails setValue:NULL_TO_NIL([dic valueForKey:@"bibliography"]) forKey:@"bibliography"];
                        [authorDetails setValue:NULL_TO_NIL([dic valueForKey:@"isInfluencer"]) forKey:@"isInfluencer"];
                        [authorDetails setValue:NULL_TO_NIL([dic valueForKey:@"starRating"]) forKey:@"starRating"];
                        
                        
//                        NSArray *authorOutletArray = [dic valueForKey:@"outlet"];
//                        NSMutableArray *outletArray = [[NSMutableArray alloc]init];
//                        for(NSDictionary *outletDic in authorOutletArray) {
//                            NSManagedObject *authorOutlet = [NSEntityDescription insertNewObjectForEntityForName:@"AuthorOutlet" inManagedObjectContext:context];
//                            [authorOutlet setValue:[outletDic valueForKey:@"id"] forKey:@"id"];
//                            [authorOutlet setValue:[outletDic valueForKey:@"outletname"] forKey:@"outletname"];
//                            [outletArray addObject:authorOutlet];
//                        }
//                        NSOrderedSet *outletObj = [[NSOrderedSet alloc]initWithArray:outletArray];
//                        [authorDetails setValue:outletObj forKey:@"authorOutlet"];
                        
                        NSArray *authorWorkTitleArray = NULL_TO_NIL([dic valueForKey:@"workTitles"]);
                        NSMutableArray *workTitleArray = [[NSMutableArray alloc]init];
                        for(NSDictionary *workTitleDic in authorWorkTitleArray) {
                            NSManagedObject *authorWorkTitle = [NSEntityDescription insertNewObjectForEntityForName:@"AuthorWorkTitle" inManagedObjectContext:context];
                            [authorWorkTitle setValue:NULL_TO_NIL([workTitleDic valueForKey:@"id"]) forKey:@"id"];
                            [authorWorkTitle setValue:NULL_TO_NIL([workTitleDic valueForKey:@"title"]) forKey:@"title"];
                            [workTitleArray addObject:authorWorkTitle];
                        }
                        NSOrderedSet *worktitleObj = [[NSOrderedSet alloc]initWithArray:workTitleArray];
                        [authorDetails setValue:worktitleObj forKey:@"authorWorkTitle"];
                        
                        
                        NSArray *authorBeatArray = NULL_TO_NIL([dic valueForKey:@"categories"]);
                        NSMutableArray *beatArray = [[NSMutableArray alloc]init];
                        for(NSDictionary *beatDic in authorBeatArray) {
                            NSManagedObject *authorBeat = [NSEntityDescription insertNewObjectForEntityForName:@"AuthorBeat" inManagedObjectContext:context];
                            [authorBeat setValue:NULL_TO_NIL([beatDic valueForKey:@"id"]) forKey:@"id"];
                            [authorBeat setValue:NULL_TO_NIL([beatDic valueForKey:@"name"]) forKey:@"name"];
                            [beatArray addObject:authorBeat];
                        }
                        NSOrderedSet *beatObj = [[NSOrderedSet alloc]initWithArray:beatArray];
                        [authorDetails setValue:beatObj forKey:@"authorBeat"];
                        
//                        NSArray *authorSocialMediaArray = [dic valueForKey:@"socialmedia"];
//                        NSMutableArray *socialMediaArray = [[NSMutableArray alloc]init];
//                        for(NSDictionary *socialMediaDic in authorSocialMediaArray) {
//                            NSManagedObject *authorSocialMedia = [NSEntityDescription insertNewObjectForEntityForName:@"AuthorSocialMedia" inManagedObjectContext:context];
//                            // NSLog(@"social isactive:%@",[socialMediaDic valueForKey:@"isactive"]);
//                            [authorSocialMedia setValue:[socialMediaDic valueForKey:@"isactive"] forKey:@"isactive"];
//                            [authorSocialMedia setValue:[socialMediaDic valueForKey:@"mediatype"] forKey:@"mediatype"];
//                            [authorSocialMedia setValue:[socialMediaDic valueForKey:@"mediatypeId"] forKey:@"mediatypeId"];
//                            [authorSocialMedia setValue:[socialMediaDic valueForKey:@"url"] forKey:@"url"];
//                            [authorSocialMedia setValue:[socialMediaDic valueForKey:@"username"] forKey:@"username"];
//                            [socialMediaArray addObject:authorSocialMedia];
//                        }
//                        NSOrderedSet *socialMediaObj = [[NSOrderedSet alloc]initWithArray:socialMediaArray];
//                        [authorDetails setValue:socialMediaObj forKey:@"authorSocialMedia"];
                        
                        [authorDetailsList addObject:authorDetails];
                    }
                    
                    
                    //  [curatedNews setValue:curatedNewsDrillIn forKey:@"details"];
                    
                    
                    // NSLog(@"author list count:%lu",(unsigned long)authorDetailsList.count);
                    NSOrderedSet *authorObj = [[NSOrderedSet alloc]initWithArray:authorDetailsList];
                    [curatedNews setValue:authorObj forKey:@"authorDetails"];
                    
                    
                    
                    //Set CuratedNewsDetails
                    NSManagedObject *curatedNewsDrillIn = [NSEntityDescription insertNewObjectForEntityForName:@"CuratedNewsDetail" inManagedObjectContext:context];
                    [curatedNewsDrillIn setValue:NULL_TO_NIL([articleDic objectForKey:@"id"]) forKey:@"articleId"];
                    //            [curatedNewsDrillIn setValue:[[responseObject objectForKey:@"articleDetail"] objectForKey:@"totalComments"] forKey:@"totalComments"];
                    //            [curatedNewsDrillIn setValue:[[responseObject objectForKey:@"articleDetail"] objectForKey:@"unReadComment"] forKey:@"unReadComment"];
                    [curatedNewsDrillIn setValue:NULL_TO_NIL([articleDic objectForKey:@"articleDetailedDescription"]) forKey:@"article"];
//                    //Set Related Post
//                    NSArray *relatedPostArray = [dic objectForKey:@"articleRelatedPosts"];
//                    NSMutableArray *postArray = [[NSMutableArray alloc]init];
//                    for(NSDictionary *postDic in relatedPostArray) {
//                        NSManagedObject *relatedPost = [NSEntityDescription insertNewObjectForEntityForName:@"RelatedPost" inManagedObjectContext:context];
//                        [relatedPost setValue:[postDic valueForKey:@"postId"] forKey:@"postId"];
//                        [relatedPost setValue:[postDic valueForKey:@"socialMediaUsername"] forKey:@"socialMediaUsername"];
//                        [relatedPost setValue:[postDic valueForKey:@"tweetURL"] forKey:@"tweetURL"];
//                        [postArray addObject:relatedPost];
//                    }
//                    
//                    NSOrderedSet *outletObj = [[NSOrderedSet alloc]initWithArray:postArray];
//                    [curatedNewsDrillIn setValue:outletObj forKey:@"relatedPost"];
                    [curatedNews setValue:curatedNewsDrillIn forKey:@"details"];
                    
                    
                    NSError *error = nil;
                    // Save the object to persistent store
                    if (![context save:&error]) {
                        // NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
                        NSLog(@"one");
                    }else {
                        //  NSLog(@"else part:%@",error);
                        NSLog(@"two");
                    }

                }
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"Test"];
                //[[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"firstTimeFlag"];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"CuratedNews" object:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"StopLoading" object:nil];
            }else if([responseObject isKindOfClass:[NSDictionary class]]){
                if([[responseObject valueForKey:@"statusCode"]isEqualToNumber:[NSNumber numberWithInt:401]]) {
                    [self showLoginView:[responseObject objectForKey:@"isAuthenticated"]];
                }
            }
            
        } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [FIUtils showErrorToast];
        }];
    } else {
        
    }
}


-(void)createFolderWithDetails:(NSString *)details withAccessToken:(NSString *)accessToken {
    if([self serviceIsReachable]) {
        [FIWebService createFolderWithDetails:details withSecurityToken:accessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            UIWindow *window = [[UIApplication sharedApplication]windows][0];
            [window makeToast:@"Folder created successfully." duration:2 position:CSToastPositionCenter];
            //[[NSNotificationCenter defaultCenter]postNotificationName:@"FolderCreated" object:nil];
            [self getFolderListWithAccessToken:accessToken withFlag:YES];
        } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [FIUtils showErrorToast];
        }];
    }else {
        [FIUtils showNoNetworkToast];
    }
}

-(void)updatePushNotificationWithDetails:(NSString *)details withAccessToken:(NSString *)accessToken {
    if([self serviceIsReachable]) {
        [FIWebService pushNotificationWithDetails:details withSecurityToken:accessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            //[self getFolderListWithAccessToken:accessToken];
        } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [FIUtils showErrorToast];
        }];
    } else {
        [FIUtils showNoNetworkToast];
    }
}

-(void)saveArticleToFolderWithDetails:(NSString *)details withAccessToken:(NSString *)accessToken withFolderId:(NSString *)folderId {
    if([self serviceIsReachable]) {
        [FIWebService saveArticlesToFolderWithDetails:details withSecurityToken:accessToken withFolderId:folderId onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            UIWindow *window = [[UIApplication sharedApplication]windows][0];
            [window makeToast:@"Saved to folder successfully." duration:2 position:CSToastPositionCenter];
            //[[NSNotificationCenter defaultCenter]postNotificationName:@"SaveToFolder" object:nil];
            [self getFolderListWithAccessToken:accessToken withFlag:YES];
        } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [FIUtils showErrorToast];
        }];
    } else {
        [FIUtils showNoNetworkToast];
    }
}

-(void)removeArticleToFolderWithDetails:(NSString *)details withAccessToken:(NSString *)accessToken withFolderId:(NSString *)folderId {
    if([self serviceIsReachable]) {
        [FIWebService removeArticlesFromFolderWithDetails:details withSecurityToken:accessToken withFolderId:folderId onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self getFolderListWithAccessToken:accessToken withFlag:YES];
        } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [FIUtils showErrorToast];
        }];
    }else {
        [FIUtils showNoNetworkToast];
    }
}

-(void)manageContentCategoryWithDetails:(NSString *)details  withFlag:(NSInteger)flag{
    if([self serviceIsReachable]) {
        _contentCategoryList = [[NSMutableArray alloc]init];
        _contentTypeList = [[NSMutableArray alloc]init];
    [FIWebService manageContentCategoryWithAccessToken:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if([[responseObject objectForKey:@"isAuthenticated"]isEqualToNumber:[NSNumber numberWithInt:1]]) {
                if(flag == 1) {
                    UIWindow *window = [[UIApplication sharedApplication]windows][0];
                    [window makeToast:@"Updated content changes." duration:1 position:CSToastPositionCenter];
                    NSMutableDictionary *menuDic = [[NSMutableDictionary alloc] init];
                    [menuDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] forKey:@"securityToken"];
                    NSData *menuJsondata = [NSJSONSerialization dataWithJSONObject:menuDic options:NSJSONWritingPrettyPrinted error:nil];
                    
                    NSString *resultJson = [[NSString alloc]initWithData:menuJsondata encoding:NSUTF8StringEncoding];
                    [self getMenuListWithAccessToken:resultJson];
                } else {
                NSArray *contentTypeArray = [responseObject objectForKey:@"contentType"];
                [_contentTypeList removeAllObjects];
                for(NSDictionary *dic in contentTypeArray) {
                    FIContentCategory *content = [FIContentCategory recursiveMenu:dic];
                    [_contentTypeList addObject:content];
                }
                
                NSArray *menuArray = [responseObject objectForKey:@"contentCategory"];
                [_contentCategoryList removeAllObjects];
                for(NSDictionary *dic in menuArray) {
                    FIContentCategory *menu = [FIContentCategory recursiveMenu:dic];
                    [_contentCategoryList addObject:menu];
                }
                [[NSUserDefaults standardUserDefaults]setObject:[NSKeyedArchiver archivedDataWithRootObject:_contentTypeList] forKey:@"contentType"];
                [[NSUserDefaults standardUserDefaults]setObject:[NSKeyedArchiver archivedDataWithRootObject:_contentCategoryList] forKey:@"contentCategory"];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"contentCategory" object:nil];
                }
            } else {
                [self hideProgressView];
                [self showLoginView:[responseObject objectForKey:@"isAuthenticated"]];
            }
        } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [FIUtils showErrorToast];
        }];
    } else {
        [FIUtils showNoNetworkToast];
    }
}


-(void)setUserActivitiesOnArticlesWithDetails:(NSString *)details {
    if([self serviceIsReachable]) {
    [FIWebService userActivitiesOnArticlesWithDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
       if([[responseObject objectForKey:@"isAuthenticated"]isEqualToNumber:[NSNumber numberWithInt:1]]) {
       } else {
           [self hideProgressView];
           [self showLoginView:[responseObject objectForKey:@"isAuthenticated"]];
       }
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [FIUtils showErrorToast];
    }];
    } else {
        [FIUtils showNoNetworkToast];
    }
}


-(void)sendResearchRequestWithDetails:(NSString *)details {
    if([self serviceIsReachable]) {
        [FIWebService sendResearchRequestWithDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(![[responseObject objectForKey:@"code"]isEqualToNumber:[NSNumber numberWithInt:102]]) {
                UIWindow *window = [[UIApplication sharedApplication]windows][0];
                [window makeToast:[responseObject objectForKey:@"message"] duration:1 position:CSToastPositionCenter];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"ResearchSend" object:nil];
            } else {
                [self hideProgressView];
                [self showLoginView:[responseObject objectForKey:@"success"]];
            }
        } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [FIUtils showErrorToast];
        }];
    } else {
        [FIUtils showNoNetworkToast];
    }
}

-(void)updateAppViewTypeWithDetails:(NSString *)details {
    if([self serviceIsReachable]) {
        [FIWebService updateAppViewTypeWithDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if([[responseObject objectForKey:@"isAuthenticated"]isEqualToNumber:[NSNumber numberWithInt:1]]) {
                UIWindow *window = [[UIApplication sharedApplication]windows][0];
                [window makeToast:[responseObject objectForKey:@"message"] duration:1 position:CSToastPositionCenter];
            } else {
                [self hideProgressView];
                [self showLoginView:[responseObject objectForKey:@"isAuthenticated"]];
            }
        } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [FIUtils showErrorToast];
        }];
    } else {
        [FIUtils showNoNetworkToast];
    }
}

-(void)featureAccessRequestWithDetails:(NSString *)details {
    if([self serviceIsReachable]) {
        [FIWebService featureAccessRequestWithDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if([[responseObject objectForKey:@"isAuthenticated"]isEqualToNumber:[NSNumber numberWithInt:1]]) {
                UIWindow *window = [[UIApplication sharedApplication]windows][0];
                [window makeToast:[responseObject objectForKey:@"message"] duration:1 position:CSToastPositionCenter];
            } else {
                [self hideProgressView];
                [self showLoginView:[responseObject objectForKey:@"isAuthenticated"]];
            }
        } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [FIUtils showErrorToast];
        }];
    } else {
        [FIUtils showNoNetworkToast];
    }
}


-(void)addCommentsWithDetails:(NSString *)details {
    if([self serviceIsReachable]) {
        [FIWebService addCommentsWithDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if(![[responseObject objectForKey:@"code"]isEqualToNumber:[NSNumber numberWithInt:102]]) {
                UIWindow *window = [[UIApplication sharedApplication]windows][0];
                [window makeToast:[responseObject objectForKey:@"message"] duration:1 position:CSToastPositionCenter];
                [self getCommentsWithDetails:self.getCommentDetailString withArticleId:self.getCommentArticleId];
                
                
            } else {
                [self hideProgressView];
                [self showLoginView:[responseObject objectForKey:@"success"]];
            }
        } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [FIUtils showErrorToast];
        }];
    } else {
        [FIUtils showNoNetworkToast];
    }
}

-(void)markCommentAsReadWithDetails:(NSString *)details {
    if([self serviceIsReachable]) {
        [FIWebService commentMarkAsReadWithDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"markCommentAsRead" object:nil userInfo:nil];
            
//            if(![[responseObject objectForKey:@"code"]isEqualToNumber:[NSNumber numberWithInt:102]]) {
//                UIWindow *window = [[UIApplication sharedApplication]windows][0];
//                [window makeToast:[responseObject objectForKey:@"message"] duration:2 position:CSToastPositionCenter];
//                [self getCommentsWithDetails:self.getCommentDetailString withArticleId:self.getCommentArticleId];
//                
//                
//            } else {
//                [self hideProgressView];
//                [self showLoginView:[responseObject objectForKey:@"success"]];
//            }
        } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [FIUtils showErrorToast];
        }];
    } else {
        [FIUtils showNoNetworkToast];
    }
}


-(NSDictionary *)getTweetDetails:(NSString *)details {
     __block NSDictionary *responseDic;
    
    
    
    [FIWebService getTweetDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        responseDic = [responseObject objectAtIndex:0];
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [FIUtils showErrorToast];
    }];
    return responseDic;
}


-(NSManagedObject *)recursiveMenuWithDictionary:(NSDictionary *)dic {
    NSManagedObjectContext *context = [self managedObjectContext];
    // Create a new managed object
    NSManagedObject *menu = [NSEntityDescription insertNewObjectForEntityForName:@"Menu" inManagedObjectContext:context];
    
    
    
    NSArray *insideMenuArray = [dic objectForKey:@"List"];
   // NSLog(@"inside list menu count:%d",insideMenuArray.count);
    NSMutableArray *insideMenuList = [[NSMutableArray alloc]init];
    for(NSDictionary *dict in insideMenuArray) {
        //NSLog(@"for loop in recursive");
       NSManagedObject *obj =  [self recursiveMenuWithDictionary:dict];
        [insideMenuList addObject:obj];
        
    }
    //NSLog(@"menu name:%@ and menu list:%d",[dic objectForKey:@"Name"],insideMenuList.count);
    [menu setValue:[dic objectForKey:@"Name"] forKey:@"name"];
    NSSet *Obj = [NSSet setWithArray:insideMenuList];
   // NSLog(@"object count:%lu",(unsigned long)Obj.count);
    [menu setValue:Obj forKey:@"list"];
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
       // NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }else {
       // NSLog(@"else part:%@",error);
    }
    return menu;
}

- (BOOL)internetIsReachable {
    
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    return status != NotReachable;
}

- (BOOL)serviceIsReachable {
    
    if (![self internetIsReachable]) {
        return NO;
    }
    NSURL *myURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.google.co.in"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: myURL];
    request.timeoutInterval = 4.0f;
    [request setHTTPMethod: @"HEAD"];
    //[request setHTTPBody:<#(NSData *)#>];
    NSURLResponse *response;
    NSError *error;
    NSData *myData = [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: &error];
    return myData != nil;
}



- (void)showProgressView
{
    UIWindow *window = [[UIApplication sharedApplication]windows][0];
    progressView = [[UCZProgressView alloc] initWithFrame:CGRectMake(window.frame.size.width/2, window.frame.size.height/2, 100, 100)];
    progressView.translatesAutoresizingMaskIntoConstraints = NO;
    [window addSubview:progressView];
    

}

- (void)hideProgressView
{
    
    
    [progressView removeFromSuperview];
}

@end
