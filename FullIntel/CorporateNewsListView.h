//
//  CorporateNewsListView.h
//  FullIntel
//
//  Created by Arul on 3/18/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FISharedResources.h"
@interface CorporateNewsListView : UIViewController {
    NSMutableArray *legendsList;
    NSManagedObject *author;
    UIRefreshControl *refreshControl;
}
@property(strong, nonatomic) UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *horizontalSpacing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpacing;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UITableView *articlesTableView;
@property (nonatomic,strong) NSNumber *categoryId;
@property (strong) NSMutableArray *devices;
@end
