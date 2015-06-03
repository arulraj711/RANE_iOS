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




+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
+(NSString*)createInputJsonForContentWithToekn:(NSString *)securityToken lastArticleId:(NSString *)articleId contentTypeId:(NSString *)contentTypeId listSize:(NSInteger)listSize activityTypeId:(NSString*)activityTypeId categoryId:(NSString *)categoryId {
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
    [window makeToast:@"Oops..! Something is wrong. Please try again later." duration:1 position:CSToastPositionCenter];
}

+(void)showNoNetworkToast {
    UIWindow *window = [[UIApplication sharedApplication]windows][0];
    [window makeToast:@"￼Oops..! Please check your internet connection." duration:1 position:CSToastPositionCenter];
}

+(void)showRequestTimeOutError {
    UIWindow *window = [[UIApplication sharedApplication]windows][0];
    [window makeToast:@"Request Time out" duration:1 position:CSToastPositionCenter];
}
+(void)makeRoundedView:(UIView*)view
{
    view.layer.cornerRadius = view.frame.size.width /2;
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = 1.0;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
  
}
+(void)callRequestionUpdateWithModuleId:(NSInteger)moduleId withFeatureId:(NSInteger)featureId{
    
    NSMutableDictionary *gradedetails = [[NSMutableDictionary alloc] init];
    [gradedetails setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
    [gradedetails setObject:[NSNumber numberWithInt:moduleId] forKey:@"moduleId"];
    [gradedetails setObject:[NSNumber numberWithInt:featureId] forKey:@"featureId"];
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:gradedetails options:NSJSONWritingPrettyPrinted error:nil];
    NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
    [[FISharedResources sharedResourceManager]featureAccessRequestWithDetails:resultStr];
    
}
@end
