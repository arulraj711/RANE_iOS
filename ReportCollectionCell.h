//
//  ReportCollectionCell.h
//  FullIntel
//
//  Created by CapeStart Apple on 3/22/16.
//  Copyright © 2016 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *reportTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *reportFromDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *reportToDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *reportCreatedDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *articleCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;

@end
