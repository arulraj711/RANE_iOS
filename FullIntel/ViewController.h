//
//  ViewController.h
//  FullIntel
//
//  Created by CapeStart on 2/15/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (nonatomic,strong)  IBOutlet UIView *outerView;
- (IBAction)signInButtonClicked:(id)sender;

@end

