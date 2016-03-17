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
@interface TopStoriesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSDictionary *reportObject;
    NSArray *headingArray;
    NSArray *nameArray;
    NSArray *outletArray;
    NSArray *articleIdArray;
    

}
@property (strong, nonatomic) IBOutlet UITableView *storyTableView;
@property (strong) NSMutableArray *devices;

@end
