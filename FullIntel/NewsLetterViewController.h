//
//  NewsLetterViewController.h
//  FullIntel
//
//  Created by Prabhu on 30/06/1937 SAKA.
//  Copyright (c) 1937 SAKA CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsLetterViewController : UIViewController {
    NSMutableArray *newsLetterArray;
}
@property (weak, nonatomic) IBOutlet UITableView *newsListTableView;
@end
