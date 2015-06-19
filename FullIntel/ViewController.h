//
//  ViewController.h
//  FullIntel
//
//  Created by CapeStart on 2/15/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AMPopTip.h"
#import "CMPopTipView.h"

@interface ViewController : UIViewController<CMPopTipViewDelegate>{
    CGRect oldFrame;
}

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (nonatomic,strong)  IBOutlet UIView *outerView;
- (IBAction)signInButtonClicked:(id)sender;
@property BOOL isAnimated;
- (IBAction)forgetPasswordButtonPressed:(id)sender;

- (IBAction)infoButtonPressed:(id)sender;

- (IBAction)newUserSignUpButtonPressed:(id)sender;
- (IBAction)privacyPolicyButtonPressed:(id)sender;
@property (nonatomic, strong)	NSDictionary	*contents;

//@property (nonatomic, strong) AMPopTip *popTip;
@property (nonatomic, strong) id currentPopTipViewTarget;
@end

