//
//  InfluencerCell.m
//  FullIntel
//
//  Created by Arul on 3/23/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "InfluencerCell.h"
#import "LegendCollectionViewCell.h"
#import "NHAlignmentFlowLayout.h"
@implementation InfluencerCell

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
    
    
    self.markedImpView.layer.masksToBounds = YES;
    self.markedImpView.layer.cornerRadius = 20.0f;
    
    self.bookmarkView.layer.masksToBounds = YES;
    self.bookmarkView.layer.cornerRadius = 18.0f;
    
    
    self.articleImageView.layer.masksToBounds = YES;
    self.articleImageView.layer.cornerRadius = 5.0f;
    self.articleImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.articleImageView.layer.borderWidth = 1.0f;
    
    
    self.authorImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.authorImageView.layer.borderWidth = 1.0f;
    
    self.legendCollectionView.collectionViewLayout = layout;
    self.selectionmageView.layer.borderColor = [UIColor blueColor].CGColor;
    self.selectionmageView.layer.borderWidth = 1.0f;
    self.selectionmageView.layer.cornerRadius = 15.0f;
    self.selectionmageView.layer.masksToBounds = YES;
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
    // NSLog(@"imp collection view");
    return self.legendsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // NSLog(@"cell for item");
    LegendCollectionViewCell *cell =(LegendCollectionViewCell*) [cv dequeueReusableCellWithReuseIdentifier:@"LegendCell" forIndexPath:indexPath];
    //cell.iconImageView.backgroundColor = [UIColor redColor];
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(6.5, 6.5, 12, 12)];
    //iconImage.backgroundColor = [UIColor redColor];
    iconImage.image = [UIImage imageNamed:[self.legendsArray objectAtIndex:indexPath.row]];
    [cell.contentView addSubview:iconImage];
    cell.contentView.layer.masksToBounds= YES;
    cell.contentView.layer.cornerRadius = 13.0f;
    cell.contentView.layer.borderWidth = 0.5f;
    cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.contentView.alpha = 0.5;
    return cell;
}
@end
