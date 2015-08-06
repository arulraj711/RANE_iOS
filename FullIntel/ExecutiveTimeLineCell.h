//
//  ExecutiveTimeLineCell.h
//  FullIntel
//
//  Created by cape start on 02/06/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExecutiveTimeLineCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *firstImage;
@property (weak, nonatomic) IBOutlet UIImageView *secondImage;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImage;
@property (weak, nonatomic) IBOutlet UIImageView *forthImage;
- (IBAction)requestUpgradeButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *requestUpgradeButton;

@end
