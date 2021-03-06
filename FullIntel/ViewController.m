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
//#import "WToast.h"
//#import "UIImageView+AnimationImages.h"
#define UIColorFromRGB(rgbValue)[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    self.isAnimated = YES;
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(afterLogin:) name:@"Login" object:nil];
    
    
    self.usernameTextField.layer.borderWidth = 1.0f;
    self.usernameTextField.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
    self.passwordTextField.layer.borderWidth = 1.0f;
    self.passwordTextField.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];;
    self.outerView.layer.masksToBounds = YES;
    self.outerView.layer.cornerRadius = 5.0f;
}

-(void)viewDidAppear:(BOOL)animated {
    self.isAnimated = YES;
    [self animateImages];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
    self.usernameTextField.leftView = paddingView;
    self.usernameTextField.leftViewMode = UITextFieldViewModeAlways;
    UIView *rPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
    self.passwordTextField.leftView = rPaddingView;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.usernameTextField.text = @"bens@mobi.com";
    self.passwordTextField.text = @"start";
}
- (void)animateImages
{
    if(self.isAnimated) {
        NSLog(@"animated images");
    static int count = 0;
    NSArray *animationImages = @[[UIImage imageNamed:@"NYSE.jpg"],[UIImage imageNamed:@"ebola_new.jpeg"],[UIImage imageNamed:@"new-york-city-wallpaper.jpg"],[UIImage imageNamed:@"o-NEW-YORK-facebook.jpg"]];
    UIImage *image = [animationImages objectAtIndex:(count % [animationImages count])];
   // CGRect oldFrame = self.backgroundImageView.frame;
    CGRect newframe = CGRectMake(self.backgroundImageView.frame.origin.x, self.backgroundImageView.frame.origin.y, self.backgroundImageView.frame.size.width-100, self.backgroundImageView.frame.size.height-100);
    [UIView transitionWithView:self.backgroundImageView
                      duration:2.5f // animation duration
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.backgroundImageView.frame = newframe;
                        self.backgroundImageView.image = image; // change to other image
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

- (void)crossfade {
    [UIView animateWithDuration:3.0
                          delay:0.0
                        options:UIViewAnimationOptionTransitionCurlUp
                     animations:^{ self.backgroundImageView.alpha = 1; }
                     completion:^(BOOL finished){
                     
                         [UIView animateWithDuration:3.0
                                               delay:0.0
                                             options:UIViewAnimationOptionTransitionCurlUp
                                          animations:^{ self.backgroundImageView.alpha = 0.3; }
                                          completion:^(BOOL finished){}
                          ];
                     }
     ];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == _usernameTextField) {
        [_passwordTextField becomeFirstResponder];
    }else {
        [textField resignFirstResponder];
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
    if([_usernameTextField.text length] == 0) {
        [self.view makeToast:@"Please check your login info and try again." duration:2 position:CSToastPositionCenter];
    } else if(![self NSStringIsValidEmail:_usernameTextField.text]) {
        [self.view makeToast:@"Please check your login info and try again." duration:2 position:CSToastPositionCenter];
    }else if([_passwordTextField.text length] == 0) {
        [self.view makeToast:@"Please check your login info and try again." duration:2 position:CSToastPositionCenter];
    }else {
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
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        [self.view makeToast:[notification.object objectForKey:@"message"] duration:2 position:CSToastPositionCenter];
//        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"FullIntel" message:[notification.object objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
    }
   
}

@end
