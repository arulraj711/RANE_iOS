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

@interface CommentsPopoverView ()

@end

@implementation CommentsPopoverView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchCommentsForArticleId) name:@"FetchingComments" object:nil];
    
    NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    
   [self.imageView setImageWithString:username color:[UIColor lightGrayColor] circular:true fontName:@"Open Sans"];
    [self fetchCommentsForArticleId];
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
    return self.commentsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSManagedObject *comment = [self.commentsArray objectAtIndex:indexPath.row];
    cell.userName.text = [comment valueForKey:@"userName"];
    cell.message.text = [comment valueForKey:@"comment"];
    NSString *name = [comment valueForKey:@"userName"];
    [cell.userImage setImageWithString:name color:[UIColor lightGrayColor] circular:true fontName:@"Open Sans"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
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
    }
    return YES;
}
@end
