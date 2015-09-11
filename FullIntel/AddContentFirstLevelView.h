//
//  AddContentFirstLevelView.h
//  FullIntel
//
//  Created by Arul on 4/15/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RFQuiltLayout.h"
#import "AddContentSecondLevelView.h"
@interface AddContentFirstLevelView : UIViewController<RFQuiltLayoutDelegate,UICollectionViewDelegate,SecondLevelDelegate> {
    RFQuiltLayout* layout;
    NSTimer *popAnimationTimer;
}
- (IBAction)closeAction:(id)sender;
- (IBAction)requestChange:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;
@property (nonatomic,strong) NSMutableArray *contentTypeArray;
@property (nonatomic,strong) NSMutableArray *contentCategoryArray;
@property (nonatomic,strong) NSMutableArray *selectedIdArray;
@property (nonatomic,strong) NSMutableArray *checkedArray;
@property (nonatomic,strong) NSMutableArray *uncheckedArray;
@property (weak, nonatomic) IBOutlet UIButton *requestChangeButton;
@property (weak,nonatomic) IBOutlet UIView *tutorialDescriptionView;
- (IBAction)checkMark:(id)sender;
@end
