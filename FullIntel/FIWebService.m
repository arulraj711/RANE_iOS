//
//  FIWebService.m
//  FullIntel
//
//  Created by Arul on 2/26/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "FIWebService.h"

//Host URL
#define BARTRIVIA_URL @"http://fullintel.com/services/mv01/sv00/appuser"

@implementation FIWebService
+ (void)getResultsForFunctionName:(NSString *)urlPath withPostDetails:(NSString*)postDetails onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
{
    NSLog(@"get ress for function ");
    
    NSString *postURL = [NSString stringWithFormat:@"%@/%@/",BARTRIVIA_URL,urlPath];
    NSURL *url = [NSURL URLWithString:postURL];
    NSMutableURLRequest * requestURL = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:60];
    [requestURL setHTTPMethod:@"POST"];
    [requestURL setHTTPBody:[postDetails dataUsingEncoding:NSUTF8StringEncoding]];
    [requestURL setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:requestURL];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSASCIIStringEncoding];
         NSData *metOfficeData = [str dataUsingEncoding:NSUTF8StringEncoding];
         NSLog(@"\n=========REQUEST=========\n%@\n%@\n===========================",operation.request.URL.absoluteString,postDetails);
         // NSLog(@"response object:%@",responseObject);
         id JSON = [NSJSONSerialization JSONObjectWithData:metOfficeData options:kNilOptions error:nil];
         NSLog(@"\n=========RESPONSE=========\n%@\n===========================",JSON);
         success(operation, JSON);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"\n=========REQUEST=========\n%@",operation.request);
         NSLog(@"\n=========RESPONSE(ERROR)=========\n%@\n==================",error);
         
         if(error.code != -999)
         failure(operation, error);
         
     }];
    [[NSOperationQueue mainQueue] addOperation:requestOperation];
    
}
+(void)fetchCuratedNewsListWithAccessToken:(NSString*)details
                                 onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
//    NSDictionary *JSON = [self dictionaryWithFileName:@"corporate_news_list"];
//    NSLog(@"curated news JSON:%@",JSON);
//    success(nil,JSON);
    
    [self getResultsForFunctionName:@"articles" withPostDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"curated news response:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        
    }];
}

+(void)fetchCuratedNewsDetailsWithDetails:(NSString *)details
                                onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [self getResultsForFunctionName:@"selectedarticledetail" withPostDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
       // NSLog(@"curated news response:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        
    }];
}

+(void)fetchCuratedNewsAuthorDetailsWithDetails:(NSString *)details
                                onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [self getResultsForFunctionName:@"articlecontact" withPostDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // NSLog(@"curated news response:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        
    }];
}


+(void)fetchInfluencerDetailsWithDetails:(NSString *)details
                               onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    [self getResultsForFunctionName:@"selectedinfluencer" withPostDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // NSLog(@"curated news response:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        
    }];
}

+(void)fetchInfluencerListWithAccessToken:(NSString*)details
                                onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [self getResultsForFunctionName:@"influencers" withPostDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"curated news response:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        
    }];
}


+(void)fetchMenuListWithAccessToken:(NSString*)accessToken
                          onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
//    NSDictionary *JSON = [self dictionaryWithFileName:@"menu"];
//    success(nil,JSON);
    
    [self getResultsForFunctionName:@"usermainmenu" withPostDetails:accessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"curated news response:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        
    }];
}


+(void)sendResearchRequestWithDetails:(NSString*)details
                            onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    [self getResultsForFunctionName:@"useractivity/article/researchrequest" withPostDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"curated news response:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        
    }];
}


+(void)loginProcessWithDetails:(NSString*)details
            onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [self getResultsForFunctionName:@"validatecredentials" withPostDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        
    }];
}

+(void)logoutWithAccessToken:(NSString*)details
                   onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [self getResultsForFunctionName:@"applogout" withPostDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        
    }];
}

+(void)validateUserOnResumeWithAccessToken:(NSString*)details
                                 onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [self getResultsForFunctionName:@"validateuseronresume" withPostDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        
    }];
}

+(void)manageContentCategoryWithAccessToken:(NSString*)details
                                  onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                  onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [self getResultsForFunctionName:@"managecontentcategories" withPostDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        
    }];
}


+(void)userActivitiesOnArticlesWithDetails:(NSString *)details
                                 onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    [self getResultsForFunctionName:@"useractivitiesonarticles" withPostDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        
    }];
}

+ (NSDictionary *)dictionaryWithContentOfFile:(NSString *)path
{
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSError *error;
    id JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    //NSLog(@"error :%@",error);
    if(error)
        return nil;
    //NSLog(@"JSON :%@",JSON);
    return JSON;
}

+ (NSDictionary *)dictionaryWithFileName:(NSString *)filename
{
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"json"];
    NSDictionary *dic = [self dictionaryWithContentOfFile:path];
    return dic ;
}



@end
