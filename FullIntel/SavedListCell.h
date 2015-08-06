//
//  SavedListCell.h
//  FullIntel
//
//  Created by Arul on 3/22/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SavedListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (nonatomic,strong) IBOutlet UIButton *checkedButton;

@end
