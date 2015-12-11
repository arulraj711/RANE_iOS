//
//  ViewController.m
//  FullIntel
//
//  Created by CapeStart on 2/15/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "ViewController.h"
#import "FISharedResources.h"
#import "UIView+Toast.h"
#import "FIUtils.h"
#import "LeftViewController.h"
#import "FIWebService.h"
#import "CMPopTipView.h"
#import "SocialWebView.h"
#import "FIWebService.h"
#import <TwitterKit/TwitterKit.h>
#define kPictureFrameHorizontalOffseta +35
#define kPictureFrameHorizontalOffset +25

//#import "WToast.h"
//#import "UIImageView+AnimationImages.h"
#define UIColorFromRGB(rgbValue)[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface ViewController ()<UIAlertViewDelegate,UITextFieldDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    i = 0;

    self.isAnimated = YES;
    [super viewDidLoad];
    
//    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
//    {
//        _outerView.translatesAutoresizingMaskIntoConstraints = YES;
//        CGFloat overallWidth = self.view.frame.size.width;
//        CGFloat outerViewWidth = _outerView.frame.size.width;
//        CGFloat outerViewHeight = _outerView.frame.size.height;
//        
//        CGFloat newOuterViewWidth = outerViewWidth-128;
//        CGFloat approxPosition = overallWidth - newOuterViewWidth;
//        CGFloat approxStartPosition = approxPosition/2;
//        [_outerView setFrame:CGRectMake(approxStartPosition, 172, newOuterViewWidth, outerViewHeight)];
//        
//        
//        _infoButtonPressed.translatesAutoresizingMaskIntoConstraints = YES;
//        CGFloat logoPosition =_logoIcon.frame.size.width+_logoIcon.frame.origin.x;
//        NSLog(@"%f",logoPosition);
//        NSLog(@"%f",_logoIcon.frame.size.width);
//        NSLog(@"%f",_logoIcon.frame.origin.x);
//        
//        [_infoButtonPressed setFrame:CGRectMake(logoPosition-66, _infoButtonPressed.frame.origin.y, _infoButtonPressed.frame.size.width, _infoButtonPressed.frame.size.height)];
//    }
    originalOuterViewy =_outerView.frame.origin.y;
    [self animateImages];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(afterLogin:) name:@"Login" object:nil];
    oldFrame = self.backgroundImageView.frame;
    self.originalCenter = self.view.center;
    self.usernameTextField.layer.borderWidth = 1.0f;
    self.usernameTextField.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
    self.passwordTextField.layer.borderWidth = 1.0f;
    self.passwordTextField.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];;
    self.outerView.layer.masksToBounds = YES;
    self.outerView.layer.cornerRadius = 5.0f;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressEvent:)];
    self.logoIcon.userInteractionEnabled = YES;
    longPress.minimumPressDuration = 3;
    // longPress.numberOfTouches = 1;
    [self.logoIcon addGestureRecognizer:longPress];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

-(void)viewDidAppear:(BOOL)animated {
    self.isAnimated = YES;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
    self.usernameTextField.leftView = paddingView;
    self.usernameTextField.leftViewMode = UITextFieldViewModeAlways;
    UIView *rPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
    self.passwordTextField.leftView = rPaddingView;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    [[FISharedResources sharedResourceManager]tagScreenInLocalytics:@"Log In View"];
}

- (void)keyboardDidShow: (NSNotification *) notif{
    // Do something here
    //    CGFloat height = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].height;
//    CGFloat height = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
//    self.view.center = CGPointMake(self.originalCenter.x, -height);
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
//to push up only the outerview.
        if (i == 0) {
            NSTimeInterval duration = [notif.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
            UIViewAnimationCurve curve = [notif.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
            [UIView setAnimationCurve:curve];
            [UIView setAnimationDuration:duration];
            // Animation code
            [UIView animateWithDuration:duration
                                  delay:0.0
                                options: (curve<<20)
                             animations:^{
                                 
                                 self.outerView.translatesAutoresizingMaskIntoConstraints = YES;  //This part hung me up
                                 self.outerView.frame = CGRectMake(self.outerView.frame.origin.x, self.outerView.frame.origin.y-kPictureFrameHorizontalOffset,  self.outerView.frame.size.width,self.outerView.frame.size.height);
                                 //self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width,self.view.frame.size.height);
                             }
                             completion:^(BOOL finished){
                             }];
            //        self.view.frame = CGRectMake(self.view.frame.origin.x, -25, self.view.frame.size.width,self.view.frame.size.height);
            i = 1;
        }
        
    }
    else
    {
        if (i == 0) {
            
            NSLog(@"%f",self.centreYOuter.constant);
            
            NSTimeInterval duration = [notif.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
            UIViewAnimationCurve curve = [notif.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
            [UIView setAnimationCurve:curve];
            [UIView setAnimationDuration:duration];
            // Animation code
            
            [UIView animateWithDuration:duration
                                  delay:0.0
                                options: (curve<<20)
                             animations:^{
                                 self.centreYOuter.constant = kPictureFrameHorizontalOffseta;
                                 NSLog(@"%f",self.centreYOuter.constant);
                                 //self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width,self.view.frame.size.height);
                             }
                             completion:^(BOOL finished){
                             }];
            //        self.view.frame = CGRectMake(self.view.frame.origin.x, -25, self.view.frame.size.width,self.view.frame.size.height);
            i = 1;
        }
    }
}

- (void)keyboardDidHide: (NSNotification *) notif{
    // Do something here
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        if (i ==1) {
            NSTimeInterval duration = [notif.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
            UIViewAnimationCurve curve = [notif.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
            [UIView setAnimationCurve:curve];
            [UIView setAnimationDuration:duration];
            // Animation code
            
            //to push up only the outerview.
            
            [UIView animateWithDuration:duration
                                  delay:0.0
                                options: UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 
                                 self.outerView.translatesAutoresizingMaskIntoConstraints = YES;  //This part hung me up
                                 
                                 self.outerView.frame = CGRectMake(self.outerView.frame.origin.x, self.outerView.frame.origin.y+kPictureFrameHorizontalOffset, self.outerView.frame.size.width,self.outerView.frame.size.height);
                                 
                                 //                             self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width,self.view.frame.size.height);
                             }
                             completion:^(BOOL finished){
                             }];
            
            //        [UIView transitionWithView:self.view duration:8.4f options:UIViewAnimationOptionTransitionNone animations:^{
            //            self.view.frame = CGRectMake(self.view.frame.origin.x, -25, self.view.frame.size.width,self.view.frame.size.height);
            //
            //        }completion:^(BOOL finished){
            //
            //        }];
            //        
            
            i= 0 ;
        }
       
    }
    else
    {
        if (i ==1) {
            
            NSLog(@"%f",self.centreYOuter.constant);
            
            NSTimeInterval duration = [notif.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
            UIViewAnimationCurve curve = [notif.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
            [UIView setAnimationCurve:curve];
            [UIView setAnimationDuration:duration];
            // Animation code
            [UIView animateWithDuration:duration
                                  delay:0.0
                                options: (curve<<20)
                             animations:^{
                                 self.centreYOuter.constant = 0;
                                 NSLog(@"%f",self.centreYOuter.constant);
                                 
                                 //self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width,self.view.frame.size.height);
                             }
                             completion:^(BOOL finished){
                             }];
            i=0;
            
        }
    }
    

}
//[self animateViewHeight:self.view withAnimationType:kCATransitionFromTop];

//- (void)animateViewHeight:(UIView*)animateView withAnimationType:(NSString*)animType {
//    CATransition *animation = [CATransition animation];
//    [animation setType:kCATransitionPush];
//    [animation setSubtype:animType];
//    
//    [animation setDuration:0.5];
//    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//    [[animateView layer] addAnimation:animation forKey:kCATransition];
//    animateView.hidden = !animateView.hidden;
//}

- (void)animateImages
{
    if(self.isAnimated) {
        static int count = 0;
        NSArray *animationImages = @[[UIImage imageNamed:@"City-Boston.jpg"],[UIImage imageNamed:@"Eiffel_Tower.jpg"],[UIImage imageNamed:@"new-york-city-wallpaper.jpg"],[UIImage imageNamed:@"o-NEW-YORK-facebook.jpg"],[UIImage imageNamed:@"san_francisco.jpg"]];
        UIImage *image = [animationImages objectAtIndex:(count % [animationImages count])];
        
        CGRect newframe = CGRectMake(self.backgroundImageView.frame.origin.x, self.backgroundImageView.frame.origin.y, self.backgroundImageView.frame.size.width, self.backgroundImageView.frame.size.height);
        [UIView transitionWithView:self.backgroundImageView
                          duration:2.0f // animation duration
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.backgroundImageView.frame = newframe;
                            self.backgroundImageView.image = image; // change to other image
                            [self.backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
                        } completion:^(BOOL finished) {
                            //self.backgroundImageView.frame = oldFrame;
                            [self animateImages]; // once finished, repeat again
                            count++; // this is to keep the reference of which image should be loaded next
                        }];
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    self.isAnimated = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == _usernameTextField) {
        [_passwordTextField becomeFirstResponder];
    }else if(textField==_passwordTextField){
        [textField resignFirstResponder];
        [self callSignInFunction];
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)signInButtonClicked:(id)sender {
    
    [_usernameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [self callSignInFunction];
}

-(void)callSignInFunction {
    if([_usernameTextField.text length] == 0) {
        [self.view makeToast:@"Please check your login info and try again." duration:1 position:CSToastPositionCenter];
    } else if(![FIUtils NSStringIsValidEmail:_usernameTextField.text]) {
        [self.view makeToast:@"Please check your login info and try again." duration:1 position:CSToastPositionCenter];
    }else if([_passwordTextField.text length] == 0) {
        [self.view makeToast:@"Please check your login info and try again." duration:1 position:CSToastPositionCenter];
    }else {
        
        NSDictionary *dictionary = @{@"email":_usernameTextField.text};
        [Localytics tagEvent:@"SignInButtonClicked" attributes:dictionary];
        
        
        
        [[NSUserDefaults standardUserDefaults]setObject:_usernameTextField.text forKey:@"userName"];
        [[NSUserDefaults standardUserDefaults]setObject:_passwordTextField.text forKey:@"passWord"];
        
        NSMutableDictionary *gradedetails = [[NSMutableDictionary alloc] init];
        [gradedetails setObject:_usernameTextField.text forKey:@"email"];
        [gradedetails setObject:_passwordTextField.text forKey:@"password"];
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:gradedetails options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
        
        [[FISharedResources sharedResourceManager] checkLoginUserWithDetails:resultStr];
        
    }
}

-(void)afterLogin:(NSNotification *)notification {
    if([[notification.object objectForKey:@"statusCode"] intValue]==200 && [[notification.object objectForKey:@"logicStatusCode"]intValue] == 1) {
        
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:-1] forKey:@"categoryId"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"parentId"];
        // NSString *inputJson = [FIUtils createInputJsonForContentWithToekn:[notification.object objectForKey:@"securityToken"] lastArticleId:@"" contentTypeId:@"1" listSize:10 activityTypeId:@"" categoryId:[NSNumber numberWithInteger:-1]];
        NSString *menuBackgroundColor = [[NSUserDefaults standardUserDefaults]objectForKey:@"headerColor"];
        NSString *stringWithoutSpaces = [menuBackgroundColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
        [[UINavigationBar appearance] setBarTintColor:[FIUtils colorWithHexString:stringWithoutSpaces]];
        NSMutableDictionary *menuDic = [[NSMutableDictionary alloc] init];
        [menuDic setObject:[notification.object objectForKey:@"securityToken"] forKey:@"securityToken"];
        NSData *menuJsondata = [NSJSONSerialization dataWithJSONObject:menuDic options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *resultJson = [[NSString alloc]initWithData:menuJsondata encoding:NSUTF8StringEncoding];
        
        
        
        NSMutableDictionary *gradedetails = [[NSMutableDictionary alloc] init];
        NSString *accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"];
        [gradedetails setObject:accessToken forKey:@"securityToken"];
        [gradedetails setObject:@"" forKey:@"lastArticleId"];
        [gradedetails setObject:[NSNumber numberWithInt:10] forKey:@"listSize"];
        [gradedetails setObject:@"" forKey:@"activityTypeIds"];
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:gradedetails options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
        //        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //
        //       // BOOL isFirst = [[NSUserDefaults standardUserDefaults]boolForKey:@"firstTimeFlag"];
        //        if(accessToken.length > 0) {
        //            [[FISharedResources sharedResourceManager]getCuratedNewsListWithAccessToken:resultStr withCategoryId:[NSNumber numberWithInt:-1] withFlag:@"" withLastArticleId:@""];
        //        }
        //        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:-1] forKey:@"categoryId"];
        //        });
        
        
        dispatch_queue_t globalConcurrentQueue =
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        
        
        // dispatch_queue_t queue_a = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
        
        dispatch_async(globalConcurrentQueue, ^{
            // NSLog(@"A - 1");
            [[FISharedResources sharedResourceManager]getMenuListWithAccessToken:accessToken];
        });
        
        dispatch_async(globalConcurrentQueue, ^{
            NSLog(@"A - 2");
            if(accessToken.length > 0) {
                [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:-1] forKey:@"categoryId"];
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"parentId"];
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"folderId"];
                
                NSNumber *contentTypeId = [[NSUserDefaults standardUserDefaults]objectForKey:@"parentId"];
                //  [[FISharedResources sharedResourceManager]getCuratedNewsListWithAccessToken:resultStr withCategoryId:[NSNumber numberWithInt:-1] withContentTypeId:contentTypeId withFlag:@"" withLastArticleId:@""];
            }
            
        });
        
        dispatch_queue_t globalBackgroundQueue =
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
        
        dispatch_async(globalBackgroundQueue, ^{
            NSLog(@"calling folder option");
            [[FISharedResources sharedResourceManager] getFolderListWithAccessToken:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] withFlag:NO withCreatedFlag:NO];
        });
        
        
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
            NSLog(@"push notification json:%@",pushResultJson);
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
                
                [[FISharedResources sharedResourceManager]pushNotificationWithDetails:pushResultJson withAccessToken:[notification.object objectForKey:@"securityToken"]];
            });
        } else {
            
        }
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        [self.view makeToast:[notification.object objectForKey:@"message"] duration:1 position:CSToastPositionCenter];
        //        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"FullIntel" message:[notification.object objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //        [alert show];
    }
    
}

- (IBAction)forgetPasswordButtonPressed:(id)sender {
    [Localytics tagEvent:@"ForgotPasswordButtonClick"];
    [self showForgetAlert:_usernameTextField.text withFlag:@""];
    
}



-(void)longPressEvent:(UILongPressGestureRecognizer *)recognizer {
    //NSLog(@"long press event is working");
    if(recognizer.state == UIGestureRecognizerStateBegan) {
        // [self showForgetAlert:_usernameTextField.text withFlag:[FIWebService getServerURL]];
        
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"API Root Domain" message:@"Please click save button to change the server URL." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
        
        alertView.alertViewStyle=UIAlertViewStylePlainTextInput;
        alertView.tag = 101;
        UITextField *textField=[alertView textFieldAtIndex:0];
        textField.keyboardType=UIKeyboardTypeEmailAddress;
        textField.returnKeyType=UIReturnKeySend;
        textField.delegate=self;
        //if(flag.length != 0) {
        textField.text=[FIWebService getServerURL];
        //}
        
        [self.view endEditing:YES];
        
        [alertView show];
        
        
    }
    
}

- (IBAction)infoButtonPressed:(id)sender {
    [Localytics tagEvent:@"InfoButtonClicked"];
    NSString *contentMessage = nil;
    UIView *contentView = nil;
    NSNumber *key = [NSNumber numberWithInteger:[(UIView *)sender tag]];
    id content = [self.contents objectForKey:key];
    if ([content isKindOfClass:[UIView class]]) {
        contentView = content;
    }
    else if ([content isKindOfClass:[NSString class]]) {
        contentMessage = content;
    }
    else {
        contentMessage = @"\tFullIntel is a more engaging and productive way to get caught up on business intelligence.\n\tOur analysts handpick the most relevant news, competitive insights, influencer comments, and other business information that matter most to your company. All delivered to our mobile enterprise app providing a single place to keep your executives informed and ready for business. \n\n\t\t\t\t www.fullintel.com";
    }
    
    NSString *title = nil;
    
    CMPopTipView *popTipView;
    if (contentView) {
        popTipView = [[CMPopTipView alloc] initWithCustomView:contentView];
    }
    else if (title) {
        popTipView = [[CMPopTipView alloc] initWithTitle:title message:contentMessage];
    }
    else {
        popTipView = [[CMPopTipView alloc] initWithMessage:contentMessage];
    }
    popTipView.delegate = self;
    popTipView.textAlignment = NSTextAlignmentLeft;
    popTipView.dismissTapAnywhere = YES;
    [popTipView autoDismissAnimated:YES atTimeInterval:10.0];
    UIButton *button = (UIButton *)sender;
    [popTipView presentPointingAtView:button inView:self.view animated:YES];
    self.currentPopTipViewTarget = sender;
}
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView
{
    //  [self.visiblePopTipViews removeObject:popTipView];
    self.currentPopTipViewTarget = nil;
}
- (IBAction)newUserSignUpButtonPressed:(id)sender {
    [Localytics tagEvent:@"SignupButtonClicked"];
    UIStoryboard *storyBoard;
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        storyBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListViewPhone" bundle:nil];
        UINavigationController *modalController = [storyBoard instantiateViewControllerWithIdentifier:@"SocialWebViewPhone"];
        SocialWebView *SocialWebViewObj=(SocialWebView *)[[modalController viewControllers]objectAtIndex:0];
        SocialWebViewObj.isFlag = YES;
        SocialWebViewObj.titleStr=@"Sign Up";
        NSString *signUpUrlString = [NSString stringWithFormat:@"%@/newusersignup.html",[FIWebService getServerURL]];
        SocialWebViewObj.urlString=signUpUrlString;
        modalController.modalPresentationStyle = UIModalPresentationCustom;
        
        [self presentViewController:modalController animated:NO completion:nil];
    } else {
        storyBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];
        UINavigationController *modalController = [storyBoard instantiateViewControllerWithIdentifier:@"SocialWebView"];
        SocialWebView *SocialWebViewObj=(SocialWebView *)[[modalController viewControllers]objectAtIndex:0];
        SocialWebViewObj.titleStr=@"Sign Up";
        NSString *signUpUrlString = [NSString stringWithFormat:@"%@/newusersignup.html",[FIWebService getServerURL]];
        SocialWebViewObj.urlString=signUpUrlString;
        modalController.modalPresentationStyle = UIModalPresentationCustom;
        
        [self presentViewController:modalController animated:NO completion:nil];
    }
   
}

- (IBAction)privacyPolicyButtonPressed:(id)sender {
    [Localytics tagEvent:@"PrivacyPolicyButtonClicked"];
    UIStoryboard *storyBoard;
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        storyBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListViewPhone" bundle:nil];
        UINavigationController *modalController = [storyBoard instantiateViewControllerWithIdentifier:@"SocialWebViewPhone"];
        SocialWebView *SocialWebViewObj=(SocialWebView *)[[modalController viewControllers]objectAtIndex:0];
        SocialWebViewObj.titleStr=@"Privacy Policy";
        NSString *privacyUrlString = [NSString stringWithFormat:@"%@/common/privacy",[FIWebService getServerURL]];
        SocialWebViewObj.urlString=privacyUrlString;
        modalController.modalPresentationStyle = UIModalPresentationCustom;
        
        [self presentViewController:modalController animated:NO completion:nil];
    } else {
        storyBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];
        UINavigationController *modalController = [storyBoard instantiateViewControllerWithIdentifier:@"SocialWebView"];
        SocialWebView *SocialWebViewObj=(SocialWebView *)[[modalController viewControllers]objectAtIndex:0];
        SocialWebViewObj.titleStr=@"Privacy Policy";
        NSString *privacyUrlString = [NSString stringWithFormat:@"%@/common/privacy",[FIWebService getServerURL]];
        SocialWebViewObj.urlString=privacyUrlString;
        modalController.modalPresentationStyle = UIModalPresentationCustom;
        
        [self presentViewController:modalController animated:NO completion:nil];
    }
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];SocialWebViewPhone
    
}


-(void)showForgetAlert:(NSString *)textString withFlag:(NSString *)flag{
    
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Forgot Password" message:@"Please enter the email address associated with your account." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", nil];
    
    alertView.alertViewStyle=UIAlertViewStylePlainTextInput;
    
    UITextField *textField=[alertView textFieldAtIndex:0];
    textField.keyboardType=UIKeyboardTypeEmailAddress;
    textField.returnKeyType=UIReturnKeySend;
    textField.delegate=self;
    if(flag.length != 0) {
        textField.text=flag;
    }
    
    [self.view endEditing:YES];
    
    [alertView show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *emailTextField = [alertView textFieldAtIndex:0];
    
    if(alertView.tag == 101) {
        if(buttonIndex == 1) {
            [FIWebService setServerURL:emailTextField.text];
        }
        
    }else {
        if(buttonIndex == 0) {
            NSLog(@"forgot cancel");
            [Localytics tagEvent:@"ForgotPasswordCancelButtonClicked"];
        } else if(buttonIndex==1){
            
            if([emailTextField.text length] == 0) {
                [self.view makeToast:@"Please enter the email address associated with your account." duration:1 position:CSToastPositionCenter];
                
                [self showForgetAlert:emailTextField.text withFlag:@""];
            } else if(![FIUtils NSStringIsValidEmail:emailTextField.text]) {
                [self.view makeToast:@"Please enter the email address associated with your account." duration:1 position:CSToastPositionCenter];
                
                [self showForgetAlert:emailTextField.text withFlag:@""];
            }else{
                
                
                [self callForgotPasswordWithEmail:emailTextField.text];
            }
        }
    }
    
}


-(void)callForgotPasswordWithEmail:(NSString *)email{
    NSDictionary *dictionary = @{@"email":email};
    [Localytics tagEvent:@"ForgotPasswordWithEmail" attributes:dictionary];
    
    NSMutableDictionary *gradedetails = [[NSMutableDictionary alloc] init];
    [gradedetails setObject:email forKey:@"email"];
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:gradedetails options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
    
    
    [FIWebService forgotPasswordWithDetails:resultStr onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *message=[responseObject objectForKey:@"message"];
        
        [self.view makeToast:message duration:2 position:CSToastPositionCenter];
        
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

@end
