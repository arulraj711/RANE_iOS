//
//  CICell.m
//  FullIntel
//
//  Created by cape start on 22/09/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "CICell.h"
#import "IssueMonitoringCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation CICell

- (void)awakeFromNib {
    // Initialization code
    self.articleImage.layer.masksToBounds = YES;
    self.articleImage.layer.cornerRadius = 10.0f;
    self.articleImage.layer.borderColor = [UIColor colorWithRed:(237/255.0) green:(240/255.0) blue:(240/255.0) alpha:1].CGColor;
    self.articleImage.layer.borderWidth = 0.5f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/* CollectionView datasource */
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.subChartImageArrayList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // NSLog(@"collectionview cell for item");
    IssueMonitoringCell *cell = (IssueMonitoringCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    // cell.cellOuterView.layer.masksToBounds = YES;
    // cell.cellOuterView.layer.cornerRadius = 60;
    // cell.cellOuterView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    // cell.cellOuterView.layer.borderWidth = 1;
    NSDictionary *issueDic = [self.subChartNameArrayList objectAtIndex:indexPath.row];
    
    cell.title.text = [issueDic objectForKey:@"name"];
    cell.cntLabel.text = [issueDic objectForKey:@"count"];
    
    //if([self.selectedItemArray containsObject:[issueDic objectForKey:@"name"]]) {
    //cell.cellOuterView.backgroundColor = UIColorFromRGB(0Xebebeb);
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[self.subChartImageArrayList objectAtIndex:indexPath.row]] placeholderImage:nil];
    // self.selectedTitle.text = [issueDic objectForKey:@"name"];
    // } else {
    // cell.cellOuterView.backgroundColor = [UIColor whiteColor];
    // }
    return cell;
}


@end
