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
@protocol SecondLevelDelegate;
@interface AddContentSecondLevelView : UIViewController<RFQuiltLayoutDelegate,ThirdLevelDelegate,UICollectionViewDataSource,UICollectionViewDelegate>{
    UILabel *testLabel;
    UICollectionView *collectionView;
    RFQuiltLayout* layout;
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
@end

@protocol SecondLevelDelegate
- (void)secondLevelDidFinish:(AddContentSecondLevelView*)secondLevel;
@end