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
@interface LeftViewController : UIViewController <RATreeViewDataSource,RATreeViewDelegate,MZFormSheetBackgroundWindowDelegate>{
    RATreeView *treeView;
}
@property (weak, nonatomic) IBOutlet UIButton *addContentButton;
@property BOOL isFirstTime;
@property (weak, nonatomic) IBOutlet UIView *treeBackView;
@property (strong) NSMutableArray *menus;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UIImageView *companyLogo;
- (IBAction)addContentButtonClick:(id)sender;
@end
