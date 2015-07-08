//
//  FolderCell.h
//  FullIntel
//
//  Created by Capestart on 7/7/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FolderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rowNumber;
@property (weak, nonatomic) IBOutlet UILabel *folderTitle;
@property (weak, nonatomic) IBOutlet UILabel *folderCreatedDate;
@property (weak, nonatomic) IBOutlet UIButton *rssButton;

@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;


@end
