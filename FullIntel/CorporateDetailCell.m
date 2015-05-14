//
//  CorporateDetailCell.m
//  FullIntel
//
//  Created by Capestart on 5/13/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "CorporateDetailCell.h"
#import "PersonalityWidgetCell.h"
#import "StockWidgetCell.h"
#import "ProductWidgetCell.h"
#import "SocialLinkCell.h"

@implementation CorporateDetailCell

- (void)awakeFromNib {
    // Initialization code
    self.authorImageView.layer.masksToBounds = YES;
    self.authorImageView.layer.cornerRadius = 25.0f;
}


- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(collectionView == self.widgetCollectionView) {
        if(indexPath.row == 0) {
            return CGSizeMake(320, 260);
        } else if(indexPath.row == 1) {
            return CGSizeMake(320, 200);
        } else if(indexPath.row == 2) {
            return CGSizeMake(320, 400);
        }
        
    }
    else if(collectionView == self.socialLinkCollectionView) {
        return CGSizeMake(50, 50);
    }
    return CGSizeMake(30, 30);
}

#pragma mark - UICollectionView Datasource

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    // NSLog(@"imp collection view");
    NSInteger itemCount;
//    if(view == self.legendsCollectionView) {
//        itemCount = self.legendsArray.count;
//    }else
    if(view == self.socialLinkCollectionView){
        itemCount = self.socialLinksArray.count;
    }else {
        itemCount = 3;
    }
    return itemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *collectionCell;
//    if(cv == self.legendsCollectionView) {
//        [self.legendsCollectionView registerClass:[LegendCollectionViewCell class]
//                       forCellWithReuseIdentifier:@"LegendCell"];
//        LegendCollectionViewCell *cell =(LegendCollectionViewCell*) [cv dequeueReusableCellWithReuseIdentifier:@"LegendCell" forIndexPath:indexPath];
//        UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//        iconImage.backgroundColor = [UIColor clearColor];
//        //        iconImage.layer.masksToBounds = YES;
//        //        iconImage.layer.cornerRadius = 20.0f;
//        iconImage.layer.masksToBounds = YES;
//        iconImage.layer.cornerRadius = 15.0f;
//        iconImage.layer.borderColor = [UIColor whiteColor].CGColor;
//        iconImage.layer.borderWidth = 1.5f;
//        // iconImage.image =  [UIImage imageNamed:@"circle30"];
//        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(7.5, 7.5, 15, 15)];
//        image.backgroundColor = [UIColor clearColor];
//        NSString *imageName = [NSString stringWithFormat:@"%@_white",[self.legendsArray objectAtIndex:indexPath.row]];
//        NSLog(@"detail view image name:%@",imageName);
//        image.image = [UIImage imageNamed:imageName];
//        [iconImage addSubview:image];
//        [cell.contentView addSubview:iconImage];
//        collectionCell = cell;
//    } else
    
    if(cv == self.socialLinkCollectionView) {
        NSManagedObject *socialLink = [self.socialLinksArray objectAtIndex:indexPath.row];
        
        SocialLinkCell *socialCell =(SocialLinkCell*) [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        if([[socialLink valueForKey:@"mediatype"] isEqualToString:@"Twitter"]) {
            socialCell.iconImage.image = [UIImage imageNamed:@"Twitter-1"];
        } else {
            socialCell.iconImage.image = [UIImage imageNamed:[socialLink valueForKey:@"mediatype"]];
        }
        
        if([[socialLink valueForKey:@"isactive"]isEqualToNumber:[NSNumber numberWithInt:1]]) {
            socialCell.blueCircleView.hidden = NO;
        } else {
            socialCell.blueCircleView.hidden = YES;
        }
        socialCell.cellOuterView.layer.borderWidth = 1.0f;
        socialCell.cellOuterView.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
        socialCell.cellOuterView.layer.masksToBounds = YES;
        socialCell.cellOuterView.layer.cornerRadius = 20.0f;
        socialCell.blueCircleView.layer.masksToBounds = YES;
        socialCell.blueCircleView.layer.cornerRadius = 5.0f;
        
        
        //        UITapGestureRecognizer *socialCellTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(socialTap:)];
        //        socialCell.tag = indexPath.row;
        //        socialCell.iconImage.userInteractionEnabled = YES;
        //        [socialCell.iconImage addGestureRecognizer:socialCellTap];
        collectionCell = socialCell;
        
    } else {
        if(indexPath.row == 0) {
            [self.widgetCollectionView registerClass:[PersonalityWidgetCell class]
                          forCellWithReuseIdentifier:@"Personality"];
            [self.widgetCollectionView registerNib:[UINib nibWithNibName:@"PersonalityWidgetCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"Personality"];
            
            PersonalityWidgetCell * cell =(PersonalityWidgetCell*) [cv dequeueReusableCellWithReuseIdentifier:@"Personality" forIndexPath:indexPath];
            cell.contentView.layer.borderWidth = 1.0f;
            cell.contentView.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
            collectionCell = cell;
        } else if(indexPath.row == 1) {
            [self.widgetCollectionView registerClass:[StockWidgetCell class]
                          forCellWithReuseIdentifier:@"stock"];
            [self.widgetCollectionView registerNib:[UINib nibWithNibName:@"StockWidgetCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"stock"];
            
            PersonalityWidgetCell *cell =(PersonalityWidgetCell*) [cv dequeueReusableCellWithReuseIdentifier:@"stock" forIndexPath:indexPath];
            cell.contentView.layer.borderWidth = 1.0f;
            cell.contentView.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
            collectionCell = cell;
        } else if(indexPath.row == 2) {
            [self.widgetCollectionView registerClass:[ProductWidgetCell class]
                          forCellWithReuseIdentifier:@"product"];
            [self.widgetCollectionView registerNib:[UINib nibWithNibName:@"ProductWidgetCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"product"];
            
            ProductWidgetCell *cell =(ProductWidgetCell*) [cv dequeueReusableCellWithReuseIdentifier:@"product" forIndexPath:indexPath];
            cell.contentView.layer.borderWidth = 1.0f;
            cell.contentView.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
            collectionCell = cell;
        }
    }
    return collectionCell;
}

-(void)socialTap:(UITapGestureRecognizer *)tapGesture {
    NSInteger row = tapGesture.view.tag;
    NSLog(@"social tap working for row:%d",row);
}


//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"did select social link");
//    if(collectionView == self.socialLinkCollectionView) {
//        
//        NSManagedObject *socialLink = [self.socialLinksArray objectAtIndex:indexPath.row];
//        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];
//        
//        UINavigationController *modalController = [storyBoard instantiateViewControllerWithIdentifier:@"SocialWebView"];
//        // UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"modal"];
//        
//        MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:modalController];
//        
//        formSheet.presentedFormSheetSize = CGSizeMake(850, 700);
//        //    formSheet.transitionStyle = MZFormSheetTransitionStyleSlideFromTop;
//        formSheet.shadowRadius = 2.0;
//        formSheet.shadowOpacity = 0.3;
//        formSheet.shouldDismissOnBackgroundViewTap = YES;
//        formSheet.shouldCenterVertically = YES;
//        formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
//        // formSheet.keyboardMovementStyle = MZFormSheetKeyboardMovementStyleMoveToTop;
//        // formSheet.keyboardMovementStyle = MZFormSheetKeyboardMovementStyleMoveToTopInset;
//        // formSheet.landscapeTopInset = 50;
//        // formSheet.portraitTopInset = 100;
//        
//        __weak MZFormSheetController *weakFormSheet = formSheet;
//        
//        
//        // If you want to animate status bar use this code
//        formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
//            UINavigationController *navController = (UINavigationController *)weakFormSheet.presentedFSViewController;
//            if ([navController.topViewController isKindOfClass:[SocialWebView class]]) {
//                SocialWebView *mzvc = (SocialWebView *)navController.topViewController;
//                mzvc.urlString = [socialLink valueForKey:@"url"];
//                //  mzvc.showStatusBar = NO;
//            }
//            
//            
//            [UIView animateWithDuration:0.3 animations:^{
//                if ([weakFormSheet respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
//                    [weakFormSheet setNeedsStatusBarAppearanceUpdate];
//                }
//            }];
//        };
//        
//        formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
//            // Passing data
//            UINavigationController *navController = (UINavigationController *)presentedFSViewController;
//            NSString *titleStr = [NSString stringWithFormat:@"%@ in %@",self.authorNameStr,[socialLink valueForKey:@"mediatype"]];
//            navController.topViewController.title = titleStr;
//            
//            navController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
//            SocialWebView *mzvc = (SocialWebView *)navController.topViewController;
//            mzvc.urlString = [socialLink valueForKey:@"url"];
//        };
//        formSheet.transitionStyle = MZFormSheetTransitionStyleCustom;
//        
//        [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
//        
//        [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
//            
//        }];
//        
//    }
//}


@end
