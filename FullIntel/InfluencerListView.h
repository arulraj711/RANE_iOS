//
//  InfluencerListView.h
//  FullIntel
//
//  Created by Arul on 3/23/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKRevealController.h"

@interface InfluencerListView : UIViewController<UIGestureRecognizerDelegate,PanDelegate> {
    NSMutableArray *legendsList;
}
- (IBAction)requestUpgradeButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UITableView *influencerTableView;
@property (weak, nonatomic) IBOutlet UIButton *requestUpgradeButton;
@property (nonatomic,strong) NSMutableArray *influencerArray;

@property (nonatomic,strong) NSString *titleName;


@property (weak, nonatomic) IBOutlet UITextView *sampleDataText;



@property (weak, nonatomic) IBOutlet UIView *rotateView;
@end
