//
//  SavedListPopoverView.m
//  FullIntel
//
//  Created by Arul on 3/20/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "SavedListPopoverView.h"
#import "SavedListCell.h"
#import "FIUtils.h"
#import "FIFolder.h"
#import "FISharedResources.h"
#import "UIView+Toast.h"

@interface SavedListPopoverView ()

@end

@implementation SavedListPopoverView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // NSMutableArray *folderArray;
    
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopFolderLoading) name:@"StopFolderLoading" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopLoading) name:@"SaveToFolder" object:nil];
    [self fetchFolderDetails];
}

-(void)fetchFolderDetails {
    NSLog(@"folder selected article id:%@",self.selectedArticleId);
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:@"FolderList"];
    if (dataRepresentingSavedArray != nil)
    {
        NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
        // NSLog(@"folder array:%@",oldSavedArray);
        _savedListArray = [[NSMutableArray alloc]initWithArray:oldSavedArray];
        selectedArray = [[NSMutableArray alloc]init];
        intermediateArray = [[NSMutableArray alloc]init];
        unselectedArray = [[NSMutableArray alloc]init];
        for(FIFolder *folder in self.savedListArray) {
            if([folder.folderArticlesIDArray containsObject:self.selectedArticleId]) {
                [intermediateArray addObject:folder.folderId];
            }
        }
        
    }
    [self.saveButton setEnabled:NO];
    [self.savedListTableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return self.savedListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SavedListCell *cell = (SavedListCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.checkedButton.tag = indexPath.row;
    FIFolder *folder = [_savedListArray objectAtIndex:indexPath.row];
    NSLog(@"folder id array:%@",folder.folderArticlesIDArray);
//    if([folder.folderArticlesIDArray containsObject:self.selectedArticleId]) {
//        [cell.checkedButton setSelected:YES];
//    } else {
//        [cell.checkedButton setSelected:NO];
//    }
    
    if([intermediateArray containsObject:folder.folderId]) {
        [cell.checkedButton setSelected:YES];
    } else {
        [cell.checkedButton setSelected:NO];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.name.text = folder.folderName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.saveButton setEnabled:YES];
    FIFolder *folder = [_savedListArray objectAtIndex:indexPath.row];
   // unselectedArray = [[NSMutableArray alloc]initWithArray:selectedArray];
    if([intermediateArray containsObject:folder.folderId]) {
        [intermediateArray removeObject:folder.folderId];
        [unselectedArray addObject:folder.folderId];
        //[selectedArray removeObject:folder.folderId];
    } else {
        [intermediateArray addObject:folder.folderId];
        [unselectedArray removeObject:folder.folderId];
        [selectedArray addObject:folder.folderId];
    }
    
    [self.savedListTableView reloadData];
}


- (IBAction)requestButtonClick:(id)sender {
    [sender setSelected:YES];
    [FIUtils callRequestionUpdateWithModuleId:10 withFeatureId:9];
}

- (IBAction)checkedButtonAction:(UIButton *)sender {
    NSLog(@"tag value:%ld",(long)sender.tag);
    [self.saveButton setEnabled:YES];
    FIFolder *folder = [_savedListArray objectAtIndex:sender.tag];
    // unselectedArray = [[NSMutableArray alloc]initWithArray:selectedArray];
    if([intermediateArray containsObject:folder.folderId]) {
        [intermediateArray removeObject:folder.folderId];
        [unselectedArray addObject:folder.folderId];
        //[selectedArray removeObject:folder.folderId];
    } else {
        [intermediateArray addObject:folder.folderId];
        [unselectedArray removeObject:folder.folderId];
        [selectedArray addObject:folder.folderId];
    }
    
    [self.savedListTableView reloadData];
}

- (IBAction)createFolderAction:(UIButton *)sender {
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Create Folder" message:@"Please enter the folder name." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Create", nil];
    
    alertView.alertViewStyle=UIAlertViewStylePlainTextInput;
    
    UITextField *textField=[alertView textFieldAtIndex:0];
    textField.keyboardType=UIKeyboardTypeEmailAddress;
    textField.returnKeyType=UIReturnKeyDone;
    textField.delegate=self;
   // if(flag.length != 0) {
      //  textField.text=flag;
    //}
    
    [self.view endEditing:YES];
    
    [alertView show];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
   // if(textField == _usernameTextField) {
       // [_passwordTextField becomeFirstResponder];
    //}else if(textField==_passwordTextField){
      //  [textField resignFirstResponder];
    NSLog(@"text field should return");
    activityIndicator1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator1.alpha = 1.0;
    activityIndicator1.center = self.view.center;
    activityIndicator1.hidesWhenStopped = YES;
    [self.view addSubview:activityIndicator1];
    [activityIndicator1 startAnimating];
    self.view.userInteractionEnabled = NO;
//    NSMutableDictionary *folderdetails = [[NSMutableDictionary alloc] init];
//    [folderdetails setObject:textField.text forKey:@"folderName"];
//    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:folderdetails options:NSJSONWritingPrettyPrinted error:nil];
//    
//    NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
//    [[FISharedResources sharedResourceManager]createFolderWithDetails:resultStr withAccessToken:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"]];
//    
    //[textField resignFirstResponder];
       // [self callSignInFunction];
    //}

    return YES;
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"alert view delegate");
    UITextField *folderNameTextField = [alertView textFieldAtIndex:0];
    
    if(buttonIndex == 1) {
        if(folderNameTextField.text.length == 0) {
            UIWindow *window = [[UIApplication sharedApplication]windows][0];
            [window makeToast:@"￼Please enter a folder name." duration:1 position:CSToastPositionCenter];
        } else {
            [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"Create Folder"];
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
            [[FISharedResources sharedResourceManager]createFolderWithDetails:resultStr withAccessToken:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"]];
        }
        
    }
    
    //[self dismissViewControllerAnimated:YES completion:nil];
}



-(void)stopFolderLoading {
    [activityIndicator stopAnimating];
    [activityIndicator1 stopAnimating];
    self.view.userInteractionEnabled = YES;
    [self fetchFolderDetails];
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)stopLoading {
    [activityIndicator stopAnimating];
    [activityIndicator1 stopAnimating];
    self.view.userInteractionEnabled = YES;
    [self fetchFolderDetails];
    //[self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)savedAction:(id)sender {
    [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"SaveFolderClick"];
   // NSLog(@"selected array count:%d and unselected count:%d",selectedArray.count,unselectedArray.count);
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.alpha = 1.0;
    activityIndicator.center = self.view.center;
    activityIndicator.hidesWhenStopped = YES;
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    self.view.userInteractionEnabled = NO;
    NSMutableArray *folderArray = [[NSMutableArray alloc]init];
    if(selectedArray.count != 0) {
    for(int i=0;i<selectedArray.count;i++) {
        NSMutableDictionary *folderdetails = [[NSMutableDictionary alloc] init];
        [folderdetails setObject:[selectedArray objectAtIndex:i] forKey:@"id"];
        [folderArray addObject:folderdetails];
    }
    
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:folderArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
        NSLog(@"save article request:%@",resultStr);
    [[FISharedResources sharedResourceManager]saveArticleToFolderWithDetails:resultStr withAccessToken:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] withArticleId:self.selectedArticleId];
    }
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        if(unselectedArray.count != 0) {
            
            NSMutableArray *unselectedFolderArray = [[NSMutableArray alloc]init];
            for(int i=0;i<unselectedArray.count;i++) {
                NSMutableDictionary *unselectedFolderDetails = [[NSMutableDictionary alloc] init];
                [unselectedFolderDetails setObject:[unselectedArray objectAtIndex:i] forKey:@"id"];
                [unselectedFolderArray addObject:unselectedFolderDetails];
//                NSNumber *folderId = [NSNumber numberWithInt:[[unselectedArray objectAtIndex:i] integerValue]];
//                [[FISharedResources sharedResourceManager]updateFolderId:@"CuratedNews" withFolderId:folderId];
            }
            
            NSData *unselectedJsonData = [NSJSONSerialization dataWithJSONObject:unselectedFolderArray options:NSJSONWritingPrettyPrinted error:nil];
            NSString *unselectedResultStr = [[NSString alloc]initWithData:unselectedJsonData encoding:NSUTF8StringEncoding];
            NSLog(@"remove articles request:%@",unselectedResultStr);
            [[FISharedResources sharedResourceManager]removeArticleToFolderWithDetails:unselectedResultStr withAccessToken:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] withArticleId:self.selectedArticleId];
        }
    });
    
    //[self dismissViewControllerAnimated:YES completion:nil];
}
@end
