//
//  DrillDownListTutorialViewController.m
//  FullIntel
//
//  Created by cape start on 17/08/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "DrillDownListTutorialViewController.h"
#import "pop.h"

@interface DrillDownListTutorialViewController ()

@end

@implementation DrillDownListTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpViews{
    
    _textViewOutterView.layer.cornerRadius=5.0f;
    
    self.bgImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapEvent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEvent)];
    [self.bgImageView addGestureRecognizer:tapEvent];

    
    _swipeLeftImageView.hidden=YES;
    _swipeRightImageView.hidden=YES;
    
    
    
}
-(void)tapEvent{
    
    BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"SwipeDownTutorialTrigger"];
    if (coachMarksShown == NO) {
        
        
        _textView.text=@"￼￼Swipe right or left to flip pages";
        
        
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"SwipeDownTutorialTrigger"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"SwipeRightLeftTutorialTrigger" object:nil userInfo:nil];
        
        
        [popAnimationTimer invalidate];

        _swipeDownImageView.hidden=YES;
        _swipeLeftImageView.hidden=NO;
        _swipeRightImageView.hidden=NO;
        
        
            popAnimationTimerTwo=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(performSwipeLeftAnimation) userInfo:nil repeats:YES];
        
            popAnimationTimerThree=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(performSwipeRightAnimation) userInfo:nil repeats:YES];
        
        
    }else
    {
        
        
        [self dismissViewControllerAnimated:NO completion:^{
            
            
            [popAnimationTimerTwo invalidate];
            [popAnimationTimerThree invalidate];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"DrillInToolBoxTutorial" object:nil userInfo:nil];
            
        }];
        
    }
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    
    [super viewWillAppear:animated];
    
    [self.textView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
    
    //[self performSwipeDownAnimation];
    
    popAnimationTimer=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(performSwipeUpAnimation) userInfo:nil repeats:YES];
    
    
}

- (void)performSwipeUpAnimation
{
    // First let's remove any existing animations
    
    [_swipeDownImageView.layer removeAllAnimations];
    
    POPDecayAnimation  *anim = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        
        anim.fromValue = @(320);
        
    }
    else{
        anim.fromValue = @(350);

    }
    anim.velocity = @(-1000.0);
    anim.deceleration = 0.995;
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        NSLog(@"Animation has completed.");
        // [self resetTutorialStateTimer:0.5];
    };
    [_swipeDownImageView.layer pop_addAnimation:anim forKey:@"slideup"];
    
}

- (void)performSwipeLeftAnimation
{
    // First let's remove any existing animations
    
    [_swipeLeftImageView.layer removeAllAnimations];
    
    POPDecayAnimation  *anim = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    anim.fromValue = @(-90);
    anim.velocity = @(1000.0);
    anim.deceleration = 0.995;
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        NSLog(@"Animation has completed.");
        // [self resetTutorialStateTimer:0.5];
    };
    [_swipeLeftImageView.layer pop_addAnimation:anim forKey:@"slideup"];
    
}

- (void)performSwipeRightAnimation
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
