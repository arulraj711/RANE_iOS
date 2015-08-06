//
//  CommentCell.h
//  FullIntel
//
//  Created by Capestart on 5/19/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *receiverImage;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *message;
@property (strong, nonatomic) IBOutlet UILabel *date;
@end
