//
//  MainListTutorialViewController.h
//  FullIntel
//
//  Created by cape start on 12/08/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainListTutorialViewController : UIViewController{
    
   NSTimer *popAnimationTimer,*popAnimationTimerTwo;
}
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIView *textBoxView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *downImageView;

@property (weak, nonatomic) IBOutlet UIImageView *upImageView;
@end
