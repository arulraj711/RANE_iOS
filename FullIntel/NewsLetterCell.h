//
//  NewsLetterCell.h
//  FullIntel
//
//  Created by Prabhu on 30/06/1937 SAKA.
//  Copyright (c) 1937 SAKA CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsLetterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *newsLetterTitle;
@property (weak, nonatomic) IBOutlet UILabel *articlesCount;
@property (weak, nonatomic) IBOutlet UILabel *createdDate;
@property (weak, nonatomic) IBOutlet UILabel *serialNumber;

@end
