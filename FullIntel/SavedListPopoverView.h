//
//  SavedListPopoverView.h
//  FullIntel
//
//  Created by Arul on 3/20/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SavedListPopoverView : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *savedListTableView;
- (IBAction)checkedButtonAction:(UIButton *)sender;
- (IBAction)createFolderAction:(UIButton *)sender;
@property (nonatomic,strong) NSMutableArray *savedListArray;
- (IBAction)requestButtonClick:(id)sender;
@property (nonatomic,strong) IBOutlet UIButton *saveButton;
@end
