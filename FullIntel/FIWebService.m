

//
//  FIWebService.m
//  FullIntel
//
//  Created by Arul on 2/26/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "FIWebService.h"

//Host URL
#define LIVE_URL @"http://fullintel.com/services/mv01/sv00/appuser"
#define STAGE_URL @"http://104.236.78.199/services/mv01/sv00/appuser"
#define Twitter_API_Key @"1c29beff4fb9acba2e7f82bc9b945a4e"
//NSString *url = @"https://stage.fullintel.com/2.1.0";

NSString *url = @"http://fullintel.com/3.0.0";


#define FUNCTION_URL @"api/v1"
@implementation FIWebService

+(NSString *) getServerURL{
    return url;
}

+(void) setServerURL:(NSString *)urls {
    url = urls;
}

+(void)getResponseTimeFromTimeStamp:(double)timeStamp {
    float milliseconds = timeStamp*1000;
    float seconds = milliseconds / 1000.0;
    float minutes = seconds / 60.0;
    float hours = minutes / 60.0;
    NSLog(@"Response seconds:%f and minutes:%f and hours:%f",seconds,minutes,hours);
}

+(void)getResultsForFunctionName:(NSString *)urlPath withPostDetails:(NSString*)postDetails onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    //NSLog(@"get ress for function ");
    //NSLog(@"start  time--->%f",CFAbsoluteTimeGetCurrent());
    NSTimeInterval startTimeInMiliseconds = [[NSDate date] timeIntervalSince1970];
    //NSLog(@"start time in ms------>%f",startTimeInMiliseconds);
    NSLog(@"%@",postDetails);
    NSLog(@"%@",urlPath);

    NSString *postURL;

    if ([urlPath isEqualToString:@"useractivitiesonarticles"]||[urlPath isEqualToString:@"updateappviewtype"]) {
        postURL = [NSString stringWithFormat:@"%@/services/mv01/sv00/appuser/%@",url,urlPath];
    }
    else if ([urlPath isEqualToString:@"managecontentcategories"]){
        postURL = [NSString stringWithFormat:@"%@/services/mv01/sv00/appuser/%@",url,urlPath];

    } else if([urlPath isEqualToString:@"validateuseronresume"]) {
        postURL = [NSString stringWithFormat:@"%@/services/mv01/sv00/appuser/%@",url,urlPath];
    }else if([urlPath isEqualToString:@"applogout"]){
        postURL = [NSString stringWithFormat:@"%@/services/mv01/sv00/appuser/%@",url,urlPath];
    }
    else if([urlPath isEqualToString:@"retrievepassword"]){
        postURL = [NSString stringWithFormat:@"%@/services/mv01/sv00/appuser/%@",url,urlPath];
    }
    else if([urlPath isEqualToString:@"useractivity/article/getcomment"]) {
        postURL = [NSString stringWithFormat:@"%@/services/mv01/sv00/appuser/%@",url,urlPath];
    }
    else if([urlPath isEqualToString:@"useractivity/article/addcomment"]) {
        postURL = [NSString stringWithFormat:@"%@/services/mv01/sv00/appuser/%@",url,urlPath];
    }
    else if([urlPath isEqualToString:@"useractivity/comment/markasRead"]) {
        postURL = [NSString stringWithFormat:@"%@/services/mv01/sv00/appuser/%@",url,urlPath];
    }
    else if([urlPath isEqualToString:@"useractivity/article/researchrequest"]) {
        postURL = [NSString stringWithFormat:@"%@/services/mv01/sv00/appuser/%@",url,urlPath];
    } else if([urlPath isEqualToString:@"featureaccessrequest"]) {
        postURL = [NSString stringWithFormat:@"%@/services/mv01/sv00/appuser/%@",url,urlPath];
    } else{
        postURL = [NSString stringWithFormat:@"%@/%@/%@",url,FUNCTION_URL,urlPath];
    }
    NSURL *url = [NSURL URLWithString:postURL];
    NSMutableURLRequest * requestURL = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:15];
    [requestURL setHTTPMethod:@"POST"];
    [requestURL setHTTPBody:[postDetails dataUsingEncoding:NSUTF8StringEncoding]];
    [requestURL setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:requestURL];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"end  time--->%f",CFAbsoluteTimeGetCurrent());
         double currentt = [[NSDate new] timeIntervalSince1970];
         NSTimeInterval differ= [[NSDate dateWithTimeIntervalSince1970:currentt] timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:startTimeInMiliseconds]];
         //NSLog(@"differ: %f", differ*1000);
         [self getResponseTimeFromTimeStamp:differ];
         
         NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSASCIIStringEncoding];
         NSData *metOfficeData = [str dataUsingEncoding:NSUTF8StringEncoding];
         NSLog(@"\n=========REQUEST=========\n%@\n%@\n===========================",operation.request.URL.absoluteString,postDetails);
         // NSLog(@"response object:%@",responseObject);
         id JSON = [NSJSONSerialization JSONObjectWithData:metOfficeData options:kNilOptions error:nil];
         NSLog(@"\n=========RESPONSE=========\n%@\n===========================",JSON);
         success(operation, JSON);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         double currentt = [[NSDate new] timeIntervalSince1970];
         NSTimeInterval differ= [[NSDate dateWithTimeIntervalSince1970:currentt] timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:startTimeInMiliseconds]];
         //NSLog(@"differ: %f", differ*1000);
         [self getResponseTimeFromTimeStamp:differ];
         NSLog(@"\n=========REQUEST=========\n%@",operation.request);
         NSLog(@"\n=========RESPONSE(ERROR)=========\n%@\n==================",error);
         if(error.code != -999)
         failure(operation, error);
     }];
    [[NSOperationQueue mainQueue] addOperation:requestOperation];
    
}


+ (void)postQueryResultsForFunctionName:(NSString *)urlPath withPostDetails:(NSString*)postDetails withSecurityToken:(NSString *)securityToken onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    //NSLog(@"get ress for function ");
    NSTimeInterval startTimeInMiliseconds = [[NSDate date] timeIntervalSince1970];
    NSString *postURL = [NSString stringWithFormat:@"%@/%@/%@",url,@"api/v1",urlPath];
    NSURL *url = [NSURL URLWithString:postURL];
    NSMutableURLRequest * requestURL = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:15];
    [requestURL setHTTPMethod:@"POST"];
    [requestURL setHTTPBody:[postDetails dataUsingEncoding:NSUTF8StringEncoding]];
    [requestURL setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:requestURL];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         double currentt = [[NSDate new] timeIntervalSince1970];
         NSTimeInterval differ= [[NSDate dateWithTimeIntervalSince1970:currentt] timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:startTimeInMiliseconds]];
         //NSLog(@"differ: %f", differ*1000);
         [self getResponseTimeFromTimeStamp:differ];
         
         NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSASCIIStringEncoding];
         NSData *metOfficeData = [str dataUsingEncoding:NSUTF8StringEncoding];
         NSLog(@"\n=========REQUEST=========\n%@\n%@\n===========================",operation.request.URL.absoluteString,postDetails);
         // NSLog(@"response object:%@",responseObject);
         id JSON = [NSJSONSerialization JSONObjectWithData:metOfficeData options:kNilOptions error:nil];
         NSLog(@"\n=========RESPONSE=========\n%@\n===========================",JSON);
         success(operation, JSON);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         double currentt = [[NSDate new] timeIntervalSince1970];
         NSTimeInterval differ= [[NSDate dateWithTimeIntervalSince1970:currentt] timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:startTimeInMiliseconds]];
         //NSLog(@"differ: %f", differ*1000);
         [self getResponseTimeFromTimeStamp:differ];
         
         NSLog(@"\n=========REQUEST=========\n%@",operation.request);
         NSLog(@"\n=========RESPONSE(ERROR)=========\n%@\n==================",error);
         
         if(error.code != -999)
             failure(operation, error);
         
     }];
    [[NSOperationQueue mainQueue] addOperation:requestOperation];
    
}


+ (void)getQueryResultsForFunctionName:(NSString *)functionName onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSTimeInterval startTimeInMiliseconds = [[NSDate date] timeIntervalSince1970];
    NSLog(@"get function name:%@",functionName);
    
    NSString *postURL = [NSString stringWithFormat:@"%@%@",url,functionName];
    NSLog(@"post url:%@",postURL);
    NSURL *url = [NSURL URLWithString:postURL];
    NSLog(@"url string:%@",url);
    NSMutableURLRequest * requestURL = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:15];
    [requestURL setHTTPMethod:@"GET"];
   // [requestURL setHTTPBody:[postDetails dataUsingEncoding:NSUTF8StringEncoding]];
   // [requestURL setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:requestURL];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         double currentt = [[NSDate new] timeIntervalSince1970];
         NSTimeInterval differ= [[NSDate dateWithTimeIntervalSince1970:currentt] timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:startTimeInMiliseconds]];
         //NSLog(@"differ: %f", differ*1000);
         [self getResponseTimeFromTimeStamp:differ];
         
         NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSData *metOfficeData = [str dataUsingEncoding:NSUTF8StringEncoding];
         NSLog(@"\n=========REQUEST=========\n%@\n===========================",operation.request.URL.absoluteString);
         // NSLog(@"response object:%@",responseObject);
         id JSON = [NSJSONSerialization JSONObjectWithData:metOfficeData options:kNilOptions error:nil];
         NSLog(@"\n=========RESPONSE=========\n%@\n===========================",JSON);
         success(operation, JSON);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         double currentt = [[NSDate new] timeIntervalSince1970];
         NSTimeInterval differ= [[NSDate dateWithTimeIntervalSince1970:currentt] timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:startTimeInMiliseconds]];
         //NSLog(@"differ: %f", differ*1000);
         [self getResponseTimeFromTimeStamp:differ];
         
         NSLog(@"\n=========REQUEST=========\n%@",operation.request);
         NSLog(@"\n=========RESPONSE(ERROR)=========\n%@\n==================",error);
         
         if(error.code != -999)
             failure(operation, error);
         
     }];
    [[NSOperationQueue mainQueue] addOperation:requestOperation];
}


+ (void)deleteQueryResultsForFunctionName:(NSString *)urlPath withSecurityToken:(NSString*)securityToken withDetails:(NSString *)postDetails onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSLog(@"inside remove articles");
    NSTimeInterval startTimeInMiliseconds = [[NSDate date] timeIntervalSince1970];
    NSString *postURL = [NSString stringWithFormat:@"%@/%@/%@",url,@"api/v1",urlPath];
    NSURL *url = [NSURL URLWithString:postURL];
    NSMutableURLRequest * requestURL = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:15];
    [requestURL setHTTPMethod:@"DELETE"];
    [requestURL setHTTPBody:[postDetails dataUsingEncoding:NSUTF8StringEncoding]];
    [requestURL setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:requestURL];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         double currentt = [[NSDate new] timeIntervalSince1970];
         NSTimeInterval differ= [[NSDate dateWithTimeIntervalSince1970:currentt] timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:startTimeInMiliseconds]];
         //NSLog(@"differ: %f", differ*1000);
         [self getResponseTimeFromTimeStamp:differ];
         
         NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSASCIIStringEncoding];
         NSData *metOfficeData = [str dataUsingEncoding:NSUTF8StringEncoding];
         NSLog(@"\n=========REQUEST=========\n%@\n%@\n===========================",operation.request.URL.absoluteString,securityToken);
         // NSLog(@"response object:%@",responseObject);
         id JSON = [NSJSONSerialization JSONObjectWithData:metOfficeData options:kNilOptions error:nil];
         NSLog(@"\n=========RESPONSE=========\n%@\n===========================",JSON);
         success(operation, JSON);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         double currentt = [[NSDate new] timeIntervalSince1970];
         NSTimeInterval differ= [[NSDate dateWithTimeIntervalSince1970:currentt] timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:startTimeInMiliseconds]];
         //NSLog(@"differ: %f", differ*1000);
         [self getResponseTimeFromTimeStamp:differ];
         
         NSLog(@"\n=========REQUEST=========\n%@",operation.request);
         NSLog(@"\n=========RESPONSE(ERROR)=========\n%@\n==================",error);
         
         if(error.code != -999)
             failure(operation, error);
         
     }];
    [[NSOperationQueue mainQueue] addOperation:requestOperation];
}


+ (void)putQueryResultsForFunctionName:(NSString *)urlPath withSecurityToken:(NSString*)securityToken withDetails:(NSString *)postDetails onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSTimeInterval startTimeInMiliseconds = [[NSDate date] timeIntervalSince1970];
    NSString *postURL = [NSString stringWithFormat:@"%@/%@/%@",url,@"api/v1",urlPath];
    NSURL *url = [NSURL URLWithString:postURL];
    NSMutableURLRequest * requestURL = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:15];
    [requestURL setHTTPMethod:@"PUT"];
     [requestURL setHTTPBody:[postDetails dataUsingEncoding:NSUTF8StringEncoding]];
     [requestURL setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:requestURL];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         double currentt = [[NSDate new] timeIntervalSince1970];
         NSTimeInterval differ= [[NSDate dateWithTimeIntervalSince1970:currentt] timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:startTimeInMiliseconds]];
         //NSLog(@"differ: %f", differ*1000);
         [self getResponseTimeFromTimeStamp:differ];
         
         NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSASCIIStringEncoding];
         NSData *metOfficeData = [str dataUsingEncoding:NSUTF8StringEncoding];
         NSLog(@"\n=========REQUEST=========\n%@\n%@\n===========================",operation.request.URL.absoluteString,securityToken);
         // NSLog(@"response object:%@",responseObject);
         id JSON = [NSJSONSerialization JSONObjectWithData:metOfficeData options:kNilOptions error:nil];
         NSLog(@"\n=========RESPONSE=========\n%@\n===========================",JSON);
         success(operation, JSON);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         double currentt = [[NSDate new] timeIntervalSince1970];
         NSTimeInterval differ= [[NSDate dateWithTimeIntervalSince1970:currentt] timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:startTimeInMiliseconds]];
         //NSLog(@"differ: %f", differ*1000);
         [self getResponseTimeFromTimeStamp:differ];
         
         NSLog(@"\n=========REQUEST=========\n%@",operation.request);
         NSLog(@"\n=========RESPONSE(ERROR)=========\n%@\n==================",error);
         
         if(error.code != -999)
             failure(operation, error);
         
     }];
    [[NSOperationQueue mainQueue] addOperation:requestOperation];
}



+(void)fetchCuratedNewsListWithAccessToken:(NSString*)details withActivityTypeID:(NSNumber *)activityTypeId
                                 onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSLog(@"webservice input:%@",details);
    [self getQueryResultsForFunctionName:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"curated news response:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);}];
}

+(void)fetchCuratedNewsDetailsWithDetails:(NSString *)details withSecurtityToken:(NSString *)securityToken
                                onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
                                    NSString *urlstr = [NSString stringWithFormat:@"articles/detail?security_token=%@",securityToken];
    [self getResultsForFunctionName:urlstr withPostDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"curated news response:%@",responseObject);
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
    
    NSDictionary *JSON = [self dictionaryWithFileName:@"influencer_new"];
   // NSLog(@"JSON:%@",JSON);
    
    success(nil,JSON);
    
    
//    [self getResultsForFunctionName:@"influencers" withPostDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //NSLog(@"curated news response:%@",responseObject);
//        success(operation,responseObject);
//    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        failure(operation, error);
//        
//    }];
}


+(void)fetchMenuListWithAccessToken:(NSString*)accessToken
                          onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
//    NSDictionary *JSON = [self dictionaryWithFileName:@"menu"];
//    success(nil,JSON);
    
    NSString *functionName = [NSString stringWithFormat:@"/api/v1/customer/menu?security_token=%@",accessToken];
    NSLog(@"fetch folder function name:%@",functionName);
    [self getQueryResultsForFunctionName:functionName onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"curated news response:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        
    }];
}

+(void)fetchMenuUnreadCountWithAccessToken:(NSString*)accessToken
                                 onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *functionName = [NSString stringWithFormat:@"/api/v1/customer/menuunreadcount?security_token=%@",accessToken];
    [self getQueryResultsForFunctionName:functionName onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"curated news response:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        
    }];
}

+(void)fetchFolderListWithAccessToken:(NSString*)accessToken
                          onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *functionName = [NSString stringWithFormat:@"/api/v1/folders?security_token=%@",accessToken];
    NSLog(@"fetch folder function name:%@",functionName);
    [self getQueryResultsForFunctionName:functionName onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"curated news response:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        
    }];
}

+(void)fetchNewsLetterListWithAccessToken:(NSString*)accessToken
                                onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *functionName = [NSString stringWithFormat:@"/api/v1/client/newsletters?security_token=%@",accessToken];
   // NSLog(@"fetch folder function name:%@",functionName);
    [self getQueryResultsForFunctionName:functionName onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"curated news response:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        
    }];
}


+(void)sendMailWithAccessToken:(NSString*)accessToken withDetails:(NSString *)details
                            onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *functionName = [NSString stringWithFormat:@"article/mail?security_token=%@",accessToken];
    [self postQueryResultsForFunctionName:functionName withPostDetails:details withSecurityToken:accessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"curated news response:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        //        NSError* error1;
        //        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:(NSData*)operation.responseObject options:kNilOptions error:&error1];
        //        NSLog(@"folder create error:%@ and json:%@",error.userInfo,json);
    }];
}


+(void)createFolderWithDetails:(NSString*)details withSecurityToken:(NSString *)securityToken
                    onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *functionName = [NSString stringWithFormat:@"folders?security_token=%@",securityToken];
    [self postQueryResultsForFunctionName:functionName withPostDetails:details withSecurityToken:securityToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"curated news response:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
//        NSError* error1;
//        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:(NSData*)operation.responseObject options:kNilOptions error:&error1];
//        NSLog(@"folder create error:%@ and json:%@",error.userInfo,json);
    }];
    
}


+(void)pushNotificationWithDetails:(NSString*)details withSecurityToken:(NSString *)securityToken
                     onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *functionName = [NSString stringWithFormat:@"customer/device?security_token=%@",securityToken];
    [self postQueryResultsForFunctionName:functionName withPostDetails:details withSecurityToken:securityToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"curated news response:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        
    }];
}


+(void)updatePushNotificationWithDetails:(NSString*)details withSecurityToken:(NSString *)securityToken
                         onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    //NSLog(@"calling update push");
    NSString *functionName = [NSString stringWithFormat:@"customer/device?security_token=%@",securityToken];
    [self putQueryResultsForFunctionName:functionName withSecurityToken:securityToken withDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"curated news response:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        
    }];
}


+(void)fetchArticlesFromFolderWithSecurityToken:(NSString *)securityToken withFolderId:(NSString *)folderId withPageNo:(NSNumber *)pageNo withSize:(NSNumber *)sizeVal withQuery:(NSString*)query withFilterBy:(NSString *)filterBy onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *functionName;
    if(query.length != 0) {
        functionName = [NSString stringWithFormat:@"/api/v1/folders/%@/articles?security_token=%@&page=%@&size=%@&query=%@",folderId,securityToken,pageNo,sizeVal,query];
    } else if(filterBy.length != 0) {
        functionName = [NSString stringWithFormat:@"/api/v1/folders/%@/articles?security_token=%@&page=%@&size=%@&filterby=%@",folderId,securityToken,pageNo,sizeVal,filterBy];
    } else {
        functionName = [NSString stringWithFormat:@"/api/v1/folders/%@/articles?security_token=%@&page=%@&size=%@",folderId,securityToken,pageNo,sizeVal];
    }
    
    [self getQueryResultsForFunctionName:functionName onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"curated news response:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        
    }];
}

+(void)fetchArticlesFromNewsLetterWithSecurityToken:(NSString *)securityToken withNewsLetterId:(NSNumber *)newsletterId withPageNo:(NSNumber *)pageNo withSize:(NSNumber *)sizeVal withQuery:(NSString *)query withFilterBy:(NSString *)filterBy onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *functionName;
    if(query.length != 0) {
        functionName = [NSString stringWithFormat:@"/api/v1/client/newsletter/%@/articles?security_token=%@&page=%@&size=%@&query=%@",newsletterId,securityToken,pageNo,sizeVal,query];
    } else if(filterBy.length != 0) {
        functionName = [NSString stringWithFormat:@"/api/v1/client/newsletter/%@/articles?security_token=%@&page=%@&size=%@&filterby=%@",newsletterId,securityToken,pageNo,sizeVal,filterBy];
    } else {
        functionName = [NSString stringWithFormat:@"/api/v1/client/newsletter/%@/articles?security_token=%@&page=%@&size=%@",newsletterId,securityToken,pageNo,sizeVal];
    }
    
    [self getQueryResultsForFunctionName:functionName onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"curated news response:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        
    }];
}


+(void)saveArticlesToFolderWithDetails:(NSString*)details withSecurityToken:(NSString *)    securityToken withFolderId:(NSString *)articleId
                     onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *functionName = [NSString stringWithFormat:@"articles/%@/folders?security_token=%@",articleId,securityToken];
    [self postQueryResultsForFunctionName:functionName withPostDetails:details withSecurityToken:securityToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"curated news response:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        
    }];
}

+(void)addMultipleArticlesToMultipleFolderWithDetails:(NSString*)details withSecurityToken:(NSString *)securityToken onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    //NSString *functionName = [NSString stringWithFormat:@"save/folders",articleId,securityToken];
    [self postQueryResultsForFunctionName:@"save/folders" withPostDetails:details withSecurityToken:securityToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"curated news response:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        
    }];
}

+(void)removeArticlesFromFolderWithDetails:(NSString*)details withSecurityToken:(NSString *)    securityToken withArticleId:(NSString *)articleId
                             onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *functionName = [NSString stringWithFormat:@"articles/%@/folders?security_token=%@",articleId,securityToken];
    
    [self deleteQueryResultsForFunctionName:functionName withSecurityToken:securityToken withDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"curated news response:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        
    }];
}


+(void)renameFolderWithDetails:(NSString*)details withSecurityToken:(NSString *)    securityToken withFolderId:(NSNumber *)folderId
                                 onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *functionName = [NSString stringWithFormat:@"folders/%@?security_token=%@",folderId,securityToken];
    [self putQueryResultsForFunctionName:functionName withSecurityToken:securityToken withDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"curated news response:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        
    }];
}

+(void)getCommentsWithDetails:(NSString*)details
                    onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    [self getResultsForFunctionName:@"useractivity/article/getcomment" withPostDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"curated news response:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        
    }];
}

+(void)addCommentsWithDetails:(NSString*)details
                    onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [self getResultsForFunctionName:@"useractivity/article/addcomment" withPostDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    //@"eti/customers/authenticate"
    //@"userauthentication"
    [self getResultsForFunctionName:@"eti/customers/authenticate" withPostDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        
    }];
}

+(void)forgotPasswordWithDetails:(NSString *)details onSuccess:(void (^)(AFHTTPRequestOperation *, id))success onFailure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    
    
    [self getResultsForFunctionName:@"retrievepassword" withPostDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
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


+(void)updateAppViewTypeWithDetails:(NSString*)details
                          onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [self getResultsForFunctionName:@"updateappviewtype" withPostDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
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

+(void)featureAccessRequestWithDetails:(NSString*)details
                             onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [self getResultsForFunctionName:@"featureaccessrequest" withPostDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        
    }];
}

+(void)commentMarkAsReadWithDetails:(NSString*)details
                          onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [self getResultsForFunctionName:@"useractivity/comment/markasRead" withPostDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        
    }];
}

+(void)getStockListDetails:(NSString *)details onSuccess:(void (^)(AFHTTPRequestOperation *, id))success onFailure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    
    
    
    NSDictionary *JSON = [self dictionaryWithFileName:@"StockResponse"];
    //NSLog(@"JSON:%@",JSON);
    
    success(nil,JSON);
    
}

+(void)getTweetDetails:(NSString*)withScreenName
             onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
//    NSDictionary *json = [self dictionaryWithContentOfFile:@"http://api.twittercounter.com/?twitter_id=813286&apikey=1c29beff4fb9acba2e7f82bc9b945a4e"];
//    NSLog(@" tweet JSON:%@",json);
    
    NSString *twitterUrl = [NSString stringWithFormat:@"https://cdn.syndication.twimg.com/widgets/followbutton/info.json?screen_names=%@",withScreenName];
    //NSLog(@"twitter url:%@",twitterUrl);
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:twitterUrl]];
    //NSLog(@"result data:%d",data.length);
    NSError* error;
    NSDictionary* json;
    if(data.length > 0) {
        json = [NSJSONSerialization
                              JSONObjectWithData:data //1
                              
                              options:kNilOptions
                              error:&error];
    }
    
    //NSLog(@"tweet json:%@",json);
    success(nil,json);
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

//Service for getting report list
+(void)getReportListonSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *companyId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"customerId"]];
    NSString *securityToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"]];
    
    NSString *functionName = [NSString stringWithFormat:@"/api/v1/companies/%@/analysis/reports?security_token=%@",companyId,securityToken];
    [self getQueryResultsForFunctionName:functionName onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"curated news response:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

+(void)getSingleReportDetailsForReportId:(NSNumber*)reportId
                               onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *companyId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"customerId"]];
    NSString *functionName = [NSString stringWithFormat:@"/api/v1/companies/%@/analysis/reports/%@",companyId,reportId];
    [self getQueryResultsForFunctionName:functionName onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"curated news response:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

//Trend of Coverage chart info
+(void)getTrendOfCoverageInfoFromDate:(NSNumber*)fromDate toDate:(NSNumber *)toDate withAPILink:(NSString*)apiLink onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
  //  NSString *companyId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"customerId"]];
    NSString *securityToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"]];
    NSString *functionName = [NSString stringWithFormat:@"%@&security_token=%@",apiLink,securityToken];
    [self getQueryResultsForFunctionName:functionName onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"curated news response:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

//Key Topics Chart Info
+(void)getKeyTopicsInfoFromDate:(NSNumber*)fromDate toDate:(NSNumber *)toDate withAPILink:(NSString*)apiLink onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
   // NSString *companyId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"customerId"]];
    NSString *securityToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"]];
    NSString *functionName = [NSString stringWithFormat:@"%@&security_token=%@",apiLink,securityToken];
    [self getQueryResultsForFunctionName:functionName onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"curated news response:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

//Media Type Chart Info
+(void)getMediaTypeInfoFromDate:(NSNumber*)fromDate toDate:(NSNumber *)toDate withAPILink:(NSString*)apiLink onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    //NSString *companyId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"customerId"]];
    NSString *securityToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"]];
    NSString *functionName = [NSString stringWithFormat:@"%@&security_token=%@",apiLink,securityToken];
    [self getQueryResultsForFunctionName:functionName onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"curated news response:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

//entiment And Volume Over Time Info
+(void)getSentimentAndVolumeOverTimeInfoFromDate:(NSNumber*)fromDate toDate:(NSNumber *)toDate withAPILink:(NSString*)apiLink onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    //NSString *companyId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"customerId"]];
 //   NSString *securityToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"]];
    NSString *functionName = [NSString stringWithFormat:@"%@",apiLink];
    [self getQueryResultsForFunctionName:functionName onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

//entiment And Volume Over Time Info
+(void)getChangeOverLastQuarterInfoFromDate:(NSNumber*)fromDate toDate:(NSNumber *)toDate withAPILink:(NSString*)apiLink onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
//    NSString *companyId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"customerId"]];
    NSString *securityToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"]];
    NSString *functionName = [NSString stringWithFormat:@"%@&security_token=%@",apiLink,securityToken];
    [self getQueryResultsForFunctionName:functionName onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}
//Top Sources Info
+(void)getTopSourcesInfoFromDate:(NSNumber*)fromDate toDate:(NSNumber *)toDate withAPILink:(NSString*)apiLink onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
   // NSString *companyId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"customerId"]];
    NSString *securityToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"]];
    NSString *functionName = [NSString stringWithFormat:@"%@&security_token=%@",apiLink,securityToken];
    [self getQueryResultsForFunctionName:functionName onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}


//Top Journalist Info
+(void)getTopJournalistInfoFromDate:(NSNumber*)fromDate toDate:(NSNumber *)toDate withAPILink:(NSString*)apiLink onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
   // NSString *companyId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"customerId"]];
    NSString *securityToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"]];
    
    
    NSString *functionName = [NSString stringWithFormat:@"%@&security_token=%@",apiLink,securityToken];
    [self getQueryResultsForFunctionName:functionName onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}


//Top Influencer
+(void)getTopInfluencerInfoFromDate:(NSNumber*)fromDate toDate:(NSNumber *)toDate withAPILink:(NSString*)apiLink onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *companyId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"customerId"]];
    NSString *securityToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"]];
    
    
    NSString *functionName = [NSString stringWithFormat:@"%@&security_token=%@",apiLink,securityToken];
    [self getQueryResultsForFunctionName:functionName onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

+(void)getTopStoriesInfoFromDate:(NSNumber*)fromDate toDate:(NSNumber *)toDate withPageNumber:(NSNumber *)pageNo withSize:(NSNumber *)size onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
//    Eg:http://stage.fullintel.com/1.3.0/api/v1/articles/2?fromDate=1451624400000&page=0&security_token=346650015f5cb4dbe98fdd327e8f3e2da7cc50e8&size=10&toDate=1456808399000
    
    NSString *securityToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"]];
    NSString *functionName = [NSString stringWithFormat:@"/api/v1/articles/2?fromDate=%@&page=%@&security_token=%@&size=%@&toDate=%@",fromDate,pageNo,securityToken,size,toDate];
    [self getQueryResultsForFunctionName:functionName onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

//Trend of coverage article list API

+(void)fetchTrendOfCoverageArticleListWithClickedDate:(NSString*)clickedDate EndDateIn:(NSString *)endDateIn fromDate:(NSNumber *)fromDate toDate:(NSNumber *)toDate withPageNo:(NSNumber *)pageNo withSize:(NSNumber *)size withFilterBy:(NSString *)filterBy withQuery:(NSString *)query onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
  //  http://stage.fullintel.com/1.4.0/api/v1/articles?clickedDate=01/12/2015&endDateIn=MONTH&fromDate=1448946000000&page=0&security_token=1c4f4e2586d4a2eaef161b000df2215f76016271&size=10&toDate=1456722000000
    
    NSString *securityToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"]];
    NSString *functionName;
    if(filterBy.length != 0 && query.length != 0) {
        functionName = [NSString stringWithFormat:@"/api/v1/articles?clickedDate=%@&endDateIn=%@&fromDate=%@&page=%@&security_token=%@&size=%@&toDate=%@&filterby=%@&query=%@",clickedDate,endDateIn,fromDate,pageNo,securityToken,size,toDate,filterBy,query];
    } else if(filterBy.length != 0) {
        functionName = [NSString stringWithFormat:@"/api/v1/articles?clickedDate=%@&endDateIn=%@&fromDate=%@&page=%@&security_token=%@&size=%@&toDate=%@&filterby=%@",clickedDate,endDateIn,fromDate,pageNo,securityToken,size,toDate,filterBy];
    } else if(query.length != 0) {
        functionName = [NSString stringWithFormat:@"/api/v1/articles?clickedDate=%@&endDateIn=%@&fromDate=%@&page=%@&security_token=%@&size=%@&toDate=%@&query=%@",clickedDate,endDateIn,fromDate,pageNo,securityToken,size,toDate,query];
    } else {
        functionName = [NSString stringWithFormat:@"/api/v1/articles?clickedDate=%@&endDateIn=%@&fromDate=%@&page=%@&security_token=%@&size=%@&toDate=%@",clickedDate,endDateIn,fromDate,pageNo,securityToken,size,toDate];
    }
    
    [self getQueryResultsForFunctionName:functionName onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

//Key topics article list API
+(void)fetchKeyTopicsArticleListWithField1:(NSString*)field_1 value1:(NSString *)value_1 fromDate:(NSNumber *)fromDate toDate:(NSNumber *)toDate withPageNo:(NSNumber *)pageNo withSize:(NSNumber *)size withFilterBy:(NSString *)filterBy withQuery:(NSString *)query onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    ///1.4.0/api/v1/articles?contentCategoryId=&field_1=fields.name&fromDate=1446354000000&page=0&security_token=1c4f4e2586d4a2eaef161b000df2215f76016271&size=10&toDate=1454302799000&value_1=Samsungu
    NSString *securityToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"]];
    
    NSString *functionName;
    if(filterBy.length != 0 && query.length != 0) {
        
        functionName = [NSString stringWithFormat:@"/api/v1/articles?field_1=%@&fromDate=%@&page=%@&security_token=%@&size=%@&toDate=%@&value_1=%@&filterby=%@&query=%@",field_1,fromDate,pageNo,securityToken,size,toDate,value_1,filterBy,query];
    } else if(filterBy.length != 0) {
        
        functionName = [NSString stringWithFormat:@"/api/v1/articles?field_1=%@&fromDate=%@&page=%@&security_token=%@&size=%@&toDate=%@&value_1=%@&filterby=%@",field_1,fromDate,pageNo,securityToken,size,toDate,value_1,filterBy];
        
    } else if(query.length != 0) {
        
        functionName = [NSString stringWithFormat:@"/api/v1/articles?field_1=%@&fromDate=%@&page=%@&security_token=%@&size=%@&toDate=%@&value_1=%@&query=%@",field_1,fromDate,pageNo,securityToken,size,toDate,value_1,query];
        
    } else {
        functionName = [NSString stringWithFormat:@"/api/v1/articles?field_1=%@&fromDate=%@&page=%@&security_token=%@&size=%@&toDate=%@&value_1=%@",field_1,fromDate,pageNo,securityToken,size,toDate,value_1];
    }
    
   
    [self getQueryResultsForFunctionName:functionName onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

//Media Types article list API
+(void)fetchMediaTypeArticleListWithMediaTypeField:(NSString*)mediaType_field mediaTypeValue:(NSString *)mediaType_value fromDate:(NSNumber *)fromDate toDate:(NSNumber *)toDate withPageNo:(NSNumber *)pageNo withSize:(NSNumber *)size withFilterBy:(NSString *)filterBy withQuery:(NSString *)query onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    ///1.4.0/api/v1/articles?fromDate=1446354000000&mediaType_field=mediaTypeId&mediaType_value=Online+Pub&page=0&security_token=1c4f4e2586d4a2eaef161b000df2215f76016271&size=10&toDate=1454302799000
    NSString *securityToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"]];
    
    
    NSString *functionName;
    if(filterBy.length != 0 && query.length != 0) {
        
        functionName = [NSString stringWithFormat:@"/api/v1/articles?fromDate=%@&mediaType_field=%@&mediaType_value=%@&page=%@&security_token=%@&size=%@&toDate=%@&filterby=%@&query=%@",fromDate,mediaType_field,mediaType_value,pageNo,securityToken,size,toDate,filterBy,query];

    } else if(filterBy.length != 0) {
        
        functionName = [NSString stringWithFormat:@"/api/v1/articles?fromDate=%@&mediaType_field=%@&mediaType_value=%@&page=%@&security_token=%@&size=%@&toDate=%@&filterby=%@",fromDate,mediaType_field,mediaType_value,pageNo,securityToken,size,toDate,filterBy];
        
    } else if(query.length != 0) {
        
        functionName = [NSString stringWithFormat:@"/api/v1/articles?fromDate=%@&mediaType_field=%@&mediaType_value=%@&page=%@&security_token=%@&size=%@&toDate=%@&query=%@",fromDate,mediaType_field,mediaType_value,pageNo,securityToken,size,toDate,query];

    } else {
        functionName = [NSString stringWithFormat:@"/api/v1/articles?fromDate=%@&mediaType_field=%@&mediaType_value=%@&page=%@&security_token=%@&size=%@&toDate=%@",fromDate,mediaType_field,mediaType_value,pageNo,securityToken,size,toDate];
    }
    
    
    
    
    [self getQueryResultsForFunctionName:functionName onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

+(void)fetchSentimentAndVolumeOverTimeArticleListWithClickedDate:(NSString*)clickedDate EndDateIn:(NSString *)endDateIn field1:(NSString *)field_1 field2:(NSString *)field_2 value1:(NSString *)value_1 value2:(NSString *)value_2 fromDate:(NSNumber *)fromDate toDate:(NSNumber *)toDate withPageNo:(NSNumber *)pageNo withSize:(NSNumber *)size withFilterBy:(NSString *)filterBy withQuery:(NSString *)query onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
//    1.4.0/api/v1/articles?clickedDate=1%2F11%2F2015&contentCategoryId=&endDateIn=MONTH&field_1=tonality.name&field_2=fields.name&fromDate=1446354000000&page=0&security_token=1c4f4e2586d4a2eaef161b000df2215f76016271&size=10&toDate=1454216400000&value_1=Positive&value_2=Lenovaa
    
    
    NSString *securityToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"]];
    
    NSString *functionName;
    if(filterBy.length != 0 && query.length != 0) {
        
        functionName = [NSString stringWithFormat:@"/api/v1/articles?clickedDate=%@&endDateIn=%@&field_1=%@&field_2=%@&fromDate=%@&page=%@&size=%@&security_token=%@&toDate=%@&value_1=%@&value_2=%@&filterby=%@&query=%@",clickedDate,endDateIn,field_1,field_2,fromDate,pageNo,size,securityToken,toDate,value_1,value_2,filterBy,query];
        
    } else if(filterBy.length != 0) {
        
        functionName = [NSString stringWithFormat:@"/api/v1/articles?clickedDate=%@&endDateIn=%@&field_1=%@&field_2=%@&fromDate=%@&page=%@&size=%@&security_token=%@&toDate=%@&value_1=%@&value_2=%@&filterby=%@",clickedDate,endDateIn,field_1,field_2,fromDate,pageNo,size,securityToken,toDate,value_1,value_2,filterBy];
        
    } else if(query.length != 0) {
        
        functionName = [NSString stringWithFormat:@"/api/v1/articles?clickedDate=%@&endDateIn=%@&field_1=%@&field_2=%@&fromDate=%@&page=%@&size=%@&security_token=%@&toDate=%@&value_1=%@&value_2=%@&query=%@",clickedDate,endDateIn,field_1,field_2,fromDate,pageNo,size,securityToken,toDate,value_1,value_2,query];
        
    } else {
        functionName = [NSString stringWithFormat:@"/api/v1/articles?clickedDate=%@&endDateIn=%@&field_1=%@&field_2=%@&fromDate=%@&page=%@&size=%@&security_token=%@&toDate=%@&value_1=%@&value_2=%@",clickedDate,endDateIn,field_1,field_2,fromDate,pageNo,size,securityToken,toDate,value_1,value_2];
    }
    
    
    
    [self getQueryResultsForFunctionName:functionName onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

+(void)fetchChangeOverLastQuarterArticleListWithClickedDate:(NSString*)clickedDate EndDateIn:(NSString *)endDateIn field1:(NSString *)field_1 value1:(NSString *)value_1 fromDate:(NSNumber *)fromDate toDate:(NSNumber *)toDate withPageNo:(NSNumber *)pageNo withSize:(NSNumber *)size withFilterBy:(NSString *)filterBy withQuery:(NSString *)query onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
{
    
//    1.4.0/api/v1/articles?clickedDate=1%2F8%2F2015&contentCategoryId=&endDateIn=MONTH&field_1=fields.name&fromDate=1446354000000&page=0&security_token=1c4f4e2586d4a2eaef161b000df2215f76016271&size=10&toDate=1454216400000&value_1=Windowss
    
    NSString *securityToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"]];
    
    NSString *functionName;
    if(filterBy.length != 0 && query.length != 0) {
        
        functionName = [NSString stringWithFormat:@"/api/v1/articles?clickedDate=%@&endDateIn=%@&field_1=%@&fromDate=%@&page=%@&security_token=%@&size=%@&toDate=%@&value_1=%@&filterby=%@&query=%@",clickedDate,endDateIn,field_1,fromDate,pageNo,securityToken,size,toDate,value_1,filterBy,query];

    } else if(filterBy.length != 0) {
        
        functionName = [NSString stringWithFormat:@"/api/v1/articles?clickedDate=%@&endDateIn=%@&field_1=%@&fromDate=%@&page=%@&security_token=%@&size=%@&toDate=%@&value_1=%@&filterby=%@",clickedDate,endDateIn,field_1,fromDate,pageNo,securityToken,size,toDate,value_1,filterBy];
        
    } else if(query.length != 0) {
        
        functionName = [NSString stringWithFormat:@"/api/v1/articles?clickedDate=%@&endDateIn=%@&field_1=%@&fromDate=%@&page=%@&security_token=%@&size=%@&toDate=%@&value_1=%@&query=%@",clickedDate,endDateIn,field_1,fromDate,pageNo,securityToken,size,toDate,value_1,query];
        
    } else {
        functionName = [NSString stringWithFormat:@"/api/v1/articles?clickedDate=%@&endDateIn=%@&field_1=%@&fromDate=%@&page=%@&security_token=%@&size=%@&toDate=%@&value_1=%@",clickedDate,endDateIn,field_1,fromDate,pageNo,securityToken,size,toDate,value_1];
    }
    
    
    
    [self getQueryResultsForFunctionName:functionName onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}

+(void)fetchHorizontalLineBarChartArticleListWithField1:(NSString *)field_1 field2:(NSString *)field_2 value1:(NSString *)value_1 value2:(NSString *)value_2 fromDate:(NSNumber *)fromDate toDate:(NSNumber *)toDate withPageNo:(NSNumber *)pageNo withSize:(NSNumber *)size withFilterBy:(NSString *)filterBy withQuery:(NSString *)query onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    
//    1.4.0/api/v1/articles?contentCategoryId=&field_1=tonality.name&field_2=outlet.name.sort&fromDate=1446354000000&page=0&security_token=1c4f4e2586d4a2eaef161b000df2215f76016271&size=10&toDate=1454302799000&value_1=Positive&value_2=Engadget
    
    NSString *securityToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"]];
    
    NSString *functionName;
    if(filterBy.length != 0 && query.length != 0) {
        
        functionName = [NSString stringWithFormat:@"/api/v1/articles?field_1=%@&field_2=%@&fromDate=%@&page=%@&size=%@&security_token=%@&toDate=%@&value_1=%@&value_2=%@&filterby=%@&query=%@",field_1,field_2,fromDate,pageNo,size,securityToken,toDate,value_1,value_2,filterBy,query];

    } else if(filterBy.length != 0) {
        
        functionName = [NSString stringWithFormat:@"/api/v1/articles?field_1=%@&field_2=%@&fromDate=%@&page=%@&size=%@&security_token=%@&toDate=%@&value_1=%@&value_2=%@&filterby=%@",field_1,field_2,fromDate,pageNo,size,securityToken,toDate,value_1,value_2,filterBy];

    } else if(query.length != 0) {
        
        functionName = [NSString stringWithFormat:@"/api/v1/articles?field_1=%@&field_2=%@&fromDate=%@&page=%@&size=%@&security_token=%@&toDate=%@&value_1=%@&value_2=%@&query=%@",field_1,field_2,fromDate,pageNo,size,securityToken,toDate,value_1,value_2,query];
        
    } else {
        functionName = [NSString stringWithFormat:@"/api/v1/articles?field_1=%@&field_2=%@&fromDate=%@&page=%@&size=%@&security_token=%@&toDate=%@&value_1=%@&value_2=%@",field_1,field_2,fromDate,pageNo,size,securityToken,toDate,value_1,value_2];
    }
    
    
    [self getQueryResultsForFunctionName:functionName onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}


+(void)downloadReportForReportId:(NSNumber*)reportId
                       onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *companyId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"customerId"]];
     NSString *securityToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"]];
   // companies/27/analysis/report/80/export/ppt?security_token=
    NSString *functionName = [NSString stringWithFormat:@"/api/v1/companies/%@/analysis/report/%@/export/ppt?security_token=%@",companyId,reportId,securityToken];
    [self getQueryResultsForFunctionName:functionName onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"curated news response:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

@end
