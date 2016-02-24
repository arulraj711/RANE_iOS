//
//  ChartListViewController.m
//  FullIntel
//
//  Created by cape start on 24/02/16.
//  Copyright © 2016 CapeStart. All rights reserved.
//

#import "ChartListViewController.h"
#import "ChartViewController.h"
#import "PKRevealController.h"
#import "FISharedResources.h"

@interface ChartListViewController ()

@end

@implementation ChartListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *navBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [navBtn setFrame:CGRectMake(0.0f,0.0f,16.0f,15.0f)];
    [navBtn setBackgroundImage:[UIImage imageNamed:@"navmenu"]  forState:UIControlStateNormal];
    [navBtn addTarget:self action:@selector(backBtnPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:navBtn];
    [self.navigationItem setLeftBarButtonItem:addButton];

    // Do any additional setup after loading the view.
}
-(void)backBtnPress {
    NSLog(@"back button press");
    if(self.revealController.state == PKRevealControllerShowsLeftViewControllerInPresentationMode) {
        NSLog(@"left view closed");
        NSDictionary *dictionary = @{@"email":[[NSUserDefaults standardUserDefaults]objectForKey:@"customerEmail"]};
        [Localytics tagEvent:@"MenuClosed" attributes:dictionary];
        [self.revealController showViewController:self.revealController.frontViewController];
    } else {
        NSLog(@"left view opened");
        NSDictionary *dictionary = @{@"email":[[NSUserDefaults standardUserDefaults]objectForKey:@"customerEmail"]};
        [Localytics tagEvent:@"MenuOpened" attributes:dictionary];
        [self.revealController showViewController:self.revealController.leftViewController];
    }
    
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

- (IBAction)navigateToChartView:(id)sender {
    
    UIStoryboard *storyboard;
    ChartViewController *chartView;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        storyboard = [UIStoryboard storyboardWithName:@"ChartViewControlleriPhone" bundle:nil];
        chartView = [storyboard instantiateViewControllerWithIdentifier:@"ChartViewController"];
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"ChartViewControlleriPad" bundle:nil];
        chartView = [storyboard instantiateViewControllerWithIdentifier:@"ChartViewController"];
    }
    
    
    [self.navigationController pushViewController:chartView animated:YES];
}
@end
