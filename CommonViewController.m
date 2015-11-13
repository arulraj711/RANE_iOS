//
//  CommonViewController.m
//  FullIntel
//
//  Created by cape start on 13/11/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "CommonViewController.h"
#import "FIUtils.h"
#import "PKRevealController.h"

@interface CommonViewController ()

@end

@implementation CommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCustomNavRightButton];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addCustomNavRightButton {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Open Sans" size:17];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.text = @"Upgrade to engage";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    
        UIButton *Btn =[UIButton buttonWithType:UIButtonTypeCustom];
        [Btn setFrame:CGRectMake(0.0f,0.0f,16.0f,15.0f)];
        [Btn setBackgroundImage:[UIImage imageNamed:@"navmenu"]  forState:UIControlStateNormal];
        [Btn addTarget:self action:@selector(backBtnPress) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:Btn];
        [self.navigationItem setLeftBarButtonItem:addButton];
    
//        UIView *addBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
//        addBtnView.backgroundColor = [UIColor clearColor];
//    
//        UIButton *addBtn =[UIButton buttonWithType:UIButtonTypeCustom];
//        [addBtn setFrame:CGRectMake(0,0,40,40)];
//        [addBtn setImage :[UIImage imageNamed:@"addcontent"]  forState:UIControlStateNormal];
//        [addBtn addTarget:self action:@selector(addContentView) forControlEvents:UIControlEventTouchUpInside];
//        [addBtnView addSubview:addBtn];
//        UIBarButtonItem *addContentButton = [[UIBarButtonItem alloc] initWithCustomView:addBtnView];
    
//
//    UIView *addBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
//    addBtnView.backgroundColor = [UIColor clearColor];
//    
//    UIButton *addBtn =[UIButton buttonWithType:UIButtonTypeCustom];
//    [addBtn setFrame:CGRectMake(0.0f,0.0f,35,35)];
//    
//    BOOL isFIViewSelected = [[NSUserDefaults standardUserDefaults]boolForKey:@"isFIViewSelected"];
//    if(isFIViewSelected) {
//        NSLog(@"fi view is selected");
//        [addBtn setBackgroundImage:[UIImage imageNamed:@"navmenu"]  forState:UIControlStateNormal];
//        [addBtn setSelected:YES];
//    } else {
//        NSLog(@"fi view is not selected");
//        [addBtn setBackgroundImage:[UIImage imageNamed:@"nav_fi"]  forState:UIControlStateNormal];
//        [addBtn setSelected:NO];
//    }
//    [addBtn addTarget:self action:@selector(globeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [addBtnView addSubview:addBtn];
//    UIBarButtonItem *addContentButton = [[UIBarButtonItem alloc] initWithCustomView:addBtnView];
//    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:addContentButton,  nil]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)backBtnPress {
    NSLog(@"back button press");
    if(self.revealController.state == PKRevealControllerShowsLeftViewControllerInPresentationMode) {
        NSLog(@"left view closed");
        NSDictionary *dictionary = @{@"email":[[NSUserDefaults standardUserDefaults]objectForKey:@"customerEmail"]};
        [self.revealController showViewController:self.revealController.frontViewController];
    } else {
        NSLog(@"left view opened");
        NSDictionary *dictionary = @{@"email":[[NSUserDefaults standardUserDefaults]objectForKey:@"customerEmail"]};
        [self.revealController showViewController:self.revealController.leftViewController];
    }
    
}
- (IBAction)requestButton:(id)sender {
    UIButton *btn=(UIButton *)sender;
    [btn setSelected:YES];
    [FIUtils callRequestionUpdateWithModuleId:_ModuleId withFeatureId:12];
}
@end
