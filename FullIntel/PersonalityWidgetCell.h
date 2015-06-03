//
//  PersonalityWidgetCell.h
//  FullIntel
//
//  Created by Arul on 3/11/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalityWidgetCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *requestUpgradeButton;
//@property (weak, nonatomic) NSString *pageName;
- (IBAction)requestUpgradeButtonClick:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *designation;


@end
