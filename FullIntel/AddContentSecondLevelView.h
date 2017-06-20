//
//  AddContentSecondLevelView.h
//  FullIntel
//
//  Created by Capestart on 5/4/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RFQuiltLayout.h"
#import "AddContentThirdLevelView.h"
//#import "AMPopTip.h"
#import "CMPopTipView.h"
@protocol SecondLevelDelegate;
@interface AddContentSecondLevelView : UIViewController<RFQuiltLayoutDelegate,ThirdLevelDelegate,UICollectionViewDataSource,UICollectionViewDelegate,CMPopTipViewDelegate>{
    UILabel *testLabel;
    UILabel *availableTopic;
    UIButton *infoButton;
    UICollectionView *collectionView;
    RFQuiltLayout* layout;
    UITapGestureRecognizer *tapEvent;
    NSTimer *popAnimationTimer;
}
@property (weak, nonatomic) IBOutlet UICollectionView *categoryCollectionView;
- (IBAction)checkMark:(id)sender;
@property (nonatomic, assign) id<SecondLevelDelegate> delegate;
@property (nonatomic,strong) NSMutableArray *selectedIdArray;
@property (nonatomic,strong) NSMutableArray *innerArray;
@property (weak, nonatomic) IBOutlet UILabel *selectTopicsLabel;
@property (nonatomic,strong) NSMutableArray *checkedArray;
@property (nonatomic,strong) NSMutableArray *uncheckedArray;
@property (nonatomic,strong) NSMutableArray *previousArray;
@property (nonatomic,strong) NSNumber *selectedId;
@property (nonatomic,weak) IBOutlet UIView *tutorialContentView;
- (IBAction)expandButtonClick:(id)sender;

//@property (nonatomic, strong) AMPopTip *popTip;
@property (nonatomic, strong) id currentPopTipViewTarget;
@property (nonatomic, strong)	NSDictionary	*contents;

@end

@protocol SecondLevelDelegate
- (void)secondLevelDidFinish:(AddContentSecondLevelView*)secondLevel;
@end