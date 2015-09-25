//
//  IssueMonitoringReportPage.h
//  FullIntel
//
//  Created by cape start on 22/09/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IssueMonitoringReportPage : UIViewController<UICollectionViewDelegate> {
    NSArray *monitoringOutletList;
    NSArray *issueList;
}
@property (weak, nonatomic) IBOutlet UITableView *monitoringOutletTableView;
@property (weak, nonatomic) IBOutlet UITableView *monitoringInfluencerTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIWebView *detailsWebview;
@property NSMutableArray *selectedItemArray;
@end
