//
//  FolderViewController.h
//  FullIntel
//
//  Created by Capestart on 7/7/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FolderViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate> {
    NSMutableArray *folderArray;
    UIActivityIndicatorView *activityIndicator;
    UIAlertView *alertView;
}
@property (nonatomic,strong) IBOutlet UITableView *folderTable;
- (IBAction)rssButtonClick:(UIButton *)sender;
- (IBAction)editButtonClick:(UIButton *)sender;
- (IBAction)deleteButtonClick:(UIButton *)sender;
@property BOOL isdeleteFlag;
@end
