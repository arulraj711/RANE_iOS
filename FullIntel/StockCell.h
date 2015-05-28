//
//  StockCell.h
//  FullIntel
//
//  Created by cape start on 28/05/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StockCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *companyName;

@property (weak, nonatomic) IBOutlet UILabel *value;

@property (weak, nonatomic) IBOutlet UILabel *firstValue;
@property (weak, nonatomic) IBOutlet UILabel *secondValue;
@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *lastName;
@property (weak, nonatomic) IBOutlet UIImageView *downImage;
@property (weak, nonatomic) IBOutlet UIImageView *graphImage;

@end
