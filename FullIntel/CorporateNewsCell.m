//
//  CorporateNewsCell.m
//  FullIntel
//
//  Created by Arul on 3/18/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "CorporateNewsCell.h"
#import "LegendCollectionViewCell.h"
#import "NHAlignmentFlowLayout.h"
#import <QuartzCore/QuartzCore.h>

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

@implementation CorporateNewsCell

- (void)awakeFromNib {
    
    // Initialization code
    [self.legendCollectionView registerClass:[LegendCollectionViewCell class]
                  forCellWithReuseIdentifier:@"LegendCell"];
    NHAlignmentFlowLayout *layout = [[NHAlignmentFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(2.5, 0, 0, 0);
    layout.alignment = NHAlignmentBottomRightAligned;
    layout.itemSize = CGSizeMake(25, 25);
    layout.minimumInteritemSpacing = 3.0;
    layout.minimumLineSpacing = 1.0;
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        self.articleImageView.layer.masksToBounds = YES;
        self.articleImageView.layer.cornerRadius = 5.0f;
        self.articleImageView.layer.borderColor = [UIColor colorWithRed:(237/255.0) green:(240/255.0) blue:(240/255.0) alpha:1].CGColor;
        self.articleImageView.layer.borderWidth = 0.25f;
    }
    else
    {
        self.markedImpView.layer.masksToBounds = YES;
        self.markedImpView.layer.cornerRadius = 22.0f;
        //    self.markedImpView.layer.borderColor = [UIColor blackColor].CGColor;
        //    self.markedImpView.layer.borderWidth = 3.0;
        
        self.bookmarkView.layer.masksToBounds = YES;
        self.bookmarkView.layer.cornerRadius = 22.0f;
        self.articleImageView.layer.masksToBounds = YES;
        self.articleImageView.layer.cornerRadius = 10.0f;
        self.articleImageView.layer.borderColor = [UIColor colorWithRed:(237/255.0) green:(240/255.0) blue:(240/255.0) alpha:1].CGColor;
        self.articleImageView.layer.borderWidth = 0.5f;
    }
    self.legendCollectionView.collectionViewLayout = layout;
    self.selectionmageView.layer.borderColor = [UIColor blueColor].CGColor;
    self.selectionmageView.layer.borderWidth = 1.0f;
    self.selectionmageView.layer.cornerRadius = 15.0f;
    self.selectionmageView.layer.masksToBounds = YES;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.legendCollectionView performBatchUpdates:nil completion:nil];
}

#pragma mark - UICollectionView Datasource

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    //NSLog(@"legends collection view count:%d",self.legendsArray.count);
    return self.legendsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // NSLog(@"cell for item");
    LegendCollectionViewCell *cell =(LegendCollectionViewCell*) [cv dequeueReusableCellWithReuseIdentifier:@"LegendCell" forIndexPath:indexPath];
    //cell.iconImageView.backgroundColor = [UIColor redColor];
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    iconImage.backgroundColor = [UIColor clearColor];
    iconImage.image =  [UIImage imageNamed:@"circle25"];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(6.5, 6.5, 12, 12)];
    image.backgroundColor = [UIColor clearColor];
    image.image = [UIImage imageNamed:[self.legendsArray objectAtIndex:indexPath.row]];
    [iconImage addSubview:image];
    [cell.contentView addSubview:iconImage];
    return cell;
}




@end
