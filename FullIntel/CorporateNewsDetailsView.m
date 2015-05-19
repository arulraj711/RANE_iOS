//
//  DetailViewController.m
//  FullIntel
//
//  Created by Arul on 3/9/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "CorporateNewsDetailsView.h"
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
#import "FIUtils.h"
#import <QuartzCore/QuartzCore.h>
#import "SocialLinkCell.h"
#import "SocialWebView.h"
#import "MZFormSheetController.h"
#import "AddContentFirstLevelView.h"
#import "ShowDetailView.h"
@interface CorporateNewsDetailsView ()

@end

@implementation CorporateNewsDetailsView

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCuratedNewsDetails) name:@"CuratedNewsDetails" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCuratedNewsAuthorDetails) name:@"CuratedNewsAuthorDetails" object:nil];
    
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
    _authorImageView.layer.masksToBounds = YES;
    _authorImageView.layer.cornerRadius = 25.0f;
    [self.legendsCollectionView reloadData];
    //[self addGradientToView:self.gradiantImage];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Open Sans" size:20];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.text = @"Article";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    _articleWebview.scrollView.scrollEnabled = NO;
    self.socialLinkCollectionView.delegate = self;
    self.socialLinkCollectionView.dataSource = self;
    
    
    innerWebView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-80)];
    self.navigationItem.rightBarButtonItem =nil;
    self.cachedImageViewSize = self.articleImageView.frame;
    [self fetchDetailsFromList];
    [self setValuesFromExistingData];
}

-(void)viewDidAppear:(BOOL)animated {
    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@",self.selectedId];
    [fetchRequest setPredicate:predicate];
    NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if(newPerson.count != 0) {
        NSManagedObject *curatedNews = [newPerson objectAtIndex:0];
        curatedNewsDetail = [curatedNews valueForKey:@"details"];
        curatedNewsAuthorDetail = [curatedNews valueForKey:@"authorDetails"];
    }
    
    if(curatedNewsDetail == nil) {
        // NSLog(@"details is null");
        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
        [resultDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
        [resultDic setObject:self.selectedId forKey:@"selectedArticleId"];
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
        [[FISharedResources sharedResourceManager]getCuratedNewsDetailsWithDetails:resultStr];
        
        
        NSMutableDictionary *auhtorResultDic = [[NSMutableDictionary alloc] init];
        [auhtorResultDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
        [auhtorResultDic setObject:self.selectedId forKey:@"articleId"];
        NSData *authorJsondata = [NSJSONSerialization dataWithJSONObject:auhtorResultDic options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *authorResultStr = [[NSString alloc]initWithData:authorJsondata encoding:NSUTF8StringEncoding];
        [[FISharedResources sharedResourceManager]getCuratedNewsAuthorDetailsWithDetails:authorResultStr withArticleId:self.selectedId];
        
        
    }else{
        [self loadCuratedNewsDetails];
        [self loadCuratedNewsAuthorDetails];
    }
}

-(void)setValuesFromExistingData {
    //Setting Value
    self.articleTitle.text = self.titleStr;
    _articleDate.text = self.dateStr;
    [_articleImageView sd_setImageWithURL:[NSURL URLWithString:self.imageStr] placeholderImage:nil];
    [_articleImageView setContentMode:UIViewContentModeScaleAspectFill];
    if(self.outletStr.length == 0) {
        self.outletIconImage.hidden = YES;
        self.outletName.hidden = YES;
        self.outletIconWidthConstraint.constant = 0;
        self.outletTextWidthConstraint.constant = 0;
        self.outletHorizontalConstraint.constant = 0;
    }else {
        _outletName.text = self.outletStr;
        self.outletIconImage.hidden = NO;
        self.outletName.hidden = NO;
        self.outletIconWidthConstraint.constant = 12;
        //self.outletTextWidthConstraint.constant = 59;
        //self.outletHorizontalConstraint.constant = 0;
    }
    
    CGFloat width =  [self.outletStr sizeWithFont:[UIFont fontWithName:@"OpenSans" size:14 ]].width;
    NSLog(@"outlet text width:%f",width);
    if(width == 0) {
        
    }
    else if(width < 59) {
        
        CGFloat value = width;
        self.outletTextWidthConstraint.constant = value;
        self.outletHorizontalConstraint.constant = value+10;
    }else {
        
        CGFloat value = width;
        self.outletTextWidthConstraint.constant = value;
        self.outletHorizontalConstraint.constant = value+10;
    }
    
    _authorName.text = self.authorNameStr;
    _bottomAuthorName.text = self.authorNameStr;
    _authorTitle.text = self.authorTitleStr;
    
    
    [_authorImageView sd_setImageWithURL:[NSURL URLWithString:self.authorImageStr] placeholderImage:[UIImage imageNamed:@"userIcon_150"]];
    [_authorImageView setContentMode:UIViewContentModeScaleAspectFill];
}
-(void)fetchDetailsFromList{
        NSSet *authorSet = [self.curatedNews valueForKey:@"author"];
        NSMutableArray *authorArray = [[NSMutableArray alloc]initWithArray:[authorSet allObjects]];
        NSManagedObject *authors;
        if(authorArray.count != 0) {
             authors = [authorArray objectAtIndex:0];
        }
    
        self.titleStr = [self.curatedNews valueForKey:@"title"];
        self.imageStr = [self.curatedNews valueForKey:@"image"];
        self.articleDesc = [self.curatedNews valueForKey:@"desc"];
        self.dateStr = [FIUtils getDateFromTimeStamp:[[self.curatedNews valueForKey:@"date"] doubleValue]];
        self.outletStr = [self.curatedNews valueForKey:@"outlet"];
        self.selectedId = [self.curatedNews valueForKey:@"articleId"];
        self.authorNameStr = [authors valueForKey:@"name"];
        self.authorTitleStr = [authors valueForKey:@"title"];
        self.authorImageStr = [authors valueForKey:@"image"];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat y = -scrollView.contentOffset.y;
    //NSLog(@"scroll y value:%f",y);
    if (y > 64) {
        self.articleImageView.frame = CGRectMake(0, scrollView.contentOffset.y, self.cachedImageViewSize.size.width+y, self.cachedImageViewSize.size.height+y+64);
        self.articleImageView.center = CGPointMake(self.view.center.x, self.articleImageView.center.y+60);
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.scrollView setDelegate:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadCuratedNewsDetails {
    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@",self.selectedId];
    [fetchRequest setPredicate:predicate];
    NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if(newPerson.count != 0) {
        NSManagedObject *curatedNews = [newPerson objectAtIndex:0];
        curatedNewsDetail = [curatedNews valueForKey:@"details"];
    }
    
    NSLog(@"curated news details in load:%@",curatedNewsDetail);
    if(curatedNewsDetail != nil) {
        NSString *htmlString = [NSString stringWithFormat:@"<body style='color:#666e73;font-family:Open Sans;line-height: 1.7;font-size: 16px;font-weight: 310;'>%@",[curatedNewsDetail valueForKey:@"article"]];
        [_articleWebview loadHTMLString:htmlString baseURL:nil];
        
    }
    
    
    //NSString *dateStr = [FIUtils getDateFromTimeStamp:[[curatedNewsDetail valueForKey:@"articlePublisheddate"] doubleValue]];
    
    
    NSNumber *markImpStatus = [curatedNewsDetail valueForKey:@"markAsImportant"];
    if(markImpStatus == [NSNumber numberWithInt:1]) {
        NSLog(@"mark selected");
        [self.markedImpButton setSelected:YES];
    } else {
        NSLog(@"mark not selected");
        [self.markedImpButton setSelected:NO];
    }
    
    NSNumber *number = [curatedNewsDetail valueForKey:@"readStatus"];
    
    // BOOL isRead = [NSNumber numberWithBool:[curatedNews valueForKey:@"readStatus"]];
    if(number == [NSNumber numberWithInt:1]) {
        
    } else {
        NSLog(@"come inside read status change");
        [[NSNotificationCenter defaultCenter]postNotificationName:@"readStatusUpdate" object:nil userInfo:@{@"indexPath":self.selectedIndexPath,@"status":[NSNumber numberWithBool:YES]}];
        //Need to refresh Menu
        NSMutableDictionary *menuDic = [[NSMutableDictionary alloc] init];
        [menuDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] forKey:@"securityToken"];
        NSData *menuJsondata = [NSJSONSerialization dataWithJSONObject:menuDic options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *resultJson = [[NSString alloc]initWithData:menuJsondata encoding:NSUTF8StringEncoding];
        [[FISharedResources sharedResourceManager]getMenuListWithAccessToken:resultJson];
    }
    //    if([[curatedNews valueForKey:@"saveForLater"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
    //        [cell.savedForLaterButton setSelected:YES];
    //    } else {
    //        [cell.savedForLaterButton setSelected:NO];
    //    }
}



-(void)loadCuratedNewsAuthorDetails {
    
    
    
    
    
    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@",self.selectedId];
    [fetchRequest setPredicate:predicate];
    NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSManagedObject *curatedNews;
    if(newPerson.count != 0) {
        curatedNews = [newPerson objectAtIndex:0];
        //curatedNewsAuthorDetail = [curatedNews valueForKey:@"authorDetails"];
    }
    
    
    NSSet *authorSet = [curatedNews valueForKey:@"authorDetails"];
    NSMutableArray *legendsArray = [[NSMutableArray alloc]initWithArray:[authorSet allObjects]];
    NSManagedObject *author;
    if(legendsArray.count != 0) {
       author  = [legendsArray objectAtIndex:0];
    }
    self.socialLinksArray = [[NSMutableArray alloc]init];
    NSSet *socialLinkSet = [author valueForKey:@"authorSocialMedia"];
    self.socialLinksArray = [[NSMutableArray alloc]initWithArray:[socialLinkSet allObjects]];
    if(self.socialLinksArray.count == 0) {
        self.socialLinkLabel.hidden = YES;
        self.socialLinkDivider.hidden = YES;
        self.socialLinkCollectionView.hidden = YES;
    } else {
        self.socialLinkLabel.hidden = NO;
        self.socialLinkDivider.hidden = NO;
        self.socialLinkCollectionView.hidden = NO;
        self.socialLinkCollectionView.delegate = self;
        self.socialLinkCollectionView.dataSource = self;
        [self.socialLinkCollectionView reloadData];
    }
    NSString *authorName = [NSString stringWithFormat:@"%@ %@",[author valueForKey:@"firstName"],[author valueForKey:@"lastName"]];
    self.aboutAuthorName.text = authorName;
    self.bioLabel.text = [author valueForKey:@"bibliography"];
    
    if([[author valueForKey:@"isInfluencer"]isEqualToNumber:[NSNumber numberWithInt:1]]) {
        self.influencerIconImage.hidden = NO;
    } else {
        self.influencerIconImage.hidden = YES;
    }
    
    [self.aboutAuthorImageView sd_setImageWithURL:[NSURL URLWithString:[author valueForKey:@"imageURL"]] placeholderImage:[UIImage imageNamed:@"userIcon_150"]];
    [self.aboutAuthorImageView setContentMode:UIViewContentModeScaleAspectFill];
    
    NSSet *workTitleSet = [author valueForKey:@"authorWorkTitle"];
    NSMutableArray *workTitleArray = [[NSMutableArray alloc]initWithArray:[workTitleSet allObjects]];
    if(workTitleArray.count != 0) {
        NSManagedObject *workTitle = [workTitleArray objectAtIndex:0];
        self.authorWorkTitleLabel.text = [workTitle valueForKey:@"title"];
    } else {
        self.authorWorkTitleImageView.hidden = YES;
        self.workTitleHeightConstraint.constant = 0;
        self.workTitleImageHeightConstraint.constant = 0;
        self.workTitleTop.constant = 0;
        self.workTitleLabelTop.constant = 0;
    }
    
    NSSet *outletSet = [author valueForKey:@"authorOutlet"];
    NSMutableArray *outletArray = [[NSMutableArray alloc]initWithArray:[outletSet allObjects]];
    if(outletArray.count != 0) {
        NSManagedObject *outlet = [outletArray objectAtIndex:0];
        self.authorOutletName.text = [outlet valueForKey:@"outletname"];
    }else {
        self.authorOutletImageView.hidden = YES;
        self.outletHeightConstraint.constant = 0;
        self.outletImageViewHeightConstraint.constant = 0;
        self.outletTop.constant = 0;
        self.outletLabelTop.constant = 0;
    }
    if([[author valueForKey:@"starRating"] integerValue] == 0) {
        self.ratingControl.hidden = YES;
    } else {
        self.ratingControl.hidden = NO;
        self.starRating.rating = [[author valueForKey:@"starRating"] integerValue];
    }
    
    
    NSString *city = [author valueForKey:@"city"];
    NSString *country = [author valueForKey:@"country"];
    NSString *authorPlace;
    if(city.length == 0) {
        authorPlace = [NSString stringWithFormat:@"%@",country];
    } else if(country.length == 0) {
        authorPlace = [NSString stringWithFormat:@"%@",city];
    } else {
        authorPlace = [NSString stringWithFormat:@"%@, %@",city,country];
    }
    
    
    if(authorPlace.length !=0 ){
        self.authorLocationLabel.text = authorPlace;
    } else {
        self.authorLocationImageView.hidden = YES;
        self.locationImageViewHeightConstraint.constant = 0;
        self.locationLabelHeightConstraint.constant = 0;
        self.locationTop.constant = 0;
        self.locationLabelTop.constant = 0;
    }
    NSSet *beatSet = [author valueForKey:@"authorBeat"];
    NSMutableArray *beatsArray = [[NSMutableArray alloc]initWithArray:[beatSet allObjects]];
    NSMutableArray *beats = [[NSMutableArray alloc]init];
    for(NSManagedObject *beat in beatsArray) {
        [beats addObject:[NSString stringWithFormat:@"#%@",[beat valueForKey:@"name"]]];
    }
    NSString *beatString = [beats componentsJoinedByString:@" "];
    if(beatString.length != 0){
        self.authorTagLabel.text = beatString;
    } else {
        self.authorTagImageView.hidden = YES;
        self.tagImageViewHeightConstraint.constant = 0;
        self.tagLabelHeightConstraint.constant = 0;
        self.tagTop.constant = 0;
        self.tagLabelTop.constant = 0;
    }
    
    
    

}

- (void)addGradientToView:(UIImageView *)view
{
    UIColor *darkOp =
    [UIColor colorWithRed:0.62f green:0.4f blue:0.42f alpha:1.0];
    UIColor *lightOp =
    [UIColor colorWithRed:0.43f green:0.76f blue:0.07f alpha:1.0];
    
    // Create the gradient
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    // Set colors
    gradient.colors = [NSArray arrayWithObjects:
                       (id)lightOp.CGColor,
                       (id)darkOp.CGColor,
                       nil];
    gradient.locations = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0.0f],
                          [NSNumber numberWithFloat:0.2],
                          nil];
    // Set bounds
    gradient.frame = view.bounds;
    
    // Add the gradient to the view
    [view.layer insertSublayer:gradient atIndex:0];
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
        
    }else if(collectionView == self.socialLinkCollectionView) {
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
    if(view == self.legendsCollectionView) {
        itemCount = self.legendsArray.count;
    }else if(view == self.socialLinkCollectionView){
        itemCount = self.socialLinksArray.count;
    }else {
        itemCount = 3;
    }
    return itemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *collectionCell;
    if(cv == self.legendsCollectionView) {
        [self.legendsCollectionView registerClass:[LegendCollectionViewCell class]
                       forCellWithReuseIdentifier:@"LegendCell"];
        LegendCollectionViewCell *cell =(LegendCollectionViewCell*) [cv dequeueReusableCellWithReuseIdentifier:@"LegendCell" forIndexPath:indexPath];
        UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        iconImage.backgroundColor = [UIColor clearColor];
//        iconImage.layer.masksToBounds = YES;
//        iconImage.layer.cornerRadius = 20.0f;
        iconImage.layer.masksToBounds = YES;
        iconImage.layer.cornerRadius = 15.0f;
        iconImage.layer.borderColor = [UIColor whiteColor].CGColor;
        iconImage.layer.borderWidth = 1.5f;
       // iconImage.image =  [UIImage imageNamed:@"circle30"];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(7.5, 7.5, 15, 15)];
        image.backgroundColor = [UIColor clearColor];
        NSString *imageName = [NSString stringWithFormat:@"%@_white",[self.legendsArray objectAtIndex:indexPath.row]];
        NSLog(@"detail view image name:%@",imageName);
        image.image = [UIImage imageNamed:imageName];
        [iconImage addSubview:image];
        [cell.contentView addSubview:iconImage];
        collectionCell = cell;
    } else if(cv == self.socialLinkCollectionView) {
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


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did select social link");
    if(collectionView == self.socialLinkCollectionView) {
        
        NSManagedObject *socialLink = [self.socialLinksArray objectAtIndex:indexPath.row];
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];
        
        UINavigationController *modalController = [storyBoard instantiateViewControllerWithIdentifier:@"SocialWebView"];
        // UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"modal"];
        
        MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:modalController];
        
        formSheet.presentedFormSheetSize = CGSizeMake(850, 700);
        //    formSheet.transitionStyle = MZFormSheetTransitionStyleSlideFromTop;
        formSheet.shadowRadius = 2.0;
        formSheet.shadowOpacity = 0.3;
        formSheet.shouldDismissOnBackgroundViewTap = YES;
        formSheet.shouldCenterVertically = YES;
        formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
        // formSheet.keyboardMovementStyle = MZFormSheetKeyboardMovementStyleMoveToTop;
        // formSheet.keyboardMovementStyle = MZFormSheetKeyboardMovementStyleMoveToTopInset;
        // formSheet.landscapeTopInset = 50;
        // formSheet.portraitTopInset = 100;
        
        __weak MZFormSheetController *weakFormSheet = formSheet;
        
        
        // If you want to animate status bar use this code
        formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
            UINavigationController *navController = (UINavigationController *)weakFormSheet.presentedFSViewController;
            if ([navController.topViewController isKindOfClass:[SocialWebView class]]) {
                SocialWebView *mzvc = (SocialWebView *)navController.topViewController;
                mzvc.urlString = [socialLink valueForKey:@"url"];
                //  mzvc.showStatusBar = NO;
            }
            
            
            [UIView animateWithDuration:0.3 animations:^{
                if ([weakFormSheet respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                    [weakFormSheet setNeedsStatusBarAppearanceUpdate];
                }
            }];
        };
        
        formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
            // Passing data
            UINavigationController *navController = (UINavigationController *)presentedFSViewController;
            NSString *titleStr = [NSString stringWithFormat:@"%@ in %@",self.authorNameStr,[socialLink valueForKey:@"mediatype"]];
            navController.topViewController.title = titleStr;
            
            navController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
            SocialWebView *mzvc = (SocialWebView *)navController.topViewController;
            mzvc.urlString = [socialLink valueForKey:@"url"];
        };
        formSheet.transitionStyle = MZFormSheetTransitionStyleCustom;
        
        [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
        
        [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
            
        }];

    }
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    
    CGSize mWebViewTextSize = [webView sizeThatFits:CGSizeMake(1.0f, 1.0f)];  // Pass about any size
    
    CGRect mWebViewFrame = webView.frame;
    
    
    mWebViewFrame.size.height = mWebViewTextSize.height;
    
    webView.frame = mWebViewFrame;
    
    
    //Disable bouncing in webview
    for (id subview in webView.subviews)
    {
        if ([[subview class] isSubclassOfClass: [UIScrollView class]])
        {
            [subview setBounces:NO];
        }
    }
    
    
    
    
    
    
//    [self.articleWebview sizeToFit];
  self.webViewHeightConstraint.constant = webView.frame.size.height;
//    webView.frame = CGRectMake(webView.frame.origin.x, webView.frame.origin.y, webView.frame.size.width, webView.frame.size.height);
////    NSLog(@"webview height:%f",self.webViewHeightConstraint.constant);
////    self.collectionViewHeightConstraint.constant = 1000;
////    if(self.webViewHeightConstraint.constant > self.collectionViewHeightConstraint.constant) {
////        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.webViewHeightConstraint.constant+900);
        //self.twitterLabelTopConstraint.constant = 55;
//    }else if(self.webViewHeightConstraint.constant < self.collectionViewHeightConstraint.constant){
//        self.twitterLabelTopConstraint.constant = self.collectionViewHeightConstraint.constant-self.webViewHeightConstraint.constant;
//    }
//    
    //self.ratingControl = [[AMRatingControl alloc]initWithFrame:self.ratingControl.frame];
    self.starRating = [[AMRatingControl alloc]initWithLocation:CGPointMake(0, 0) emptyColor:[UIColor colorWithRed:161/255.0 green:16/255.0 blue:27/255.0 alpha:1.0] solidColor:[UIColor colorWithRed:161/255.0 green:16/255.0 blue:27/255.0 alpha:1.0] andMaxRating:5];
    self.starRating.userInteractionEnabled = NO;
    [self.ratingControl addSubview:self.starRating];
}

- (IBAction)commentsButtonClick:(UIButton *)sender {
    CommentsPopoverView *popOverView = [[CommentsPopoverView alloc]initWithNibName:@"CommentsPopoverView" bundle:nil];
    self.popOver =[[UIPopoverController alloc] initWithContentViewController:popOverView];
    self.popOver.popoverContentSize=CGSizeMake(400, 300);
    //self.popOver.delegate = self;
    [self.popOver presentPopoverFromRect:sender.frame inView:self.bottomView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}
- (IBAction)mailButtonClick:(UIButton *)sender {
    mailComposer = [[MFMailComposeViewController alloc]init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setSubject:self.titleStr];
    
    NSString *mailBodyStr = [NSString stringWithFormat:@"%@\n\n%@",self.articleDesc,[curatedNewsDetail valueForKey:@"articleUrl"]];
    
    [mailComposer setMessageBody:mailBodyStr isHTML:NO];
    //[self presentModalViewController:mailComposer animated:YES];
    [self presentViewController:mailComposer animated:YES completion:nil];
}
#pragma mark - mail compose delegate
-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (result) {
        NSLog(@"Result : %d",result);
    }
    if (error) {
        NSLog(@"Error : %@",error);
    }
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)moreButtonClick:(UIButton *)sender {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MorePopoverView" bundle:nil];
    
    MorePopoverView *popOverView = [storyBoard instantiateViewControllerWithIdentifier:@"MorePopoverView"];
    popOverView.articleTitle = [curatedNewsDetail valueForKey:@"articleHeading"];
    popOverView.articleUrl = [curatedNewsDetail valueForKey:@"articleUrl"];
    popOverView.articleImageUrl = [curatedNewsDetail valueForKey:@"articleImageURL"];
    self.popOver =[[UIPopoverController alloc] initWithContentViewController:popOverView];
    self.popOver.popoverContentSize=CGSizeMake(350, 250);
    //self.popOver.delegate = self;
    [self.popOver presentPopoverFromRect:sender.frame inView:self.bottomView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}
- (IBAction)researchRequestButtonClick:(UIButton *)sender {
    ResearchRequestPopoverView *popOverView = [[ResearchRequestPopoverView alloc]initWithNibName:@"ResearchRequestPopoverView" bundle:nil];
    popOverView.articleId = [curatedNewsDetail valueForKey:@"articleId"];
    popOverView.articleTitle = [curatedNewsDetail valueForKey:@"articleHeading"];
    self.popOver =[[UIPopoverController alloc] initWithContentViewController:popOverView];
    self.popOver.popoverContentSize=CGSizeMake(400, 260);
    //self.popOver.delegate = self;
    [self.popOver presentPopoverFromRect:sender.frame inView:self.bottomView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

- (IBAction)savedListButtonClick:(UIButton *)sender {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"SavedListPopoverView" bundle:nil];
    
    SavedListPopoverView *popOverView = [storyBoard instantiateViewControllerWithIdentifier:@"SavedList"];
    self.popOver =[[UIPopoverController alloc] initWithContentViewController:popOverView];
    self.popOver.popoverContentSize=CGSizeMake(350, 267);
    //self.popOver.delegate = self;
    [self.popOver presentPopoverFromRect:sender.frame inView:self.bottomView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

- (IBAction)markedImpButtonClick:(UIButton *)sender {
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
    [resultDic setObject:[curatedNewsDetail valueForKey:@"articleId"] forKey:@"selectedArticleId"];
    [resultDic setObject:@"2" forKey:@"status"];
   
    
    
    if(sender.selected) {
        [sender setSelected:NO];
        [resultDic setObject:@"false" forKey:@"isSelected"];
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
        
        [curatedNewsDetail setValue:[NSNumber numberWithBool:NO] forKey:@"markAsImportant"];
        
        [[FISharedResources sharedResourceManager]setUserActivitiesOnArticlesWithDetails:resultStr];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"markedImportantUpdate" object:nil userInfo:@{@"indexPath":self.selectedIndexPath,@"status":[NSNumber numberWithBool:NO]}];
        [self.view makeToast:@"Unchecked from Important List!" duration:1.5 position:CSToastPositionCenter];
    }else {
        [sender setSelected:YES];
        [resultDic setObject:@"true" forKey:@"isSelected"];
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
        
        [curatedNewsDetail setValue:[NSNumber numberWithBool:YES] forKey:@"markAsImportant"];
        
        NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
        [[FISharedResources sharedResourceManager]setUserActivitiesOnArticlesWithDetails:resultStr];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"markedImportantUpdate" object:nil userInfo:@{@"indexPath":self.selectedIndexPath,@"status":[NSNumber numberWithBool:YES]}];
        [self.view makeToast:@"Marked Important!" duration:1.5 position:CSToastPositionCenter];
    }
    
}
- (IBAction)saveButtonClick:(UIButton *)sender {
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
    [resultDic setObject:[curatedNewsDetail valueForKey:@"articleId"] forKey:@"selectedArticleId"];
    [resultDic setObject:@"3" forKey:@"status"];
    
    
    
    if(sender.selected) {
        [sender setSelected:NO];
        [resultDic setObject:@"false" forKey:@"isSelected"];
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
        
        [curatedNewsDetail setValue:[NSNumber numberWithBool:NO] forKey:@"saveForLater"];
        
        [[FISharedResources sharedResourceManager]setUserActivitiesOnArticlesWithDetails:resultStr];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"saveForLaterUpdate" object:nil userInfo:@{@"indexPath":self.selectedIndexPath,@"status":[NSNumber numberWithBool:NO]}];
        [self.view makeToast:@"Removed from Saved List!" duration:1.5 position:CSToastPositionCenter];
    }else {
        [sender setSelected:YES];
        [resultDic setObject:@"true" forKey:@"isSelected"];
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
        
        [curatedNewsDetail setValue:[NSNumber numberWithBool:YES] forKey:@"saveForLater"];
        
        NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
        [[FISharedResources sharedResourceManager]setUserActivitiesOnArticlesWithDetails:resultStr];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"saveForLaterUpdate" object:nil userInfo:@{@"indexPath":self.selectedIndexPath,@"status":[NSNumber numberWithBool:YES]}];
        [self.view makeToast:@"Saved Successfully!" duration:1.5 position:CSToastPositionCenter];
    }
}

- (IBAction)globeButtonClick:(UIButton *)sender {
    NSLog(@"globe button click");
    
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         innerWebView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-144);

                         
                         UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, innerWebView.frame.size.width, innerWebView.frame.size.height)];
                          webView.backgroundColor = [UIColor whiteColor];
                         NSURL *url = [NSURL URLWithString:[curatedNewsDetail valueForKey:@"articleUrl"]];
                         NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
                         [webView loadRequest:requestObj];
                         [innerWebView addSubview:webView];
                         innerWebView.backgroundColor = [UIColor whiteColor];
                         self.navigationItem.hidesBackButton = YES;
                         UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                         [button addTarget:self action:@selector(closeWebView)
                          forControlEvents:UIControlEventTouchUpInside];
                         [button setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
                         // [button setTitle:@"Show View" forState:UIControlStateNormal];
                         button.frame = CGRectMake(0, 10, 28, 28);
                         UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
                         self.navigationItem.rightBarButtonItem = customBarItem;
                     }
                     completion:^(BOOL finished){
                     }];
    [self.view addSubview:innerWebView];
}

-(void)closeWebView {
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         innerWebView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-80);
                     }
                     completion:^(BOOL finished){
                         if (finished)
                             [innerWebView removeFromSuperview];
                         self.navigationItem.hidesBackButton = NO;
                         self.navigationItem.rightBarButtonItem = nil;
                     }];
}
@end
