//
//  IpAndLegalViewController.m
//  FullIntel
//
//  Created by cape start on 01/06/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "IpAndLegalViewController.h"

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
#import "IpAndLegalCell.h"
#import "NumberOfPatternsCell.h"
#import "RecentPaternsCell.h"
#import "MZFormSheetController.h"
#import "SocialWebView.h"
#import "ViewController.h"
#define UIColorFromRGB(rgbValue)[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface IpAndLegalViewController ()

@end

@implementation IpAndLegalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoginPage) name:@"authenticationFailed" object:nil];
    
    UIButton *Btn =[UIButton buttonWithType:UIButtonTypeCustom];
    
    [Btn setFrame:CGRectMake(0.0f,0.0f,16.0f,15.0f)];
    [Btn setBackgroundImage:[UIImage imageNamed:@"navmenu"]  forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(backBtnPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    [self.navigationItem setLeftBarButtonItem:addButton];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Open Sans" size:16];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.text = _titleName;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    
//        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/184003479/fullIntel/testdata/legalDril.html"]];
//        [_dealsWebView loadRequest:urlRequest];
    
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"legalDril" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [_dealsWebView loadHTMLString:htmlString baseURL:nil];
    
    
    _requestUpgradeButton.layer.borderColor=[[UIColor darkGrayColor]CGColor];
    _requestUpgradeButton.layer.borderWidth=1.5;
    _requestUpgradeButton.layer.cornerRadius=5.0;
    
    
        [FIUtils makeRoundedView:_authorImageView];
    
    NSMutableAttributedString *attriString=[[NSMutableAttributedString alloc]initWithString:@"IP & LEGAL offers insight on relevant patents, trademarks and other legal matters that are relevant to you."];
    
    [attriString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Bold" size:20] range:NSMakeRange(0,10)];
    
    [attriString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0XA4131E) range:NSMakeRange(0,10)];
    
    _DealsLabel.attributedText=attriString;
    
    
    
    [_authorImageBigView sd_setImageWithURL:[NSURL URLWithString:@"https://pbs.twimg.com/profile_images/525460441502187520/52FB7IFR_400x400.jpeg"] placeholderImage:[UIImage imageNamed:@"FI"]];
    
    [_authorImageView sd_setImageWithURL:[NSURL URLWithString:@"https://pbs.twimg.com/profile_images/525460441502187520/52FB7IFR_400x400.jpeg"] placeholderImage:[UIImage imageNamed:@"FI"]];
    
    
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
    
    @try{
        [self.sampleDataText removeObserver:self forKeyPath:@"contentSize"];
    }@catch(id anException) {
        NSLog(@"error message:%@",anException);
    }
    
    
}
-(void)backBtnPress {
    
    
    if(self.revealController.state == PKRevealControllerShowsLeftViewControllerInPresentationMode) {
       // NSLog(@"left view opened");
        [self.revealController showViewController:self.revealController.frontViewController];
    } else {
       // NSLog(@"left view closed");
        [self.revealController showViewController:self.revealController.leftViewController];
    }
    
}

-(void)showLoginPage {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];
    UINavigationController *listView = [storyBoard instantiateViewControllerWithIdentifier:@"CorporateView"];
    [self.revealController setFrontViewController:listView];
    [self.revealController showViewController:self.revealController.leftViewController];
    
    NSArray *navArray = self.navigationController.viewControllers;
    if(navArray.count > 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        UIStoryboard *loginStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewController *loginView = [loginStoryBoard instantiateViewControllerWithIdentifier:@"LoginView"];
        UIWindow *window = [[UIApplication sharedApplication]windows][0];
        [window addSubview:loginView.view];
    } else {
        UIStoryboard *loginStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewController *loginView = [loginStoryBoard instantiateViewControllerWithIdentifier:@"LoginView"];
        UIWindow *window = [[UIApplication sharedApplication]windows][0];
        [window addSubview:loginView.view];
    }
    
    
    //[self presentViewController:loginView animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            return CGSizeMake(400, 400);
        } else if(indexPath.row == 1) {
            return CGSizeMake(400, 350);
        } else if(indexPath.row == 2) {
            return CGSizeMake(400, 150);
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
        if(indexPath.row == 1) {
            [self.widgetCollectionView registerClass:[NumberOfPatternsCell class]
                          forCellWithReuseIdentifier:@"NumberOfPatternsCell"];
            [self.widgetCollectionView registerNib:[UINib nibWithNibName:@"NumberOfPatternsCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"NumberOfPatternsCell"];
            
            NumberOfPatternsCell * cell =(NumberOfPatternsCell*) [cv dequeueReusableCellWithReuseIdentifier:@"NumberOfPatternsCell" forIndexPath:indexPath];
            cell.contentView.layer.borderWidth = 1.0f;
            cell.contentView.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
            
            
            UITapGestureRecognizer *socialCellTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(socialTap:)];
            socialCellTap.numberOfTapsRequired=1;
            cell.requestUpgradeButton.tag=indexPath.row;
            [cell.requestUpgradeButton addGestureRecognizer:socialCellTap];
            collectionCell = cell;
        } else if(indexPath.row == 0) {
            [self.widgetCollectionView registerClass:[IpAndLegalCell class]
                          forCellWithReuseIdentifier:@"IpAndLegalCell"];
            [self.widgetCollectionView registerNib:[UINib nibWithNibName:@"IpAndLegalCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"IpAndLegalCell"];
            
            IpAndLegalCell *cell =(IpAndLegalCell*) [cv dequeueReusableCellWithReuseIdentifier:@"IpAndLegalCell" forIndexPath:indexPath];
            cell.contentView.layer.borderWidth = 1.0f;
            cell.contentView.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1] CGColor];
            
            UITapGestureRecognizer *socialCellTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(socialTap:)];
            socialCellTap.numberOfTapsRequired=1;
            cell.requestUpgradeButton.tag=indexPath.row;
            [cell.requestUpgradeButton addGestureRecognizer:socialCellTap];
            collectionCell = cell;
        } else if(indexPath.row == 2) {
            [self.widgetCollectionView registerClass:[RecentPaternsCell class]
                          forCellWithReuseIdentifier:@"RecentPaternsCell"];
            [self.widgetCollectionView registerNib:[UINib nibWithNibName:@"RecentPaternsCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"RecentPaternsCell"];
            
            RecentPaternsCell *cell =(RecentPaternsCell*) [cv dequeueReusableCellWithReuseIdentifier:@"RecentPaternsCell" forIndexPath:indexPath];
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

-(void)socialTap:(UITapGestureRecognizer *)sender{
    
    UIButton *btn=(UIButton *)sender.view;
    
    if(btn.tag==0){
        [btn setSelected:YES];
        [FIUtils callRequestionUpdateWithModuleId:4 withFeatureId:5];
        // [btn setEnabled:NO];
    }
    if(btn.tag==1){
        [btn setSelected:YES];
        [FIUtils callRequestionUpdateWithModuleId:4 withFeatureId:14];
       //  [btn setEnabled:NO];
    }
    if(btn.tag==2){
        [btn setSelected:YES];
        [FIUtils callRequestionUpdateWithModuleId:4 withFeatureId:14];
        // [btn setEnabled:NO];
    }
    
}
- (IBAction)requestUpgradeButtonPressed:(id)sender {
    UIButton *btn=(UIButton *)sender;
    [btn setSelected:YES];
    [FIUtils callRequestionUpdateWithModuleId:4 withFeatureId:12];
    
}
@end
