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
@interface InfluencerListView ()

@end

@implementation InfluencerListView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadInfluencerList) name:@"InfluencerList" object:nil];
    
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
    label.font = [UIFont fontWithName:@"Open Sans" size:20];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.text = @"Home";
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
    NSLog(@"influencer array count:%d",self.influencerArray.count);
    [self.influencerTableView reloadData];
}

-(void)loadInfluencerList {
    self.influencerArray = [[NSMutableArray alloc]init];
    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Influencer"];
    self.influencerArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSLog(@"influencer array count:%d",self.influencerArray.count);
    [self.influencerTableView reloadData];
}


-(void)backBtnPress {
    [self.revealController showViewController:self.revealController.leftViewController];
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
    NSLog(@"author image url:%@ and author:%@",[author valueForKey:@"image"],author);
    [cell.authorImageView sd_setImageWithURL:[NSURL URLWithString:[author valueForKey:@"image"]] placeholderImage:nil];
    cell.title.text = [influencer valueForKey:@"title"];
    cell.descTextView.text = [influencer valueForKey:@"desc"];
    cell.articleDate.text = [influencer valueForKey:@"date"];
    cell.outlet.text = [influencer valueForKey:@"outlet"];
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        
        NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Influencer"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@", [influencer valueForKey:@"articleId"]];
        [fetchRequest setPredicate:predicate];
        NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        
        NSManagedObject *influencer = [newPerson objectAtIndex:0];
        
        if([influencer valueForKey:@"details"] == nil) {
            
            NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
            [resultDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
            [resultDic setObject:[influencer valueForKey:@"articleId"] forKey:@"selectedArticleId"];
            NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
            
            NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
            [[FISharedResources sharedResourceManager]getInfluencerDetailsWithDetails:resultStr];
        }else {
            //NSLog(@"not null");
        }
    });
    
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
    
    NSManagedObject *influencer = [self.influencerArray objectAtIndex:indexPath.row];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"InfluencerListView" bundle:nil];
    InfluencerDetailsView *detailView = [storyBoard instantiateViewControllerWithIdentifier:@"DetailView"];
    detailView.legendsArray = legendsList;
    detailView.selectedId = [influencer valueForKey:@"articleId"];
    [self.navigationController pushViewController:detailView animated:YES];
}


@end
