//
//  LeftViewController.h
//  FullIntel
//
//  Created by Arul on 2/17/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RATreeView.h"
#import "MZFormSheetController.h"
#import "WSCoachMarksView.h"
#import "RADataObject.h"
@interface LeftViewController : UIViewController <RATreeViewDataSource,RATreeViewDelegate,MZFormSheetBackgroundWindowDelegate,UIViewControllerTransitioningDelegate,WSCoachMarksViewDelegate>{
    RATreeView *treeView;
    MZFormSheetController *formSheet;
    WSCoachMarksView *coachMarksView;
    NSArray *coachMarks;
    int unreadCnt;
    NSTimer *popAnimationTimer,*popAnimationTimerTwo;
    RADataObject *data;
}
@property (weak, nonatomic) IBOutlet UIButton *addContentButton;
@property (weak, nonatomic) IBOutlet UIButton *researchButton;
@property BOOL isFirstTime;
@property (weak, nonatomic) IBOutlet UIView *treeBackView;
@property (strong) NSMutableArray *menus;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UIImageView *companyLogo;
- (IBAction)addContentButtonClick:(id)sender;
- (IBAction)researchRequestButtonClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *overlayView;


@end
