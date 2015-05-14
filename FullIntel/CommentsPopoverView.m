//
//  CommentsPopoverView.m
//  FullIntel
//
//  Created by Arul on 3/19/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "CommentsPopoverView.h"

@interface CommentsPopoverView ()

@end

@implementation CommentsPopoverView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 50;
    self.imageView.layer.borderWidth = 1.0f;
    self.imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
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

@end
