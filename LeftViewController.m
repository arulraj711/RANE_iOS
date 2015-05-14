//
//  LeftViewController.m
//  FullIntel
//
//  Created by Arul on 2/17/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "LeftViewController.h"
#import "RADataObject.h"
#import "RATableViewCell.h"
#import "FISharedResources.h"
#import "FIMenu.h"
#import "PKRevealController.h"
#import "CorporateNewsListView.h"
#import "InfluencerListView.h"
#import "AddContentFirstLevelView.h"
#import "FIUtils.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FIUtils.h"
#define UIColorFromRGB(rgbValue)[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface LeftViewController () <RATreeViewDelegate, RATreeViewDataSource>

@property (strong, nonatomic) NSMutableArray *data;
@property (weak, nonatomic) RATreeView *treeView;

@property (strong, nonatomic) UIBarButtonItem *editButton;

@end

@implementation LeftViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMenus) name:@"MenuList" object:nil];
    self.addContentButton.layer.cornerRadius = 5.0f;
    self.addContentButton.layer.masksToBounds = YES;
    self.addContentButton.layer.borderWidth = 1.0f;
    self.addContentButton.layer.borderColor = [UIColor colorWithRed:(220/255.0) green:(223/255.0) blue:(224/255.0) alpha:1].CGColor;    
    
    NSMutableArray *objectArray;
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:@"MenuList"];
    if (dataRepresentingSavedArray != nil)
    {
        NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
        if (oldSavedArray != nil)
            objectArray = [[NSMutableArray alloc] initWithArray:oldSavedArray];
        else
            objectArray = [[NSMutableArray alloc] init];
    }
    treeView = [[RATreeView alloc] initWithFrame:self.treeBackView.bounds];
    treeView.delegate = self;
    treeView.dataSource = self;
    treeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
    [treeView reloadData];
    [treeView setBackgroundColor:[UIColor clearColor]];
    self.treeView = treeView;
    [self.treeBackView addSubview:self.treeView];
   // NSLog(@"menu array count in viewdidload:%lu",(unsigned long)objectArray.count);
    
    
    self.isFirstTime = YES;
    
    
    [self.treeView registerNib:[UINib nibWithNibName:NSStringFromClass([RATableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([RATableViewCell class])];
    
    //[self.treeBackView insertSubview:treeView atIndex:0];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = NSLocalizedString(@"Things", nil);
    [self updateNavigationItemButton];
    
    
    self.menus = [[NSMutableArray alloc]initWithArray:objectArray];
    [self test:self.menus];
    [treeView reloadData];
    
    
    if(self.data.count > 1) {
        [self.treeView selectRowForItem:[self.data objectAtIndex:2] animated:YES scrollPosition:RATreeViewScrollPositionTop];
        [self treeView:self.treeView didSelectRowForItem:[self.data objectAtIndex:2]];
    }
}

-(void)viewDidAppear:(BOOL)animated {
   
//    if([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >= 7) {
//        CGRect statusBarViewRect = [[UIApplication sharedApplication] statusBarFrame];
//        float heightPadding = statusBarViewRect.size.height+self.navigationController.navigationBar.frame.size.height;
//        self.treeView.contentInset = UIEdgeInsetsMake(heightPadding, 0.0, 0.0, 0.0);
//        self.treeView.contentOffset = CGPointMake(0.0, -heightPadding);
//    }
    
    self.treeView.frame = self.treeBackView.bounds;
    NSString *companyLogoImageStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"companyLogo"];
    NSString *companyNameStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"companyName"];
    
    [self.companyLogo sd_setImageWithURL:[NSURL URLWithString:companyLogoImageStr] placeholderImage:nil];
    self.companyName.text = [companyNameStr uppercaseString];
    
}

-(void)loadMenus {
    self.menus = [[NSMutableArray alloc]initWithArray:[FISharedResources sharedResourceManager].menuList];
    [self test:self.menus];
    [treeView reloadData];
    NSString *accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"];
    if(accessToken.length > 0) {
        [self.treeView selectRowForItem:[self.data objectAtIndex:2] animated:YES scrollPosition:RATreeViewScrollPositionTop];
        [self treeView:self.treeView didSelectRowForItem:[self.data objectAtIndex:2]];
    }
    
}

-(void)test:(NSMutableArray *)array {
    
    self.data = [[NSMutableArray alloc]init];
    for(FIMenu *menu in array) {
        
        RADataObject *dataObj = [self recursiveDataObjectFrom:menu];
       // NSLog(@"for loop:%@",dataObj);
        [self.data addObject:dataObj];
    }
    //self.data = [NSArray arrayWithObjects:phone, computer, car, bike, house, flats, motorbike, drinks, food, nil];
    RADataObject *dataObj = [[RADataObject alloc]init];
    dataObj.name = @"LOGOUT";
    dataObj.children = nil;
    [self.data addObject:dataObj];
   // [treeView reloadData];
}

-(RADataObject *)recursiveDataObjectFrom:(FIMenu *)menu {
    RADataObject *dataObj = [[RADataObject alloc]init];
    dataObj.name = menu.name;
    dataObj.nodeId = menu.nodeId;
    dataObj.unReadCount = menu.unreadCount;
   // menu.name = [dic objectForKey:@"Name"];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSArray *menuArray = menu.listArray;
    for(FIMenu *dict in menuArray) {
        RADataObject *insideMenu = [self recursiveDataObjectFrom:dict];
        [array addObject:insideMenu];
    }
    dataObj.children = array;
    //menu.listArray = array;
    return dataObj;
}

-(void)viewDidDisappear:(BOOL)animated {
   // [self.treeView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    if([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >= 7) {
//        CGRect statusBarViewRect = [[UIApplication sharedApplication] statusBarFrame];
//        float heightPadding = statusBarViewRect.size.height+self.navigationController.navigationBar.frame.size.height;
//        self.treeView.contentInset = UIEdgeInsetsMake(heightPadding, 0.0, 0.0, 0.0);
//        self.treeView.contentOffset = CGPointMake(0.0, -heightPadding);
//    }
//    
//    self.treeView.frame = self.treeBackView.bounds;
}


#pragma mark - Actions

- (void)editButtonTapped:(id)sender
{
    [self.treeView setEditing:!self.treeView.isEditing animated:YES];
    [self updateNavigationItemButton];
}

- (void)updateNavigationItemButton
{
    UIBarButtonSystemItem systemItem = self.treeView.isEditing ? UIBarButtonSystemItemDone : UIBarButtonSystemItemEdit;
    self.editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:self action:@selector(editButtonTapped:)];
    self.navigationItem.rightBarButtonItem = self.editButton;
}


#pragma mark TreeView Delegate methods

- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item
{
    return 40;
}

- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item
{
    return YES;
}

- (void)treeView:(RATreeView *)treeViews willExpandRowForItem:(id)item
{
    RATableViewCell *cell = (RATableViewCell *)[treeViews cellForItem:item];
    [cell setAdditionButtonHidden:NO animated:YES];
}

- (void)treeView:(RATreeView *)treeViews willCollapseRowForItem:(id)item
{
    RATableViewCell *cell = (RATableViewCell *)[treeViews cellForItem:item];
    [cell setAdditionButtonHidden:YES animated:YES];
}

- (void)treeView:(RATreeView *)treeView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowForItem:(id)item
{
    if (editingStyle != UITableViewCellEditingStyleDelete) {
        return;
    }
    
    RADataObject *parent = [self.treeView parentForItem:item];
    NSInteger index = 0;
    
    if (parent == nil) {
        index = [self.data indexOfObject:item];
        NSMutableArray *children = [self.data mutableCopy];
        [children removeObject:item];
        self.data = [children copy];
        
    } else {
        index = [parent.children indexOfObject:item];
        [parent removeChild:item];
    }
    
    [self.treeView deleteItemsAtIndexes:[NSIndexSet indexSetWithIndex:index] inParent:parent withAnimation:RATreeViewRowAnimationRight];
    if (parent) {
        [self.treeView reloadRowsForItems:@[parent] withRowAnimation:RATreeViewRowAnimationNone];
    }
}




#pragma mark TreeView Data Source


//- (void)treeView:(RATreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item {
//    RATableViewCell *cell1 = (RATableViewCell*)[self.treeView cellForItem:item];
//    if(cell1.isSelected) {
//        NSLog(@"cell is selected");
//        cell1.customTitleLabel.textColor = UIColorFromRGB(0x1e8cd4);
//    }else {
//        NSLog(@"cell is not selected");
//        cell1.customTitleLabel.textColor = [UIColor blackColor];
//    }
//}


- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item
{
    //NSLog(@"cell for item");
    
    RADataObject *dataObject = item;
    NSInteger level = [self.treeView levelForCellForItem:item];
    NSInteger numberOfChildren = [dataObject.children count];
    
    NSString *detailText = [NSString localizedStringWithFormat:@"Number of children %@", [@(numberOfChildren) stringValue]];
    BOOL expanded = [self.treeView isCellForItemExpanded:item];
   
    RATableViewCell *cell = [self.treeView dequeueReusableCellWithIdentifier:NSStringFromClass([RATableViewCell class])];
    
    [cell setupWithTitle:dataObject.name detailText:detailText level:level additionButtonHidden:!expanded];
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithRed:(230/255.0) green:(230/255.0) blue:(230/255.0) alpha:1];
    cell.selectedBackgroundView = selectionColor;
    if(![[dataObject.name uppercaseString] isEqualToString:@"MARKED IMPORTANT"]) {
        UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        separatorLineView.backgroundColor = [UIColor colorWithRed:(220/255.0) green:(223/255.0) blue:(224/255.0) alpha:1];
        [cell.contentView addSubview:separatorLineView];
    }
    if([dataObject.unReadCount intValue] > 0) {
        cell.countLabel.hidden = NO;
        cell.countLabel.text = [NSString stringWithFormat:@"%@",dataObject.unReadCount];
    }else {
        cell.countLabel.hidden = YES;
    }
    if(numberOfChildren > 0) {
        cell.expandButton.hidden = NO;
        [cell.expandButton addTarget:self action:@selector(dropDown) forControlEvents:UIControlEventTouchUpInside];
    }else {
        cell.expandButton.hidden = YES;
    }
    __weak typeof(self) weakSelf = self;
    cell.additionButtonTapAction = ^(id sender){
        if (![weakSelf.treeView isCellForItemExpanded:dataObject] || weakSelf.treeView.isEditing) {
            return;
        }
        RADataObject *newDataObject = [[RADataObject alloc] initWithName:@"Added value" children:@[]];
        [dataObject addChild:newDataObject];
        [weakSelf.treeView insertItemsAtIndexes:[NSIndexSet indexSetWithIndex:0] inParent:dataObject withAnimation:RATreeViewRowAnimationLeft];
        [weakSelf.treeView reloadRowsForItems:@[dataObject] withRowAnimation:RATreeViewRowAnimationNone];
    };
    
    
    
    CGFloat left;
    if([dataObject.nodeId integerValue] == 9) {
        left = 40 + 11 + 20 * level;
        cell.iconImage.hidden = NO;
        cell.iconImage.image = [UIImage imageNamed:@"markedImp"];
    } else if([dataObject.nodeId integerValue] == 6) {
        left = 40 + 11 + 20 * level;
        cell.iconImage.hidden = NO;
        cell.iconImage.image = [UIImage imageNamed:@"savedForLater"];
    } else if([[dataObject.name uppercaseString] isEqualToString:@"LOGOUT"]) {
        left = 40 + 11 + 20 * level;
        cell.iconImage.hidden = NO;
        cell.iconImage.image = [UIImage imageNamed:@"logout"];
    } else {
        left = 34 + 20 * level;
        cell.iconImage.hidden = YES;
    }
    CGRect titleFrame = cell.customTitleLabel.frame;
    titleFrame.origin.x = left;
    cell.customTitleLabel.frame = titleFrame;
    
    
    
    
    return cell;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [self.data count];
    }
    
    RADataObject *data = item;
    return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    RADataObject *data = item;
    if (item == nil) {
        return [self.data objectAtIndex:index];
    }
    
    return data.children[index];
}

-(void)dropDown {
   // [self.revealController showViewController:self.revealController.frontViewController];
    
}
-(void)treeView:(RATreeView *)treeView didDeselectRowForItem:(id)item {
    RATableViewCell *cell = (RATableViewCell *)[self.treeView cellForItem:item];
    cell.customTitleLabel.textColor = UIColorFromRGB(0x666E73);
    cell.iconImage.image = [cell.iconImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    cell.iconImage.tintColor = UIColorFromRGB(0x666E73);
}




- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item {
    RADataObject *data = item;
   // NSLog(@"did select row:%@",data.name);
    RATableViewCell *cell = (RATableViewCell *)[self.treeView cellForItem:item];
    BOOL expanded = [self.treeView isCellForItemExpanded:item];
    if(expanded) {
       // NSLog(@"list is expanded");
        [cell.expandButton setSelected:NO];
    }else {
       // NSLog(@"list is clopsed");
        [cell.expandButton setSelected:YES];
    }
    if([data.name isEqualToString:@"LOGOUT"]) {
        cell.customTitleLabel.textColor = UIColorFromRGB(0x666E73);
        cell.iconImage.image = [cell.iconImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        cell.iconImage.tintColor = UIColorFromRGB(0x666E73);
    } else {
        cell.customTitleLabel.textColor = UIColorFromRGB(0x1e8cd4);
        cell.iconImage.image = [cell.iconImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        cell.iconImage.tintColor = UIColorFromRGB(0x1e8cd4);
    }
    
    if([data.nodeId integerValue] == 9) {
        NSMutableDictionary *gradedetails = [[NSMutableDictionary alloc] init];
        [gradedetails setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
        [gradedetails setObject:@"" forKey:@"lastArticleId"];
        [gradedetails setObject:[NSNumber numberWithInt:10] forKey:@"listSize"];
        [gradedetails setObject:@"2" forKey:@"activityTypeIds"];
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:gradedetails options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
        [[FISharedResources sharedResourceManager]getCuratedNewsListWithAccessToken:resultStr withCategoryId:-2 withFlag:@""];
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:-2] forKey:@"categoryId"];
        
    } else if([data.nodeId integerValue] == 1) {
        NSMutableDictionary *gradedetails = [[NSMutableDictionary alloc] init];
        NSString *accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"];
        [gradedetails setObject:accessToken forKey:@"securityToken"];
        [gradedetails setObject:@"" forKey:@"lastArticleId"];
        [gradedetails setObject:[NSNumber numberWithInt:10] forKey:@"listSize"];
        [gradedetails setObject:@"" forKey:@"activityTypeIds"];
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:gradedetails options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
        if(accessToken.length > 0) {
        [[FISharedResources sharedResourceManager]getCuratedNewsListWithAccessToken:resultStr withCategoryId:-1 withFlag:@""];
        }
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:-1] forKey:@"categoryId"];
        
    } else if([data.nodeId integerValue] == 6) {
        NSMutableDictionary *gradedetails = [[NSMutableDictionary alloc] init];
        [gradedetails setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
        [gradedetails setObject:@"" forKey:@"lastArticleId"];
        [gradedetails setObject:[NSNumber numberWithInt:10] forKey:@"listSize"];
        [gradedetails setObject:@"3" forKey:@"activityTypeIds"];
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:gradedetails options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
        [[FISharedResources sharedResourceManager]getCuratedNewsListWithAccessToken:resultStr withCategoryId:-3 withFlag:@""];
       
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:-3] forKey:@"categoryId"];
        
    } else if([data.nodeId integerValue] == 7) {
        UIStoryboard *centerStoryBoard = [UIStoryboard storyboardWithName:@"InfluencerListView" bundle:nil];
        UINavigationController *navCtlr = [centerStoryBoard instantiateViewControllerWithIdentifier:@"InfluencerView"];
        [[UINavigationBar appearance] setBarTintColor: [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0]];
        navCtlr.navigationBar.tintColor = [UIColor whiteColor];
        [self.revealController setFrontViewController:navCtlr];
    } else if([[data.name uppercaseString] isEqualToString:@"LOGOUT"]) {
        
        NSMutableDictionary *logoutDic = [[NSMutableDictionary alloc] init];
        [logoutDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:logoutDic options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
        [[FISharedResources sharedResourceManager] logoutUserWithDetails:resultStr withFlag:[NSNumber numberWithInt:1]];
        [FIUtils deleteExistingData];
        
       
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"accesstoken"];
        UIStoryboard *centerStoryBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];
        UINavigationController *navCtlr = [centerStoryBoard instantiateViewControllerWithIdentifier:@"CorporateView"];
        [[UINavigationBar appearance] setBarTintColor: [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0]];
        navCtlr.navigationBar.tintColor = [UIColor whiteColor];
        [self.revealController setFrontViewController:navCtlr];
        [self.revealController showViewController:self.revealController.frontViewController];
    }
    
    if([[data.name uppercaseString] isEqualToString:@"LOGOUT"]) {
    } else {
    if([data.nodeId integerValue] == 1 || [data.nodeId integerValue] == 9 || [data.nodeId integerValue] == 6) {
       // NSLog(@"empty node id");
    }else {
        //NSLog(@"full node id");
        NSString *inputJson = [FIUtils createInputJsonForContentWithToekn:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] lastArticleId:@"" contentTypeId:@"1" listSize:10 activityTypeId:@"" categoryId:data.nodeId];
        [[NSUserDefaults standardUserDefaults]setObject:data.nodeId forKey:@"categoryId"];
        
        [[FISharedResources sharedResourceManager]getCuratedNewsListWithAccessToken:inputJson withCategoryId:[data.nodeId integerValue] withFlag:@""];
        }
    }
}


- (IBAction)addContentButtonClick:(id)sender {
    
    
    
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"AddContent" bundle:nil];
    
    UINavigationController *modalController = [storyBoard instantiateViewControllerWithIdentifier:@"addContentNav"];
   // UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"modal"];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:modalController];
    
    formSheet.presentedFormSheetSize = CGSizeMake(800, 650);
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
@end
