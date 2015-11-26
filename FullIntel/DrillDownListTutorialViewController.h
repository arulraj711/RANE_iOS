//
//  DrillDownListTutorialViewController.h
//  FullIntel
//
//  Created by cape start on 17/08/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrillDownListTutorialViewController : UIViewController{
    
    
    NSTimer *popAnimationTimer,*popAnimationTimerTwo,*popAnimationTimerThree;
}
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *swipeDownImageView;
@property (weak, nonatomic) IBOutlet UIView *textViewOutterView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *swipeLeftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *swipeRightImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *drilldownTutHeightConstraint;

@end
