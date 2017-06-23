//
//  AddContentFifthLevelView.m
//  FullIntel
//
//  Created by Capestart on 5/25/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "AddContentFifthLevelView.h"
#import "SecondLevelCell.h"
//#import "FIContentCategory.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FirstLevelCell.h"
//#import "FIMenu.h"
#import "FIAddContentMenu.h"
#import "FISharedResources.h"
#import "UIView+Toast.h"
#import "MZFormSheetController.h"
#import "FIUtils.h"

@interface AddContentFifthLevelView ()

@end

@implementation AddContentFifthLevelView
@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.title;
    self.title = @"Add Content";
    self.noSearchResultsFoundText.hidden = YES;
    
    UIImageView *envelopeView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 16, 15)];
    envelopeView.image = [UIImage imageNamed:@"searchTextField"];
    envelopeView.contentMode = UIViewContentModeScaleAspectFit;
    UIView *test=  [[UIView alloc]initWithFrame:CGRectMake(5, 0, 26, 15)];
    [test addSubview:envelopeView];
    [self.searchTextField.leftView setFrame:envelopeView.frame];
    self.searchTextField.leftView =test;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextField.layer.cornerRadius=5.0f;
    
    // Do any additional setup after loading the view.
    self.selectTopicsLabel.hidden = YES;
    //self.titleLabel.text = self.title;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChangeNotification:)
                                                name:UITextFieldTextDidChangeNotification object:nil];
    
    
    
    NSMutableArray *firstArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"fifthLevelSelection"];
    NSMutableArray *secondArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"fifthLevelUnSelection"];
    self.selectedIdArray = [[NSMutableArray alloc]initWithArray:firstArray];
    self.uncheckedArray = [[NSMutableArray alloc]initWithArray:secondArray];
    self.checkedArray = [[NSMutableArray alloc]init];
    
    // Do any additional setup after loading the view.
//    RFQuiltLayout* layout = (id)[self.categoryCollectionView collectionViewLayout];
//    layout.direction = UICollectionViewScrollDirectionVertical;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        //layout.blockPixels = CGSizeMake(110,110);
        testLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, self.selectTopicsLabel.frame.origin.y-10 ,self.selectTopicsLabel.frame.size.width,self.selectTopicsLabel.frame.size.height)];
        testLabel.text = self.title;
        testLabel.textAlignment = NSTextAlignmentCenter;
        testLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:18.0];
        [self.view addSubview:testLabel];
        UIBarButtonItem *addAcc = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Save"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(updateAddContent)];
        NSArray *arrBtns = [[NSArray alloc]initWithObjects:addAcc, nil];
        self.navigationItem.rightBarButtonItems = arrBtns;
    } else {
    //layout.blockPixels = CGSizeMake(180,180);
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        if(orientation == 1) {
            testLabel = [[UILabel alloc]initWithFrame:CGRectMake((760-self.selectTopicsLabel.frame.size.width)/2, self.selectTopicsLabel.frame.origin.y ,self.selectTopicsLabel.frame.size.width,self.selectTopicsLabel.frame.size.height)];
            testLabel.text = self.title;
            testLabel.textAlignment = NSTextAlignmentCenter;
            testLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:18.0];
            //self.selectTopicsLabel.frame = CGRectMake(0, self.selectTopicsLabel.frame.origin.y, self.selectTopicsLabel.frame.size.width, self.selectTopicsLabel.frame.size.height);
            // layout.blockPixels = CGSizeMake(100,150);
        }else {
            // layout.blockPixels = CGSizeMake(130,150);
            testLabel = [[UILabel alloc]initWithFrame:CGRectMake((800-self.selectTopicsLabel.frame.size.width)/2, self.selectTopicsLabel.frame.origin.y ,self.selectTopicsLabel.frame.size.width,self.selectTopicsLabel.frame.size.height)];
            testLabel.text = self.title;
            testLabel.textAlignment = NSTextAlignmentCenter;
            testLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:18.0];
            //self.selectTopicsLabel.frame = CGRectMake((800-self.selectTopicsLabel.frame.size.width)/2, self.selectTopicsLabel.frame.origin.y, self.selectTopicsLabel.frame.size.width, self.selectTopicsLabel.frame.size.height);
        }
        [self.view addSubview:testLabel];
        UIBarButtonItem *addAcc = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Save"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(updateAddContent)];
        NSArray *arrBtns = [[NSArray alloc]initWithObjects:addAcc, nil];
        self.navigationItem.rightBarButtonItems = arrBtns;
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                         initWithTitle:@"Cancel"
                                         style:UIBarButtonItemStyleBordered
                                         target:self
                                         action:@selector(cancelButtonPress)];
        self.navigationItem.leftBarButtonItem = cancelButton;
    }
    
    
    [self.categoryCollectionView reloadData];
    [self loadSelectedCategory];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)textChangeNotification:(NSNotification *)notification {
    NSLog(@"search notification");
    [self searchRecordsAsPerText:self.searchTextField.text];
}

-(void)searchRecordsAsPerText:(NSString *)string {
    [searchArray removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[cd] %@", string];
    NSArray *filtered = [self.innerArray filteredArrayUsingPredicate:predicate];
    NSLog(@"filtered array :%@",filtered);
    if(string.length != 0){
        if(searchArray.count != 0) {
            self.categoryCollectionView.hidden = NO;
            self.noSearchResultsFoundText.hidden = YES;
            [self.categoryCollectionView reloadData];
        } else {
            self.categoryCollectionView.hidden = YES;
            self.noSearchResultsFoundText.hidden = NO;
        }
    } else if(string.length == 0) {
        self.categoryCollectionView.hidden = NO;
        self.noSearchResultsFoundText.hidden = YES;
        [self.categoryCollectionView reloadData];
    }
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    // NSLog(@"device rotate is working:%ld",(long)fromInterfaceOrientation);
    if(fromInterfaceOrientation == 1) {
        //  layout.blockPixels = CGSizeMake(130,150);
        testLabel.frame = CGRectMake((800-testLabel.frame.size.width)/2, testLabel.frame.origin.y, testLabel.frame.size.width, testLabel.frame.size.height);
    }else {
        // layout.blockPixels = CGSizeMake(100,150);
        testLabel.frame = CGRectMake((760-testLabel.frame.size.width)/2, testLabel.frame.origin.y, testLabel.frame.size.width, testLabel.frame.size.height);
    }
    
}


- (void)loadSelectedCategory
{
    //if(self.isSelected) {
        BOOL isChanged = [[NSUserDefaults standardUserDefaults]boolForKey:@"isFifthLevelChanged"];
        NSMutableArray *alreadySelectedArray = [[NSUserDefaults standardUserDefaults]objectForKey:[self.selectedId stringValue]];
        
        if(isChanged) {
            if(alreadySelectedArray.count == 0){
                for(FIAddContentMenu *category in self.innerArray) {
                    [self.checkedArray addObject:category.nodeId];
                    [self.selectedIdArray addObject:category.nodeId];
                }
            } else {
                self.selectedIdArray = [[NSMutableArray alloc]initWithArray:alreadySelectedArray];
            }
        } else {
            for(FIAddContentMenu *category in self.innerArray) {
                if(category.isSubscribed) {
                    [self.checkedArray addObject:category.nodeId];
                    [self.selectedIdArray addObject:category.nodeId];
                } else {
                    [self.uncheckedArray addObject:category.nodeId];
                    [self.selectedIdArray removeObject:category.nodeId];
                }
            }
        }
//    } else {
//        self.selectedIdArray = [[NSMutableArray alloc]init];
//        [[NSUserDefaults standardUserDefaults]setObject:self.selectedIdArray forKey:[self.selectedId stringValue]];
//    }
    [self.categoryCollectionView reloadData];
}
-(void) viewWillAppear:(BOOL)animated {
    self.navigationItem.title = @"Add Content";
}

-(void) viewWillDisappear:(BOOL)animated {
    self.navigationItem.title = @"Back";
    if(self.selectedIdArray.count == 0) {
        //[self.previousArray removeObject:self.selectedId];
        //self.selectedIdArray = [[NSMutableArray alloc]init];
        //[[NSUserDefaults standardUserDefaults]setObject:self.selectedIdArray forKey:[self.selectedId stringValue]];
    } else {
        [self.previousArray addObject:self.selectedId];
    }
    [delegate fifthLevelDidFinish:self];
    [super viewWillDisappear:animated];
}


#pragma mark – RFQuiltLayoutDelegate

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(1, 1);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(5, 5, 5, 10);
}
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    NSInteger rowCount = 0;
    if(searchArray.count != 0) {
        rowCount = searchArray.count;
    } else {
        rowCount = self.innerArray.count;
    }
    return rowCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // NSLog(@"cell for item");
    FirstLevelCell *cell =(FirstLevelCell*) [cv dequeueReusableCellWithReuseIdentifier:@"FirstLevelCell" forIndexPath:indexPath];
    
    FIAddContentMenu *contentCategory;
    if(searchArray.count != 0) {
        contentCategory = [searchArray objectAtIndex:indexPath.row];
    } else {
        contentCategory = [self.innerArray objectAtIndex:indexPath.row];
    }
    cell.name.text = contentCategory.name;
    
    if([self.selectedIdArray containsObject:contentCategory.nodeId]) {
        //[self.selectedIdArray addObject:contentCategory.categoryId];
        [cell.checkMarkButton setSelected:YES];
    }else {
        // [self.selectedIdArray removeObject:contentCategory.categoryId];
        [cell.checkMarkButton setSelected:NO];
    }
    cell.expandButton.hidden = YES;
    cell.checkMarkButton.tag = indexPath.row;
    cell.expandButton.tag = indexPath.row;
//    cell.contentView.layer.borderColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0].CGColor;
//    cell.contentView.layer.borderWidth = 1.0f;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (IBAction)checkMark:(id)sender {
    FIAddContentMenu *contentCategory = [self.innerArray objectAtIndex:[sender tag]];
    if([self.selectedIdArray containsObject:contentCategory.nodeId]) {
        [self.selectedIdArray removeObject:contentCategory.nodeId];
        [sender setSelected:NO];
        [self.checkedArray removeObject:contentCategory.nodeId];
        // } else {
        [self.uncheckedArray addObject:contentCategory.nodeId];
        // }
    } else {
        [self.selectedIdArray addObject:contentCategory.nodeId];
        [sender setSelected:YES];
        //  if([self.checkedArray containsObject:contentCategory.categoryId]) {
        [self.checkedArray addObject:contentCategory.nodeId];
        // } else {
        [self.uncheckedArray removeObject:contentCategory.nodeId];
        // }
    }
    NSDictionary *dictionary = @{@"userId":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"], @"userName":[[NSUserDefaults standardUserDefaults]objectForKey:@"firstName"],@"contentCategory":contentCategory.name};
    [Localytics tagEvent:@"AddContent Module Change" attributes:dictionary];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFifthLevelChanged"];
    [[NSUserDefaults standardUserDefaults]setObject:self.selectedIdArray forKey:[self.selectedId stringValue]];
    [[NSUserDefaults standardUserDefaults]setObject:self.selectedIdArray forKey:@"fifthLevelSelection"];
    [[NSUserDefaults standardUserDefaults]setObject:self.uncheckedArray forKey:@"fifthLevelUnSelection"];
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
        
        for(int i=0;i<self.firstLevelCheckedArray.count;i++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            
            NSDictionary *contentTypeDic = [self.firstLevelCheckedArray objectAtIndex:i];
            
            [dic setObject:[contentTypeDic objectForKey:@"id"] forKey:@"id"];
            [dic setObject:[contentTypeDic objectForKey:@"companyId"] forKey:@"companyId"];
            [dic setObject:[contentTypeDic objectForKey:@"contentTypeForCustomerId"] forKey:@"contentTypeForCustomerId"];
            [dic setObject:[NSNumber numberWithBool:YES] forKey:@"isSubscribed"];
            [contentType addObject:dic];
        }
        for(int i=0;i<self.firstLevelUnCheckedArray.count;i++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            NSDictionary *contentTypeDic = [self.firstLevelUnCheckedArray objectAtIndex:i];
            
            [dic setObject:[contentTypeDic objectForKey:@"id"] forKey:@"id"];
            [dic setObject:[contentTypeDic objectForKey:@"companyId"] forKey:@"companyId"];
            [dic setObject:[contentTypeDic objectForKey:@"contentTypeForCustomerId"] forKey:@"contentTypeForCustomerId"];
            [dic setObject:[NSNumber numberWithBool:NO] forKey:@"isSubscribed"];
            [contentType addObject:dic];
        }
        // NSLog(@"content type %d and category:%d and checked array:%d and unchecked array:%@",contentType.count,categoryArray.count,self.checkedArray.count,contentType);
        //        if(self.checkedArray.count == 0) {
        //            NSManagedObject *addContentBrandingIdentity = [FIUtils getBrandFromBrandingIdentityForId:[NSNumber numberWithInt:35]];
        //            NSString *message = [NSString stringWithFormat:@"%@",[addContentBrandingIdentity valueForKey:@"name"]];
        //            [self.view makeToast:message duration:1 position:CSToastPositionCenter];
        //        } else {
        NSMutableDictionary *gradedetails = [[NSMutableDictionary alloc] init];
        [gradedetails setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
        [gradedetails setObject:[NSNumber numberWithBool:YES] forKey:@"updateCategory"];
        [gradedetails setObject:categoryArray forKey:@"contentCategory"];
        [gradedetails setObject:contentType forKey:@"contentType"];
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:gradedetails options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
        NSLog(@"final json format:%@",resultStr);
        
        //if(_isContentChanged){
        
        [[FISharedResources sharedResourceManager]manageContentCategoryWithDetails:resultStr withFlag:1];
        // }
        
        //[self.view makeToast:@"Content types and Content categories updated successfully" duration:2 position:CSToastPositionCenter];
        [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
        // }
        
    }
}

-(void)cancelButtonPress{
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

@end
