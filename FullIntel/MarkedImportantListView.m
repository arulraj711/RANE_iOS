//
//  MarkedImportantListView.m
//  FullIntel
//
//  Created by Arul on 3/18/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "MarkedImportantListView.h"
#import "ViewController.h"
#import "CorporateNewsCell.h"
#import "UIView+Toast.h"
#import "FISharedResources.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PKRevealController.h"
#import "MarkedImportantDetailsView.h"
#import "FIUtils.h"
#import "CorporateNewsDetailsView.h"
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define UIColorFromRGB(rgbValue)[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface MarkedImportantListView ()

@end

@implementation MarkedImportantListView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCuratedNews) name:@"CuratedNews" object:nil];
    
    
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
    

    BOOL isLoadFirst = [[NSUserDefaults standardUserDefaults]boolForKey:@"isMarkImpLoad"];
    if(!isLoadFirst) {
        NSMutableDictionary *gradedetails = [[NSMutableDictionary alloc] init];
        [gradedetails setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
        [gradedetails setObject:@"" forKey:@"lastArticleId"];
        [gradedetails setObject:[NSNumber numberWithInt:10] forKey:@"listSize"];
        [gradedetails setObject:@"2" forKey:@"activityTypeIds"];
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:gradedetails options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
//        [[FISharedResources sharedResourceManager]getCuratedNewsListWithAccessToken:resultStr withCategoryId:@"2"];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    // NSLog(@"corporate view did appear");
    
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"];
    if(accessToken.length == 0) {
        // NSLog(@"corporate if part");
        UIStoryboard *loginStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewController *loginView = [loginStoryBoard instantiateViewControllerWithIdentifier:@"LoginView"];
        [self presentViewController:loginView animated:YES completion:nil];
    } else {
        //NSLog(@"corporate else part");
    }
    
    
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"MarkedImportant"];
    self.devices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    //NSLog(@"device array:%@ and count:%d",self.devices,self.devices.count);
    [self.influencerTableView reloadData];
}

-(void)loadCuratedNews {
    self.devices = [[NSMutableArray alloc]init];
    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"MarkedImportant"];
    self.devices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
     NSLog(@"device array:%@ and count:%d",self.devices,self.devices.count);
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
    
    CorporateNewsCell *cell = (CorporateNewsCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    // Configure the cell...
    NSManagedObject *curatedNews = [self.devices objectAtIndex:indexPath.row];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CorporateNewsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSSet *authorSet = [curatedNews valueForKey:@"author"];
    NSMutableArray *authorArray = [[NSMutableArray alloc]initWithArray:[authorSet allObjects]];
    
    NSSet *legendsSet = [curatedNews valueForKey:@"legends"];
    NSMutableArray *legendsArray = [[NSMutableArray alloc]initWithArray:[legendsSet allObjects]];
    legendsList = [[NSMutableArray alloc]init];
    for(NSManagedObject *legends in legendsArray) {
        if([[legends valueForKey:@"flag"]isEqualToString:@"yes"]) {
            [legendsList addObject:[legends valueForKey:@"name"]];
        }
    }
    
    NSString *dateStr = [FIUtils getDateFromTimeStamp:[[curatedNews valueForKey:@"date"] doubleValue]];
    cell.articleDate.text = dateStr;
    [cell.articleImageView sd_setImageWithURL:[NSURL URLWithString:[curatedNews valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [cell.articleImageView setContentMode:UIViewContentModeScaleAspectFill];
    cell.articleNumber.text = [curatedNews valueForKey:@"articleId"];
    cell.legendsArray = [[NSMutableArray alloc]initWithArray:legendsList];
    if(authorArray.count != 0) {
        author = [authorArray objectAtIndex:0];
    }
    
    // NSLog(@"curated author:%@ and name:%@",author,[author valueForKey:@"name"]);
    cell.authorName.text = [author valueForKey:@"name"];
    cell.authorTitle.text = [author valueForKey:@"title"];
    [cell.authorImageView sd_setImageWithURL:[NSURL URLWithString:[author valueForKey:@"image"]] placeholderImage:nil];
    
    cell.title.text = [curatedNews valueForKey:@"title"];
    NSRange r;
    NSString *s = [curatedNews valueForKey:@"desc"];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    s= [s stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
    
    cell.descTextView.text = s;
    CGFloat width =  [[curatedNews valueForKey:@"outlet"] sizeWithFont:[UIFont fontWithName:@"OpenSans" size:15 ]].width;
    NSLog(@"outlet text width:%f and label width:%f",width,cell.outlet.frame.size.width);
    if(width == 0) {
        cell.outletWidthConstraint.constant = 0;
        cell.outletImageWidthConstraint.constant = 0;
        cell.outletHorizontalConstraint.constant = 8;
    }
    else if(width < 126) {
        
        CGFloat value = width-8;
        cell.outletWidthConstraint.constant = value;
        cell.outletImageWidthConstraint.constant = 12;
        cell.outletHorizontalConstraint.constant = value+12+25;
    }else {
        
        CGFloat value = width-21;
        cell.outletWidthConstraint.constant = value;
        cell.outletImageWidthConstraint.constant = 12;
        cell.outletHorizontalConstraint.constant = value+12+25;
    }
    cell.outlet.text = [curatedNews valueForKey:@"outlet"];
    
    if([curatedNews valueForKey:@"readStatus"]) {
        //cell.contentView.alpha = 0.7f;
    } else {
        // cell.contentView.alpha = 1.0f;
    }
    if([[curatedNews valueForKey:@"markAsImportant"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
        [cell.markedImpButton setSelected:YES];
    } else {
        [cell.markedImpButton setSelected:NO];
    }
    if([[curatedNews valueForKey:@"saveForLater"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
        [cell.savedForLaterButton setSelected:YES];
    } else {
        [cell.savedForLaterButton setSelected:NO];
    }
    UITapGestureRecognizer *markedImpTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(markedImpAction:)];
    cell.markedImpButton.tag = indexPath.row;
    [cell.markedImpButton addGestureRecognizer:markedImpTap];
    
    UITapGestureRecognizer *savedLaterTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(savedAction:)];
    cell.savedForLaterButton.tag = indexPath.row;
    [cell.savedForLaterButton addGestureRecognizer:savedLaterTap];
    
    UITapGestureRecognizer *checkMarkTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkMark:)];
    cell.checkMarkButton.tag = indexPath.row;
    [cell.checkMarkButton addGestureRecognizer:checkMarkTap];
    
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
    
    NSManagedObject *influencer = [self.devices objectAtIndex:indexPath.row];
    NSSet *authorSet = [influencer valueForKey:@"author"];
    NSMutableArray *authorArray = [[NSMutableArray alloc]initWithArray:[authorSet allObjects]];
    NSManagedObject *authors;
    if(authorArray.count != 0) {
        authors = [authorArray objectAtIndex:0];
    }
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];
    CorporateNewsDetailsView *detailView = [storyBoard instantiateViewControllerWithIdentifier:@"DetailView"];
    detailView.legendsArray = legendsList;
    detailView.titleStr = [influencer valueForKey:@"title"];
    detailView.imageStr = [influencer valueForKey:@"image"];
    //detailView.author = author;
    detailView.authorNameStr = [authors valueForKey:@"name"];
    detailView.authorTitleStr = [authors valueForKey:@"title"];
    detailView.authorImageStr = [authors valueForKey:@"image"];
    detailView.outletStr = [influencer valueForKey:@"outlet"];
    detailView.selectedId = [influencer valueForKey:@"articleId"];
    [self.navigationController pushViewController:detailView animated:YES];
}

-(void)checkMark:(UITapGestureRecognizer *)tapGesture {
    UIButton *checkMarkBtn = (UIButton *)[tapGesture view];
    if(checkMarkBtn.selected) {
        [checkMarkBtn setSelected:NO];
    }else {
        [checkMarkBtn setSelected:YES];
    }
}


- (void)scrollViewDidScroll: (UIScrollView*)scroll {
    // UITableView only moves in one direction, y axis
    CGFloat currentOffset = scroll.contentOffset.y;
    CGFloat maximumOffset = scroll.contentSize.height - scroll.frame.size.height;
    
    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= 10.0) {
        //NSLog(@"tableview reach the limt");
        // [self methodThatAddsDataAndReloadsTableView];
    }
}

-(void)markedImpAction:(UITapGestureRecognizer *)tapGesture {
    
    
    NSInteger selectedTag = [tapGesture view].tag;
    NSManagedObject *curatedNews = [self.devices objectAtIndex:selectedTag];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
    [resultDic setObject:[curatedNews valueForKey:@"articleId"] forKey:@"selectedArticleId"];
    [resultDic setObject:@"2" forKey:@"status"];
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
    NSLog(@"result string for mark as important:%@",resultStr);
    [[FISharedResources sharedResourceManager]setUserActivitiesOnArticlesWithDetails:resultStr];
    UIButton *markedImpBtn = (UIButton *)[tapGesture view];
    if(markedImpBtn.selected) {
        [markedImpBtn setSelected:NO];
        [self.view makeToast:@"Unchecked from Important List!" duration:1.5 position:CSToastPositionCenter];
    }else {
        [markedImpBtn setSelected:YES];
        [self.view makeToast:@"Marked Important!" duration:1.5 position:CSToastPositionCenter];
    }
    
}

-(void)savedAction:(UITapGestureRecognizer *)tapGesture {
    
    NSInteger selectedTag = [tapGesture view].tag;
    NSManagedObject *curatedNews = [self.devices objectAtIndex:selectedTag];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
    [resultDic setObject:[curatedNews valueForKey:@"articleId"] forKey:@"selectedArticleId"];
    [resultDic setObject:@"3" forKey:@"status"];
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
    NSLog(@"result string for mark as important:%@",resultStr);
    [[FISharedResources sharedResourceManager]setUserActivitiesOnArticlesWithDetails:resultStr];
    UIButton *savedBtn = (UIButton *)[tapGesture view];
    if(savedBtn.selected) {
        [savedBtn setSelected:NO];
        [self.view makeToast:@"Removed from Saved List!" duration:1.5 position:CSToastPositionCenter];
    }else {
        [savedBtn setSelected:YES];
        [self.view makeToast:@"Saved Successfully!" duration:1.5 position:CSToastPositionCenter];
    }
    
}
@end
