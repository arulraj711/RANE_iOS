//
//  EndOfTutorialViewController.m
//  FullIntel
//
//  Created by cape start on 18/08/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "EndOfTutorialViewController.h"

@interface EndOfTutorialViewController ()

@end

@implementation EndOfTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)setUpViews{
    
    self.bgImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapEvent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEvent)];
    [self.bgImageView addGestureRecognizer:tapEvent];
    
    
    _tutorialTextBoxView.layer.cornerRadius=5.0f;
    
    
    
}
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    
//    [self tapEvent];
//}
//-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    
//    
//    [self tapEvent];
//    
//}
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
    


        
        [self dismissViewControllerAnimated:NO completion:^{
            
            

            
        }];
    
    
}

@end
