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

@interface CommentsPopoverView ()

@end

@implementation CommentsPopoverView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.outerView.layer.masksToBounds = YES;
    self.outerView.layer.cornerRadius = 10;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchCommentsForArticleId) name:@"FetchingComments" object:nil];
    
    NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    
   [self.imageView setImageWithString:username color:[UIColor lightGrayColor] circular:true fontName:@"Open Sans"];
    [self fetchCommentsForArticleId];
    
    self.backImgeView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapEvent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEvent)];
    [self.backImgeView addGestureRecognizer:tapEvent];
    
}

-(void)tapEvent {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)fetchCommentsForArticleId{
    NSManagedObjectContext *managedObjectContext = [[FISharedResources sharedResourceManager]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CuratedNews"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleId == %@",self.articleId];
    [fetchRequest setPredicate:predicate];
    NSArray *filterArray =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if(filterArray.count != 0) {
        NSManagedObject *curatedNews = [filterArray objectAtIndex:0];
        NSLog(@"comments:%@",[curatedNews valueForKey:@"comments"]);
        NSManagedObject *userComments = [curatedNews valueForKey:@"comments"];
        NSSet *commentSet = [userComments valueForKey:@"comments"];
        self.commentsArray = [[NSMutableArray alloc]initWithArray:[commentSet allObjects]];
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
        cell.message.text = [comment valueForKey:@"comment"];
        NSString *name = [comment valueForKey:@"userName"];
        [cell.userImage setImageWithString:name color:[UIColor lightGrayColor] circular:true fontName:@"Open Sans"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableCell = cell;
    }
    return tableCell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField.text.length != 0) {
        NSMutableDictionary *commentsDic = [[NSMutableDictionary alloc] init];
        [commentsDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"accesstoken"] forKey:@"securityToken"];
        [commentsDic setObject:self.articleId forKey:@"articleId"];
        [commentsDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"] forKey:@"userId"];
        [commentsDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"customerId"] forKey:@"customerId"];
        [commentsDic setObject:@"1" forKey:@"version"];
        [commentsDic setObject:@"-1" forKey:@"parentId"];
        [commentsDic setObject:textField.text forKey:@"comment"];
        NSData *commentsJsondata = [NSJSONSerialization dataWithJSONObject:commentsDic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *commentsResultStr = [[NSString alloc]initWithData:commentsJsondata encoding:NSUTF8StringEncoding];
        if(textField.text.length != 0) {
            [[FISharedResources sharedResourceManager]addCommentsWithDetails:commentsResultStr];
            textField.text = @"";
            [textField resignFirstResponder];
        } else {
            UIWindow *window = [[UIApplication sharedApplication]windows][0];
            [window makeToast:@"Please enter a comment." duration:1 position:CSToastPositionCenter];
        }
    }
    
    
   
    
    return YES;
}

#define k_KEYBOARD_OFFSET 310.0

-(void)keyboardWillAppear {
    // Move current view up / down with Animation
//    if (self.view.frame.origin.y >= 0)
//    {
//        [self moveViewUp:YES];
//    }
//    else if (self.view.frame.origin.y < 0)
//    {
//        [self moveViewUp:NO];
//    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4]; // to slide the view up
    
    CGRect rect = self.view.frame;
    rect.size.height -= k_KEYBOARD_OFFSET;
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

-(void)keyboardWillDisappear {
//    if (self.view.frame.origin.y >= 0)
//    {
//        [self moveViewUp:YES];
//    }
//    else if (self.view.frame.origin.y < 0)
//    {
//        [self moveViewUp:NO];
//    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4]; // to slide the view up
    
    CGRect rect = self.view.frame;
    rect.size.height += k_KEYBOARD_OFFSET;
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    //if ([sender isEqual:txtEmail]) // txtEmail is UITextField control for email address
   // {
        //move the main view up, so the keyboard will not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
           // [self moveViewUp:YES];
        }
   // }
}

//Custom method to move the view up/down whenever the keyboard is appeared / disappeared
-(void)moveViewUp:(BOOL)bMovedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4]; // to slide the view up
    
    CGRect rect = self.view.frame;
    if (bMovedUp) {
        // 1. move the origin of view up so that the text field will come above the keyboard
        //rect.origin.y -= k_KEYBOARD_OFFSET;
        
        // 2. increase the height of the view to cover up the area behind the keyboard
        rect.size.height -= k_KEYBOARD_OFFSET;
        NSLog(@"show height:%f",rect.size.height);
    } else {
        // revert to normal state of the view.
        //rect.origin.y += k_KEYBOARD_OFFSET;
        rect.size.height += k_KEYBOARD_OFFSET;
        NSLog(@"hide height:%f",rect.size.height);
    }
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void)viewWillAppear:(BOOL)animated
{
    // register keyboard notifications to appear / disappear the keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAppear)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillDisappear)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while moving to the other screen.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

@end
