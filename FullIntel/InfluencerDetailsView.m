//
//  InfluencerDetailsView.m
//  FullIntel
//
//  Created by Arul on 3/30/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "InfluencerDetailsView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LegendCollectionViewCell.h"
#import "NHAlignmentFlowLayout.h"
#import "PersonalityWidgetCell.h"
#import "StockWidgetCell.h"
#import "ProductWidgetCell.h"
#import "CommentsPopoverView.h"
#import "MailPopoverView.h"
#import "SavedListPopoverView.h"
#import "ResearchRequestPopoverView.h"
#import "MorePopoverView.h"
#import "UIView+Toast.h"
#import "FISharedResources.h"

@interface InfluencerDetailsView ()

@end

@implementation InfluencerDetailsView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NHAlignmentFlowLayout *layout = [[NHAlignmentFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(2.5, 0, 0, 0);
    layout.alignment = NHAlignmentBottomRightAligned;
    layout.itemSize = CGSizeMake(40, 40);
    layout.minimumInteritemSpacing = 3.0;
    layout.minimumLineSpacing = 1.0;
    self.legendsCollectionView.collectionViewLayout = layout;
    
    //Author ImageView Code
    [_authorImageView sd_setImageWithURL:[NSURL URLWithString:@"http://s9.postimg.org/dufyh9oln/Brad_Reed.jpg"] placeholderImage:nil];
    _authorImageView.layer.masksToBounds = YES;
    _authorImageView.layer.cornerRadius = 25.0f;
    
    [self.legendsCollectionView reloadData];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Open Sans" size:20];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.text = @"Article";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    _articleWebview.scrollView.scrollEnabled = NO;
    
    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Influencer"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@",self.selectedId];
    [fetchRequest setPredicate:predicate];
    NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSManagedObject *influencer = [newPerson objectAtIndex:0];
    NSManagedObject *influencerDetail = [influencer valueForKey:@"details"];
    self.articleTitle.text = [influencerDetail valueForKey:@"title"];
    [_articleImageView sd_setImageWithURL:[NSURL URLWithString:[influencerDetail valueForKey:@"image"]] placeholderImage:nil];
    [_articleImageView setContentMode:UIViewContentModeScaleAspectFill];
    NSString *htmlString = [NSString stringWithFormat:@"<font face='Open Sans' size='4' line-height='1.7'>%@",[influencerDetail valueForKey:@"desc"]];
    [_articleWebview loadHTMLString:htmlString baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if(view == self.legendsCollectionView) {
        itemCount = self.legendsArray.count;
    }else {
        itemCount = 3;
    }
    return itemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    if(cv == self.legendsCollectionView) {
        [self.legendsCollectionView registerClass:[LegendCollectionViewCell class]
                       forCellWithReuseIdentifier:@"LegendCell"];
        cell =(LegendCollectionViewCell*) [cv dequeueReusableCellWithReuseIdentifier:@"LegendCell" forIndexPath:indexPath];
        UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(7.5, 7.5, 15, 15)];
        NSString *imageName = [NSString stringWithFormat:@"%@_white",[self.legendsArray objectAtIndex:indexPath.row]];
       // NSLog(@"detail view image name:%@",imageName);
        iconImage.image = [UIImage imageNamed:imageName];
        
        [cell.contentView addSubview:iconImage];
        cell.contentView.layer.masksToBounds= YES;
        cell.contentView.layer.cornerRadius = 15.0f;
        cell.contentView.layer.borderWidth = 1.5f;
        cell.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
    }else {
        if(indexPath.row == 0) {
            [self.widgetCollectionView registerClass:[PersonalityWidgetCell class]
                          forCellWithReuseIdentifier:@"Personality"];
            [self.widgetCollectionView registerNib:[UINib nibWithNibName:@"PersonalityWidgetCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"Personality"];
            
            cell =(PersonalityWidgetCell*) [cv dequeueReusableCellWithReuseIdentifier:@"Personality" forIndexPath:indexPath];
            cell.contentView.layer.borderWidth = 1.0f;
            cell.contentView.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
        } else if(indexPath.row == 1) {
            [self.widgetCollectionView registerClass:[StockWidgetCell class]
                          forCellWithReuseIdentifier:@"stock"];
            [self.widgetCollectionView registerNib:[UINib nibWithNibName:@"StockWidgetCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"stock"];
            
            cell =(PersonalityWidgetCell*) [cv dequeueReusableCellWithReuseIdentifier:@"stock" forIndexPath:indexPath];
            cell.contentView.layer.borderWidth = 1.0f;
            cell.contentView.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
        } else if(indexPath.row == 2) {
            [self.widgetCollectionView registerClass:[ProductWidgetCell class]
                          forCellWithReuseIdentifier:@"product"];
            [self.widgetCollectionView registerNib:[UINib nibWithNibName:@"ProductWidgetCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"product"];
            
            cell =(ProductWidgetCell*) [cv dequeueReusableCellWithReuseIdentifier:@"product" forIndexPath:indexPath];
            cell.contentView.layer.borderWidth = 1.0f;
            cell.contentView.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
        }
    }
    return cell;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.articleWebview sizeToFit];
    self.webViewHeightConstraint.constant = self.articleWebview.frame.size.height;
    self.collectionViewHeightConstraint.constant = 1000;
    if(self.webViewHeightConstraint.constant > self.collectionViewHeightConstraint.constant) {
        //        self.twitterLabelTopConstraint.constant = self.webViewHeightConstraint.constant-self.collectionViewHeightConstraint.constant;
    }else if(self.webViewHeightConstraint.constant < self.collectionViewHeightConstraint.constant){
        self.twitterLabelTopConstraint.constant = self.collectionViewHeightConstraint.constant-self.webViewHeightConstraint.constant;
    }
    
}

- (IBAction)commentsButtonClick:(UIButton *)sender {
    CommentsPopoverView *popOverView = [[CommentsPopoverView alloc]initWithNibName:@"CommentsPopoverView" bundle:nil];
    self.popOver =[[UIPopoverController alloc] initWithContentViewController:popOverView];
    //self.popOver.backgroundColor = [UIColor blueColor];
    self.popOver.popoverContentSize=CGSizeMake(400, 300);
    //self.popOver.delegate = self;
    [self.popOver presentPopoverFromRect:sender.frame inView:self.bottomView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}
- (IBAction)mailButtonClick:(UIButton *)sender {
    MailPopoverView *popOverView = [[MailPopoverView alloc]initWithNibName:@"MailPopoverView" bundle:nil];
    self.popOver =[[UIPopoverController alloc] initWithContentViewController:popOverView];
    //self.popOver.backgroundColor = [UIColor blueColor];
    self.popOver.popoverContentSize=CGSizeMake(400, 300);
    //self.popOver.delegate = self;
    [self.popOver presentPopoverFromRect:sender.frame inView:self.bottomView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}
- (IBAction)moreButtonClick:(UIButton *)sender {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MorePopoverView" bundle:nil];
    
    MorePopoverView *popOverView = [storyBoard instantiateViewControllerWithIdentifier:@"MorePopoverView"];
    self.popOver =[[UIPopoverController alloc] initWithContentViewController:popOverView];
    //self.popOver.backgroundColor = [UIColor blueColor];
    self.popOver.popoverContentSize=CGSizeMake(350, 250);
    //self.popOver.delegate = self;
    [self.popOver presentPopoverFromRect:sender.frame inView:self.bottomView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}
- (IBAction)researchRequestButtonClick:(UIButton *)sender {
    ResearchRequestPopoverView *popOverView = [[ResearchRequestPopoverView alloc]initWithNibName:@"ResearchRequestPopoverView" bundle:nil];
    self.popOver =[[UIPopoverController alloc] initWithContentViewController:popOverView];
    //self.popOver.backgroundColor = [UIColor blueColor];
    self.popOver.popoverContentSize=CGSizeMake(400, 260);
    //self.popOver.delegate = self;
    [self.popOver presentPopoverFromRect:sender.frame inView:self.bottomView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

- (IBAction)savedListButtonClick:(UIButton *)sender {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"SavedListPopoverView" bundle:nil];
    
    SavedListPopoverView *popOverView = [storyBoard instantiateViewControllerWithIdentifier:@"SavedList"];
    self.popOver =[[UIPopoverController alloc] initWithContentViewController:popOverView];
    //self.popOver.backgroundColor = [UIColor blueColor];
    self.popOver.popoverContentSize=CGSizeMake(350, 267);
    //self.popOver.delegate = self;
    [self.popOver presentPopoverFromRect:sender.frame inView:self.bottomView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

- (IBAction)markedImpButtonClick:(UIButton *)sender {
    [self.view makeToast:@"Marked Important!" duration:1.5 position:CSToastPositionCenter];
}
- (IBAction)saveButtonClick:(UIButton *)sender {
    [self.view makeToast:@"Saved Successfully!" duration:1.5 position:CSToastPositionCenter];
}

@end
