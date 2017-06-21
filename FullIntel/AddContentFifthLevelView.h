//
//  AddContentFifthLevelView.h
//  FullIntel
//
//  Created by Capestart on 5/25/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RFQuiltLayout.h"
#import "Localytics.h"
@protocol FifthLevelDelegate;
@interface AddContentFifthLevelView : UIViewController<RFQuiltLayoutDelegate> {
    UILabel *testLabel;
    NSMutableArray *searchArray;
}
@property (weak, nonatomic) IBOutlet UICollectionView *categoryCollectionView;
- (IBAction)checkMark:(id)sender;
@property (nonatomic, assign) id<FifthLevelDelegate> delegate;
@property (nonatomic,strong) NSMutableArray *innerArray;
@property (weak, nonatomic) IBOutlet UILabel *selectTopicsLabel;
@property (nonatomic,strong) NSMutableArray *selectedIdArray;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) NSMutableArray *previousArray;
@property (nonatomic,strong) NSNumber *selectedId;
@property (nonatomic,strong) NSMutableArray *checkedArray;
- (IBAction)backButtonClicked:(id)sender;
@property (nonatomic,strong) NSMutableArray *uncheckedArray;
@property BOOL isSelected;
@property NSMutableArray *firstLevelCheckedArray;
@property NSMutableArray *firstLevelUnCheckedArray;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
//@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
- (IBAction)requestChange:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *noSearchResultsFoundText;

@end

@protocol FifthLevelDelegate
- (void)fifthLevelDidFinish:(AddContentFifthLevelView*)fifthLevel;
@end