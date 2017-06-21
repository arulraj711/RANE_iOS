//
//  AddContentFirstLevelView.m
//  FullIntel
//
//  Created by Arul on 4/15/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "AddContentFirstLevelView.h"
#import "FirstLevelCell.h"
#import "MZFormSheetController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FISharedResources.h"
#import "FIContentCategory.h"
#import "UIView+Toast.h"
#import "AddContentSecondLevelView.h"
#import "FIUtils.h"
#import "FIMenu.h"
#import "FIUnreadMenu.h"
//#import "Localytics.h"
#import "pop.h"
#import "UILabel+CustomHeaderLabel.h"
#import "UIColor+CustomColor.h"
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
@interface AddContentFirstLevelView ()


@property (nonatomic, readwrite) BOOL isContentChanged;
@end

@implementation AddContentFirstLevelView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noSearchResultsFoundText.hidden = YES;
    // Do any additional setup after loading the view.
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMenusFromService:) name:@"MenuList" object:nil];
    searchArray = [[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUnreadCount:) name:@"AddContentMenuAPI" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadContentCategory) name:@"contentCategory" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddContentExpire) name:@"AddContentExpire" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentSelected) name:@"contentSelected" object:nil];
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backBtnPress) name:@"closeAddContentView" object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChangeNotification:)
                                                name:UITextFieldTextDidChangeNotification object:nil];
    
    
    UIImageView *envelopeView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 16, 15)];
    envelopeView.image = [UIImage imageNamed:@"searchTextField"];
    envelopeView.contentMode = UIViewContentModeScaleAspectFit;
    UIView *test=  [[UIView alloc]initWithFrame:CGRectMake(5, 0, 26, 15)];
    [test addSubview:envelopeView];
    [self.searchTextField.leftView setFrame:envelopeView.frame];
    self.searchTextField.leftView =test;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
     self.searchTextField.layer.cornerRadius=5.0f;
    
    
//    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
//    self.searchTextField.leftView = paddingView;
//    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
//    self.searchTextField.leftViewMode = UITextFieldViewModeUnlessEditing;
//    self.searchTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];
    
    
//    layout = (id)[self.contentCollectionView collectionViewLayout];
//    layout.direction = UICollectionViewScrollDirectionVertical;
//    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
//    //NSLog(@"current device orientation:%ld",(long)orientation);
//    
//    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
//        if (IS_IPHONE_6)
//        {
//        layout.blockPixels = CGSizeMake(500,110);
//            
//            
//        }
//        else if (IS_IPHONE_6P)
//        {
//        layout.blockPixels = CGSizeMake(500,110);
//
//        }
//
//    } else {
//        if(orientation == 1) {
//            layout.blockPixels = CGSizeMake(120,150);
//        }else {
//            layout.blockPixels = CGSizeMake(130,150);
//        }
//    }
    
    
    //[self.contentCollectionView reloadData];
    self.selectedIdArray = [[NSMutableArray alloc]init];
    self.checkedArray = [[NSMutableArray alloc]init];
    self.uncheckedArray = [[NSMutableArray alloc]init];
    [[NSUserDefaults standardUserDefaults]setObject:self.selectedIdArray forKey:@"secondLevelSelection"];
    [[NSUserDefaults standardUserDefaults]setObject:self.selectedIdArray forKey:@"thirdLevelSelection"];
    [[NSUserDefaults standardUserDefaults]setObject:self.selectedIdArray forKey:@"fourthLevelSelection"];
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"];
    [[FISharedResources sharedResourceManager]getAddContentMenuWithAccessToken:accessToken];
    //[[FISharedResources sharedResourceManager]getMenuListWithAccessToken:accessToken];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
//        label.backgroundColor = [UIColor clearColor];
//        label.font = [UIFont fontWithName:@"Open Sans" size:16];
//        label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
//        label.text =@"Add Content";
//        label.textAlignment = NSTextAlignmentCenter;
//        label.textColor = [UIColor whiteColor]; // change this color
        self.navigationItem.titleView = [UILabel setCustomHeaderLabelFromText:@"Add Content"];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Cancel"
                                       style:UIBarButtonItemStyleBordered
                                       target:self
                                       action:@selector(cancelButtonPress)];
        self.navigationItem.leftBarButtonItem = cancelButton;
        
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"CloseAddContentTutorial"];
   
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                         initWithTitle:@"Save"
                                         style:UIBarButtonItemStyleBordered
                                         target:self
                                       action:@selector(updateAddContent)];
        self.navigationItem.rightBarButtonItem = saveButton;
    }
    else{
        UIButton *Btn =[UIButton buttonWithType:UIButtonTypeCustom];
        
        [Btn setFrame:CGRectMake(0, 0, 60, 30)];
        // [Btn setBackgroundImage:[UIImage imageNamed:@"close"]  forState:UIControlStateNormal];
        
        [Btn setTitle:@"Cancel" forState:UIControlStateNormal];
        
        Btn.titleLabel.font= [UIFont fontWithName:@"OpenSans" size:17];
        [Btn addTarget:self action:@selector(backBtnPress) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:Btn];
        [[UIBarButtonItem appearance]setTintColor:[UIColor buttonTextColor]];
        [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:addButton,  nil]];
        
        
        
        UIButton *addBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setFrame:CGRectMake(0,0,50,30)];
        // [addBtn setImage :[UIImage imageNamed:@"checkMark"]  forState:UIControlStateNormal];
        
        [addBtn setTitle:@"Save" forState:UIControlStateNormal];
        
        addBtn.titleLabel.font= [UIFont fontWithName:@"OpenSans" size:17];
        [addBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *addContentButton = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
        [[UIBarButtonItem appearance]setTintColor:[UIColor buttonTextColor]];
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:addContentButton,  nil]];
        
        
//        _requestChangeButton.layer.cornerRadius=5.0f;
//        _requestChangeButton.layer.borderColor=[[UIColor darkGrayColor]CGColor];
//        _requestChangeButton.layer.borderWidth=1.0f;
        
    }
    _tutorialDescriptionView.hidden=YES;
        BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"TutorialShown"];
    if (coachMarksShown == YES) {
        _tutorialDescriptionView.hidden=YES;
        
    }else{
        
        _tutorialDescriptionView.hidden=NO;
    }
    
    _tutorialDescriptionView.layer.cornerRadius=5.0f;
    
    
    UITapGestureRecognizer *tapEvent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(triggerSecondTutorial)];
    
    [self.view addGestureRecognizer:tapEvent];
    
    
//    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
//    NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:@"MenuList"];
//    if (dataRepresentingSavedArray.length != 0)
//    {
//        NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
//        self.contentTypeArray = [[NSMutableArray alloc]initWithArray:oldSavedArray];
//    }
//    
//    
//    NSLog(@"content type array count :%d",self.contentTypeArray.count);
    
}

//-(void)loadMenusFromService:(NSNotification *)notification {
//    
//    NSString *accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"];
//    [[FISharedResources sharedResourceManager]getMenuUnreadCountWithAccessToken:accessToken];
//    
//    menuArray = notification.object;
//    self.contentTypeArray = [[NSMutableArray alloc]initWithArray:menuArray];
////    for(FIMenu *menu in menuArray) {
////        if([menu.isSubscribed isEqualToNumber:[NSNumber numberWithBool:YES]]){
////            [self.contentTypeArray addObject:menu];
////        } else {
////            
////        }
////    }
//    NSLog(@"content type array count :%d",self.contentTypeArray.count);
//    //[self.contentCollectionView reloadData];
//}



-(void)textChangeNotification:(NSNotification *)notification {
    NSLog(@"search notification");
    [self searchRecordsAsPerText:self.searchTextField.text];
}

-(void)searchRecordsAsPerText:(NSString *)string {
    [searchArray removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[cd] %@", string];
    NSArray *filtered = [self.contentTypeArray filteredArrayUsingPredicate:predicate];
    NSLog(@"filtered array :%@",filtered);
    searchArray = [[NSMutableArray alloc]initWithArray:filtered];
    
    if(string.length != 0){
        if(searchArray.count != 0) {
            self.contentCollectionView.hidden = NO;
            self.noSearchResultsFoundText.hidden = YES;
            [self.contentCollectionView reloadData];
        } else {
            self.contentCollectionView.hidden = YES;
            self.noSearchResultsFoundText.hidden = NO;
        }
    } else if(string.length == 0) {
        self.contentCollectionView.hidden = NO;
        self.noSearchResultsFoundText.hidden = YES;
        [self.contentCollectionView reloadData];
    }
    
//    if(string.length != 0 && searchArray.count != 0) {
//        self.contentCollectionView.hidden = NO;
//        self.noSearchResultsFoundText.hidden = YES;
//        [self.contentCollectionView reloadData];
//    } else {
//        self.contentCollectionView.hidden = YES;
//        self.noSearchResultsFoundText.hidden = NO;
//    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return TRUE;
}

-(void)updateUnreadCount:(NSNotification*)notification {
    NSArray  *unreadMenuArray = notification.object;
    
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:@"MenuList"];
    menuArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
    
    for(FIMenu *unreadMenu in unreadMenuArray) {
        for(FIMenu *menu in menuArray) {
            NSLog(@"menu Id :%@ and %@",unreadMenu.nodeId,menu.nodeId);
            if([unreadMenu.nodeId isEqualToNumber:menu.nodeId]) {
                NSLog(@"list array :%@",unreadMenu.listArray);
                menu.listArray = unreadMenu.listArray;
                menu.articleCount = unreadMenu.articleCount;
            }
        }
    }
    NSLog(@"after");
    
//    unreadCnt = 0;
//    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
//    NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:@"MenuList"];
//    menuArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
//    for(FIMenu *menu in menuArray) {
//        //NSLog(@"old count array:%@",unreadMenuArray);
//        for(FIUnreadMenu *unreadMenu in unreadMenuArray) {
//            //NSLog(@"unread count:%@",unreadMenu.unreadCount);
//            //NSLog(@"nodeid:%@:%@ and :%@",menu.name,menu.nodeId,unreadMenu.nodeId);
//            if([menu.nodeId isEqualToNumber:unreadMenu.nodeId] && [menu.companyId isEqualToNumber:unreadMenu.companyId]) {
//                menu.unreadCount = unreadMenu.unreadCount;
//                if([menu.subListAvailable isEqualToNumber:[NSNumber numberWithBool:YES]] && [unreadMenu.subListAvailable isEqualToNumber:[NSNumber numberWithBool:YES]]) {
//                    [self setSubMenuArticleCount:menu.listArray with:unreadMenu.listArray];
//                }
//                else if(!unreadMenu.subListAvailable){
//                    menu.subListAvailable = unreadMenu.subListAvailable;
//                }
//            }
//        }
//    }
    [self loadMenus];
}

-(void)loadMenus {
    self.menus = [[NSMutableArray alloc]initWithArray:menuArray];
    [self test:self.menus];
}


-(void)test:(NSMutableArray *)array {
    
    NSMutableDictionary *contentCategoryJSON = [[NSMutableDictionary alloc] init];
    [contentCategoryJSON setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
    [contentCategoryJSON setObject:[NSNumber numberWithBool:NO] forKey:@"updateCategory"];
    
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:contentCategoryJSON options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
    [[FISharedResources sharedResourceManager]manageContentCategoryWithDetails:resultStr withFlag:0];
    
    
    //[self.contentCollectionView reloadData];
}

-(FIMenu *)recursiveDataObjectFrom:(FIMenu *)menu {
    FIMenu *dataObj = [[FIMenu alloc]init];
    if([menu.nodeId isEqualToNumber:[NSNumber numberWithInt:9]]) {
        NSManagedObject *markedImpBrandingIdentity = [FIUtils getBrandFromBrandingIdentityForId:[NSNumber numberWithInt:1]];
        NSString *markedImportantName = [NSString stringWithFormat:@"%@",[markedImpBrandingIdentity valueForKey:@"name"]];
        dataObj.name = [markedImportantName uppercaseString];
    } else if([menu.nodeId isEqualToNumber:[NSNumber numberWithInt:6]]) {
        NSManagedObject *savedForLaterBrandingIdentity = [FIUtils getBrandFromBrandingIdentityForId:[NSNumber numberWithInt:2]];
        NSString *savedForLaterName = [NSString stringWithFormat:@"%@",[savedForLaterBrandingIdentity valueForKey:@"name"]];
        dataObj.name = [savedForLaterName uppercaseString];
    } else {
        dataObj.name = menu.name;
    }
    
    //    NSMutableArray *unreadMenuArray = [[FISharedResources sharedResourceManager]menuUnReadCountArray];
    //    NSLog(@"unread menu array:%@ and selected item:%@",unreadMenuArray,data.name);
    //    for(FIUnreadMenu *unreadMenu in unreadMenuArray) {
    //        NSLog(@"%@ ----> %@",menu.nodeId,unreadMenu.nodeId);
    //        if(menu.nodeId == unreadMenu.nodeId) {
    //            dataObj.articleCount = unreadMenu.articleCount;
    //        }
    //
    //
    
    //NSLog(@"aaaaaaa:%@",menu.articleCount);
    dataObj.companyId = menu.companyId;
    dataObj.nodeId = menu.nodeId;
    dataObj.unreadCount = menu.unreadCount;
    dataObj.subListAvailable = menu.subListAvailable;
    dataObj.isParent = menu.isParent;
    dataObj.articleCount = menu.articleCount;
    dataObj.isSubscribed = menu.isSubscribed;
   // dataObj.iconURL = menu.menuIconURL;
    // menu.name = [dic objectForKey:@"Name"];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    //if([menu.subListAvailable isEqualToNumber:[NSNumber numberWithBool:YES]]) {
    //subListAvailabel TRUE
    NSArray *menuArray = menu.listArray;
    for(FIMenu *dict in menuArray) {
        FIMenu *insideMenu = [self recursiveDataObjectFrom:dict];
//        NSLog(@"inside menu name :%@",insideMenu.name);
        if([insideMenu.isParent isEqualToNumber:[NSNumber numberWithInt:-1]] || (![insideMenu.isParent isEqualToNumber:[NSNumber numberWithInt:-1]] && ![insideMenu.articleCount isEqualToNumber:[NSNumber numberWithInt:0]])) {
            [array addObject:insideMenu];
        }
    }
    //    } else {
    //        //subListAvailabel FALSE
    //    }
    
    dataObj.children = array;
    //menu.listArray = array;
    return dataObj;
}



-(void) setSubMenuArticleCount:(NSMutableArray*)existMenu with:(NSMutableArray *)countMenu {
    bool hasSub = false;
    for(FIMenu *menu in existMenu) {
        for(FIUnreadMenu *unreadMenu in countMenu) {
            if([menu.nodeId isEqualToNumber:unreadMenu.nodeId] && [menu.companyId isEqualToNumber:unreadMenu.companyId ]) {
                //NSLog(@"unread counttttttt:%@",unreadMenu.articleCount);
                menu.articleCount = unreadMenu.articleCount;
                if(unreadMenu.articleCount > 0){
                    hasSub = true;
                }
            }
        }
        menu.subListAvailable = [NSNumber numberWithBool:hasSub];
        if(NULL != menu.listArray && menu.listArray.count > 0){
            [self setSubMenuArticleCount:menu.listArray with:countMenu];
        }
        
    }
}

-(void)cancelButtonPress{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)triggerSecondTutorial{
    
    
    
    BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"TutorialShown"];
    if (coachMarksShown == NO) {
        _tutorialDescriptionView.hidden=YES;
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"SecondLevelTutorialTrigger" object:nil];
        
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"TutorialShown"];
        
        [popAnimationTimer invalidate];
        
        [_contentCollectionView reloadData];
        
    }
    
}


-(void)backBtnPress{
    
    [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"CancelChangesInAddContent"];
    BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"CloseAddContentTutorial"];
    if (coachMarksShown == YES) {
        
        //[[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"CancelChangesInAddContent"];
        
        [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    // NSLog(@"device rotate is working:%ld",(long)fromInterfaceOrientation);
//    if(fromInterfaceOrientation == 1) {
//        layout.blockPixels = CGSizeMake(130,150);
//    }else {
//        layout.blockPixels = CGSizeMake(120,150);
//    }
    
}

-(void)contentSelected{
    
    _isContentChanged=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Access to form sheet controller
    MZFormSheetController *controller = self.navigationController.formSheetController;
    controller.shouldDismissOnBackgroundViewTap = YES;
    
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //    self.showStatusBar = YES;
    [UIView animateWithDuration:0.3 animations:^{
        [self.navigationController.formSheetController setNeedsStatusBarAppearanceUpdate];
    }];
    
}


-(void)loadContentCategory {
    NSLog(@"self :%@",self.menus);
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isThirdLevelChanged"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isFourthLevelChanged"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isFifthLevelChanged"];
    NSMutableArray *contentTypeArray = [[NSMutableArray alloc]initWithArray:[FISharedResources sharedResourceManager].contentTypeList];
    NSMutableArray *contentCategoryArray = [[NSMutableArray alloc]initWithArray:[FISharedResources sharedResourceManager].contentCategoryList];
    
    
    for(FIContentCategory *category in contentTypeArray) {
        for(FIMenu *menu in self.contentTypeArray) {
            //NSLog(@"menu id :%@ and %@",menu.nodeId,menu.subListAvailable);
            if([category.categoryId isEqualToNumber:menu.nodeId]){
                menu.contentTypeForCustomerId = category.contentTypeForCustomerId;
            }
        }
    }
    
    for(FIMenu *menu in self.menus) {
//        NSLog(@"menu article count :%@",menu.articleCount);
        NSLog(@"menu Id :%@",menu.listArray);
        for(FIMenu *insideMenu in menu.listArray) {
            NSLog(@"inside menu %@",insideMenu.nodeId);
            for(FIContentCategory *category in contentCategoryArray) {
                if([insideMenu.nodeId isEqualToNumber:category.categoryId]){
                    insideMenu.listArray = category.listArray;
                    insideMenu.name = category.name;
                    insideMenu.isSubscribed = [NSNumber numberWithBool:category.isSubscribed];
                    break;
                }
            }
        }
        
    }
    NSLog(@"data :%@",self.menus);
    self.data = [[NSMutableArray alloc]initWithArray:self.menus];
    
    
    //self.contentTypeArray = [[NSMutableArray alloc]init];

    
    for(FIMenu *menu in self.menus) {
        NSNumber *accountTypeIdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"userAccountTypeId"];
        
        // if([menu.isSubscribed isEqualToNumber:[NSNumber numberWithBool:YES]]) {
       // if([accountTypeIdStr isEqualToNumber:[NSNumber numberWithInt:3]]) {
            //handle test user
//            if([menu.nodeId isEqualToNumber:[NSNumber numberWithInt:7]] || [menu.nodeId isEqualToNumber:[NSNumber numberWithInt:5]] || [menu.nodeId isEqualToNumber:[NSNumber numberWithInt:2]] || [menu.nodeId isEqualToNumber:[NSNumber numberWithInt:4]] || [menu.nodeId isEqualToNumber:[NSNumber numberWithInt:8]]) {
//                [self.data removeObject:menu];
//            }
        
        if([menu.nodeId isEqualToNumber:[NSNumber numberWithInt:9]] || [menu.nodeId isEqualToNumber:[NSNumber numberWithInt:6]] || [menu.nodeId isEqualToNumber:[NSNumber numberWithInt:35]] || [menu.nodeId isEqualToNumber:[NSNumber numberWithInt:36]] || [menu.nodeId isEqualToNumber:[NSNumber numberWithInt:37]] || [menu.nodeId isEqualToNumber:[NSNumber numberWithInt:38]]) {
            [self.data removeObject:menu];
        }
        
    }
    
    
    
    
    
    self.contentTypeArray = [[NSMutableArray alloc]initWithArray:self.data];
    

    for(FIContentCategory *category in contentTypeArray) {
        if(category.isSubscribed) {
            NSMutableDictionary *dic =[[NSMutableDictionary alloc]init];
            [dic setValue:category.categoryId forKey:@"id"];
            [dic setValue:category.companyId forKey:@"companyId"];
            [dic setValue:category.contentTypeForCustomerId forKey:@"contentTypeForCustomerId"];
            [self.checkedArray addObject:dic];
            [self.selectedIdArray addObject:category.categoryId];
        } else {
            NSMutableDictionary *dic =[[NSMutableDictionary alloc]init];
            [dic setValue:category.categoryId forKey:@"id"];
            [dic setValue:category.companyId forKey:@"companyId"];
            [dic setValue:category.contentTypeForCustomerId forKey:@"contentTypeForCustomerId"];
            [self.uncheckedArray addObject:dic];
            [self.selectedIdArray removeObject:category.categoryId];
        }
    }
    [self.contentCollectionView reloadData];
    
}

- (void)secondLevelDidFinish:(AddContentSecondLevelView*)secondLevel {
    // NSLog(@"first level delegate method is working fine:%@",secondLevel.previousArray);
    if(secondLevel.previousArray != 0) {
        self.selectedIdArray = secondLevel.previousArray;
    } else {
        [self.selectedIdArray removeAllObjects];
    }
    [self.contentCollectionView reloadData];
}


- (IBAction)requestChange:(id)sender {
    
    BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"CloseAddContentTutorial"];
    if (coachMarksShown == YES) {
        
        [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"requestChange" object:nil userInfo:nil];
        [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"ResearchRequestChangeInAddContent"];
    }
}

-(void)AddContentExpire {
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)updateAddContent {
    [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"SaveChangesInAddContent"];
    BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"CloseAddContentTutorial"];
    if (coachMarksShown == YES) {
        
        NSMutableArray *categoryArray = [[NSMutableArray alloc]init];
        NSMutableArray *contentType = [[NSMutableArray alloc]init];
        
        NSMutableArray *secondLevelSelection = [[NSUserDefaults standardUserDefaults]objectForKey:@"secondLevelSelection"];
        for(int i=0;i<secondLevelSelection.count;i++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:[secondLevelSelection objectAtIndex:i] forKey:@"id"];
            [dic setObject:[NSNumber numberWithBool:YES] forKey:@"isSubscribed"];
            [categoryArray addObject:dic];
        }
        
        NSMutableArray *secondLevelUnSelection = [[NSUserDefaults standardUserDefaults]objectForKey:@"secondLevelUnSelection"];
        for(int i=0;i<secondLevelUnSelection.count;i++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:[secondLevelUnSelection objectAtIndex:i] forKey:@"id"];
            [dic setObject:[NSNumber numberWithBool:NO] forKey:@"isSubscribed"];
            [categoryArray addObject:dic];
        }
        
        
        NSMutableArray *thirdLevelSelection = [[NSUserDefaults standardUserDefaults]objectForKey:@"thirdLevelSelection"];
        for(int i=0;i<thirdLevelSelection.count;i++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:[thirdLevelSelection objectAtIndex:i] forKey:@"id"];
            [dic setObject:[NSNumber numberWithBool:YES] forKey:@"isSubscribed"];
            [categoryArray addObject:dic];
        }
        
        NSMutableArray *thirdLevelUnSelection = [[NSUserDefaults standardUserDefaults]objectForKey:@"thirdLevelUnSelection"];
        for(int i=0;i<thirdLevelUnSelection.count;i++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:[thirdLevelUnSelection objectAtIndex:i] forKey:@"id"];
            [dic setObject:[NSNumber numberWithBool:NO] forKey:@"isSubscribed"];
            [categoryArray addObject:dic];
        }
        
        NSMutableArray *fourthLevelSelection = [[NSUserDefaults standardUserDefaults]objectForKey:@"fourthLevelSelection"];
        for(int i=0;i<fourthLevelSelection.count;i++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:[fourthLevelSelection objectAtIndex:i] forKey:@"id"];
            [dic setObject:[NSNumber numberWithBool:YES] forKey:@"isSubscribed"];
            [categoryArray addObject:dic];
        }
        
        NSMutableArray *fourthLevelUnSelection = [[NSUserDefaults standardUserDefaults]objectForKey:@"fourthLevelUnSelection"];
        for(int i=0;i<fourthLevelUnSelection.count;i++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:[fourthLevelUnSelection objectAtIndex:i] forKey:@"id"];
            [dic setObject:[NSNumber numberWithBool:NO] forKey:@"isSubscribed"];
            [categoryArray addObject:dic];
        }
        
        NSMutableArray *fifthLevelSelection = [[NSUserDefaults standardUserDefaults]objectForKey:@"fifthLevelSelection"];
        for(int i=0;i<fifthLevelSelection.count;i++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:[fifthLevelSelection objectAtIndex:i] forKey:@"id"];
            [dic setObject:[NSNumber numberWithBool:YES] forKey:@"isSubscribed"];
            [categoryArray addObject:dic];
        }
        
        NSMutableArray *fifthLevelUnSelection = [[NSUserDefaults standardUserDefaults]objectForKey:@"fifthLevelUnSelection"];
        for(int i=0;i<fifthLevelUnSelection.count;i++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:[fifthLevelUnSelection objectAtIndex:i] forKey:@"id"];
            [dic setObject:[NSNumber numberWithBool:NO] forKey:@"isSubscribed"];
            [categoryArray addObject:dic];
        }
        
        
        for(int i=0;i<self.checkedArray.count;i++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            
            NSDictionary *contentTypeDic = [self.checkedArray objectAtIndex:i];
            
            [dic setObject:[contentTypeDic objectForKey:@"id"] forKey:@"id"];
            [dic setObject:[contentTypeDic objectForKey:@"companyId"] forKey:@"companyId"];
            [dic setObject:[contentTypeDic objectForKey:@"contentTypeForCustomerId"] forKey:@"contentTypeForCustomerId"];
            [dic setObject:[NSNumber numberWithBool:YES] forKey:@"isSubscribed"];
            [contentType addObject:dic];
        }
        for(int i=0;i<self.uncheckedArray.count;i++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            NSDictionary *contentTypeDic = [self.uncheckedArray objectAtIndex:i];
            
            [dic setObject:[contentTypeDic objectForKey:@"id"] forKey:@"id"];
            [dic setObject:[contentTypeDic objectForKey:@"companyId"] forKey:@"companyId"];
            [dic setObject:[contentTypeDic objectForKey:@"contentTypeForCustomerId"] forKey:@"contentTypeForCustomerId"];
            [dic setObject:[NSNumber numberWithBool:NO] forKey:@"isSubscribed"];
            [contentType addObject:dic];
        }
        // NSLog(@"content type %d and category:%d and checked array:%d and unchecked array:%@",contentType.count,categoryArray.count,self.checkedArray.count,contentType);
        if(self.checkedArray.count == 0) {
            NSManagedObject *addContentBrandingIdentity = [FIUtils getBrandFromBrandingIdentityForId:[NSNumber numberWithInt:35]];
            NSString *message = [NSString stringWithFormat:@"%@",[addContentBrandingIdentity valueForKey:@"name"]];
            [self.view makeToast:message duration:1 position:CSToastPositionCenter];
        } else {
            NSMutableDictionary *gradedetails = [[NSMutableDictionary alloc] init];
            [gradedetails setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
            [gradedetails setObject:[NSNumber numberWithBool:YES] forKey:@"updateCategory"];
            [gradedetails setObject:categoryArray forKey:@"contentCategory"];
            [gradedetails setObject:contentType forKey:@"contentType"];
            NSData *jsondata = [NSJSONSerialization dataWithJSONObject:gradedetails options:NSJSONWritingPrettyPrinted error:nil];
            
            NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
            NSLog(@"final json format:%@",resultStr);
            
            if(_isContentChanged){
                
                [[FISharedResources sharedResourceManager]manageContentCategoryWithDetails:resultStr withFlag:1];
            }
            
            //[self.view makeToast:@"Content types and Content categories updated successfully" duration:2 position:CSToastPositionCenter];
            [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
}

- (IBAction)saveAction:(id)sender {
    
    [self updateAddContent];
}

#pragma mark – RFQuiltLayoutDelegate

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 10; // This is the minimum inter item spacing, can be more
//}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(1, 1);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    // NSLog(@"imp collection view");
    NSInteger rowCount = 0;
    if(searchArray.count != 0) {
        rowCount = searchArray.count;
    } else {
        rowCount = self.contentTypeArray.count;
    }
    return rowCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FirstLevelCell *cell =(FirstLevelCell*) [cv dequeueReusableCellWithReuseIdentifier:@"FirstLevelCell" forIndexPath:indexPath];
    FIMenu *contentCategory;
    if(searchArray.count != 0) {
        contentCategory = [searchArray objectAtIndex:indexPath.row];
    } else {
        contentCategory = [self.contentTypeArray objectAtIndex:indexPath.row];
    }
    cell.name.text = contentCategory.name;
    cell.checkMarkButton.tag = indexPath.row;
    cell.expandButton.tag = indexPath.row;
    
    if([self.selectedIdArray containsObject:contentCategory.nodeId]) {
        [cell.checkMarkButton setSelected:YES];
    }else {
        [cell.checkMarkButton setSelected:NO];
    }
    
    
    if([contentCategory.subListAvailable isEqualToNumber:[NSNumber numberWithBool:YES]] && contentCategory.listArray.count != 0) {
        cell.expandButton.hidden = NO;
    } else {
        cell.expandButton.hidden = YES;
    }
    
//    BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"TutorialShown"];
//    if (coachMarksShown == NO) {
//        
//        if(indexPath.row==0){
//            cell.layer.borderWidth=1.0;
//            cell.layer.borderColor=[[UIColor redColor]CGColor];
//            
//            popAnimationTimer=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(permformAnimation:) userInfo:cell repeats:YES];
//        }else{
//            cell.layer.borderWidth=0.0;
//        }
//        
//    }else{
//        
//        cell.layer.borderWidth=0.0;
//    }
    cell.contentView.layer.borderColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0].CGColor;
    cell.contentView.layer.borderWidth = 1.0f;

    return cell;
}

-(void)permformAnimation:(NSTimer *)timer {
    FirstLevelCell *cell=timer.userInfo;
    
    [self animateFirstCell:cell];
    
}
-(void)animateFirstCell:(FirstLevelCell *)cell{
    
    [cell.layer removeAllAnimations];
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue=[NSValue valueWithCGSize:CGSizeMake(0.5, 0.5)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1,1)];
    scaleAnimation.springBounciness = 10;
    scaleAnimation.springSpeed=10;
    [cell.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
    
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did select item");
    BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"CloseAddContentTutorial"];
    if (coachMarksShown == YES) {
        FIContentCategory *contentCategory = [self.contentTypeArray objectAtIndex:indexPath.row];
        if(contentCategory.listArray.count != 0) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AddContentPhone" bundle:nil];
            AddContentSecondLevelView *secondLevel = [storyboard instantiateViewControllerWithIdentifier:@"SecondLevel"];
            secondLevel.delegate = self;
            secondLevel.innerArray = contentCategory.listArray;
            secondLevel.title = contentCategory.name;
            secondLevel.previousArray = self.selectedIdArray;
            secondLevel.selectedId = contentCategory.categoryId;
            NSDictionary *dictionary = @{@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"], @"userName":[[NSUserDefaults standardUserDefaults]objectForKey:@"firstName"],@"contentCategory":contentCategory.name};
            [Localytics tagEvent:@"Addcontent Topic Change" attributes:dictionary];
            [self.navigationController pushViewController:secondLevel animated:YES];
        }
    }
}

-(void)upgradeTap:(UITapGestureRecognizer *)sender {
    UIView *view = sender.view;
    //NSLog(@"tag value:%d",view.tag);
    FIContentCategory *contentCategory = [self.contentTypeArray objectAtIndex:view.tag];
    //NSLog(@"slected name:%@ and id:%@",contentCategory.name,contentCategory.categoryId);
    if([contentCategory.categoryId isEqualToNumber:[NSNumber numberWithInt:2]]) {
        //Stock Watch
        [FIUtils callRequestionUpdateWithModuleId:2 withFeatureId:15];
    } else if([contentCategory.categoryId isEqualToNumber:[NSNumber numberWithInt:4]]) {
        //IP and Legal
        [FIUtils callRequestionUpdateWithModuleId:4 withFeatureId:15];
    } else if([contentCategory.categoryId isEqualToNumber:[NSNumber numberWithInt:5]]) {
        //Executive Moves
        [FIUtils callRequestionUpdateWithModuleId:5 withFeatureId:15];
    } else if([contentCategory.categoryId isEqualToNumber:[NSNumber numberWithInt:7]]) {
        //Influencer Comments
        [FIUtils callRequestionUpdateWithModuleId:7 withFeatureId:15];
    } else if([contentCategory.categoryId isEqualToNumber:[NSNumber numberWithInt:8]]) {
        //Deals
        [FIUtils callRequestionUpdateWithModuleId:8 withFeatureId:15];
    } else if([contentCategory.categoryId isEqualToNumber:[NSNumber numberWithInt:10]]) {
        //Deals
        [FIUtils callRequestionUpdateWithModuleId:11 withFeatureId:15];
    } else if([contentCategory.categoryId isEqualToNumber:[NSNumber numberWithInt:11]]) {
        //Deals
        [FIUtils callRequestionUpdateWithModuleId:12 withFeatureId:15];
    }
    NSDictionary *dictionary = @{@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"], @"userName":[[NSUserDefaults standardUserDefaults]objectForKey:@"firstName"],@"contentCategory":contentCategory.name};
    [Localytics tagEvent:@"AddcontentTopicUpgradeRequest" attributes:dictionary];
    [self.view makeToast:@"Your request has been sent." duration:1 position:CSToastPositionCenter];
}

- (IBAction)checkMark:(id)sender {
    _isContentChanged=YES;
    FIMenu *contentCategory = [self.contentTypeArray objectAtIndex:[sender tag]];
    if([self.selectedIdArray containsObject:contentCategory.nodeId]) {
        [self.selectedIdArray removeObject:contentCategory.nodeId];
        [sender setSelected:NO];
        
        NSLog(@"checked array dic:%@",self.checkedArray);
        NSDictionary *selectedDic;
        for(NSDictionary *dic in self.checkedArray) {
            if([[dic objectForKey:@"id"] isEqual:contentCategory.nodeId]) {
                selectedDic = dic;
            } else {
                
            }
        }
        NSLog(@"after dic:%@",selectedDic);
        [self.checkedArray removeObject:selectedDic];
        NSLog(@"after that");
        // } else {
        [self.uncheckedArray addObject:selectedDic];
        // }
        
    } else {
        [self.selectedIdArray addObject:contentCategory.nodeId];
        [sender setSelected:YES];
        
        NSLog(@"unchecked array dic:%@",self.uncheckedArray);
        NSDictionary *selectedDic;
        for(NSDictionary *dic in self.uncheckedArray) {
            if([[dic objectForKey:@"id"] isEqual:contentCategory.nodeId]) {
                selectedDic = dic;
            } else {
                
            }
        }
        NSLog(@"after dic:%@",selectedDic);
        
        [self.uncheckedArray removeObject:selectedDic];
        [self.checkedArray addObject:selectedDic];
    }
    
    NSLog(@"after selection:%@ and checked:%@ and unchecked:%@",self.selectedIdArray,self.checkedArray,self.uncheckedArray);
    
}

- (IBAction)expandButtonClick:(id)sender {
    NSLog(@"expand button click :%ld",(long)[sender tag]);
    
    FIMenu *contentCategory;
    if(searchArray.count != 0) {
        contentCategory = [searchArray objectAtIndex:[sender tag]];
    } else {
        contentCategory = [self.contentTypeArray objectAtIndex:[sender tag]];
    }
    
    //FIMenu *contentCategory = [self.contentTypeArray objectAtIndex:[sender tag]];
    if(contentCategory.listArray.count != 0) {
        UIStoryboard *storyboard;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            storyboard = [UIStoryboard storyboardWithName:@"AddContentPhone" bundle:nil];
        } else if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            storyboard = [UIStoryboard storyboardWithName:@"AddContent" bundle:nil];
        }
        AddContentSecondLevelView *secondLevel = [storyboard instantiateViewControllerWithIdentifier:@"SecondLevel"];
        secondLevel.delegate = self;
        secondLevel.innerArray = contentCategory.listArray;
        secondLevel.title = contentCategory.name;
        secondLevel.previousArray = self.selectedIdArray;
        secondLevel.selectedId = contentCategory.nodeId;
        secondLevel.firstLevelCheckedArray = self.checkedArray;
        secondLevel.firstLevelUnCheckedArray = self.uncheckedArray;
        NSDictionary *dictionary = @{@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"], @"userName":[[NSUserDefaults standardUserDefaults]objectForKey:@"firstName"],@"contentCategory":contentCategory.name};
        [Localytics tagEvent:@"Addcontent Topic Change" attributes:dictionary];
        [self.navigationController pushViewController:secondLevel animated:YES];
    }
}
@end
