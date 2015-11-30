//
//  CommentsPopoverView.m
//  FullIntel
//
//  Created by Arul on 3/19/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "CommentsPopoverView.h"
#import "CommentCell.h"
#import "FISharedResources.h"
#import "UIImageView+Letters.h"
#import "UIView+Toast.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FIUtils.h"

@interface CommentsPopoverView ()

@end

@implementation CommentsPopoverView
- (void)viewDidLoad {
    [super viewDidLoad];
    self.textfldNamed.layer.masksToBounds = YES;
    self.textfldNamed.layer.cornerRadius = 2.0f;

    // Do any additional setup after loading the view from its nib.
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.outerView.layer.masksToBounds = YES;
        self.outerView.layer.cornerRadius = 2;
       

    }
    else{
        self.outerView.layer.masksToBounds = YES;
        self.outerView.layer.cornerRadius = 10;
        
        self.senderImage.layer.masksToBounds = YES;
        self.senderImage.layer.cornerRadius = 20.0f;

    }
  
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchCommentsForArticleId) name:@"FetchingComments" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CommentsExpire) name:@"CommentsExpire" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(markCommentAsRead) name:@"markCommentAsRead" object:nil];
    
    NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    
    NSString *userImage = [[NSUserDefaults standardUserDefaults]objectForKey:@"photoUrl"];
    
    if(userImage.length != 0) {
        [self.senderImage sd_setImageWithURL:[NSURL URLWithString:userImage] placeholderImage:[UIImage imageNamed:@"userIcon_150"]];
        [self.senderImage setContentMode:UIViewContentModeScaleAspectFill];
    } else {
        [self.senderImage setImageWithString:username color:[UIColor lightGrayColor] circular:true fontName:@"Open Sans"];
    }
   
    [self fetchCommentsForArticleId];
    
    self.backImgeView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapEvent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEvent)];
    [self.backImgeView addGestureRecognizer:tapEvent];
    
}

- (void)viewDidDisappear:(BOOL)animated  // Called after the view was dismissed, covered or otherwise hidden. Default does nothing
{
    [self.commentsDelegate dismissCommentsView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.view endEditing:YES];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}

-(void)markCommentAsRead {
    
    //NSLog(@"before comments count:%d",self.commentsArray.count);
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"commentStatusUpdate" object:nil userInfo:@{@"indexPath":self.selectedIndexPath,@"status":[NSNumber numberWithInt:0],@"totalComments":[NSNumber numberWithInt:self.commentsArray.count]}];
}

-(void)CommentsExpire {
    [self dismissViewControllerAnimated:NO completion:NULL];
    [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"CloseComment"];
}
-(void)tapEvent {
    [self dismissViewControllerAnimated:NO completion:NULL];
    [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"CloseComment"];
}

-(void)fetchCommentsForArticleId{
    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@",self.articleId];
    [fetchRequest setPredicate:predicate];
    NSArray *filterArray =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if(filterArray.count != 0) {
        NSManagedObject *curatedNews = [filterArray objectAtIndex:0];
        //NSLog(@"comments:%@",[curatedNews valueForKey:@"comments"]);
        NSManagedObject *userComments = [curatedNews valueForKey:@"comments"];
        NSSet *commentSet = [userComments valueForKey:@"comments"];
        self.commentsArray = [[NSMutableArray alloc]initWithArray:[commentSet allObjects]];
    }
    
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
    [resultDic setObject:self.articleId forKey:@"articleId"];
    [resultDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
    [resultDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"customerId"] forKey:@"customerId"];
    [resultDic setObject:@"1" forKey:@"activityTypeId"];
    [resultDic setObject:@"1" forKey:@"version"];
    
    
    NSMutableArray *commentIdArray = [[NSMutableArray alloc]init];
    for(NSManagedObject *comment in self.commentsArray) {
        NSMutableDictionary *commentDic = [[NSMutableDictionary alloc] init];
        [commentDic setObject:[comment valueForKey:@"id"] forKey:@"id"];
        [commentIdArray addObject:commentDic];
    }
    
    [resultDic setObject:commentIdArray forKey:@"commentList"];
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *resultStr = [[NSString alloc]initWithData:jsondata encoding:NSUTF8StringEncoding];
    if(commentIdArray.count != 0){
        [[FISharedResources sharedResourceManager]markCommentAsReadWithDetails:resultStr];
    }
    [self.commentsTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.commentsArray.count == 0) {
        return 1;
    }
    return self.commentsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableCell;
    if(self.commentsArray.count == 0) {
        tableCell = [[UITableViewCell alloc] init];
        tableCell.textLabel.text = @"No comments to display";
        tableCell.textLabel.textAlignment = NSTextAlignmentCenter;
        tableCell.textLabel.font = [UIFont fontWithName:@"OpenSans" size:18];
        tableCell.textLabel.textColor = [UIColor lightGrayColor];
    } else {
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        NSManagedObject *comment = [self.commentsArray objectAtIndex:indexPath.row];
        cell.userName.text = [comment valueForKey:@"userName"];
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            //for date
            
            NSString *dateForComments =[comment valueForKey:@"createdDate"];
            NSLog(@"%@",dateForComments);
            
            NSDateFormatter *frmaeer=[[NSDateFormatter alloc]init];
            [frmaeer setDateFormat:@"yyyy-MM-dd HH:mm:ss.zzz"];
            [frmaeer setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
            NSDate *dats = [frmaeer dateFromString:dateForComments];
            NSLog(@"%@",dats);
            NSLog(@"%@",[FIUtils relativeDateStringForDate:dats]);
            
            NSString *finalDateString =[FIUtils relativeDateStringForDate:dats];
            NSLog(@"%@",finalDateString);
            cell.date.text = finalDateString;

        } else {
            
//            cell.date.text = [comment valueForKey:@"createdDate"];

        }

        

        NSData *newdata=[[comment valueForKey:@"comment"] dataUsingEncoding:NSUTF8StringEncoding
                                  allowLossyConversion:YES];
        NSString *mystring=[[NSString alloc] initWithData:newdata encoding:NSNonLossyASCIIStringEncoding];
        
        cell.message.text = mystring;
        NSString *name = [comment valueForKey:@"userName"];
        
        NSString *receiverImageUrl = [comment valueForKey:@"photoUrl"];
        if(receiverImageUrl.length != 0){
            [cell.receiverImage sd_setImageWithURL:[NSURL URLWithString:receiverImageUrl] placeholderImage:[UIImage imageNamed:@"userIcon_150"]];
            
        } else {
            [cell.receiverImage setImageWithString:name color:[UIColor lightGrayColor] circular:true fontName:@"Open Sans"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableCell = cell;
    }
    return tableCell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self postCommentCommonMethod:textField];
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (range.location == 0 && [string isEqualToString:@" "]) {
        return NO;
    }
    return YES;
}
-(void)postCommentCommonMethod :(UITextField *)textField
{

    if(textField.text.length != 0) {
        NSMutableDictionary *commentsDic = [[NSMutableDictionary alloc] init];
        [commentsDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
        [commentsDic setObject:self.articleId forKey:@"articleId"];
        [commentsDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"] forKey:@"userId"];
        [commentsDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"customerId"] forKey:@"customerId"];
        [commentsDic setObject:@"1" forKey:@"version"];
        [commentsDic setObject:@"-1" forKey:@"parentId"];
        
        NSData *data = [textField.text dataUsingEncoding:NSNonLossyASCIIStringEncoding];
        NSString *optionString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        [commentsDic setObject:optionString forKey:@"comment"];
        NSData *commentsJsondata = [NSJSONSerialization dataWithJSONObject:commentsDic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *commentsResultStr = [[NSString alloc]initWithData:commentsJsondata encoding:NSUTF8StringEncoding];
//        if(textField.text.length != 0) {
            [[FISharedResources sharedResourceManager]addCommentsWithDetails:commentsResultStr];
            textField.text = @"";
            [textField resignFirstResponder];
//        } else {
//        }
    }
    else{
        UIWindow *window = [[UIApplication sharedApplication]windows][0];
        [window makeToast:@"Please enter a comment." duration:1 position:CSToastPositionCenter];

    }
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.view endEditing:YES];
    return YES;
}
#define k_KEYBOARD_OFFSET 310.0
#define k_KEYBOARD_OFFSs 245.0

- (void)keyboardDidShow:(NSNotification *)notification
{
    // Assign new frame to your view
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4]; // to slide the view up
    
    NSDictionary *userInfo = [notification userInfo];
    NSLog(@"keyboard userinfo:%@",userInfo);
    CGRect keyboardEndFrame;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    // Use keyboardEndFrame
    
    
    CGRect rect = self.view.frame;
    CGRect popRect = self.view.superview.frame;
    NSLog(@"view frame height before keyboardDidShow:%f, %f,minu value:%f",self.view.frame.size.height,rect.size.height,popRect.size.height - keyboardEndFrame.size.height);
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        popRect.size.height = 300;
        rect.size.height=50;
        self.view.frame = rect;
        self.view.superview.frame = popRect;
    } else {
        if(rect.size.height==768){
            
            rect.size.height=410;
        }else if(rect.size.height==1024) {
            rect.size.height=800;
        }else if(rect.size.height==568) {
            rect.size.height=370;
        }else if(rect.size.height==736) {
            rect.size.height=500;
        }
        else if(rect.size.height<100) {
            rect.size.height=270;
        }
        self.view.frame = rect;
    }
    
    
        //NSLog(@"view frame height after keyboardDidShow:%f",self.view.frame.size.height);
    
    [UIView commitAnimations];
    
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
   // NSLog(@"device rotate is working:%ld",(long)fromInterfaceOrientation);
    if(fromInterfaceOrientation == 1) {
       
    }else {
       
    }
    
}
-(void)keyboardDidHide:(NSNotification *)notification
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4]; // to slide the view up
    
    NSDictionary *userInfo = [notification userInfo];
    
    CGRect keyboardEndFrame;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    
       NSLog(@"view frame height before keyboardDidHide:%f",self.view.frame.size.height);
    
   
    CGRect rect = self.view.frame;
    CGRect popRect = self.view.superview.frame;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        popRect.size.height = 480;
        rect.size.height=50;
        self.view.frame = rect;
        self.view.superview.frame = popRect;
    }
    else{
        if(rect.size.height==410){
            rect.size.height =768;
        }else if(rect.size.height==800){
            rect.size.height =1024;
        }else if(rect.size.height==370){
            rect.size.height =568;
        }
        
        self.view.frame = rect;
        

    }
    
    //NSLog(@"view frame height after keyboardDidHide:%f",self.view.frame.size.height);
    
    [UIView commitAnimations];
}

-(void)changeInputMode:(NSNotification *)notification
{
    NSString *inputMethod = [[UITextInputMode currentInputMode] primaryLanguage];
    //NSLog(@"inputMethod=%@",inputMethod);
    if([inputMethod isEqualToString:@"emoji"]) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4]; // to slide the view up
        
        CGRect rect = self.view.frame;
        
        rect.size.height +=k_KEYBOARD_OFFSET;       
        self.view.frame = rect;
        
        [UIView commitAnimations];
    }
    
}

- (IBAction)postButton:(id)sender {
    [self postCommentCommonMethod:_textfldNamed];
}

- (IBAction)doneButton:(id)sender {
    [self.textfldNamed resignFirstResponder];
    [self.commentsDelegate dismissCommentsView];
}
@end
