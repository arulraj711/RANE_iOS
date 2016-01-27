//
//  IssuesResultListPage.h
//  FullIntel
//
//  Created by cape start on 22/09/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IssuesResultListPage : UIViewController {
    NSArray *issueList;
}
@property (weak, nonatomic) IBOutlet UITableView *issueListTableView;
- (IBAction)overviewButtonClick:(id)sender;
- (IBAction)monitoringReportButtonClick:(id)sender;

@end
