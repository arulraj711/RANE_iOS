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
NSString *url = @"http://stage.fullintel.com";
#define FUNCTION_URL @"services/mv01/sv00/appuser"
@implementation FIWebService

+(NSString *) getServerURL{
    return url;
}

+(void) setServerURL:(NSString *)urls {
    url = urls;
}

+ (void)getResultsForFunctionName:(NSString *)urlPath withPostDetails:(NSString*)postDetails onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    //NSLog(@"get ress for function ");
    NSLog(@"start  time--->%f",CFAbsoluteTimeGetCurrent());
    NSString *postURL = [NSString stringWithFormat:@"%@/%@/%@/",url,FUNCTION_URL,urlPath];
    NSURL *url = [NSURL URLWithString:postURL];
    NSMutableURLRequest * requestURL = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:10];
    [requestURL setHTTPMethod:@"POST"];
    [requestURL setHTTPBody:[postDetails dataUsingEncoding:NSUTF8StringEncoding]];
    [requestURL setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:requestURL];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"end  time--->%f",CFAbsoluteTimeGetCurrent());
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


+ (void)postQueryResultsForFunctionName:(NSString *)urlPath withPostDetails:(NSString*)postDetails withSecurityToken:(NSString *)securityToken onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    //NSLog(@"get ress for function ");
    
    NSString *postURL = [NSString stringWithFormat:@"%@/%@/%@",url,@"api/v1",urlPath];
    NSURL *url = [NSURL URLWithString:postURL];
    NSMutableURLRequest * requestURL = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:10];
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


+ (void)getQueryResultsForFunctionName:(NSString *)urlPath withSecurityToken:(NSString*)securityToken onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *postURL = [NSString stringWithFormat:@"%@/%@/%@",url,@"api/v1",urlPath];
    NSURL *url = [NSURL URLWithString:postURL];
    NSMutableURLRequest * requestURL = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:10];
    [requestURL setHTTPMethod:@"GET"];
   // [requestURL setHTTPBody:[postDetails dataUsingEncoding:NSUTF8StringEncoding]];
   // [requestURL setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:requestURL];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSASCIIStringEncoding];
         NSData *metOfficeData = [str dataUsingEncoding:NSUTF8StringEncoding];
         NSLog(@"\n=========REQUEST=========\n%@\n%@\n===========================",operation.request.URL.absoluteString,securityToken);
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


+ (void)deleteQueryResultsForFunctionName:(NSString *)urlPath withSecurityToken:(NSString*)securityToken onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *postURL = [NSString stringWithFormat:@"%@/%@/%@",url,@"api/v1",urlPath];
    NSURL *url = [NSURL URLWithString:postURL];
    NSMutableURLRequest * requestURL = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:10];
    [requestURL setHTTPMethod:@"DELETE"];
    // [requestURL setHTTPBody:[postDetails dataUsingEncoding:NSUTF8StringEncoding]];
    // [requestURL setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:requestURL];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSASCIIStringEncoding];
         NSData *metOfficeData = [str dataUsingEncoding:NSUTF8StringEncoding];
         NSLog(@"\n=========REQUEST=========\n%@\n%@\n===========================",operation.request.URL.absoluteString,securityToken);
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
    
    [self getResultsForFunctionName:@"usermainmenu" withPostDetails:accessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"curated news response:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        
    }];
}


+(void)fetchFolderListWithAccessToken:(NSString*)accessToken
                          onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *functionName = [NSString stringWithFormat:@"folders?security_token=%@",accessToken];
    [self getQueryResultsForFunctionName:functionName withSecurityToken:accessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"curated news response:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        
    }];
}

+(void)createFolderWithDetails:(NSString*)details withSecurityToken:(NSString *)securityToken
                    onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *functionName = [NSString stringWithFormat:@"folder?security_token=%@",securityToken];
    [self postQueryResultsForFunctionName:functionName withPostDetails:details withSecurityToken:securityToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"curated news response:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        
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


+(void)fetchArticlesFromFolderWithSecurityToken:(NSString *)securityToken withFolderId:(NSString *)folderId
                             onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *functionName = [NSString stringWithFormat:@"folder/%@/articles?security_token=%@",folderId,securityToken];
    [self getQueryResultsForFunctionName:functionName withSecurityToken:securityToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"curated news response:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        
    }];
}



+(void)saveArticlesToFolderWithDetails:(NSString*)details withSecurityToken:(NSString *)    securityToken withFolderId:(NSString *)folderId
                     onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *functionName = [NSString stringWithFormat:@"folder/%@/article?security_token=%@",folderId,securityToken];
    [self postQueryResultsForFunctionName:functionName withPostDetails:details withSecurityToken:securityToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"curated news response:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        
    }];
}

+(void)removeArticlesFromFolderWithDetails:(NSString*)details withSecurityToken:(NSString *)    securityToken withFolderId:(NSString *)folderId
                             onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *functionName = [NSString stringWithFormat:@"folder/%@/article/%@?security_token=%@",folderId,details,securityToken];
    
    [self deleteQueryResultsForFunctionName:functionName withSecurityToken:securityToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    [self getResultsForFunctionName:@"validatecredentials" withPostDetails:details onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
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



@end
