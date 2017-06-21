//
//  AddContentFourthLevelView.h
//  FullIntel
//
//  Created by Capestart on 5/4/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RFQuiltLayout.h"
#import "AddContentFifthLevelView.h"
#import "Localytics.h"
@protocol FourthLevelDelegate;
@interface AddContentFourthLevelView : UIViewController<RFQuiltLayoutDelegate,FifthLevelDelegate> {
    UILabel *testLabel;
    NSMutableArray *searchArray;
}
@property (weak, nonatomic) IBOutlet UICollectionView *categoryCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
- (IBAction)checkMark:(id)sender;
- (IBAction)expandButtonClick:(id)sender;
@property (nonatomic, assign) id<FourthLevelDelegate> delegate;
@property (nonatomic,strong) NSMutableArray *innerArray;
@property (nonatomic,strong) NSMutableArray *selectedIdArray;
@property (nonatomic,strong) NSMutableArray *previousArray;
@property (weak, nonatomic) IBOutlet UILabel *selectTopicsLabel;
@property (nonatomic,strong) NSNumber *selectedId;
@property (nonatomic,strong) NSMutableArray *checkedArray;
- (IBAction)backButtonClicked:(id)sender;
@property BOOL isSelected;
@property (nonatomic,strong) NSMutableArray *uncheckedArray;
@property NSMutableArray *firstLevelCheckedArray;
@property NSMutableArray *firstLevelUnCheckedArray;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
- (IBAction)requestChange:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *noSearchResultsFoundText;
@end

@protocol FourthLevelDelegate
- (void)fourthLevelDidFinish:(AddContentFourthLevelView*)thirdLevel;
@end