//
//  ReportListCell.h
//  FullIntel
//
//  Created by CapeStart Apple on 3/2/16.
//  Copyright © 2016 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *serialNumber;
@property (weak, nonatomic) IBOutlet UILabel *reportTitle;
@property (strong, nonatomic) IBOutlet UILabel *dateCell;

@end
