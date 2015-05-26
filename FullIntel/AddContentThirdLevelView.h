//
//  AddContentThirdLevelView.h
//  FullIntel
//
//  Created by Capestart on 5/4/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RFQuiltLayout.h"
#import "AddContentFourthLevelView.h"
@protocol ThirdLevelDelegate;
@interface AddContentThirdLevelView : UIViewController<RFQuiltLayoutDelegate,FourthLevelDelegate> {
   // id<ThirdLevelDelegate> delegate;
    UILabel *testLabel;
}
- (IBAction)backButtonClicked:(id)sender;
@property (nonatomic, assign) id<ThirdLevelDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectTopicsLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *categoryCollectionView;
- (IBAction)checkMark:(id)sender;
@property (nonatomic,strong) NSMutableArray *innerArray;
@property (nonatomic,strong) NSMutableArray *selectedIdArray;
@property (nonatomic,strong) NSMutableArray *previousArray;

@property (nonatomic,strong) NSNumber *selectedId;
@property (nonatomic,strong) NSMutableArray *checkedArray;
@property (nonatomic,strong) NSMutableArray *uncheckedArray;
@end

@protocol ThirdLevelDelegate
- (void)thirdLevelDidFinish:(AddContentThirdLevelView*)thirdLevel;
@end