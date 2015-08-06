//
//  VideoWidgetCell.h
//  FullIntel
//
//  Created by Capestart on 5/29/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoWidgetCell : UICollectionViewCell
- (IBAction)requestUpgradeButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *requestUpgradeButton;
@end
