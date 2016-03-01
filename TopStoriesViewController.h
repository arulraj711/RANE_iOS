//
//  TopStoriesViewController.h
//  FullIntel
//
//  Created by cape start on 01/03/16.
//  Copyright © 2016 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryTableViewCell.h"
@interface TopStoriesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *chartStoryList;

}
@property (strong, nonatomic) IBOutlet UITableView *storyTableView;
@end
