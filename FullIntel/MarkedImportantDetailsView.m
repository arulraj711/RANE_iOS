//
//  MarkedImportantDetailsView.m
//  FullIntel
//
//  Created by Arul on 3/9/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "MarkedImportantDetailsView.h"
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
@interface MarkedImportantDetailsView ()

@end

@implementation MarkedImportantDetailsView

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
    
    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@",self.selectedId];
    [fetchRequest setPredicate:predicate];
    NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
  //  NSManagedObject *curatedNews = [newPerson objectAtIndex:0];
  //  curatedNewsDetail = [curatedNews valueForKey:@"details"];
    self.articleTitle.text = [curatedNewsDetail valueForKey:@"articleHeading"];
    [_articleImageView sd_setImageWithURL:[NSURL URLWithString:[curatedNewsDetail valueForKey:@"articleImageURL"]] placeholderImage:nil];
    [_articleImageView setContentMode:UIViewContentModeScaleAspectFill];
    NSString *htmlString = [NSString stringWithFormat:@"<body style='color:#666e73;font-family:Open Sans;line-height: 1.8;font-size: 15px;'>%@",[curatedNewsDetail valueForKey:@"article"]];
    [_articleWebview loadHTMLString:htmlString baseURL:nil];
    NSString *dateStr = [FIUtils getDateFromTimeStamp:[[curatedNewsDetail valueForKey:@"articlePublisheddate"] doubleValue]];
    _articleDate.text = dateStr;
    //_outletName.text = [curatedNewsDetail valueForKey:@"outletname"];
    _outletName.text = self.outletStr;
    if([[curatedNewsDetail valueForKey:@"markAsImportant"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
        [self.markedImpButton setSelected:YES];
    } else {
        [self.markedImpButton setSelected:NO];
    }
    //    if([[curatedNews valueForKey:@"saveForLater"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
    //        [cell.savedForLaterButton setSelected:YES];
    //    } else {
    //        [cell.savedForLaterButton setSelected:NO];
    //    }
    
    NSSet *authorSet = [curatedNewsDetail valueForKey:@"author"];
    NSMutableArray *authorArray = [[NSMutableArray alloc]initWithArray:[authorSet allObjects]];
    NSLog(@"author array:%@",authorArray);
    if(authorArray.count != 0) {
        self.author = [authorArray objectAtIndex:0];
    }
    
    //NSLog(@"selected author:%@",self.author);
    _authorName.text = self.authorNameStr;
    _bottomAuthorName.text = self.authorNameStr;
    if([[self.author valueForKey:@"title"]isEqualToString:@""]) {
        _authorTitle.text = @"Editor";
    }else {
        _authorTitle.text = [self.author valueForKey:@"title"];
    }
    _authorTitle.text = self.authorTitleStr;
    
    UIImageView *placeHolderImg = [[UIImageView alloc]init];
    [placeHolderImg sd_setImageWithURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/184003479/fullIntel/no_image/noAuthor1.png"] placeholderImage:nil];
    
    [_authorImageView sd_setImageWithURL:[NSURL URLWithString:self.authorImageStr] placeholderImage:placeHolderImg.image];
    [_authorImageView setContentMode:UIViewContentModeScaleAspectFill];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    
    
    //    CAGradientLayer *gradient = [CAGradientLayer layer];
    //    gradient.frame = view.bounds;
    ////    gradient.colors = @[(id)[[UIColor lightGrayColor] CGColor]
    ////                        ];
    //    gradient.colors =@[(id)[UIColor redColor].CGColor];
    //    gradient.startPoint =CGPointMake(0, .5);
    //    gradient.endPoint =CGPointMake(1, .5);
    //    [view.layer addSublayer:gradient];
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
        UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        iconImage.backgroundColor = [UIColor clearColor];
        iconImage.image =  [UIImage imageNamed:@"circle30"];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(7.5, 7.5, 15, 15)];
        image.backgroundColor = [UIColor clearColor];
        NSString *imageName = [NSString stringWithFormat:@"%@_white",[self.legendsArray objectAtIndex:indexPath.row]];
        NSLog(@"detail view image name:%@",imageName);
        image.image = [UIImage imageNamed:imageName];
        [iconImage addSubview:image];
        [cell.contentView addSubview:iconImage];
        
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
    NSLog(@"webview height:%f",self.webViewHeightConstraint.constant);
    self.collectionViewHeightConstraint.constant = 1000;
    if(self.webViewHeightConstraint.constant > self.collectionViewHeightConstraint.constant) {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.webViewHeightConstraint.constant+700);
        //        self.twitterLabelTopConstraint.constant = self.webViewHeightConstraint.constant-self.collectionViewHeightConstraint.constant;
    }else if(self.webViewHeightConstraint.constant < self.collectionViewHeightConstraint.constant){
        self.twitterLabelTopConstraint.constant = self.collectionViewHeightConstraint.constant-self.webViewHeightConstraint.constant;
    }
    
}

- (IBAction)commentsButtonClick:(UIButton *)sender {
    CommentsPopoverView *popOverView = [[CommentsPopoverView alloc]initWithNibName:@"CommentsPopoverView" bundle:nil];
    self.popOver =[[UIPopoverController alloc] initWithContentViewController:popOverView];
    self.popOver.popoverContentSize=CGSizeMake(400, 300);
    //self.popOver.delegate = self;
    [self.popOver presentPopoverFromRect:sender.frame inView:self.bottomView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}
- (IBAction)mailButtonClick:(UIButton *)sender {
    MailPopoverView *popOverView = [[MailPopoverView alloc]initWithNibName:@"MailPopoverView" bundle:nil];
    self.popOver =[[UIPopoverController alloc] initWithContentViewController:popOverView];
    self.popOver.popoverContentSize=CGSizeMake(400, 300);
    //self.popOver.delegate = self;
    [self.popOver presentPopoverFromRect:sender.frame inView:self.bottomView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}
- (IBAction)moreButtonClick:(UIButton *)sender {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MorePopoverView" bundle:nil];
    
    MorePopoverView *popOverView = [storyBoard instantiateViewControllerWithIdentifier:@"MorePopoverView"];
    self.popOver =[[UIPopoverController alloc] initWithContentViewController:popOverView];
    self.popOver.popoverContentSize=CGSizeMake(350, 250);
    //self.popOver.delegate = self;
    [self.popOver presentPopoverFromRect:sender.frame inView:self.bottomView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}
- (IBAction)researchRequestButtonClick:(UIButton *)sender {
    ResearchRequestPopoverView *popOverView = [[ResearchRequestPopoverView alloc]initWithNibName:@"ResearchRequestPopoverView" bundle:nil];
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
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
    NSLog(@"result string for mark as important:%@",resultStr);
    [[FISharedResources sharedResourceManager]setUserActivitiesOnArticlesWithDetails:resultStr];
    if(sender.selected) {
        [sender setSelected:NO];
        [self.view makeToast:@"Unchecked from Important List!" duration:1.5 position:CSToastPositionCenter];
    }else {
        [sender setSelected:YES];
        [self.view makeToast:@"Marked Important!" duration:1.5 position:CSToastPositionCenter];
    }
    
}
- (IBAction)saveButtonClick:(UIButton *)sender {
    [self.view makeToast:@"Saved Successfully!" duration:1.5 position:CSToastPositionCenter];
}
@end
