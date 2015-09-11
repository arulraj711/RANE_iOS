//
//  TutorialPopViewController.h
//  FullIntel
//
//  Created by cape start on 29/07/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialPopViewController : UIViewController{
    
    NSTimer *popAnimationTimer;
}
@property (weak, nonatomic) IBOutlet UIView *outerBoxView;

- (IBAction)continueButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *laterButton;
- (IBAction)laterButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@end
