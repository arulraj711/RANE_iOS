//
//  MainListTutorialViewController.m
//  FullIntel
//
//  Created by cape start on 12/08/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "MainListTutorialViewController.h"
#import "pop.h"

@interface MainListTutorialViewController ()

@end

@implementation MainListTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performSwipeUpAnimation
{
    // First let's remove any existing animations

    [_upImageView.layer removeAllAnimations];
    POPDecayAnimation  *anim = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        
        anim.fromValue = @(320);

    }
    else{
        anim.fromValue = @(400);

    }
    anim.velocity = @(-1000.0);
    anim.deceleration = 0.995;
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        NSLog(@"Animation has completed.");
       // [self resetTutorialStateTimer:0.5];
    };
    [_upImageView.layer pop_addAnimation:anim forKey:@"slideup"];

    
}
- (void)performSwipeDownAnimation
{
    // First let's remove any existing animations
    
    [_downImageView.layer removeAllAnimations];
    
    POPDecayAnimation  *anim = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        
            anim.fromValue = @(250);
        }
    else{
        if(self.view.frame.size.height==768){
            
            anim.fromValue = @(500);
            
        }else{
            anim.fromValue = @(700);
            
        }
    }
    anim.velocity = @(1000.0);
    anim.deceleration = 0.995;
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        NSLog(@"Animation has completed.");
        // [self resetTutorialStateTimer:0.5];
    };
    [_downImageView.layer pop_addAnimation:anim forKey:@"slideup"];
    
    
}


-(void)performSwipeRighAnimation
{
    // First let's remove any existing animations
    
    [_swipeRightImageView.layer removeAllAnimations];
    
    POPDecayAnimation  *anim = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    anim.fromValue = @(self.view.frame.origin.x+self.view.frame.size.width+90);
    anim.velocity = @(-1000.0);
    anim.deceleration = 0.995;
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        NSLog(@"Animation has completed.");
        // [self resetTutorialStateTimer:0.5];
    };
    [_swipeRightImageView.layer pop_addAnimation:anim forKey:@"slideup"];
}
-(void)setUpViews{
    
    
    _textBoxView.layer.cornerRadius=5.0f;
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    self.bgImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapEvent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEvent)];
    [self.bgImageView addGestureRecognizer:tapEvent];
    
}

-(void)tapEvent{
    
    BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"SwipeUpAndDownTutorialTrigger"];
    if (coachMarksShown == NO) {
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            _swipeRightImageView.hidden=NO;
            _textView.text=@"￼Swipe each row, to reveal more options";
            popAnimationTimerThree=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(performSwipeRighAnimation) userInfo:nil repeats:YES];

        }
        else{
            _textView.text=@"￼￼Tap here to add to “Saved For Later” folder";

        }

        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"SwipeUpAndDownTutorialTrigger"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"SaveForLaterTutorialTrigger" object:nil userInfo:nil];
        
        
        [popAnimationTimer invalidate];
        [popAnimationTimerTwo invalidate];
        
        
        _upImageView.hidden=YES;
        _downImageView.hidden=YES;
        
    }else
    {
        
        [self dismissViewControllerAnimated:NO completion:^{
            [popAnimationTimer invalidate];
            [popAnimationTimerTwo invalidate];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"DrillInTutorialTrigger" object:nil userInfo:nil];
            
        }];
        
    }
    
    
    
}
- (void)deviceOrientationDidChange:(NSNotification *)notification {
    
    //Obtaining the current device orientation
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    //Ignoring specific orientations
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown) {
        return;
    }
    
    NSLog(@"View height:%f",self.view.frame.size.height);
    
    // We need to allow a slight pause before running handler to make sure rotation has been processed by the view hierarchy

}

- (void)handleDeviceOrientationChange {
    
    // Begin the whole coach marks process again from the beginning, rebuilding the coachmarks with updated co-ordinates
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    
    [super viewWillAppear:animated];
    
    [self.textView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
    
    //[self performSwipeDownAnimation];
    
    popAnimationTimer=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(performSwipeUpAnimation) userInfo:nil repeats:YES];
    
       popAnimationTimerTwo=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(performSwipeDownAnimation) userInfo:nil repeats:YES];
    self.swipeRightImageView.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    
    [super viewWillDisappear:animated];
    
    [self.textView removeObserver:self forKeyPath:@"contentSize"];
    
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    
    UITextView *tv = object;
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
