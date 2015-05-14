//
//  MarkedImportantListView.h
//  FullIntel
//
//  Created by Arul on 4/9/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FISharedResources.h"
@interface MarkedImportantListView : UIViewController {
    NSMutableArray *legendsList;
    NSManagedObject *author;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *horizontalSpacing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpacing;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UITableView *influencerTableView;
@property (strong) NSMutableArray *devices;
@end
