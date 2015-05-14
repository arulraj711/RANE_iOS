//
//  ShowDetailView.m
//  FullIntel
//
//  Created by Capestart on 5/5/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "ShowDetailView.h"

@interface ShowDetailView ()

@end

@implementation ShowDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURL *url = [NSURL URLWithString:@"https://www.google.co.in/?gfe_rd=cr&ei=l25IVb_SH-bI8AeLuYFg"];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];

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
