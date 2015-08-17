//
//  AppDelegate.m
//  FullIntel
//
//  Created by CapeStart on 2/15/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "AppDelegate.h"
#import "CorporateNewsListView.h"
#import "LeftViewController.h"
#import "FISharedResources.h"
#import <Fabric/Fabric.h>
#import <DigitsKit/DigitsKit.h>
#import <Crashlytics/Crashlytics.h>
#import <TwitterKit/TwitterKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "FIUtils.h"
#import "Reachability.h"
#import "Localytics.h"
#import "NSString+URLDecoding.h"
@interface AppDelegate ()<PKRevealing>
#pragma mark - Properties
@property (nonatomic, strong, readwrite) PKRevealController *revealController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   // [[Twitter sharedInstance] startWithConsumerKey:@"lEJQRlkFDatgQmZrU24r3gVIM" consumerSecret:@"P401aFimzxdfFRFmKHTSw97vUENnB1pAQBJo8moGEoajMqNOIl"];
//    [Fabric with:@[[Twitter sharedInstance]]];
//    [Fabric with:@[CrashlyticsKit]];
    
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fullintel://"]];
    
    [Localytics autoIntegrate:@"438bf8ffebdfbbaa1d8fedb-5e0569d4-3c14-11e5-65d1-00736b041834" launchOptions:launchOptions];
    
    [Fabric with:@[TwitterKit, CrashlyticsKit, DigitsKit]];

    
    
    // Initialize Reachability
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
    
//    reachability.reachableBlock = ^(Reachability *reachability) {
//        NSLog(@"Network is reachable.");
//    };
//    
//    reachability.unreachableBlock = ^(Reachability *reachability) {
//        NSLog(@"Network is unreachable.");
//    };
    
    // Start Monitoring
    [reachability startNotifier];
    

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
   
    
    UIStoryboard *centerStoryBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];
    UIViewController *viewCtlr = [centerStoryBoard instantiateViewControllerWithIdentifier:@"CorporateView"];
    
    UINavigationController *navCtlr = [[UINavigationController alloc]initWithRootViewController:viewCtlr];
    
    NSString *headerColor = [[NSUserDefaults standardUserDefaults]objectForKey:@"headerColor"];
    NSString *stringWithoutSpaces = [headerColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
    [[UINavigationBar appearance] setBarTintColor:[FIUtils colorWithHexString:stringWithoutSpaces]];
    //[[UINavigationBar appearance] setBarTintColor: [UIColor colorWithRed:97/255.0 green:98/255.0 blue:100/255.0 alpha:1.0]];
    navCtlr.navigationBar.tintColor = [UIColor whiteColor];
    navCtlr.navigationBar.barStyle = UIBarStyleBlack;
    UIStoryboard *leftStoryBoard = [UIStoryboard storyboardWithName:@"LeftView" bundle:nil];
    LeftViewController *leftViewController = [leftStoryBoard instantiateViewControllerWithIdentifier:@"LeftView"];
    self.revealController = [PKRevealController revealControllerWithFrontViewController:navCtlr
                                                                     leftViewController:leftViewController
                                                                    rightViewController:nil];
    // Step 3: Configure.
    self.revealController.delegate = self;
    self.revealController.animationDuration = 0.25;
    
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        NSLog(@"one");
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        NSLog(@"two");
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
   // [self.revealController showViewController:self.revealController.leftViewController];
    
    // Step 4: Apply.
    self.window.rootViewController = self.revealController;
    
    [self.window makeKeyAndVisible];
    
    
    [FISharedResources sharedResourceManager];
    
    
    return YES;
}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    NSDate *fetchStart = [NSDate date];
    
    UINavigationController *navCtlr = (UINavigationController *)self.revealController.frontViewController;
    
    CorporateNewsListView *viewController = [[navCtlr viewControllers] objectAtIndex:0];
    
    [viewController fetchNewDataWithCompletionHandler:^(UIBackgroundFetchResult result) {
        completionHandler(result);
        [self syncCuratedNewsList];
        NSDate *fetchEnd = [NSDate date];
        NSTimeInterval timeElapsed = [fetchEnd timeIntervalSinceDate:fetchStart];
        NSLog(@"Background Fetch Duration: %f seconds", timeElapsed);
        
    }];
}





- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"Calling Application Bundle ID: %@", sourceApplication);
    NSLog(@"URL scheme:%@ and url:%@", [url scheme],url);
    NSLog(@"URL query: %@", [url query]);
    
    if([url query].length != 0) {
        
        NSArray *subStrings = [[url query] componentsSeparatedByString:@"&"]; //or rather @" - "
        
        NSString *objectIdString = [subStrings objectAtIndex:0];
        NSArray *objectIdArray = [objectIdString componentsSeparatedByString:@"="];
        NSString *encodedObjectId = [objectIdArray objectAtIndex:1];
        NSLog(@"before:%@",encodedObjectId);
        NSString *decodedObjectText = [encodedObjectId stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"test value:%@",decodedObjectText);
        // NSData from the Base64 encoded str
        NSData *firstDecodedObjectData = [[NSData alloc]initWithBase64EncodedString:decodedObjectText options:0];
        // Decoded NSString from the NSData
        NSString *decodedObjectId = [[NSString alloc]
                                   initWithData:firstDecodedObjectData encoding:NSUTF8StringEncoding];
        NSLog(@"Decoded: %@", decodedObjectId);
        // NSData from the Base64 encoded str
        NSData *secondDecodedObjectData = [[NSData alloc]
                                           initWithBase64EncodedString:decodedObjectId
                                           options:0];
        // Decoded NSString from the NSData
        NSString *objectId = [[NSString alloc]
                                    initWithData:secondDecodedObjectData encoding:NSUTF8StringEncoding];
        
        NSLog(@"email:%@",objectId);
        
        
        
        NSString *itemIdString = [subStrings objectAtIndex:1];
        NSArray *itemIdArray = [itemIdString componentsSeparatedByString:@"="];
        NSString *encodedItemId = [itemIdArray objectAtIndex:1];
        NSString *decodedItemText = [encodedItemId stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"test value:%@",decodedItemText);
        // NSData from the Base64 encoded str
        NSData *firstDecodedItemData = [[NSData alloc]initWithBase64EncodedString:decodedItemText options:0];
        
        // Decoded NSString from the NSData
        NSString *decodedItemId = [[NSString alloc]
                                     initWithData:firstDecodedItemData encoding:NSUTF8StringEncoding];
        
        
        
        
        NSLog(@"Decoded: %@", decodedItemId);
        // NSData from the Base64 encoded str
        NSData *secondDecodedItemData = [[NSData alloc]
                                           initWithBase64EncodedString:decodedItemId
                                           options:0];
        
        // Decoded NSString from the NSData
        NSString *itemId = [[NSString alloc]
                              initWithData:secondDecodedItemData encoding:NSUTF8StringEncoding];
    
        
        
        NSManagedObjectContext *context = [self managedObjectContext];
        
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@ AND categoryId == %@",itemId,[NSNumber numberWithInt:-1]];
        [fetchRequest setPredicate:predicate];
        NSArray *existingArray = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
        
        NSLog(@"article id:%@ and existing array:%d",itemId,existingArray.count);
        NSString *accessToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"]];
       // NSString *customerEmail = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"customerEmail"]];
        if(accessToken.length != 0) {
            if(existingArray.count != 0) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"NewsLetterNavigation" object:nil userInfo:@{@"articleId":itemId}];
            } else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Article not available to access" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
            }
            
        }
    }
    return YES;
}

- (NSString *) URLEncodedString_ch:(NSString *)strings {
    NSMutableString * output = [NSMutableString string];
    const unsigned char * source = (const unsigned char *)[strings UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken

{
    
    NSLog(@"coming into get device token");
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"token :%@",token);
    
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:token forKey:@"deviceToken"];
    
    // [[SMUSharedResources sharedResourceManager] setRemoteNotificationDeviceToken:token];
    
    
}

-(void)test {
   // NSLog(@"inside test function");
    UINavigationController *navCtlr = (UINavigationController *)self.revealController.frontViewController;
    [navCtlr popViewControllerAnimated:YES];
}

#pragma mark - Helpers

- (UIViewController *)leftViewController
{
    UIViewController *leftViewController = [[UIViewController alloc] init];
    leftViewController.view.backgroundColor = [UIColor yellowColor];
    
    UIButton *presentationModeButton = [[UIButton alloc] initWithFrame:CGRectMake(20.0, 60.0, 180.0, 30.0)];
    [presentationModeButton setTitle:@"Presentation Mode" forState:UIControlStateNormal];
    [presentationModeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [presentationModeButton addTarget:self.revealController
                               action:@selector(startPresentationMode)
                     forControlEvents:UIControlEventTouchUpInside];
    
    [leftViewController.view addSubview:presentationModeButton];
    
    return leftViewController;
}

- (UIViewController *)rightViewController
{
    UIViewController *rightViewController = [[UIViewController alloc] init];
    rightViewController.view.backgroundColor = [UIColor redColor];
    
    UIButton *presentationModeButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth([[UIScreen mainScreen] bounds])-200.0, 60.0, 180.0, 30.0)];
    presentationModeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [presentationModeButton setTitle:@"Presentation Mode" forState:UIControlStateNormal];
    [presentationModeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [presentationModeButton addTarget:self.revealController
                               action:@selector(startPresentationMode)
                     forControlEvents:UIControlEventTouchUpInside];
    
    [rightViewController.view addSubview:presentationModeButton];
    
    return rightViewController;
}

- (void)startPresentationMode
{
    if (![self.revealController isPresentationModeActive])
    {
        [self.revealController enterPresentationModeAnimated:YES completion:nil];
    }
    else
    {
        [self.revealController resignPresentationModeEntirely:NO animated:YES completion:nil];
    }
}


-(void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"app enter in backgound");
    NSString *accessToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"]];
    NSLog(@"application enter in background:%@",accessToken);

    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isAppActive"];

    if(accessToken.length > 0) {
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        NSMutableDictionary *pushDic = [[NSMutableDictionary alloc] init];
        
        NSString *deviceTokenStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"];
        if(deviceTokenStr.length != 0) {
            [pushDic setObject:deviceTokenStr forKey:@"deviceToken"];
            [pushDic setObject:timeZone.name forKey:@"locale"];
            [pushDic setObject:timeZone.abbreviation forKey:@"timeZone"];
            [pushDic setObject:[NSNumber numberWithBool:YES] forKey:@"isAllowPushNotification"];
            [pushDic setObject:[NSNumber numberWithInteger:timeZone.secondsFromGMT] forKey:@"offset"];
            NSData *pushJsondata = [NSJSONSerialization dataWithJSONObject:pushDic options:NSJSONWritingPrettyPrinted error:nil];
            
            NSString *pushResultJson = [[NSString alloc]initWithData:pushJsondata encoding:NSUTF8StringEncoding];
            //dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSLog(@"enter back");
            
            [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"Minimize app"];
            
            [[FISharedResources sharedResourceManager]updatePushNotificationWithDetails:pushResultJson withAccessToken:accessToken];
        } else {
            
        }
    }
}


-(void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"app enter foreground");
    //dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [FISharedResources sharedResourceManager];
   // });
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

-(void)applicationDidBecomeActive:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isAppActive"];
    NSString *accessToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"]];
    if(accessToken.length > 0) {
        NSMutableDictionary *logoutDic = [[NSMutableDictionary alloc] init];
        [logoutDic setObject:accessToken forKey:@"securityToken"];
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:logoutDic options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
        [[FISharedResources sharedResourceManager]validateUserOnResumeWithDetails:resultStr];
    }
    [self syncCuratedNewsList];
}


-(void)syncCuratedNewsList {
    NSLog(@"sync method is working");
    NSString *accessToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"]];
    BOOL isAppActive = [[NSUserDefaults standardUserDefaults]boolForKey:@"isAppActive"];
    if(accessToken.length > 0 && isAppActive) {
        dispatch_queue_t queue_a = dispatch_queue_create("test", 0);
        dispatch_async(queue_a, ^(void){
            [self getArticlesIdFromDB];
            NSString *lastArticleId = [self.articleIdArray lastObject];
            NSString *inputJson;
            NSNumber *folderId = [[NSUserDefaults standardUserDefaults]objectForKey:@"folderId"];
            // NSNumber *category = [[NSUserDefaults standardUserDefaults] valueForKey:@"categoryId"];
            // NSInteger category = categoryStr.integerValue;
            if([folderId isEqualToNumber:[NSNumber numberWithInt:0]]) {
                //NSLog(@"curated news:%@",curatedNews);
                inputJson = [FIUtils createInputJsonForContentWithToekn:[[NSUserDefaults standardUserDefaults] valueForKey:@"accesstoken"] lastArticleId:lastArticleId contentTypeId:@"1" listSize:10 activityTypeId:@"" categoryId:[[NSUserDefaults standardUserDefaults] valueForKey:@"categoryId"]];
                
                [[FISharedResources sharedResourceManager]getCuratedNewsListWithAccessToken:inputJson withCategoryId:[[NSUserDefaults standardUserDefaults] valueForKey:@"categoryId"] withFlag:@"" withLastArticleId:lastArticleId];
            }
            
        });
    }
}



-(void)getArticlesIdFromDB {
   // NSNumber *categoryId = [[NSUserDefaults standardUserDefaults]objectForKey:@"categoryId"];
   // NSNumber *folderId = [[NSUserDefaults standardUserDefaults]objectForKey:@"folderId"];
    NSManagedObjectContext *context = [[FISharedResources sharedResourceManager]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CuratedNews" inManagedObjectContext:context];
    NSPredicate *predicate;
//    if([folderId isEqualToNumber:[NSNumber numberWithInt:0]]) {
//        if([categoryId isEqualToNumber:[NSNumber numberWithInt:-3]]) {
//            BOOL savedForLaterIsNew =[[NSUserDefaults standardUserDefaults]boolForKey:@"SavedForLaterIsNew"];
//            if(savedForLaterIsNew){
//                //                NSLog(@"saved for later new");
//                predicate  = [NSPredicate predicateWithFormat:@"saveForLater == %@ AND categoryId == %@",[NSNumber numberWithBool:YES],categoryId];
//            } else {
//                NSLog(@"saved for later old");
//                predicate  = [NSPredicate predicateWithFormat:@"saveForLater == %@",[NSNumber numberWithBool:YES]];
//            }
//        } else {
            predicate  = [NSPredicate predicateWithFormat:@"categoryId == %@",[NSNumber numberWithInt:-1]];
//        }
//    } else {
//        predicate  = [NSPredicate predicateWithFormat:@"isFolder == %@ AND folderId == %@",[NSNumber numberWithBool:YES],folderId];
//    }
    
    
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *date = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:date, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
    
    NSMutableArray *elementsFromColumn = [[NSMutableArray alloc] init];
    for (NSManagedObject *fetchedObject in fetchedObjects) {
        [elementsFromColumn addObject:[fetchedObject valueForKey:@"articleId"]];
    }
    
    //NSLog(@"elementsfrom column:%@",elementsFromColumn);
    self.articleIdArray = [[NSMutableArray alloc]initWithArray:elementsFromColumn];
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.capestart.FullIntel" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FullIntel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationStoresDirectory] URLByAppendingPathComponent:@"FullIntel.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSFileManager *fm = [NSFileManager defaultManager];
        
        // Move Incompatible Store
        if ([fm fileExistsAtPath:[storeURL path]]) {
            NSURL *corruptURL = [[self applicationIncompatibleStoresDirectory] URLByAppendingPathComponent:[self nameForIncompatibleStore]];
            
            // Move Corrupt Store
            NSError *errorMoveStore = nil;
            [fm moveItemAtURL:storeURL toURL:corruptURL error:&errorMoveStore];
            
            if (errorMoveStore) {
                NSLog(@"Unable to move corrupt store.");
            }
        }
    }
    
    
//    NSError *errorAddingStore = nil;
//    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&errorAddingStore]) {
//        NSLog(@"Unable to create persistent store after recovery. %@, %@", errorAddingStore, errorAddingStore.localizedDescription);
//    }
    return _persistentStoreCoordinator;
}


- (NSURL *)applicationStoresDirectory {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *applicationApplicationSupportDirectory = [[fm URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *URL = [applicationApplicationSupportDirectory URLByAppendingPathComponent:@"Stores"];
    
    if (![fm fileExistsAtPath:[URL path]]) {
        NSError *error = nil;
        [fm createDirectoryAtURL:URL withIntermediateDirectories:YES attributes:nil error:&error];
        
        if (error) {
            NSLog(@"Unable to create directory for data stores.");
            
            return nil;
        }
    }
    
    return URL;
}

- (NSURL *)applicationIncompatibleStoresDirectory {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *URL = [[self applicationStoresDirectory] URLByAppendingPathComponent:@"Incompatible"];
    
    if (![fm fileExistsAtPath:[URL path]]) {
        NSError *error = nil;
        [fm createDirectoryAtURL:URL withIntermediateDirectories:YES attributes:nil error:&error];
        
        if (error) {
            NSLog(@"Unable to create directory for corrupt data stores.");
            
            return nil;
        }
    }
    
    return URL;
}


- (NSString *)nameForIncompatibleStore {
    // Initialize Date Formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // Configure Date Formatter
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    
    return [NSString stringWithFormat:@"%@.sqlite", [dateFormatter stringFromDate:[NSDate date]]];
}

/*- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FullIntel.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}*/


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
