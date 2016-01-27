//
//  IssueMonitoringCell.h
//  FullIntel
//
//  Created by cape start on 23/09/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IssueMonitoringCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *cellOuterView;
@property (weak, nonatomic) IBOutlet UILabel *cntLabel;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end
