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
#import "MBProgressHUD.h"
#import "FIUtils.h"
#import "FIContentCategory.h"
#import "UIView+Toast.h"
#import "AppDelegate.h"


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

            NSDictionary *preferenceDic = [responseObject objectForKey:@"preferences"];
            [[NSUserDefaults standardUserDefaults]setObject:[preferenceDic objectForKey:@"headerColor"] forKey:@"headerColor"];
            [[NSUserDefaults standardUserDefaults]setObject:[preferenceDic objectForKey:@"highlightColor"] forKey:@"highlightColor"];
            [[NSUserDefaults standardUserDefaults]setObject:[preferenceDic objectForKey:@"menuBgColor"] forKey:@"menuBgColor"];
            [[NSUserDefaults standardUserDefaults]setObject:[responseObject objectForKey:@"securityToken"] forKey:@"accesstoken"];
            [[NSUserDefaults standardUserDefaults]setObject:[responseObject valueForKey:@"companyLogoURL"] forKey:@"companyLogo"];
            [[NSUserDefaults standardUserDefaults]setObject:[responseObject valueForKey:@"companyName"] forKey:@"companyName"];
            [[NSUserDefaults standardUserDefaults]setObject:[responseObject valueForKey:@"customerid"] forKey:@"customerId"];
            [[NSUserDefaults standardUserDefaults]setObject:[responseObject valueForKey:@"userid"] forKey:@"userId"];
            [[NSUserDefaults standardUserDefaults]setObject:[responseObject valueForKey:@"userAccountTypeId"] forKey:@"userAccountTypeId"];
            NSString *username = [NSString stringWithFormat:@"%@ %@",[responseObject valueForKey:@"firstName"],[responseObject valueForKey:@"lastName"]];
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
                [window makeToast:[responseObject objectForKey:@"message"] duration:2 position:CSToastPositionCenter];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"logoutSuccess" object:nil];
            }else {
                
                
                //NSString *errMsg = [NSString stringWithFormat:@"%@"];
                
                UIWindow *window = [[UIApplication sharedApplication]windows][0];
                [window makeToast:@"Seems like your session may have expired. This could also happen if the same credentials are used to login using another device. Please login again." duration:2 position:CSToastPositionCenter];
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

- (BOOL)clearEntity:(NSString *)entity withCategoryId:(NSInteger)categoryId{
    NSManagedObjectContext *myContext = [self managedObjectContext];
    NSFetchRequest *fetchAllObjects = [[NSFetchRequest alloc] init];
    [fetchAllObjects setEntity:[NSEntityDescription entityForName:entity inManagedObjectContext:myContext]];
    [fetchAllObjects setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"categoryId == %d",categoryId];
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



-(void)getCuratedNewsListWithAccessToken:(NSString *)details withCategoryId:(NSInteger)categoryId withFlag:(NSString *)updownFlag {
   // [self showProgressView];
    
    if([self serviceIsReachable]) {
    [FIWebService fetchCuratedNewsListWithAccessToken:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([[responseObject objectForKey:@"isAuthenticated"]isEqualToNumber:[NSNumber numberWithInt:1]]) {
       // [self clearEntity:@"CuratedNews"];
        [self hideProgressView];
        NSArray *influencerArray = [responseObject objectForKey:@"articleList"];
            
            if(influencerArray.count == 0) {
                UIWindow *window = [[UIApplication sharedApplication]windows][0];
                [window makeToast:@"No more articles to display" duration:2 position:CSToastPositionCenter];
            }
            
            if([updownFlag isEqualToString:@"up"]) {
                if(categoryId == -2 || categoryId == -3) {
                    [self clearEntity:@"CuratedNews" withCategoryId:categoryId];
                }
            }
            
        for(NSDictionary *dic in influencerArray) {
            
            NSManagedObjectContext *context;
            // Create a new managed object
            NSManagedObject *influencer;
            context = [self managedObjectContext];
            
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"categoryId == %d AND articleId == %@",categoryId,[dic objectForKey:@"id"]];
            [fetchRequest setPredicate:predicate];
            //    NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
            NSArray *existingArray = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
            
            if(existingArray.count != 0) {
                influencer = [existingArray objectAtIndex:0];
            } else {
                influencer = [NSEntityDescription insertNewObjectForEntityForName:@"CuratedNews" inManagedObjectContext:context];
                [_articleIdArray addObject:[dic objectForKey:@"id"]];
            }
            
            
            [influencer setValue:[dic objectForKey:@"id"] forKey:@"articleId"];
            [influencer setValue:[dic objectForKey:@"articleHeading"] forKey:@"title"];
            [influencer setValue:[dic objectForKey:@"articleDescription"] forKey:@"desc"];
            [influencer setValue:[dic objectForKey:@"articlePublisheddate"] forKey:@"date"];
            [influencer setValue:[dic objectForKey:@"articleImageURL"] forKey:@"image"];
            [influencer setValue:[dic objectForKey:@"articleUrl"] forKey:@"articleUrl"];
            [influencer setValue:[dic objectForKey:@"articleTypeId"] forKey:@"articleTypeId"];
            [influencer setValue:[dic objectForKey:@"articleType"] forKey:@"articleType"];
            [influencer setValue:[dic objectForKey:@"readStatus"] forKey:@"readStatus"];
            [influencer setValue:[dic objectForKey:@"markAsImportant"] forKey:@"markAsImportant"];
            [influencer setValue:[dic objectForKey:@"saveForLater"] forKey:@"saveForLater"];
            [influencer setValue:[NSNumber numberWithInteger:categoryId] forKey:@"categoryId"];
            NSArray *outletArray = [dic objectForKey:@"outlet"];
            if(outletArray.count != 0){
                NSDictionary *outletDic = [outletArray objectAtIndex:0];
                 [influencer setValue:[outletDic objectForKey:@"outletname"] forKey:@"outlet"];
            }
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
          //  NSLog(@"middle");
            NSOrderedSet *Obj = [[NSOrderedSet alloc]initWithArray:authorList];
            [influencer setValue:Obj forKey:@"author"];
          
            NSSet *legendsSet1 = [influencer valueForKey:@"legends"];
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
                [influencer setValue:legendsSet forKey:@"legends"];
            }
            
            
            
            NSError *error = nil;
            // Save the object to persistent store
            if (![context save:&error]) {
               // NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            }else {
              //  NSLog(@"else part:%@",error);
            }

        }
        [self hideProgressView];
       // NSLog(@"reached end");
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"Test"];
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
    if([self serviceIsReachable]) {
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
                NSLog(@"social isactive:%@",[socialMediaDic valueForKey:@"isactive"]);
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
    } else {
        [FIUtils showNoNetworkToast];
    }
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
        [curatedNewsDrillIn setValue:[[responseObject objectForKey:@"articleDetail"] objectForKey:@"articleImageURL"] forKey:@"articleImageURL"];
        [curatedNewsDrillIn setValue:[[responseObject objectForKey:@"articleDetail"] objectForKey:@"article"] forKey:@"article"];
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
    _menuList = [[NSMutableArray alloc]init];
    [FIWebService fetchMenuListWithAccessToken:accessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([[responseObject objectForKey:@"isAuthenticated"]isEqualToNumber:[NSNumber numberWithInt:1]]) {
        NSArray *menuArray = [responseObject objectForKey:@"menuList"];
        [_menuList removeAllObjects];
        for(NSDictionary *dic in menuArray) {
            FIMenu *menu = [FIMenu recursiveMenu:dic];
            [_menuList addObject:menu];
        }
        [[NSUserDefaults standardUserDefaults]setObject:[NSKeyedArchiver archivedDataWithRootObject:_menuList] forKey:@"MenuList"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MenuList" object:nil];
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


-(void)manageContentCategoryWithDetails:(NSString *)details  withFlag:(NSInteger)flag{
    if([self serviceIsReachable]) {
        _contentCategoryList = [[NSMutableArray alloc]init];
        _contentTypeList = [[NSMutableArray alloc]init];
    [FIWebService manageContentCategoryWithAccessToken:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if([[responseObject objectForKey:@"isAuthenticated"]isEqualToNumber:[NSNumber numberWithInt:1]]) {
                if(flag == 1) {
                    UIWindow *window = [[UIApplication sharedApplication]windows][0];
                    [window makeToast:@"Updated content changes." duration:2 position:CSToastPositionCenter];
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
            if([[responseObject objectForKey:@"success"]isEqualToNumber:[NSNumber numberWithInt:1]]) {
                UIWindow *window = [[UIApplication sharedApplication]windows][0];
                [window makeToast:[responseObject objectForKey:@"message"] duration:2 position:CSToastPositionCenter];
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


-(void)addCommentsWithDetails:(NSString *)details {
    if([self serviceIsReachable]) {
        [FIWebService addCommentsWithDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if([[responseObject objectForKey:@"success"]isEqualToNumber:[NSNumber numberWithInt:1]]) {
                UIWindow *window = [[UIApplication sharedApplication]windows][0];
                [window makeToast:[responseObject objectForKey:@"message"] duration:2 position:CSToastPositionCenter];
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

- (void)showProgressHUDForViewWithTitle:(NSString*)title withDetail:(NSString*)detail;
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] windows][0] animated:YES];
    [hud setLabelText:title];
    [hud setDetailsLabelText:detail];
}

- (void)showProgressHUDForView
{
    
    NSLog(@"showProgressHUDForView is running");
    [self showProgressHUDForViewWithTitle:nil withDetail:nil];
}

- (void)hideProgressHUDForView
{ NSLog(@"hideProgressHUDForView is running");
    
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] windows][0] animated:YES];
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
