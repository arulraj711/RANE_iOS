//
//  SecondLevelCell.h
//  FullIntel
//
//  Created by Capestart on 5/4/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondLevelCell : UICollectionViewCell
@property (nonatomic,strong) IBOutlet UIImageView *image;
@property (nonatomic,strong) IBOutlet UILabel *name;
@property (nonatomic,strong) IBOutlet UIButton *checkMarkButton;
@end
