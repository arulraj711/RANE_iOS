//
//  CorporateNewsDetailsTest.h
//  FullIntel
//
//  Created by Capestart on 5/13/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FISharedResources.h"
#import <MessageUI/MessageUI.h>
#import "WSCoachMarksView.h"

@interface CorporateNewsDetailsView : UIViewController<MFMailComposeViewControllerDelegate,UIViewControllerTransitioningDelegate,UICollectionViewDataSource,UICollectionViewDelegate> {
    NSTimer *oneSecondTicker;
    NSManagedObject *curatedNewsDetail;
    NSManagedObject *curatedNewsAuthorDetail;
    MFMailComposeViewController *mailComposer;
    UIView *innerWebView;
    UIActivityIndicatorView *activityIndicator;
    NSString *mailArticleId;
    NSString *mailTitle;
    NSString *mailBody;
    NSArray *coachMarks;
    WSCoachMarksView *coachMarksView;
}
@property NSIndexPath *selectedIndexPath;
@property (nonatomic,strong) NSMutableArray *socialLinksArray;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *articleIdArray;
@property (nonatomic) int currentIndex;
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) int selectedIndex;
-(void)getArticleIdListFromDB;
@property (weak,nonatomic) IBOutlet UITextView *tutorialTextView;
@property (weak,nonatomic) IBOutlet UIView *tutorialTextBoxView;
@end
