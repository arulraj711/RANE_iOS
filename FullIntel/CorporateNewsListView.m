//
//  CorporateNewsListView.m
//  FullIntel
//
//  Created by Arul on 3/18/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "CorporateNewsListView.h"
#import "ViewController.h"
#import "CorporateNewsCell.h"
#import "UIView+Toast.h"
#import "FISharedResources.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PKRevealController.h"
#import "CorporateNewsDetailsView.h"
#import "CorporateNewsDetailsTest.h"
#import "FIUtils.h"
#import "AddContentFirstLevelView.h"
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define UIColorFromRGB(rgbValue)[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface CorporateNewsListView ()

@end

@implementation CorporateNewsListView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.revealController showViewController:self.revealController.leftViewController];

   // NSLog(@"list did load");
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCuratedNews) name:@"CuratedNews" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoginPage) name:@"authenticationFailed" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(markedImportantUpdate:) name:@"markedImportantUpdate" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveForLaterUpdate:) name:@"saveForLaterUpdate" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readStatusUpdate:) name:@"readStatusUpdate" object:nil];
    
    
   // [self.revealController showViewController:self.revealController.leftViewController];
    UIButton *Btn =[UIButton buttonWithType:UIButtonTypeCustom];
    
    [Btn setFrame:CGRectMake(0.0f,0.0f,16.0f,15.0f)];
    [Btn setBackgroundImage:[UIImage imageNamed:@"navmenu"]  forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(backBtnPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    [self.navigationItem setLeftBarButtonItem:addButton];
    
    UIView *addBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
    addBtnView.backgroundColor = [UIColor clearColor];
    
    UIButton *addBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setFrame:CGRectMake(0.0f,0.0f,16.0f,15.0f)];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"addcontent"]  forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addContentView) forControlEvents:UIControlEventTouchUpInside];
    [addBtnView addSubview:addBtn];
    UIBarButtonItem *addContentButton = [[UIBarButtonItem alloc] initWithCustomView:addBtnView];
    
//    UIView *searchBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 15)];
//    searchBtnView.backgroundColor = [UIColor clearColor];
//    UIButton *searchBtn =[UIButton buttonWithType:UIButtonTypeCustom];
//    [searchBtn setFrame:CGRectMake(0.0f,0.0f,16.0f,15.0f)];
//    [searchBtn setBackgroundImage:[UIImage imageNamed:@"search"]  forState:UIControlStateNormal];
//    [searchBtn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
//    [searchBtnView addSubview:searchBtn];
//    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithCustomView:searchBtnView];
//    
//    UIView *settingsBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 15)];
//    settingsBtnView.backgroundColor = [UIColor clearColor];
//    UIButton *settingsBtn =[UIButton buttonWithType:UIButtonTypeCustom];
//    [settingsBtn setFrame:CGRectMake(0.0f,0.0f,15.0f,15.0f)];
//    [settingsBtn setBackgroundImage:[UIImage imageNamed:@"settings"]  forState:UIControlStateNormal];
//    [settingsBtn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
//    [settingsBtnView addSubview:settingsBtn];
//    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithCustomView:settingsBtnView];

    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:addContentButton,  nil]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Open Sans" size:18];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.text = @"Home";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    
    
   
    refreshControl = [[UIRefreshControl alloc]init];
    [self.articlesTableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"];
    if(accessToken.length == 0) {
        // NSLog(@"corporate if part");
        [self showLoginPage];
    } else {
        [self loadCuratedNews];
        
    }
    
}
//-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
//    
//    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
//    
//    if(toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation==UIInterfaceOrientationLandscapeRight){
//        
//        NSLog(@"view size in Landscape :%f :%f :%f :%f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
//        
//        self.corporateListWidthConstraint.constant=self.view.frame.size.width-30;
//        
//    }else if(toInterfaceOrientation==UIInterfaceOrientationPortrait){
//        
//          NSLog(@"view size in Portrait :%f :%f :%f :%f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
//        
//        self.corporateListWidthConstraint.constant=self.view.frame.size.width-30;
//    }
//}

#pragma mark -
#pragma mark Rotation handling methods

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:
(NSTimeInterval)duration {
    
    // Fade the collectionView out

}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    // Force realignment of cell being displayed

//    CGSize contentSize=self.articlesTableView.contentSize;
//    contentSize.width=self.articlesTableView.bounds.size.width;
//    self.articlesTableView.contentSize=contentSize;
    
//    [self.articlesTableView beginUpdates];
//    [self.articlesTableView endUpdates];
}
-(void)showLoginPage {
    NSArray *navArray = self.navigationController.viewControllers;
    if(navArray.count > 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    UIStoryboard *loginStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *loginView = [loginStoryBoard instantiateViewControllerWithIdentifier:@"LoginView"];
    [self presentViewController:loginView animated:YES completion:nil];
}

-(void)viewDidAppear:(BOOL)animated {
  // [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isFIViewSelected"];
}

-(void)loadCuratedNews {
    NSInteger categoryId = [[[NSUserDefaults standardUserDefaults]objectForKey:@"categoryId"] integerValue];
    NSLog(@"category id in curated news:%d",categoryId);
    self.devices = [[NSMutableArray alloc]init];
    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"categoryId == %d",categoryId];
    [fetchRequest setPredicate:predicate];
    
    
    NSSortDescriptor *date = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:date, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    
//    NSArray *newPerson =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    self.devices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    _spinner.hidden = YES;
    [_spinner stopAnimating];
    [self.articlesTableView reloadData];
 //   [self.revealController showViewController:self.revealController.leftViewController];
}

- (void)refreshTable {
    //TODO: refresh your data
    //if(self.devices.count == 0) {
    
    NSString *categoryStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"categoryId"];
    NSInteger category = categoryStr.integerValue;
    NSString *inputJson;
    if(category == -2) {
        inputJson = [FIUtils createInputJsonForContentWithToekn:[[NSUserDefaults standardUserDefaults] valueForKey:@"accesstoken"] lastArticleId:@"" contentTypeId:@"1" listSize:10 activityTypeId:@"2" categoryId:[NSNumber numberWithInt:-1]];
    } else if(category == -3) {
        inputJson = [FIUtils createInputJsonForContentWithToekn:[[NSUserDefaults standardUserDefaults] valueForKey:@"accesstoken"] lastArticleId:@"" contentTypeId:@"1" listSize:10 activityTypeId:@"3" categoryId:[NSNumber numberWithInt:-1]];
    } else {
        inputJson = [FIUtils createInputJsonForContentWithToekn:[[NSUserDefaults standardUserDefaults] valueForKey:@"accesstoken"] lastArticleId:@"" contentTypeId:@"1" listSize:10 activityTypeId:@"" categoryId:[NSNumber numberWithInt:category]];
    }
    
    
        [[FISharedResources sharedResourceManager]getCuratedNewsListWithAccessToken:inputJson withCategoryId:[[[NSUserDefaults standardUserDefaults] valueForKey:@"categoryId"] integerValue] withFlag:@"up"];
   // }
    
    [refreshControl endRefreshing];
//    [self.influencerTableView reloadData];
}


-(void)addContentView {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"AddContent" bundle:nil];
    
    UINavigationController *modalController = [storyBoard instantiateViewControllerWithIdentifier:@"addContentNav"];
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:modalController];
    formSheet.presentedFormSheetSize = CGSizeMake(800, 650);
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    __weak MZFormSheetController *weakFormSheet = formSheet;
    
    
    // If you want to animate status bar use this code
    formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
        UINavigationController *navController = (UINavigationController *)weakFormSheet.presentedFSViewController;
        if ([navController.topViewController isKindOfClass:[AddContentFirstLevelView class]]) {
            //AddContentFirstLevelView *mzvc = (AddContentFirstLevelView *)navController.topViewController;
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
        navController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        navController.topViewController.title = @"Add Content";
    };
    formSheet.transitionStyle = MZFormSheetTransitionStyleCustom;
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}

- (void)markedImportantUpdate:(id)sender
{
    NSNotification *notification = sender;
    NSDictionary *userInfo = notification.userInfo;
    NSIndexPath *indexPath = [userInfo objectForKey:@"indexPath"];
   // NSNumber  = [userInfo objectForKey:@"status"];
    NSManagedObject *curatedNews = [self.devices objectAtIndex:indexPath.row];
    [curatedNews setValue:[userInfo objectForKey:@"status"] forKey:@"markAsImportant"];
    [self updateMarkedImportantStatusForRow:indexPath];
    
}

-(void)saveForLaterUpdate:(id)sender {
    NSNotification *notification = sender;
    NSDictionary *userInfo = notification.userInfo;
    NSIndexPath *indexPath = [userInfo objectForKey:@"indexPath"];
    // NSNumber  = [userInfo objectForKey:@"status"];
    NSManagedObject *curatedNews = [self.devices objectAtIndex:indexPath.row];
    [curatedNews setValue:[userInfo objectForKey:@"status"] forKey:@"saveForLater"];
    [self updateSaveForLaterStatusForRow:indexPath];
}

-(void)readStatusUpdate:(id)sender {
    NSNotification *notification = sender;
    NSDictionary *userInfo = notification.userInfo;
    NSIndexPath *indexPath = [userInfo objectForKey:@"indexPath"];
    // NSNumber  = [userInfo objectForKey:@"status"];
    NSManagedObject *curatedNews = [self.devices objectAtIndex:indexPath.row];
    [curatedNews setValue:[userInfo objectForKey:@"status"] forKey:@"readStatus"];
    [self updateReadUnReadStatusForRow:indexPath];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(self.devices.count == 0) {
        return 1;
    }
    return self.devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableCell;
    if(self.devices.count == 0) {
        tableCell = [[UITableViewCell alloc] init];
        tableCell.textLabel.text = @"No articles to display";
        tableCell.textLabel.textAlignment = NSTextAlignmentCenter;
        tableCell.textLabel.font = [UIFont fontWithName:@"OpenSans" size:28];
        tableCell.textLabel.textColor = [UIColor lightGrayColor];
    } else {
        //whatever else to configure your one cell you're going to return
        CorporateNewsCell *cell = (CorporateNewsCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        // Configure the cell...
        NSManagedObject *curatedNews = [self.devices objectAtIndex:indexPath.row];
        NSSet *authorSet = [curatedNews valueForKey:@"author"];
        NSMutableArray *authorArray = [[NSMutableArray alloc]initWithArray:[authorSet allObjects]];
        
        NSSet *legendsSet = [curatedNews valueForKey:@"legends"];
        NSMutableArray *legendsArray = [[NSMutableArray alloc]initWithArray:[legendsSet allObjects]];
      //  NSLog(@"curated news legend set:%d",legendsSet.count);
        legendsList = [[NSMutableArray alloc]init];
        for(NSManagedObject *legends in legendsArray) {
            if([[legends valueForKey:@"flag"]isEqualToString:@"yes"]) {
                [legendsList addObject:[legends valueForKey:@"name"]];
            }
        }
       // NSLog(@"curated news legends list:%d",legendsList.count);
        NSString *dateStr = [FIUtils getDateFromTimeStamp:[[curatedNews valueForKey:@"date"] doubleValue]];
        cell.articleDate.text = dateStr;
        [cell.articleImageView sd_setImageWithURL:[NSURL URLWithString:[curatedNews valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"FI"]];
        [cell.articleImageView setContentMode:UIViewContentModeScaleAspectFill];
        cell.articleNumber.text = [curatedNews valueForKey:@"articleId"];
        cell.legendsArray = [[NSMutableArray alloc]initWithArray:legendsList];
        NSMutableArray *multipleAuthorArray = [[NSMutableArray alloc]init];
        if(authorArray.count != 0) {
            if(authorArray.count > 1) {
                for(int i=0;i<2;i++) {
                    NSManagedObject *authorObject = [authorArray objectAtIndex:i];
                    [multipleAuthorArray addObject:[authorObject valueForKey:@"name"]];
                }
                cell.authorName.text = [multipleAuthorArray componentsJoinedByString:@" and "];
            } else {
                NSManagedObject *authorObject = [authorArray objectAtIndex:0];
                cell.authorName.text = [authorObject valueForKey:@"name"];
            }
        }
       // NSLog(@"multiple author array:%@",multipleAuthorArray);
        
        
        //cell.authorTitle.text = [author valueForKey:@"title"];
        //[cell.authorImageView sd_setImageWithURL:[NSURL URLWithString:[author valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"FI"]];
        
        cell.title.text = [curatedNews valueForKey:@"title"];
        NSRange r;
        NSString *s = [curatedNews valueForKey:@"desc"];
        while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
            s = [s stringByReplacingCharactersInRange:r withString:@""];
        s= [s stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
        
        UIFont *font = [UIFont fontWithName:@"OpenSans" size:14];
        UIColor *textColor = [UIColor colorWithRed:(102/255.0) green:(110/255.0) blue:(115/255.0) alpha:1];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        style.lineSpacing = 2;
        cell.descTextView.attributedText = [[NSAttributedString alloc]initWithString:s attributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:font,NSForegroundColorAttributeName:textColor}];
        
        
        CGFloat width =  [[curatedNews valueForKey:@"outlet"] sizeWithFont:[UIFont fontWithName:@"OpenSans" size:15 ]].width;
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
        CGSize maximumLabelSize = CGSizeMake(600, FLT_MAX);
        CGSize expectedLabelSize = [[curatedNews valueForKey:@"title"] sizeWithFont:cell.title.font constrainedToSize:maximumLabelSize lineBreakMode:cell.title.lineBreakMode];
        NSLog(@"text %@ and text height:%f",[curatedNews valueForKey:@"title"],expectedLabelSize.height);
//        if(expectedLabelSize.height < 60) {
//            cell.titleHeightConstraint.constant = expectedLabelSize.height-20;
//        } else {
//            cell.titleHeightConstraint.constant = expectedLabelSize.height-60;
//        }
        
//        if(expectedLabelSize.height > 80) {
//            cell.titleHeightConstraint.constant = expectedLabelSize.height-50;
//        } else {
            //cell.titleHeightConstraint.constant = expectedLabelSize.height-30;
       // }
        
        
        
        //int i=30;
        
//        if(expectedLabelSize.height > 180) {
//            cell.titleHeightConstraint.constant = expectedLabelSize.height - 30*5;
//        } else if(expectedLabelSize.height > 150) {
//            cell.titleHeightConstraint.constant = expectedLabelSize.height - 30*4;
//        } else if(expectedLabelSize.height > 120) {
//            cell.titleHeightConstraint.constant = expectedLabelSize.height - 30*3;
//        } else if(expectedLabelSize.height > 90) {
//            cell.titleHeightConstraint.constant = expectedLabelSize.height - 45*2;
//        } else if(expectedLabelSize.height > 60) {
//            cell.titleHeightConstraint.constant = expectedLabelSize.height - 45*1;
//        } else if(expectedLabelSize.height > 30) {
//            cell.titleHeightConstraint.constant = expectedLabelSize.height - 30*0;
//        } else {
//            cell.titleHeightConstraint.constant = expectedLabelSize.height;
//        }
        
        cell.titleHeightConstraint.constant = expectedLabelSize.height;
        NSNumber *number = [curatedNews valueForKey:@"markAsImportant"];
        NSLog(@"marked important staus:%@",number);
        if(number == [NSNumber numberWithInt:1]) {
            
            [cell.markedImpButton setSelected:YES];
        } else {
            [cell.markedImpButton setSelected:NO];
        }
        
        
        if([[curatedNews valueForKey:@"saveForLater"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [cell.savedForLaterButton setSelected:YES];
        } else {
            [cell.savedForLaterButton setSelected:NO];
        }
        
        if([[curatedNews valueForKey:@"readStatus"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            cell.readStatusImageView.hidden = NO;
        } else {
            cell.readStatusImageView.hidden = YES;
        }
        
        //[self updateReadUnReadStatusForRow:indexPath];
        //[self updateMarkedImportantStatusForRow:indexPath];
       // [self updateSaveForLaterStatusForRow:indexPath];
       
        
        UITapGestureRecognizer *markedImpTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(markedImpAction:)];
        cell.markedImpButton.tag = indexPath.row;
        [cell.markedImpButton addGestureRecognizer:markedImpTap];
        
        UITapGestureRecognizer *savedLaterTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(savedAction:)];
        cell.savedForLaterButton.tag = indexPath.row;
        [cell.savedForLaterButton addGestureRecognizer:savedLaterTap];
        
        UITapGestureRecognizer *checkMarkTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkMark:)];
        cell.checkMarkButton.tag = indexPath.row;
        [cell.checkMarkButton addGestureRecognizer:checkMarkTap];
        tableCell = cell;
    }
    
    
    
    tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return tableCell;
}


-(void)updateReadUnReadStatusForRow:(NSIndexPath *)indexPath {
    NSManagedObject *curatedNews = [self.devices objectAtIndex:indexPath.row];
    NSNumber *number = [curatedNews valueForKey:@"readStatus"];
    CorporateNewsCell *cell = (CorporateNewsCell *)[self.articlesTableView cellForRowAtIndexPath:indexPath];
    // BOOL isRead = [NSNumber numberWithBool:[curatedNews valueForKey:@"readStatus"]];
    if(number == [NSNumber numberWithInt:1]) {
        // cell.title.alpha = 0.7f;
        cell.readStatusImageView.hidden = NO;
    } else {
        // cell.title.alpha = 1.0f;
        cell.readStatusImageView.hidden = YES;
    }
}

-(void)updateMarkedImportantStatusForRow:(NSIndexPath *)indexPath {
     NSManagedObject *curatedNews = [self.devices objectAtIndex:indexPath.row];
    CorporateNewsCell *cell = (CorporateNewsCell *)[self.articlesTableView cellForRowAtIndexPath:indexPath];
    NSNumber *number = [curatedNews valueForKey:@"markAsImportant"];
    if(number == [NSNumber numberWithInt:1]) {
        
        [cell.markedImpButton setSelected:YES];
    } else {
        [cell.markedImpButton setSelected:NO];
    }
}

-(void)updateSaveForLaterStatusForRow:(NSIndexPath *)indexPath {
    NSManagedObject *curatedNews = [self.devices objectAtIndex:indexPath.row];
    CorporateNewsCell *cell = (CorporateNewsCell *)[self.articlesTableView cellForRowAtIndexPath:indexPath];
    NSNumber *number = [curatedNews valueForKey:@"saveForLater"];
    if(number == [NSNumber numberWithInt:1]) {
        [cell.savedForLaterButton setSelected:YES];
    } else {
        [cell.savedForLaterButton setSelected:NO];
    }
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
    
//    NSManagedObject *influencer = [self.devices objectAtIndex:indexPath.row];
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];
//    CorporateNewsDetailsView *detailView = [storyBoard instantiateViewControllerWithIdentifier:@"DetailView"];
//    detailView.curatedNews = influencer;
//    detailView.selectedIndexPath = indexPath;
//    detailView.legendsArray = legendsList;
//    [self.navigationController pushViewController:detailView animated:YES];
    if(self.devices.count != 0) {
        
        //UpgradeView
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];
        NSString *userAccountTypeId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userAccountTypeId"]];
        CorporateNewsDetailsTest *testView;
        if([userAccountTypeId isEqualToString:@"3"]) {
            testView = [storyBoard instantiateViewControllerWithIdentifier:@"NormalView"];
        }else if([userAccountTypeId isEqualToString:@"2"] || [userAccountTypeId isEqualToString:@"1"]) {
            testView = [storyBoard instantiateViewControllerWithIdentifier:@"UpgradeView"];
        }
        
        testView.currentIndex = indexPath.row;
        testView.selectedIndexPath = indexPath;
        [self.navigationController pushViewController:testView animated:YES];
    }
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
    
    
     NSManagedObject *curatedNewsDetail = [curatedNews valueForKey:@"details"];
    if([[FISharedResources sharedResourceManager]serviceIsReachable]) {
        UIButton *markedImpBtn = (UIButton *)[tapGesture view];
        if(markedImpBtn.selected) {
            [markedImpBtn setSelected:NO];
            [resultDic setObject:@"false" forKey:@"isSelected"];
            [curatedNewsDetail setValue:[NSNumber numberWithBool:NO] forKey:@"markAsImportant"];
            [curatedNews setValue:[NSNumber numberWithBool:NO] forKey:@"markAsImportant"];
            NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
            NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
            [[FISharedResources sharedResourceManager]setUserActivitiesOnArticlesWithDetails:resultStr];
            [self.view makeToast:@"Removed from \"Marked Important\"" duration:1.0 position:CSToastPositionCenter];
        }else {
            [markedImpBtn setSelected:YES];
            [resultDic setObject:@"true" forKey:@"isSelected"];
            [curatedNewsDetail setValue:[NSNumber numberWithBool:YES] forKey:@"markAsImportant"];
            [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"markAsImportant"];
            NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
            NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
            [[FISharedResources sharedResourceManager]setUserActivitiesOnArticlesWithDetails:resultStr];
            [self.view makeToast:@"Marked Important." duration:1.0 position:CSToastPositionCenter];
        }
    } else {
        [FIUtils showNoNetworkToast];
    }
    
    
}

-(void)savedAction:(UITapGestureRecognizer *)tapGesture {
   
    NSInteger selectedTag = [tapGesture view].tag;
    NSManagedObject *curatedNews = [self.devices objectAtIndex:selectedTag];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
    [resultDic setObject:[curatedNews valueForKey:@"articleId"] forKey:@"selectedArticleId"];
    [resultDic setObject:@"3" forKey:@"status"];
    NSManagedObject *curatedNewsDetail = [curatedNews valueForKey:@"details"];
    if([[FISharedResources sharedResourceManager]serviceIsReachable]) {
    UIButton *savedBtn = (UIButton *)[tapGesture view];
    if(savedBtn.selected) {
        [savedBtn setSelected:NO];
        [resultDic setObject:@"false" forKey:@"isSelected"];
        [curatedNewsDetail setValue:[NSNumber numberWithBool:NO] forKey:@"saveForLater"];
        [curatedNews setValue:[NSNumber numberWithBool:NO] forKey:@"saveForLater"];
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
        [[FISharedResources sharedResourceManager]setUserActivitiesOnArticlesWithDetails:resultStr];
        [self.view makeToast:@"Removed from \"Saved for Later\"" duration:1.0 position:CSToastPositionCenter];
    }else {
        [savedBtn setSelected:YES];
        [resultDic setObject:@"true" forKey:@"isSelected"];
        NSLog(@"curated news detail:%@",curatedNewsDetail);
        if(curatedNewsDetail == nil) {
            // NSLog(@"details is null");
            NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
            [resultDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
            [resultDic setObject:[curatedNews valueForKey:@"articleId"] forKey:@"selectedArticleId"];
            NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
            
            NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
            
            NSMutableDictionary *auhtorResultDic = [[NSMutableDictionary alloc] init];
            [auhtorResultDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
            [auhtorResultDic setObject:[curatedNews valueForKey:@"articleId"] forKey:@"articleId"];
            NSData *authorJsondata = [NSJSONSerialization dataWithJSONObject:auhtorResultDic options:NSJSONWritingPrettyPrinted error:nil];
            
            NSString *authorResultStr = [[NSString alloc]initWithData:authorJsondata encoding:NSUTF8StringEncoding];
            
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                //Background Thread
                [[FISharedResources sharedResourceManager]getCuratedNewsDetailsWithDetails:resultStr];
                [[FISharedResources sharedResourceManager]getCuratedNewsAuthorDetailsWithDetails:authorResultStr withArticleId:[curatedNews valueForKey:@"articleId"]];
                
            });
            
        }
        
        [curatedNewsDetail setValue:[NSNumber numberWithBool:YES] forKey:@"saveForLater"];
        [curatedNews setValue:[NSNumber numberWithBool:YES] forKey:@"saveForLater"];
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
        [[FISharedResources sharedResourceManager]setUserActivitiesOnArticlesWithDetails:resultStr];
        [self.view makeToast:@"Added to \"Saved for Later\"" duration:1.0 position:CSToastPositionCenter];
    }
    } else {
        [FIUtils showNoNetworkToast];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView
                  willDecelerate:(BOOL)decelerate{
    if(self.devices.count > 9){
    CGPoint offset = self.articlesTableView.contentOffset;
    CGRect bounds = self.articlesTableView.bounds;
    CGSize size = self.articlesTableView.contentSize;
    UIEdgeInsets inset = self.articlesTableView.contentInset;
    
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = 50;
    if(y > h + reload_distance) {
        //NSLog(@"load more data");
        
      _spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _spinner.frame=CGRectMake(0, 0, 310, 44);
        [_spinner startAnimating];
        
        _spinner.hidden=NO;
        
        self.articlesTableView.tableFooterView = _spinner;
        
        NSManagedObject *curatedNews = [self.devices lastObject];
        NSString *inputJson;
        
            inputJson = [FIUtils createInputJsonForContentWithToekn:[[NSUserDefaults standardUserDefaults] valueForKey:@"accesstoken"] lastArticleId:[curatedNews valueForKey:@"articleId"] contentTypeId:@"1" listSize:10 activityTypeId:@"" categoryId:[[NSUserDefaults standardUserDefaults] valueForKey:@"categoryId"]];
        [[FISharedResources sharedResourceManager]getCuratedNewsListWithAccessToken:inputJson withCategoryId:[[[NSUserDefaults standardUserDefaults] valueForKey:@"categoryId"] integerValue] withFlag:@""];
        }
        //[self reloadData];
    }
}

@end
