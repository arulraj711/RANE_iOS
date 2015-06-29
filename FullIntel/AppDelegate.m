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
#import <Crashlytics/Crashlytics.h>
#import <TwitterKit/TwitterKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "FIUtils.h"
@interface AppDelegate ()<PKRevealing>
#pragma mark - Properties
@property (nonatomic, strong, readwrite) PKRevealController *revealController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[Twitter sharedInstance] startWithConsumerKey:@"5SFUoRnKqdK579pDWxYKlQZxt" consumerSecret:@"junQ5JKwosra5x31ADHYK9ctrpittnnhUFeP8AHYnxrTnwsO8Y"];
    [Fabric with:@[[Twitter sharedInstance]]];
    [Fabric with:@[CrashlyticsKit]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
   
    
    UIStoryboard *centerStoryBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];
    UINavigationController *navCtlr = [centerStoryBoard instantiateViewControllerWithIdentifier:@"CorporateView"];
    
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
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    
    
   // [self.revealController showViewController:self.revealController.leftViewController];
    
    // Step 4: Apply.
    self.window.rootViewController = self.revealController;
    
    [self.window makeKeyAndVisible];
    return YES;
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


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

-(void)applicationDidBecomeActive:(UIApplication *)application {
    NSString *accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"];
    if(accessToken.length > 0) {
        NSMutableDictionary *logoutDic = [[NSMutableDictionary alloc] init];
        [logoutDic setObject:accessToken forKey:@"securityToken"];
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:logoutDic options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
        [[FISharedResources sharedResourceManager]validateUserOnResumeWithDetails:resultStr];
    }
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
}


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
