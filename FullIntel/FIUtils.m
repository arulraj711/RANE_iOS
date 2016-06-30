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
#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

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
+(NSString*)getDateFromTimeStampTwo:(double)timeStamp {
    double unixTimeStamp = timeStamp;
    NSTimeInterval _interval=unixTimeStamp/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *frmaer=[[NSDateFormatter alloc]init];
    [frmaer setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [frmaer setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSString *dateStsr=[frmaer stringFromDate:date];
    return dateStsr;
}
+(NSString *)relativeDateStringForDate:(NSDate *)date
{
    NSLog(@"%@",date);
    NSCalendarUnit units = NSCalendarUnitDay | NSCalendarUnitWeekOfYear |
    NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    // if `date` is before "now" (i.e. in the past) then the components will be positive
    NSDateComponents *components = [[NSCalendar currentCalendar] components:units
                                                                   fromDate:date
                                                                     toDate:[NSDate date]
                                                                    options:0];
    NSLog(@"%@",date);
    NSLog(@"%@",[NSDate date]);
    NSLog(@"%ld",(long)components.minute);
    NSLog(@"%ld",(long)components.year);
    NSLog(@"%ld",(long)components.month);
    NSLog(@"%ld",(long)components.second);
    NSLog(@"%ld",(long)components.day);

    if (components.year > 0) {
        NSDateFormatter *frmaers=[[NSDateFormatter alloc]init];
        [frmaers setDateFormat:@"MM/dd/yy"];
        [frmaers setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        NSString *dateStsr=[frmaers stringFromDate:date];
        return dateStsr;
    }
    else if (components.month > 0) {
            
            NSDateFormatter *frmaers=[[NSDateFormatter alloc]init];
            [frmaers setDateFormat:@"MM/dd/yy"];
            [frmaers setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
            NSString *dateStsr=[frmaers stringFromDate:date];
            return dateStsr;
        }
    else if (components.weekOfYear > 0) {
        
        return [NSString stringWithFormat:@"%ldw ago", (long)components.weekOfYear];
    }
    else if (components.day > 0) {
        
        if (components.day > 1) {
            return [NSString stringWithFormat:@"%ldd ago", (long)components.day];
        } else {
            return @"1d ago";
        }
    }
    else if (components.hour > 0) {
        
        return [NSString stringWithFormat:@"%ldh ago", (long)components.hour];
    }
    else if (components.minute > 0) {
        
        return [NSString stringWithFormat:@"%ldm ago", (long)components.minute];
    }
    else if (components.second > 0) {
        
        return [NSString stringWithFormat:@"%lds ago", (long)components.second];
    }
    else {
        
        return @"Today";
    }
}

+(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
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
+(NSString*)createInputJsonForContentWithToekn:(NSString *)securityToken lastArticleId:(NSString *)articleId contentTypeId:(NSNumber *)contentTypeId listSize:(NSInteger)listSize activityTypeId:(NSString*)activityTypeId categoryId:(NSNumber *)categoryId {
    NSMutableDictionary *gradedetails = [[NSMutableDictionary alloc] init];
    [gradedetails setObject:securityToken forKey:@"securityToken"];

 
    
    if(articleId != nil) {
        [gradedetails setObject:articleId forKey:@"lastArticleId"];
    }
    
    [gradedetails setObject:[NSNumber numberWithInteger:listSize] forKey:@"listSize"];
    [gradedetails setObject:activityTypeId forKey:@"activityTypeIds"];
    if(categoryId == nil) {
        [gradedetails setObject:@"-1" forKey:@"categoryId"];
        [gradedetails setObject:@"-1" forKey:@"contentTypeId"];
    } else {
        [gradedetails setObject:categoryId forKey:@"categoryId"];
        [gradedetails setObject:contentTypeId forKey:@"contentTypeId"];
    }
    
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:gradedetails options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
    NSLog(@"after result:%@",resultStr);
    return resultStr;
}


+(NSString *)formArticleListInuptFromSecurityToken:(NSString *)securitytoken withContentTypeId:(NSNumber *)contentTypeId withPageNumber:(NSNumber *)page withSize:(NSNumber *)size withQuery:(NSString *)query withContentCategoryId:(NSNumber *)contentCategoryId withOrderBy:(NSString *)orderBy withFilterBy:(NSString *)filterBy withActivityTypeID:(NSNumber *)activityTypId withCompanyId:(NSNumber *)companyId {
    NSString *queryString;
    NSLog(@"%@, %@",query,filterBy);
   
    if([companyId isEqualToNumber:[NSNumber numberWithInt:0]]) {
        companyId = [[NSUserDefaults standardUserDefaults]objectForKey:@"customerId"];
    }
    if([contentCategoryId isEqualToNumber:[NSNumber numberWithInt:-1]]){
        //Main menu-------------------------------------------------

        if(query.length == 0) {
             //search empty-------------------------------------------------
            if (filterBy.length==0) {
                //search empty filter empty
                if([activityTypId intValue]== 2){
                    queryString = [NSString stringWithFormat:@"/api/v1/articles/2?security_token=%@&companyId=%@&contentTypeId=%@&page=%@&size=%@",securitytoken,companyId,contentTypeId,page,size];
                }
                else if ([activityTypId intValue]==3){
                    queryString = [NSString stringWithFormat:@"/api/v1/articles/3?security_token=%@&companyId=%@&contentTypeId=%@&page=%@&size=%@",securitytoken,companyId,contentTypeId,page,size];
                    
                }
                else{
                    queryString = [NSString stringWithFormat:@"/api/v1/articles?security_token=%@&companyId=%@&contentTypeId=%@&page=%@&size=%@",securitytoken,companyId,contentTypeId,page,size];
                }

            } else {
                //search empty filter has value-------------------------------------------------
                if([activityTypId intValue]== 2){
                    queryString = [NSString stringWithFormat:@"/api/v1/articles/2?security_token=%@&companyId=%@&contentTypeId=%@&page=%@&size=%@&filterby=%@",securitytoken,companyId,contentTypeId,page,size,filterBy];
                }
                else if ([activityTypId intValue]==3){
                    queryString = [NSString stringWithFormat:@"/api/v1/articles/3?security_token=%@&companyId=%@&contentTypeId=%@&page=%@&size=%@&filterby=%@",securitytoken,companyId,contentTypeId,page,size,filterBy];
                    
                }
                else{
                    queryString = [NSString stringWithFormat:@"/api/v1/articles?security_token=%@&companyId=%@&contentTypeId=%@&page=%@&size=%@&filterby=%@",securitytoken,companyId,contentTypeId,page,size,filterBy];
                }
            }
            
        } else {
            //search has value-------------------------------------------------

            if (filterBy == 0) {
                //search has value filter empty-------------------------------------------------

                if([activityTypId intValue]== 2){
                    queryString = [NSString stringWithFormat:@"/api/v1/articles/2?security_token=%@&companyId=%@&contentTypeId=%@&page=%@&size=%@&query=%@",securitytoken,companyId,contentTypeId,page,size,query];
                }
                else if ([activityTypId intValue]==3){
                    queryString = [NSString stringWithFormat:@"/api/v1/articles/3?security_token=%@&companyId=%@&contentTypeId=%@&page=%@&size=%@&query=%@",securitytoken,companyId,contentTypeId,page,size,query];
                    
                }
                else{
                    queryString = [NSString stringWithFormat:@"/api/v1/articles?security_token=%@&companyId=%@&contentTypeId=%@&page=%@&size=%@&query=%@",securitytoken,companyId,contentTypeId,page,size,query];
                }


            } else {
                //search has value filter has value-------------------------------------------------

                if([activityTypId intValue]== 2){
                    queryString = [NSString stringWithFormat:@"/api/v1/articles/2?security_token=%@&companyId=%@&contentTypeId=%@&page=%@&size=%@&query=%@&filterby=%@",securitytoken,companyId,contentTypeId,page,size,query,filterBy];
                }
                else if ([activityTypId intValue]==3){
                    queryString = [NSString stringWithFormat:@"/api/v1/articles/3?security_token=%@&companyId=%@&contentTypeId=%@&page=%@&size=%@&query=%@&filterby=%@",securitytoken,companyId,contentTypeId,page,size,query,filterBy];
                    
                }
                else{
                    queryString = [NSString stringWithFormat:@"/api/v1/articles?security_token=%@&companyId=%@&contentTypeId=%@&page=%@&size=%@&query=%@&filterby=%@",securitytoken,companyId,contentTypeId,page,size,query,filterBy];
                }
            }
        }
        
    } else {
        //sub other than main menu-------------------------------------------------

        if(query.length == 0) {
            if (filterBy.length==0) {
                queryString = [NSString stringWithFormat:@"/api/v1/articles?security_token=%@&companyId=%@&contentTypeId=%@&page=%@&size=%@&contentCategoryId=%@",securitytoken,companyId,contentTypeId,page,size,contentCategoryId];
            }
            else{
                //filterby true
                queryString = [NSString stringWithFormat:@"/api/v1/articles?security_token=%@&companyId=%@&contentTypeId=%@&page=%@&size=%@&contentCategoryId=%@&filterby=%@",securitytoken,companyId,contentTypeId,page,size,contentCategoryId,filterBy];
            }
        } else {
            
            if (filterBy.length==0) {
                queryString = [NSString stringWithFormat:@"/api/v1/articles?security_token=%@&companyId=%@&contentTypeId=%@&page=%@&size=%@&query=%@&contentCategoryId=%@",securitytoken,companyId,contentTypeId,page,size,query,contentCategoryId];
            }
            else{
                //ssearch and filter on-------------------------------------------------

                queryString = [NSString stringWithFormat:@"/api/v1/articles?security_token=%@&companyId=%@&contentTypeId=%@&page=%@&size=%@&query=%@&contentCategoryId=%@&filterby=%@",securitytoken,companyId,contentTypeId,page,size,query,contentCategoryId,filterBy];

            }
    
        }
        
    }
    
    
    
    return queryString;
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

+(void)showErrorWithMessage:(NSString *)message {
    UIWindow *window = [[UIApplication sharedApplication]windows][0];
    [window makeToast:message duration:1.5 position:CSToastPositionCenter];
}

+(void)showNoNetworkToast {
    UIWindow *window = [[UIApplication sharedApplication]windows][0];
    [window makeToast:@"￼Oops..! Please check your internet connection." duration:1 position:CSToastPositionCenter];
}

+(void)showRequestTimeOutError {
    UIWindow *window = [[UIApplication sharedApplication]windows][0];
    [window makeToast:@"This seems to take longer than expected...Please wait..." duration:1 position:CSToastPositionCenter];
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




+(NSManagedObject *)getBrandFromBrandingIdentityForId:(NSNumber *)defaultLabelId {
    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"BrandingIdentity"];
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"defaultLabelId == %@",defaultLabelId];
    [fetchRequest setPredicate:predicate];
    NSArray *result =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSManagedObject *brandingIdentity;
    if(result.count != 0) {
        brandingIdentity = [result objectAtIndex:0];
    }
    return brandingIdentity;
}

-(void)storeColorThemesFromBrandingDictionary:(NSDictionary *)dic {
    [[NSUserDefaults standardUserDefaults]setObject:NULL_TO_NIL([dic objectForKey:@"headerBgColor"]) forKey:@"headerBgColor"];
    [[NSUserDefaults standardUserDefaults]setObject:NULL_TO_NIL([dic objectForKey:@"headerFgColor"]) forKey:@"headerFgColor"];
    [[NSUserDefaults standardUserDefaults]setObject:NULL_TO_NIL([dic objectForKey:@"highlightBgColor"]) forKey:@"highlightBgColor"];
    [[NSUserDefaults standardUserDefaults]setObject:NULL_TO_NIL([dic objectForKey:@"highlightFgColor"]) forKey:@"highlightFgColor"];
    [[NSUserDefaults standardUserDefaults]setObject:NULL_TO_NIL([dic objectForKey:@"menuBgColor"]) forKey:@"menuBgColor"];
    [[NSUserDefaults standardUserDefaults]setObject:NULL_TO_NIL([dic objectForKey:@"textColor"]) forKey:@"textColor"];
    [[NSUserDefaults standardUserDefaults]setObject:NULL_TO_NIL([dic objectForKey:@"notificationBgColor"]) forKey:@"notificationBgColor"];
    [[NSUserDefaults standardUserDefaults]setObject:NULL_TO_NIL([dic objectForKey:@"notificationFgColor"]) forKey:@"notificationFgColor"];
    [[NSUserDefaults standardUserDefaults]setObject:NULL_TO_NIL([dic objectForKey:@"buttonBgColor"]) forKey:@"buttonBgColor"];
    [[NSUserDefaults standardUserDefaults]setObject:NULL_TO_NIL([dic objectForKey:@"buttonFgColor"]) forKey:@"buttonFgColor"];
}


//+(void)showNoNetworkBanner {
//    UIWindow *window = [[UIApplication sharedApplication]windows][0];
//    NSLog(@"Unreachable width:%f and resize:%f and another:%f",window.frame.size.width,window.frame.size.width/2,(window.frame.size.width/2)-(200/2));
//    UIView *backgrView = [[UIView alloc] initWithFrame:CGRectMake((window.frame.size.width/2)-(300/2), 0, 300, 64)];
//    backgrView.backgroundColor = [FIUtils colorWithHexString:@"AA0000"];
//    
//    UILabel *errorLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 200, 64)];
//    errorLabel.text = @"No Network Connection";
//    errorLabel.textColor = [UIColor whiteColor];
//    errorLabel.textAlignment = NSTextAlignmentCenter;
//    [backgrView addSubview:errorLabel];
//    backgrView.layer.cornerRadius = 25.0f;
//    backgrView.layer.masksToBounds = YES;
//    
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button addTarget:self
//               action:@selector(closeBannerView)
//     forControlEvents:UIControlEventTouchUpInside];
//    [button setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
//    //[button setTitle:@"Show View" forState:UIControlStateNormal];
//    button.frame = CGRectMake(300-50, 0, 40, 40);
//    [backgrView addSubview:button];
//    
//    // backgrView.alpha = 0.6;
//    [window addSubview:backgrView];
//}
//
//+(void)hideNoNetworkBanner {
//    UIWindow *window = [[UIApplication sharedApplication]windows][0];
//    
//    NSArray *subViewArray = [window subviews];
//    //NSLog(@"window array count:%d",subViewArray.count);
//    if(subViewArray.count > 1) {
//        id obj = [subViewArray lastObject];
//        [obj removeFromSuperview];
//    }
//}

//-(void)closeBannerView {
//    //[FIUtils hideNoNetworkBanner];
//    UIWindow *window = [[UIApplication sharedApplication]windows][0];
//    
//    NSArray *subViewArray = [window subviews];
//    //NSLog(@"window array count:%d",subViewArray.count);
//    if(subViewArray.count > 1) {
//        id obj = [subViewArray lastObject];
//        [obj removeFromSuperview];
//    }
//}

@end
