//
//  LeftMenuTutorialPopViewController.m
//  FullIntel
//
//  Created by cape start on 11/08/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "LeftMenuTutorialPopViewController.h"

@interface LeftMenuTutorialPopViewController ()

@end

@implementation LeftMenuTutorialPopViewController

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
    
    self.bgImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapEvent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEvent)];
    [self.bgImageView addGestureRecognizer:tapEvent];
    
    
    _tutorialContentView.layer.cornerRadius=5.0f;
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    
    [super viewWillAppear:animated];
    
    [self.textView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
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
-(void)tapEvent{
    
    
  //  [[NSNotificationCenter defaultCenter]postNotificationName:@"MarkImportantTutorialTrigger" object:nil userInfo:nil];
    

    
    BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"MarkImportantTutorialTrigger"];
    if (coachMarksShown == NO) {
        
        _textView.text=@"Marked Important folder contains the articles hand selected by FullIntel Analysts or your colleagues";
        self.leftTextViewHeightConstraint.constant = 75;

        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"MarkImportantTutorialTrigger"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MarkImportantTutorialTrigger" object:nil userInfo:nil];
    }else{
        
         [[NSNotificationCenter defaultCenter]postNotificationName:@"MainListTutorialTrigger" object:nil userInfo:nil];
        
        [self dismissViewControllerAnimated:NO completion:^{
            
                     [[NSNotificationCenter defaultCenter]postNotificationName:@"MainListArrowTutorial" object:nil userInfo:nil];
            
        }];
    }
    
    
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
