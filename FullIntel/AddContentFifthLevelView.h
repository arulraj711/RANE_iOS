//
//  AddContentFifthLevelView.h
//  FullIntel
//
//  Created by Capestart on 5/25/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RFQuiltLayout.h"
@protocol FifthLevelDelegate;
@interface AddContentFifthLevelView : UIViewController<RFQuiltLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *categoryCollectionView;
- (IBAction)checkMark:(id)sender;
@property (nonatomic, assign) id<FifthLevelDelegate> delegate;
@property (nonatomic,strong) NSMutableArray *innerArray;
@property (nonatomic,strong) NSMutableArray *selectedIdArray;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) NSMutableArray *previousArray;
@property (nonatomic,strong) NSNumber *selectedId;
@property (nonatomic,strong) NSMutableArray *checkedArray;
- (IBAction)backButtonClicked:(id)sender;
@property (nonatomic,strong) NSMutableArray *uncheckedArray;
@end

@protocol FifthLevelDelegate
- (void)fifthLevelDidFinish:(AddContentFifthLevelView*)fifthLevel;
@end