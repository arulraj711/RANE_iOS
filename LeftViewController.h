//
//  LeftViewController.h
//  FullIntel
//
//  Created by Arul on 2/17/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RATreeView.h"
#import "RADataObject.h"
#import "MZFormSheetController.h"
#import "WSCoachMarksView.h"
#import "RATableViewCell.h"
#import "RATreeView+Private.h"
@interface LeftViewController : UIViewController <RATreeViewDataSource,RATreeViewDelegate,MZFormSheetBackgroundWindowDelegate,UIViewControllerTransitioningDelegate,WSCoachMarksViewDelegate,ExpandButtonDelegate>{
    WSCoachMarksView *coachMarksView;
    RATreeView *treeView;
    MZFormSheetController *formSheet;
    int unreadCnt;
    RADataObject *data;
    NSTimer *popAnimationTimerTwo,*popAnimationTimer;
    NSArray *menuArray;
    NSMutableArray *menuSelectionArray;
}
@property (weak, nonatomic) IBOutlet UIButton *addContentButton;
@property (weak, nonatomic) IBOutlet UIImageView *researchRequestImage;
@property (weak, nonatomic) IBOutlet UILabel *addContentLabel;
@property (weak, nonatomic) IBOutlet UIButton *researchButton;
@property BOOL isFirstTime;
@property (weak, nonatomic) IBOutlet UIView *treeBackView;
@property (strong) NSMutableArray *menus;
- (IBAction)triggerTutorial:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UIImageView *companyLogo;
@property (weak, nonatomic) IBOutlet UIImageView *menuBottomLogo;

- (IBAction)addContentButtonClick:(id)sender;
- (IBAction)researchRequestButtonClick:(UIButton *)sender;
@end
