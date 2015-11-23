//
//  TutorialPopViewController.m
//  FullIntel
//
//  Created by cape start on 29/07/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "TutorialPopViewController.h"
#import "pop.h"
//#import "Localytics.h"
#import "FISharedResources.h"
@interface TutorialPopViewController ()

@end

@implementation TutorialPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpViews];
}

-(void)setUpViews{
    
    self.outerBoxView.layer.masksToBounds = YES;
    self.outerBoxView.layer.cornerRadius = 10.0f;
    
    self.bgImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapEvent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEvent)];
    [self.bgImageView addGestureRecognizer:tapEvent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"TutorialBoxShown"];

    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    
   popAnimationTimer=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(performSpringAnimation) userInfo:nil repeats:YES];
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    
    [popAnimationTimer invalidate];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)performSpringAnimation{
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue=[NSValue valueWithCGSize:CGSizeMake(0.5, 0.5)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1,1)];
    scaleAnimation.springBounciness = 10;
    scaleAnimation.springSpeed=1;
    [_continueButton.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
}

-(void)performSpringAnimationTwo{
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue=[NSValue valueWithCGSize:CGSizeMake(0.5, 0.5)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1,1)];
    scaleAnimation.springBounciness = 10;
    scaleAnimation.springSpeed=10;
    [_laterButton.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
}

-(void)tapEvent {
    

  //  [self dismissViewControllerAnimated:NO completion:NULL];
}

- (IBAction)continueButtonPressed:(id)sender {
    
     [popAnimationTimer invalidate];

     [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"TutorialContinueClick"];
    
   [self dismissViewControllerAnimated:NO completion:NULL];
     [[NSNotificationCenter defaultCenter]postNotificationName:@"TutorialTrigger" object:nil userInfo:nil];
    
   
}
- (IBAction)laterButtonPressed:(id)sender {
    
     [popAnimationTimer invalidate];
    
    
    [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"TutorialLaterClick"];
    
     [self dismissViewControllerAnimated:NO completion:NULL];
}
@end
