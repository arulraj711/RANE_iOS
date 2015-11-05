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

@interface FolderViewController ()

@end

@implementation FolderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Open Sans" size:16];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.text =@"FOLDERS";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    
    
    UIButton *Btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [Btn setFrame:CGRectMake(0.0f,0.0f,16.0f,15.0f)];
    [Btn setBackgroundImage:[UIImage imageNamed:@"navmenu"]  forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(backBtnPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    [self.navigationItem setLeftBarButtonItem:addButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopFolderLoading) name:@"StopFolderLoading" object:nil];
    [self fetchFolderDetails];
    
    
    
    
    
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
    //NSLog(@"rss feed url:%@",folder.rssFeedUrl);
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
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFolderClick"];
    FIFolder *folder = [folderArray objectAtIndex:indexPath.row];
    [[FISharedResources sharedResourceManager]fetchArticleFromFolderWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken"] withFolderId:folder.folderId withOffset:[NSNumber numberWithInt:0] withLimit:[NSNumber numberWithInt:5] withUpFlag:NO];
    UIStoryboard *centerStoryBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];
    CorporateNewsListView *listView = [centerStoryBoard instantiateViewControllerWithIdentifier:@"CorporateNewsListView"];
    listView.titleName = folder.folderName;
//    UINavigationController *navCtlr = [centerStoryBoard instantiateViewControllerWithIdentifier:@"CorporateView"];
//    CorporateNewsListView *CorporateNewsListViewObj=(CorporateNewsListView *)[[navCtlr viewControllers]objectAtIndex:0];
//    CorporateNewsListViewObj.titleName=folder.folderName;
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
        } else {
            [self.folderTable reloadData];
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
            
        } else  {
            [self.folderTable reloadData];
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
    if(self.revealController.state == PKRevealControllerShowsLeftViewControllerInPresentationMode) {
        NSLog(@"left view closed");
        NSDictionary *dictionary = @{@"email":[[NSUserDefaults standardUserDefaults]objectForKey:@"customerEmail"]};
        [Localytics tagEvent:@"MenuClosed" attributes:dictionary];
        [self.revealController showViewController:self.revealController.frontViewController];
    } else {
        NSLog(@"left view opened");
        NSDictionary *dictionary = @{@"email":[[NSUserDefaults standardUserDefaults]objectForKey:@"customerEmail"]};
        [Localytics tagEvent:@"MenuOpened" attributes:dictionary];
        [self.revealController showViewController:self.revealController.leftViewController];
    }
    
}

@end
