//
//  DealsViewController.m
//  FullIntel
//
//  Created by cape start on 29/05/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "DealsViewController.h"
#import "CorporateDetailCell.h"
#import "PersonalityWidgetCell.h"
#import "StockWidgetCell.h"
#import "ProductWidgetCell.h"
#import "SocialLinkCell.h"
#import "TweetsCell.h"
#import "MZFormSheetController.h"
#import "SocialWebView.h"
#import "ResearchRequestPopoverView.h"
#import "UIView+Toast.h"
#import "CommentsPopoverView.h"
#import "FISharedResources.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <TwitterKit/TwitterKit.h>
#import "FIUtils.h"
#import "SavedListPopoverView.h"
#import "MorePopoverView.h"
#import "CompanyCell.h"
#import "TimeLineCell.h"
#import "CompetitorCell.h"
#import "FIUtils.h"


#define UIColorFromRGB(rgbValue)[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface DealsViewController ()

@end

@implementation DealsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _requestUpgradeButton.layer.borderColor=[[UIColor darkGrayColor]CGColor];
    _requestUpgradeButton.layer.borderWidth=1.5;
    _requestUpgradeButton.layer.cornerRadius=5.0;
  
    
    NSMutableAttributedString *attriString=[[NSMutableAttributedString alloc]initWithString:@"DEALS provides stock market information and top stories on a list of companies that you are watching"];
    
    [attriString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Bold" size:20] range:NSMakeRange(0,5)];
    
    [attriString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0XA4131E) range:NSMakeRange(0,5)];
    
    _DealsLabel.attributedText=attriString;
    
    
       [_firstCompanyImageView sd_setImageWithURL:[NSURL URLWithString:@"http://archiveteam.org/images/thumb/b/bc/Verizon_Logo.png/800px-Verizon_Logo.png"] placeholderImage:[UIImage imageNamed:@"FI"]];
    
        [_secondCampanyImageView sd_setImageWithURL:[NSURL URLWithString:@"http://img4.wikia.nocookie.net/__cb20130101110037/logopedia/images/0/0c/1000px-AOL_logo.svg.png"] placeholderImage:[UIImage imageNamed:@"FI"]];
    

    
    
//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/184003479/fullIntel/testdata/dealsDril.html"]];
//    [_dealsWebView loadRequest:urlRequest];
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"dealsDril" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [_dealsWebView loadHTMLString:htmlString baseURL:nil];
    
            [_authorImageBigView sd_setImageWithURL:[NSURL URLWithString:@"https://media.licdn.com/mpr/mpr/shrinknp_400_400/p/8/005/07a/0c9/315cf95.jpg"] placeholderImage:[UIImage imageNamed:@"FI"]];
    
            [_authorImageView sd_setImageWithURL:[NSURL URLWithString:@"https://media.licdn.com/mpr/mpr/shrinknp_400_400/p/8/005/07a/0c9/315cf95.jpg"] placeholderImage:[UIImage imageNamed:@"FI"]];
    
    
    [FIUtils makeRoundedView:_authorImageView];
    
    
    _overlayView.layer.cornerRadius=5.0f;
    _overlayView.clipsToBounds=YES;
    
    
    UIButton *Btn =[UIButton buttonWithType:UIButtonTypeCustom];
    
    [Btn setFrame:CGRectMake(0.0f,0.0f,16.0f,15.0f)];
    [Btn setBackgroundImage:[UIImage imageNamed:@"navmenu"]  forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(backBtnPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    [self.navigationItem setLeftBarButtonItem:addButton];
    
//    
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Deals" bundle:nil];
//    
//    UIViewController *popOverView = [storyBoard instantiateViewControllerWithIdentifier:@"overlayView"];
//    self.popOver =[[UIPopoverController alloc] initWithContentViewController:popOverView];
//    self.popOver.popoverContentSize=CGSizeMake(350, 267);
//    //self.popOver.delegate = self;
//    [self.popOver presentPopoverFromRect:CGRectMake(500, 1000, 100, 100) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    
    
    
    _rotateView.transform = CGAffineTransformMakeRotation(-0.6);

    
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    

    UITextView *tv = object;
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    tv.font=[UIFont fontWithName:@"OpenSans" size:50.0];
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.sampleDataText addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
        [self.sampleDataText removeObserver:self forKeyPath:@"contentSize"];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backBtnPress {
    
    
    if(self.revealController.state == PKRevealControllerShowsLeftViewControllerInPresentationMode) {
        NSLog(@"left view opened");
        [self.revealController showViewController:self.revealController.frontViewController];
    } else {
        NSLog(@"left view closed");
        [self.revealController showViewController:self.revealController.leftViewController];
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UICollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(collectionView == self.widgetCollectionView) {
        if(indexPath.row == 0) {
            return CGSizeMake(400, 540);
        } else if(indexPath.row == 1) {
            return CGSizeMake(400, 310);
        } else if(indexPath.row == 2) {
            return CGSizeMake(400, 310);
        }
        
    }
    else if(collectionView == self.socialCollectionView) {
        return CGSizeMake(50, 50);
    } else if(collectionView == self.twitterCollectionView) {
        return CGSizeMake(320, 300);
    }
    return CGSizeMake(30, 30);
}


- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {

    NSInteger itemCount;

    if(view == self.socialCollectionView){
        itemCount = 1;
    }else if(view == self.twitterCollectionView) {
        itemCount = 1;
    }else {
        itemCount = 3;
    }
    return itemCount;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *collectionCell;
    
    if(cv == self.socialCollectionView) {
        // NSLog(@"inside social link collectionview cellfor item");
//        NSManagedObject *socialLink = [self.socialLinksArray objectAtIndex:indexPath.row];
//        
        SocialLinkCell *socialCell =(SocialLinkCell*) [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
//        if([[socialLink valueForKey:@"mediatype"] isEqualToString:@"Twitter"]) {
//            socialCell.iconImage.image = [UIImage imageNamed:@"Twitter-1"];
//        } else {
//            socialCell.iconImage.image = [UIImage imageNamed:[socialLink valueForKey:@"mediatype"]];
//        }
//        
//        if([[socialLink valueForKey:@"isactive"]isEqualToNumber:[NSNumber numberWithInt:1]]) {
//            socialCell.blueCircleView.hidden = NO;
//        } else {
//            socialCell.blueCircleView.hidden = YES;
//        }
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
        
         socialCell.iconImage.image = [UIImage imageNamed:@"Twitter-1"];
         socialCell.blueCircleView.hidden = YES;
        collectionCell = socialCell;
        
    } else if(cv == self.twitterCollectionView) {
        TweetsCell *tweetCell =(TweetsCell*) [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
//        TWTRTweet *tweetObj = [tweetArray objectAtIndex:indexPath.row];
//        TWTRUser *author = tweetObj.author;
//        NSLog(@"twitter authro:%@",author.name);
//        NSLog(@"twitter text:%@",tweetObj.text);
//        NSLog(@"twitter retweet cnt:%lld",tweetObj.retweetCount);
//        NSLog(@"twitter favourate cnt:%lld",tweetObj.favoriteCount);
//        tweetCell.author.text = author.name;
//        tweetCell.auhtor2.text = [NSString stringWithFormat:@"@%@",author.name];
//        tweetCell.twitterText.text = tweetObj.text;
//        tweetCell.retweet.text = [NSString stringWithFormat:@"%lld",tweetObj.retweetCount];
//        tweetCell.favourate.text = [NSString stringWithFormat:@"%lld",tweetObj.favoriteCount];
        tweetCell.contentView.layer.borderWidth = 1.0f;
        tweetCell.contentView.layer.borderColor = [[UIColor colorWithRed:237.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1] CGColor];
        collectionCell = tweetCell;
    }else {
        if(indexPath.row == 2) {
            [self.widgetCollectionView registerClass:[CompanyCell class]
                          forCellWithReuseIdentifier:@"CompanyCell"];
            [self.widgetCollectionView registerNib:[UINib nibWithNibName:@"CompanyCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"CompanyCell"];
            
            CompanyCell * cell =(CompanyCell*) [cv dequeueReusableCellWithReuseIdentifier:@"CompanyCell" forIndexPath:indexPath];
            cell.contentView.layer.borderWidth = 1.0f;
            cell.contentView.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
            
            UITapGestureRecognizer *socialCellTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(socialTap:)];
            socialCellTap.numberOfTapsRequired=1;
            cell.requestUpgradeButton.tag=indexPath.row;
            [cell.requestUpgradeButton addGestureRecognizer:socialCellTap];
            collectionCell = cell;
        } else if(indexPath.row == 0) {
            [self.widgetCollectionView registerClass:[TimeLineCell class]
                          forCellWithReuseIdentifier:@"TimeLineCell"];
            [self.widgetCollectionView registerNib:[UINib nibWithNibName:@"TimeLineCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"TimeLineCell"];
            
            TimeLineCell *cell =(TimeLineCell*) [cv dequeueReusableCellWithReuseIdentifier:@"TimeLineCell" forIndexPath:indexPath];
            cell.contentView.layer.borderWidth = 1.0f;
            cell.contentView.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
            
            UITapGestureRecognizer *socialCellTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(socialTap:)];
            socialCellTap.numberOfTapsRequired=1;
            cell.requestUpgradeButton.tag=indexPath.row;
            [cell.requestUpgradeButton addGestureRecognizer:socialCellTap];
            collectionCell = cell;
        } else if(indexPath.row == 1) {
            [self.widgetCollectionView registerClass:[CompetitorCell class]
                          forCellWithReuseIdentifier:@"CompetitorCell"];
            [self.widgetCollectionView registerNib:[UINib nibWithNibName:@"CompetitorCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"CompetitorCell"];
            
            CompetitorCell *cell =(CompetitorCell*) [cv dequeueReusableCellWithReuseIdentifier:@"CompetitorCell" forIndexPath:indexPath];
            cell.contentView.layer.borderWidth = 1.0f;
            cell.contentView.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
            
            UITapGestureRecognizer *socialCellTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(socialTap:)];
            socialCellTap.numberOfTapsRequired=1;
            cell.requestUpgradeButton.tag=indexPath.row;
            [cell.requestUpgradeButton addGestureRecognizer:socialCellTap];
            collectionCell = cell;
        }
    }
    return collectionCell;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(collectionView==self.widgetCollectionView){
        
        
        if(indexPath.row==2){
            
            [self presentWebViewWithLink:@"https://www.crunchbase.com/organization/verizon"];
        }
    }
    
}

-(void)presentWebViewWithLink :(NSString *)urlString{
    
    
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
            mzvc.urlString = urlString;
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
        
        navController.topViewController.title = @"";
        
        navController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        SocialWebView *mzvc = (SocialWebView *)navController.topViewController;
        mzvc.urlString = urlString;
    };
    formSheet.transitionStyle = MZFormSheetTransitionStyleCustom;
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
    
}


-(void)socialTap:(UITapGestureRecognizer *)sender{
    
    UIButton *btn=(UIButton *)sender.view;
    
    if(btn.tag==0){
        [btn setSelected:YES];
        [FIUtils callRequestionUpdateWithModuleId:8 withFeatureId:5];
         [btn setEnabled:NO];
    }
    if(btn.tag==1){
        [btn setSelected:YES];
        [FIUtils callRequestionUpdateWithModuleId:8 withFeatureId:13];
         [btn setEnabled:NO];
    }
    if(btn.tag==2){
        [btn setSelected:YES];
        [FIUtils callRequestionUpdateWithModuleId:8 withFeatureId:3];
         [btn setEnabled:NO];
    }
    
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:
(NSTimeInterval)duration {
    
    if(toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation==UIInterfaceOrientationLandscapeRight){
        
        NSLog(@"coming into landscape");
        
  _forLabel.hidden=NO;
        _forLabel.text=@"for";
        
    }else if(toInterfaceOrientation==UIInterfaceOrientationPortrait){

        NSLog(@"coming into Portrait");
        _forLabel.hidden=YES;
        _forLabel.text=@"";
    }
}


- (IBAction)requestUpgradeButtonPressed:(id)sender {
    
   [FIUtils callRequestionUpdateWithModuleId:8 withFeatureId:12];
}
@end
