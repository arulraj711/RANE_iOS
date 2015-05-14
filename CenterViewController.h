//
//  CenterViewController.h
//  FullIntel
//
//  Created by Arul on 2/17/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CenterViewController : UIViewController {
    NSMutableArray *legendsList;
}
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UITableView *influencerTableView;
@property (strong) NSMutableArray *devices;
@end
