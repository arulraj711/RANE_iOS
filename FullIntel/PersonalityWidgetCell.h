//
//  PersonalityWidgetCell.h
//  FullIntel
//
//  Created by Arul on 3/11/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalityWidgetCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *reqButton;
- (IBAction)requestUpgradeButtonClick:(id)sender;
@end
