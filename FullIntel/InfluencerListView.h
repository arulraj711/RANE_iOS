//
//  InfluencerListView.h
//  FullIntel
//
//  Created by Arul on 3/23/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfluencerListView : UIViewController {
    NSMutableArray *legendsList;
}
@property (weak, nonatomic) IBOutlet UITableView *influencerTableView;
@property (nonatomic,strong) NSMutableArray *influencerArray;
@end
