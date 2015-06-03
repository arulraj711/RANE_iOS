//
//  IpAndLegalCell.h
//  FullIntel
//
//  Created by cape start on 01/06/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IpAndLegalCell : UICollectionViewCell
- (IBAction)requestUpgradeButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *requestUpgradeButton;

@end
