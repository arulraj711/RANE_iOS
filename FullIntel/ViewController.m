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
//#import "WToast.h"
//#import "UIImageView+AnimationImages.h"
#define UIColorFromRGB(rgbValue)[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface ViewController ()<UIAlertViewDelegate,UITextFieldDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    self.isAnimated = YES;
    [super viewDidLoad];
    [self animateImages];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(afterLogin:) name:@"Login" object:nil];
    oldFrame = self.backgroundImageView.frame;
    
    self.usernameTextField.layer.borderWidth = 1.0f;
    self.usernameTextField.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
    self.passwordTextField.layer.borderWidth = 1.0f;
    self.passwordTextField.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];;
    self.outerView.layer.masksToBounds = YES;
    self.outerView.layer.cornerRadius = 5.0f;
}

-(void)viewDidAppear:(BOOL)animated {
    self.isAnimated = YES;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
    self.usernameTextField.leftView = paddingView;
    self.usernameTextField.leftViewMode = UITextFieldViewModeAlways;
    UIView *rPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
    self.passwordTextField.leftView = rPaddingView;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    


    self.usernameTextField.text = @"prabhujef@gmail.com";
    self.passwordTextField.text = @"start";



}
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

//- (void)crossfade {
//    [UIView animateWithDuration:3.0
//                          delay:0.0
//                        options:UIViewAnimationOptionTransitionCurlUp
//                     animations:^{ self.backgroundImageView.alpha = 1; }
//                     completion:^(BOOL finished){
//                     
//                         [UIView animateWithDuration:3.0
//                                               delay:0.0
//                                             options:UIViewAnimationOptionTransitionCurlUp
//                                          animations:^{ self.backgroundImageView.alpha = 0.3; }
//                                          completion:^(BOOL finished){}
//                          ];
//                     }
//     ];
//}


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

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (IBAction)signInButtonClicked:(id)sender {
    [_usernameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [self callSignInFunction];
}

-(void)callSignInFunction {
    if([_usernameTextField.text length] == 0) {
        [self.view makeToast:@"Please check your login info and try again." duration:2 position:CSToastPositionCenter];
    } else if(![self NSStringIsValidEmail:_usernameTextField.text]) {
        [self.view makeToast:@"Please check your login info and try again." duration:2 position:CSToastPositionCenter];
    }else if([_passwordTextField.text length] == 0) {
        [self.view makeToast:@"Please check your login info and try again." duration:2 position:CSToastPositionCenter];
    }else {
        
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
    NSLog(@"notification object:%@",notification.object);
    
    if([[notification.object objectForKey:@"statusCode"] intValue]==200 && [[notification.object objectForKey:@"logicStatusCode"]intValue] == 1) {
       
       [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:-1] forKey:@"categoryId"];
       // NSString *inputJson = [FIUtils createInputJsonForContentWithToekn:[notification.object objectForKey:@"securityToken"] lastArticleId:@"" contentTypeId:@"1" listSize:10 activityTypeId:@"" categoryId:[NSNumber numberWithInteger:-1]];
        NSString *menuBackgroundColor = [[NSUserDefaults standardUserDefaults]objectForKey:@"headerColor"];
        NSString *stringWithoutSpaces = [menuBackgroundColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
        [[UINavigationBar appearance] setBarTintColor:[FIUtils colorWithHexString:stringWithoutSpaces]];
        NSMutableDictionary *menuDic = [[NSMutableDictionary alloc] init];
        [menuDic setObject:[notification.object objectForKey:@"securityToken"] forKey:@"securityToken"];
        NSData *menuJsondata = [NSJSONSerialization dataWithJSONObject:menuDic options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *resultJson = [[NSString alloc]initWithData:menuJsondata encoding:NSUTF8StringEncoding];
        [[FISharedResources sharedResourceManager]getMenuListWithAccessToken:resultJson];
         //[[FISharedResources sharedResourceManager]getCuratedNewsListWithAccessToken:inputJson withCategoryId:-1 withFlag:@""];
      //  [self dismissViewControllerAnimated:YES completion:nil];
        [self.view removeFromSuperview];
    } else {
        [self.view makeToast:[notification.object objectForKey:@"message"] duration:2 position:CSToastPositionCenter];
//        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"FullIntel" message:[notification.object objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
    }
   
}

- (IBAction)forgetPasswordButtonPressed:(id)sender {
    
    [self showForgetAlert:_usernameTextField.text];

}

- (IBAction)infoButtonPressed:(id)sender {
    
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
        contentMessage = @"FullIntel is a more en productive way to get business intelligence. Our analysts handpic relevant news, compe influencer comments, business information to your company. All mobile enterprise app single place to keep you informed and ready \n\n\n\n www.fullintel.com";
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
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];
    UINavigationController *modalController = [storyBoard instantiateViewControllerWithIdentifier:@"SocialWebView"];
    SocialWebView *SocialWebViewObj=(SocialWebView *)[[modalController viewControllers]objectAtIndex:0];
    SocialWebViewObj.titleStr=@"Sign Up";
    SocialWebViewObj.urlString=@"http://fullintel.com/newusersignup.html";
    modalController.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:modalController animated:NO completion:nil];
}


-(void)showForgetAlert:(NSString *)textString{

    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Forgot Password" message:@"Please enter the email address associated with your account." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", nil];
    
    alertView.alertViewStyle=UIAlertViewStylePlainTextInput;
    
    UITextField *textField=[alertView textFieldAtIndex:0];
    textField.keyboardType=UIKeyboardTypeEmailAddress;
    textField.returnKeyType=UIReturnKeySend;
    textField.delegate=self;
    
   // textField.text=textString;
    
    [alertView show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *emailTextField = [alertView textFieldAtIndex:0];
    NSLog(@"%@",emailTextField.text);
    
    NSLog(@"Button Index:%ld",(long)buttonIndex);

    
    
    
    
    
    
    if(buttonIndex==1){
        
        if([emailTextField.text length] == 0) {
            [self.view makeToast:@"Please enter the email address associated with your account." duration:2 position:CSToastPositionCenter];
            
            [self showForgetAlert:emailTextField.text];
        } else if(![self NSStringIsValidEmail:emailTextField.text]) {
            [self.view makeToast:@"Please enter the email address associated with your account." duration:2 position:CSToastPositionCenter];
            
            [self showForgetAlert:emailTextField.text];
        }else{
        
       
            [self callForgotPasswordWithEmail:emailTextField.text];
       }
    }
}


-(void)callForgotPasswordWithEmail:(NSString *)email{
    
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
