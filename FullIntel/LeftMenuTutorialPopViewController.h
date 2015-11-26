//
//  LeftMenuTutorialPopViewController.h
//  FullIntel
//
//  Created by cape start on 11/08/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftMenuTutorialPopViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *tutorialContentView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftTextViewHeightConstraint;
@end
