//
//  FIUtils.m
//  FullIntel
//
//  Created by Arul on 3/30/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "FIUtils.h"
#import "FISharedResources.h"
#import "UIView+Toast.h"

@implementation FIUtils
+(NSString*)getDateFromTimeStamp:(double)timeStamp {
    double unixTimeStamp = timeStamp;
    NSTimeInterval _interval=unixTimeStamp/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setLocale:[NSLocale currentLocale]];
    [_formatter setDateFormat:@"MMM dd, yyyy"];
    NSString *dateStr=[_formatter stringFromDate:date];
    return dateStr;
}

+(NSString*)createInputJsonForContentWithToekn:(NSString *)securityToken lastArticleId:(NSString *)articleId contentTypeId:(NSString *)contentTypeId listSize:(NSInteger)listSize activityTypeId:(NSString*)activityTypeId categoryId:(NSNumber *)categoryId {
    NSMutableDictionary *gradedetails = [[NSMutableDictionary alloc] init];
    [gradedetails setObject:securityToken forKey:@"securityToken"];
    [gradedetails setObject:articleId forKey:@"lastArticleId"];
    [gradedetails setObject:contentTypeId forKey:@"contentTypeId"];
    [gradedetails setObject:[NSNumber numberWithInteger:listSize] forKey:@"listSize"];
    [gradedetails setObject:activityTypeId forKey:@"activityTypeIds"];
    [gradedetails setObject:categoryId forKey:@"categoryId"];
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:gradedetails options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
    return resultStr;
}


+(void)deleteExistingData {
    NSError * error;
    // retrieve the store URL
    NSURL * storeURL = [[[[FISharedResources sharedResourceManager] managedObjectContext] persistentStoreCoordinator] URLForPersistentStore:[[[[[FISharedResources sharedResourceManager] managedObjectContext] persistentStoreCoordinator] persistentStores] lastObject]];
    // lock the current context
    [[[FISharedResources sharedResourceManager] managedObjectContext] lock];
    [[[FISharedResources sharedResourceManager] managedObjectContext] reset];//to drop pending changes
    //delete the store from the current managedObjectContext
    if ([[[[FISharedResources sharedResourceManager] managedObjectContext] persistentStoreCoordinator] removePersistentStore:[[[[[FISharedResources sharedResourceManager] managedObjectContext] persistentStoreCoordinator] persistentStores] lastObject] error:&error])
    {
        // remove the file containing the data
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
        //recreate the store like in the  appDelegate method
        [[[[FISharedResources sharedResourceManager] managedObjectContext] persistentStoreCoordinator] addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];//recreates the persistent store
    }
    [[[FISharedResources sharedResourceManager] managedObjectContext] unlock];
    
}

+(void)showErrorToast {
    UIWindow *window = [[UIApplication sharedApplication]windows][0];
    [window makeToast:@"Oops..! Please try again later" duration:2 position:CSToastPositionCenter];
}

+(void)showNoNetworkToast {
    UIWindow *window = [[UIApplication sharedApplication]windows][0];
    [window makeToast:@"Please check your internet connection" duration:2 position:CSToastPositionCenter];
}

@end
