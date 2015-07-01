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

@interface SavedListPopoverView ()

@end

@implementation SavedListPopoverView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   // NSMutableArray *folderArray;
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:@"FolderList"];
    if (dataRepresentingSavedArray != nil)
    {
        NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
        // NSLog(@"folder array:%@",oldSavedArray);
        _savedListArray = [[NSMutableArray alloc]initWithArray:oldSavedArray];
        selectedArray = [[NSMutableArray alloc]init];
        unselectedArray = [[NSMutableArray alloc]init];
        for(FIFolder *folder in self.savedListArray) {
            if([folder.folderArticlesIDArray containsObject:self.selectedArticleId]) {
                [selectedArray addObject:folder.folderId];
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
    
    if([selectedArray containsObject:folder.folderId]) {
        [cell.checkedButton setSelected:YES];
    } else {
        [cell.checkedButton setSelected:NO];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.name.text = folder.folderName;
    return cell;
}

- (IBAction)requestButtonClick:(id)sender {
    [sender setSelected:YES];
    [FIUtils callRequestionUpdateWithModuleId:10 withFeatureId:9];
}

- (IBAction)checkedButtonAction:(UIButton *)sender {
    NSLog(@"tag value:%ld",(long)sender.tag);
    [self.saveButton setEnabled:YES];
//    if(sender.selected) {
//        [sender setSelected:NO];
//        FIFolder *folder = [_savedListArray objectAtIndex:sender.tag];
//        [selectedArray removeObject:folder.folderId];
////        FIFolder *folder = [_savedListArray objectAtIndex:sender.tag];
////        [folder.folderArticlesIDArray removeObject:self.selectedArticleId];
//    }else {
//        [sender setSelected:YES];
        FIFolder *folder = [_savedListArray objectAtIndex:sender.tag];
    unselectedArray = [[NSMutableArray alloc]initWithArray:selectedArray];
        [selectedArray removeAllObjects];
        [selectedArray addObject:folder.folderId];
   // }
    [self.savedListTableView reloadData];
}

- (IBAction)createFolderAction:(UIButton *)sender {
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Create Folder" message:@"Please enter the folder name." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Create", nil];
    
    alertView.alertViewStyle=UIAlertViewStylePlainTextInput;
    
    UITextField *textField=[alertView textFieldAtIndex:0];
    textField.keyboardType=UIKeyboardTypeEmailAddress;
    textField.returnKeyType=UIReturnKeySend;
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
        [textField resignFirstResponder];
       // [self callSignInFunction];
    //}

    return YES;
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *emailTextField = [alertView textFieldAtIndex:0];
    
    if(buttonIndex == 1) {
        NSMutableDictionary *folderdetails = [[NSMutableDictionary alloc] init];
        [folderdetails setObject:emailTextField.text forKey:@"folderName"];
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:folderdetails options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
        [[FISharedResources sharedResourceManager]createFolderWithDetails:resultStr withAccessToken:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"]];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];

    
}

- (IBAction)savedAction:(id)sender {
    NSMutableDictionary *folderdetails = [[NSMutableDictionary alloc] init];
    [folderdetails setObject:self.selectedArticleId forKey:@"articleId"];
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:folderdetails options:NSJSONWritingPrettyPrinted error:nil];
    NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
    [[FISharedResources sharedResourceManager]saveArticleToFolderWithDetails:resultStr withAccessToken:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] withFolderId:[selectedArray objectAtIndex:0]];

    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        if(unselectedArray.count != 0) {
            [[FISharedResources sharedResourceManager]removeArticleToFolderWithDetails:self.selectedArticleId withAccessToken:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] withFolderId:[unselectedArray objectAtIndex:0]];
        }
    });
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
