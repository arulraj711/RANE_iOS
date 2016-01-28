//
//  SavedListPopoverView.h
//  FullIntel
//
//  Created by Arul on 3/20/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SavedListPopoverView : UIViewController<UITextFieldDelegate,UITableViewDelegate> {
    NSMutableArray *selectedArray;
    NSMutableArray *unselectedArray;
    NSMutableArray *intermediateArray;
    UIActivityIndicatorView *activityIndicator,*activityIndicator1;
}

@property (weak, nonatomic) IBOutlet UITableView *savedListTableView;
- (IBAction)checkedButtonAction:(UIButton *)sender;
- (IBAction)createFolderAction:(UIButton *)sender;
@property (nonatomic,strong) NSMutableArray *savedListArray;
- (IBAction)savedAction:(id)sender;
@property (nonatomic,strong) NSString *selectedArticleId;
@property (nonatomic,strong) NSMutableArray *selectedArticleIdArray;
- (IBAction)requestButtonClick:(id)sender;
@property (nonatomic,strong) IBOutlet UIButton *saveButton;
@end
