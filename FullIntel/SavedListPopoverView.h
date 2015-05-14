//
//  SavedListPopoverView.h
//  FullIntel
//
//  Created by Arul on 3/20/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SavedListPopoverView : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *savedListTableView;
@property (nonatomic,strong) NSMutableArray *savedListArray;
@end
