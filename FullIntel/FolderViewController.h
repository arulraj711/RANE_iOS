//
//  FolderViewController.h
//  FullIntel
//
//  Created by Capestart on 7/7/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKRevealController.h"
@interface FolderViewController : UIViewController<UITableViewDataSource,UITextFieldDelegate,PanDelegate,UIGestureRecognizerDelegate> {
    NSMutableArray *folderArray;
    UIActivityIndicatorView *activityIndicator;
}
@property (nonatomic,strong) IBOutlet UITableView *folderTable;
- (IBAction)rssButtonClick:(UIButton *)sender;
- (IBAction)editButtonClick:(UIButton *)sender;
- (IBAction)deleteButtonClick:(UIButton *)sender;
@property BOOL isdeleteFlag;
@end
