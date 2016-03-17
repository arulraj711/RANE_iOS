//
//  TopStoriesViewController.h
//  FullIntel
//
//  Created by cape start on 01/03/16.
//  Copyright © 2016 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryTableViewCell.h"
#import "ReportObject.h"
#import "FISharedResources.h"
#import "CorporateNewsDetailsView.h"
#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

@interface TopStoriesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *headingArray;
    NSString *articleIdArray;
    

}
@property (strong, nonatomic) IBOutlet UITableView *storyTableView;
@property (strong) NSMutableArray *devices;

@end
