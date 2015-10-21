//
//  FirstLevelCell.h
//  FullIntel
//
//  Created by Capestart on 4/16/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstLevelCell : UICollectionViewCell
@property (nonatomic,strong) IBOutlet UIImageView *image;
@property (nonatomic,strong) IBOutlet UILabel *name;
@property (nonatomic,strong) IBOutlet UIButton *checkMarkButton;
@property (nonatomic,strong) IBOutlet UIView *gradientView;
@property (nonatomic,strong) IBOutlet UIButton *upgradeButton;
@property (strong, nonatomic) IBOutlet UIView *bottomContentView;
@property (strong, nonatomic) IBOutlet UIImageView *imgBottomPart;
@end
