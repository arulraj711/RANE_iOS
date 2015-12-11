//
//  InfluencerListView.m
//  FullIntel
//
//  Created by Arul on 3/23/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "InfluencerListView.h"
#import "InfluencerCell.h"
#import "FISharedResources.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PKRevealController.h"
#import "InfluencerDetailsView.h"
#import "UIView+Toast.h"
#import "FIUtils.h"
@interface InfluencerListView ()

@end

@implementation InfluencerListView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadInfluencerList) name:@"InfluencerList" object:nil];
    
    
    
    NSMutableAttributedString *attriString=[[NSMutableAttributedString alloc]initWithString:@"INFLUENCER COMMENTS aggregates relevant articles and research notes from relevant industry analysts, financial firms and influencers from the traditional and social media"];
    
    [attriString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Bold" size:20] range:NSMakeRange(0,19)];
    
    [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:164.0/255.0 green:19.0/255.0 blue:30.0/255.0 alpha:1] range:NSMakeRange(0,19)];
    
    _topLabel.attributedText=attriString;
    
    
    UIButton *Btn =[UIButton buttonWithType:UIButtonTypeCustom];
    
    [Btn setFrame:CGRectMake(0.0f,0.0f,16.0f,15.0f)];
    [Btn setBackgroundImage:[UIImage imageNamed:@"navmenu"]  forState:UIControlStateNormal];
    //[Btn setTitle:@"OK" forState:UIControlStateNormal];
    //Btn.titleLabel.font = [UIFont fontWithName:@"Georgia" size:14];
    [Btn addTarget:self action:@selector(backBtnPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    [self.navigationItem setLeftBarButtonItem:addButton];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"OpenSans" size:16];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.text = _titleName;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
    [resultDic setObject:@"" forKey:@"lastArticleId"];
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
    
    
//    BOOL isLoadFirst = [[NSUserDefaults standardUserDefaults]boolForKey:@"isInfluencerLoad"];
//    if(!isLoadFirst) {
        [[FISharedResources sharedResourceManager]getInfluencerListWithAccessToken:resultStr];
   // }
    
    
    
//    _requestUpgradeButton.layer.borderColor=[[UIColor darkGrayColor]CGColor];
//    _requestUpgradeButton.layer.borderWidth=1.5;
//    _requestUpgradeButton.layer.cornerRadius=5.0;
    
    _rotateView.transform = CGAffineTransformMakeRotation(-0.6);
    self.revealController.revealPanGestureRecognizer.delegate = self;
    self.revealController.panDelegate = self;
}

- (void)handlePanGestureStart {
    // self.articlesTableView.scrollEnabled = NO;
    
}

-(void)handleVeriticalPan {
    // self.articlesTableView.scrollEnabled = YES;
}
-(void)handlePanGestureEnd {
    //  self.articlesTableView.scrollEnabled = YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return  YES;
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if(self.revealController.state == PKRevealControllerShowsLeftViewControllerInPresentationMode) {
        // NSLog(@"left view opened");
        [self.revealController showViewController:self.revealController.frontViewController];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Influencer"];
    self.influencerArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    //NSLog(@"influencer array count:%d",self.influencerArray.count);
    [self.influencerTableView reloadData];
}

-(void)loadInfluencerList {
    self.influencerArray = [[NSMutableArray alloc]init];
    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Influencer"];
    self.influencerArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    //NSLog(@"influencer array count:%d",self.influencerArray.count);
    [self.influencerTableView reloadData];
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
        //NSLog(@"left view opened");
        [self.revealController showViewController:self.revealController.frontViewController];
    } else {
        //NSLog(@"left view closed");
        [self.revealController showViewController:self.revealController.leftViewController];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return self.influencerArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InfluencerCell *cell = (InfluencerCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    // Configure the cell...
    NSManagedObject *influencer = [self.influencerArray objectAtIndex:indexPath.row];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InfluencerCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
   // [cell.articleImageView sd_setImageWithURL:[NSURL URLWithString:[influencer valueForKey:@"image"]] placeholderImage:nil];
    [cell.articleImageView setContentMode:UIViewContentModeScaleAspectFill];
    NSSet *authorSet = [influencer valueForKey:@"author"];
    NSMutableArray *authorArray = [[NSMutableArray alloc]initWithArray:[authorSet allObjects]];
    
    NSSet *legendsSet = [influencer valueForKey:@"legends"];
    NSMutableArray *legendsArray = [[NSMutableArray alloc]initWithArray:[legendsSet allObjects]];
    legendsList = [[NSMutableArray alloc]init];
    for(NSManagedObject *legends in legendsArray) {
        if([[legends valueForKey:@"flag"]isEqualToString:@"yes"]) {
            [legendsList addObject:[legends valueForKey:@"name"]];
        }
    }
   // cell.articleNumber.text = [influencer valueForKey:@"articleId"];
    cell.legendsArray = [[NSMutableArray alloc]initWithArray:legendsList];
    NSManagedObject *author = [authorArray objectAtIndex:0];
    cell.authorName.text = [author valueForKey:@"name"];
    cell.authorTitle.text = [author valueForKey:@"title"];
    //NSLog(@"author image url:%@ and author:%@",[author valueForKey:@"image"],author);
    [cell.authorImageView sd_setImageWithURL:[NSURL URLWithString:[author valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"FI"]];
    cell.title.text = [influencer valueForKey:@"title"];
    cell.descTextView.text = [influencer valueForKey:@"desc"];
    
    NSString *dateStr = [FIUtils getDateFromTimeStamp:[[influencer valueForKey:@"date"] doubleValue]];
    cell.articleDate.text = dateStr;
    
    //cell.articleDate.text = [influencer valueForKey:@"date"];
    cell.outlet.text = [influencer valueForKey:@"outlet"];
    
    
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(queue, ^{
//        
//        
//        NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
//        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Influencer"];
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@", [influencer valueForKey:@"articleId"]];
//        [fetchRequest setPredicate:predicate];
//        NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
//        
//        NSManagedObject *influencer = [newPerson objectAtIndex:0];
//        
//        if([influencer valueForKey:@"details"] == nil) {
//            
//            NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
//            [resultDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
//            [resultDic setObject:[influencer valueForKey:@"articleId"] forKey:@"selectedArticleId"];
//            NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
//            
//            NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
//            [[FISharedResources sharedResourceManager]getInfluencerDetailsWithDetails:resultStr];
//        }else {
//            //NSLog(@"not null");
//        }
//    });
    
    UITapGestureRecognizer *markedImpTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(markedImpAction:)];
    [cell.markedImpButton addGestureRecognizer:markedImpTap];
    
    UITapGestureRecognizer *savedLaterTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(savedAction:)];
    [cell.savedForLaterButton addGestureRecognizer:savedLaterTap];
    
    CGFloat width =  [cell.outlet.text sizeWithFont:[UIFont fontWithName:@"OpenSans" size:15 ]].width;
    if(width < cell.outlet.frame.size.width) {
        CGFloat value = width+6;
        cell.outletWidthConstraint.constant = value;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)markedImpAction:(UITapGestureRecognizer *)tapGesture {
    [self.view makeToast:@"Marked Important!" duration:1.5 position:CSToastPositionCenter];
}

-(void)savedAction:(UITapGestureRecognizer *)tapGesture {
    [self.view makeToast:@"Saved Successfully!" duration:1.5 position:CSToastPositionCenter];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSManagedObject *influencer = [self.influencerArray objectAtIndex:indexPath.row];
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"InfluencerListView" bundle:nil];
//    InfluencerDetailsView *detailView = [storyBoard instantiateViewControllerWithIdentifier:@"DetailView"];
//    detailView.legendsArray = legendsList;
//    detailView.selectedId = [influencer valueForKey:@"articleId"];
//    [self.navigationController pushViewController:detailView animated:YES];
}


- (IBAction)requestUpgradeButtonClick:(id)sender {
    NSMutableDictionary *gradedetails = [[NSMutableDictionary alloc] init];
    [gradedetails setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
    [gradedetails setObject:[NSNumber numberWithInt:7] forKey:@"moduleId"];
    [gradedetails setObject:[NSNumber numberWithInt:11] forKey:@"featureId"];
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:gradedetails options:NSJSONWritingPrettyPrinted error:nil];
    NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
    [[FISharedResources sharedResourceManager]featureAccessRequestWithDetails:resultStr];
}
@end
