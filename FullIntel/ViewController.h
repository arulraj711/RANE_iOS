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
#import "Localytics.h"

@interface ViewController : UIViewController<CMPopTipViewDelegate>{
    CGRect oldFrame;
    CGFloat originalOuterViewy;
    int i;
}
@property CGPoint originalCenter;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centreYOuter;
@property (nonatomic,strong)  IBOutlet UIView *outerView;
- (IBAction)signInButtonClicked:(id)sender;
@property BOOL isAnimated;
- (IBAction)forgetPasswordButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *logoIcon;

- (IBAction)infoButtonPressed:(id)sender;

- (IBAction)newUserSignUpButtonPressed:(id)sender;
- (IBAction)privacyPolicyButtonPressed:(id)sender;
@property (nonatomic, strong)	NSDictionary	*contents;

//@property (nonatomic, strong) AMPopTip *popTip;
@property (nonatomic, strong) id currentPopTipViewTarget;


@end

