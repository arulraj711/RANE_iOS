//
//  FolderViewController.m
//  FullIntel
//
//  Created by Capestart on 7/7/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "FolderViewController.h"
#import "FolderCell.h"
#import "FIFolder.h"
#import "UIView+Toast.h"
#import "FISharedResources.h"
#import "CorporateNewsListView.h"
#import "ViewController.h"
#import "UILabel+CustomHeaderLabel.h"
#import "UIImage+CustomNavIconImage.h"

@interface FolderViewController ()

@end

@implementation FolderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.revealController showViewController:self.revealController.frontViewController];
    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
//    label.backgroundColor = [UIColor clearColor];
//    label.font = [UIFont fontWithName:@"Open Sans" size:16];
//   // label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
//    label.text =@"FOLDERS";
//    label.textAlignment = NSTextAlignmentCenter;
//    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = [UILabel setCustomHeaderLabelFromText:self.titleName];
    
    // Do any additional setup after loading the view.
    UIButton *Btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [Btn setFrame:CGRectMake(0.0f,0.0f,16.0f,15.0f)];
    [Btn setBackgroundImage:[UIImage createCustomNavIconFromImage:@"navmenu"]  forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(backBtnPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    [self.navigationItem setLeftBarButtonItem:addButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopFolderLoading) name:@"StopFolderLoading" object:nil];
    [self fetchFolderDetails];
    
}

-(void)viewDidAppear:(BOOL)animated {
    NSString *accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"];
    if(accessToken.length == 0) {
        // NSLog(@"corporate if part");
        
        [self showLoginPage];
    }
}

-(void)showLoginPage {
    UIStoryboard *centerStoryBoard;
    UIViewController *viewCtlr;
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        centerStoryBoard = [UIStoryboard storyboardWithName:@"MainPhone" bundle:nil];
        viewCtlr = [centerStoryBoard instantiateViewControllerWithIdentifier:@"LoginView"];
        
        
    } else {
        centerStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        viewCtlr = [centerStoryBoard instantiateViewControllerWithIdentifier:@"LoginView"];
        
        
    }
    
    
    [self.revealController setFrontViewController:viewCtlr];
    [self.revealController showViewController:self.revealController.frontViewController];
    //        [self presentViewController:loginView animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetchFolderDetails{
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:@"FolderList"];
    if (dataRepresentingSavedArray != nil)
    {
        NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
        // NSLog(@"folder array:%@",oldSavedArray);
        folderArray = [[NSMutableArray alloc]initWithArray:oldSavedArray];
    }
    [self.folderTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return folderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FolderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    FIFolder *folder = [folderArray objectAtIndex:indexPath.row];
    cell.folderTitle.text = folder.folderName;
    NSInteger rowNumer = indexPath.row+1;
    cell.rowNumber.text = [NSString stringWithFormat:@"%d",rowNumer];
    cell.folderCreatedDate.text = folder.createdDate;
    NSLog(@"rss feed url:%@",folder.rssFeedUrl);
    if([folder.defaultFlag isEqualToNumber:[NSNumber numberWithInt:1]]) {
        cell.rssButton.tag = indexPath.row;
        cell.rssButton.hidden = NO;
        cell.editButton.hidden = YES;
        cell.deleteButton.hidden = YES;
    } else {
        cell.editButton.tag = indexPath.row;
        cell.deleteButton.tag = indexPath.row;
        cell.rssButton.hidden = YES;
        cell.editButton.hidden = NO;
        cell.deleteButton.hidden = NO;
    }
    [cell.editButton setSelected:NO];
    [cell.deleteButton setSelected:NO];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:101] forKey:@"newsletterId"];
    [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"Click Folder List"];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFolderClick"];
    FIFolder *folder = [folderArray objectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults]setObject:folder.folderId forKey:@"folderId"];

    [[FISharedResources sharedResourceManager]fetchArticleFromFolderWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withFolderId:folder.folderId withPageNo:[NSNumber numberWithInt:0] withSize:[NSNumber numberWithInt:10] withUpFlag:NO withQuery:@"" withFilterBy:@""];
    UIStoryboard *centerStoryBoard;
    CorporateNewsListView *listView;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        centerStoryBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListViewPhone" bundle:nil];
        listView = [centerStoryBoard instantiateViewControllerWithIdentifier:@"CorporateNewsListViewPhone"];
    } else {
        centerStoryBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];
        listView = [centerStoryBoard instantiateViewControllerWithIdentifier:@"CorporateNewsListView"];
    }
    listView.titleName = folder.folderName;
    listView.mediaAnalysisArticleCount = [NSNumber numberWithInt:0];
    [self.navigationController pushViewController:listView animated:YES];
}

- (IBAction)rssButtonClick:(UIButton *)sender {
    FIFolder *folder =  [folderArray objectAtIndex:sender.tag];
    NSLog(@"rss url:%@",folder.rssFeedUrl);
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:folder.rssFeedUrl];
    UIWindow *window = [[UIApplication sharedApplication]windows][0];
    [window makeToast:@"RSS url copied successfully" duration:1 position:CSToastPositionCenter];
}
- (IBAction)editButtonClick:(UIButton *)sender {
    [sender setSelected:YES];
    self.isdeleteFlag = NO;
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Rename Folder" message:@"Please enter the folder name." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    
    alertView.alertViewStyle=UIAlertViewStylePlainTextInput;
    
    UITextField *textField=[alertView textFieldAtIndex:0];
    textField.keyboardType=UIKeyboardTypeEmailAddress;
    textField.returnKeyType=UIReturnKeySend;
    textField.delegate=self;
    textField.tag = sender.tag;
    FIFolder *folder = [folderArray objectAtIndex:sender.tag];
    textField.text = folder.folderName;
    
    [self.view endEditing:YES];
    
    [alertView show];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.folderTable reloadData];
    if(self.isdeleteFlag) {
        if(buttonIndex == 1) {
            activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityIndicator.alpha = 1.0;
            activityIndicator.center = self.view.center;
            activityIndicator.hidesWhenStopped = YES;
            [self.view addSubview:activityIndicator];
            [activityIndicator startAnimating];
            self.view.userInteractionEnabled = NO;
            NSMutableDictionary *folderdetails = [[NSMutableDictionary alloc] init];
            [folderdetails setObject:[NSNumber numberWithBool:YES] forKey:@"deleted"];
            NSData *jsondata = [NSJSONSerialization dataWithJSONObject:folderdetails options:NSJSONWritingPrettyPrinted error:nil];
            NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
            
            FIFolder *folder = [folderArray objectAtIndex:alertView.tag];
            
            [[FISharedResources sharedResourceManager]renameFolderWithDetails:resultStr withAccessToken:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] withFolderId:folder.folderId];
        }
    } else {
        UITextField *folderNameTextField = [alertView textFieldAtIndex:0];
        if(buttonIndex == 1) {
            if(folderNameTextField.text.length == 0) {
                UIWindow *window = [[UIApplication sharedApplication]windows][0];
                [window makeToast:@"￼Please enter a folder name." duration:1 position:CSToastPositionCenter];
            } else {
                activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                activityIndicator.alpha = 1.0;
                activityIndicator.center = self.view.center;
                activityIndicator.hidesWhenStopped = YES;
                [self.view addSubview:activityIndicator];
                [activityIndicator startAnimating];
                self.view.userInteractionEnabled = NO;
                NSMutableDictionary *folderdetails = [[NSMutableDictionary alloc] init];
                [folderdetails setObject:folderNameTextField.text forKey:@"folderName"];
                NSData *jsondata = [NSJSONSerialization dataWithJSONObject:folderdetails options:NSJSONWritingPrettyPrinted error:nil];
                NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
                
                FIFolder *folder = [folderArray objectAtIndex:folderNameTextField.tag];
                
                [[FISharedResources sharedResourceManager]renameFolderWithDetails:resultStr withAccessToken:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] withFolderId:folder.folderId];
                //  [[FISharedResources sharedResourceManager]createFolderWithDetails:resultStr withAccessToken:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"]];
            }
            
        }
    }
    
    
    //[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)stopFolderLoading {
    [activityIndicator stopAnimating];
    self.view.userInteractionEnabled = YES;
    [self fetchFolderDetails];
}

- (IBAction)deleteButtonClick:(UIButton *)sender {
    [sender setSelected:YES];
    self.isdeleteFlag = YES;
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Delete" message:@"Are you sure you want to delete the folder?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alertView.tag = sender.tag;
    [alertView show];
    
}

-(void)backBtnPress {
    NSLog(@"back button press");
    if(self.revealController.state == 2) {
        NSLog(@"left view closed");
        NSDictionary *dictionary = @{@"email":[[NSUserDefaults standardUserDefaults]objectForKey:@"customerEmail"]};
        [Localytics tagEvent:@"MenuClosed" attributes:dictionary];
        [self.revealController showViewController:self.revealController.frontViewController];
    } else if(self.revealController.state == 3){
        NSLog(@"left view opened");
        NSDictionary *dictionary = @{@"email":[[NSUserDefaults standardUserDefaults]objectForKey:@"customerEmail"]};
        [Localytics tagEvent:@"MenuOpened" attributes:dictionary];
        [self.revealController showViewController:self.revealController.leftViewController];
    }
    
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self.revealController showViewController:self.revealController.frontViewController];
}
@end
