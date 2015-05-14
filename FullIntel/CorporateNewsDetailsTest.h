//
//  CorporateNewsDetailsTest.h
//  FullIntel
//
//  Created by Capestart on 5/13/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FISharedResources.h"

@interface CorporateNewsDetailsTest : UIViewController {
    NSTimer *oneSecondTicker;
    NSManagedObject *curatedNewsDetail;
    NSManagedObject *curatedNewsAuthorDetail;
}
@property (nonatomic,strong) NSMutableArray *socialLinksArray;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *articleIdArray;
@property (nonatomic) int currentIndex;
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) int selectedIndex;
-(void)getArticleIdListFromDB;
@end
