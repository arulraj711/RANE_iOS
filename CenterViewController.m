//
//  CenterViewController.m
//  FullIntel
//
//  Created by Arul on 2/17/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "CenterViewController.h"
#import "ViewController.h"
#import "InfluencersTableViewCell.h"
#import "FISharedResources.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PKRevealController.h"
#import "CorporateNewsDetailsView.h"
#define degreesToRadian(x) (M_PI * (x) / 180.0)
@interface CenterViewController ()

@end

@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *Btn =[UIButton buttonWithType:UIButtonTypeCustom];
    
    [Btn setFrame:CGRectMake(0.0f,0.0f,30.0f,30.0f)];
    [Btn setBackgroundImage:[UIImage imageNamed:@"navmenu"]  forState:UIControlStateNormal];
    //[Btn setTitle:@"OK" forState:UIControlStateNormal];
    //Btn.titleLabel.font = [UIFont fontWithName:@"Georgia" size:14];
    [Btn addTarget:self action:@selector(backBtnPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    [self.navigationItem setLeftBarButtonItem:addButton];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.text = @"Home";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
}

-(void)viewDidAppear:(BOOL)animated {
    self.devices = [[NSMutableArray alloc]init];
//    BOOL isloggedIn = (BOOL)[[NSUserDefaults standardUserDefaults]objectForKey:@"isLoggedIn"];
//    if(!isloggedIn) {
//        UIStoryboard *loginStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        ViewController *loginView = [loginStoryBoard instantiateViewControllerWithIdentifier:@"LoginView"];
//        [self presentViewController:loginView animated:YES completion:nil];
//    }
    
    
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
    self.devices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
   // NSLog(@"device array:%@ and count:%d",self.devices,self.devices.count);
    [self.influencerTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backBtnPress {
    [self.revealController showViewController:self.revealController.leftViewController];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return self.devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    InfluencersTableViewCell *cell = (InfluencersTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    
    
    // Configure the cell...
    NSManagedObject *influencer = [self.devices objectAtIndex:indexPath.row];
    NSString *articleImageStr = [influencer valueForKey:@"image"];
    if(articleImageStr.length > 0) {
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InfluencersTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
         [cell.articleImageView setImageWithURL:[NSURL URLWithString:[influencer valueForKey:@"image"]] placeholderImage:nil];
    }else {
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InfluencerCustomTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
    }
    
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
    cell.articleNumber.text = [influencer valueForKey:@"articleId"];
    cell.legendsArray = [[NSMutableArray alloc]initWithArray:legendsList];
    NSManagedObject *author = [authorArray objectAtIndex:0];
    cell.authorName.text = [author valueForKey:@"name"];
    cell.authorTitle.text = [author valueForKey:@"title"];
    [cell.authorImageView setImageWithURL:[NSURL URLWithString:[author valueForKey:@"image"]] placeholderImage:nil];
    cell.title.text = [influencer valueForKey:@"title"];
    cell.textView.text = [influencer valueForKey:@"desc"];
    cell.articleDate.text = [influencer valueForKey:@"date"];
    cell.outlet.text = [influencer valueForKey:@"outlet"];
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 0)];
    //if (section == integerRepresentingYourSectionOfInterest)
        [headerView setBackgroundColor:[UIColor blueColor]];
    //else
       // [headerView setBackgroundColor:[UIColor clearColor]];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"CenterView" bundle:nil];
    CorporateNewsDetailsView *detailView = [storyBoard instantiateViewControllerWithIdentifier:@"DetailView"];
    detailView.legendsArray = legendsList;
    [self.navigationController pushViewController:detailView animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
