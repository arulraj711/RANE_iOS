//
//  MorePopoverView.m
//  FullIntel
//
//  Created by Arul on 3/20/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "MorePopoverView.h"
#import "MoreViewCell.h"
#import <Social/Social.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface MorePopoverView ()

@end

@implementation MorePopoverView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _moreInforArray = [[NSMutableArray alloc]init];
    [_moreInforArray addObject:@"Facebook"];
    [_moreInforArray addObject:@"Twitter"];
    [_moreInforArray addObject:@"Linkedin"];
    [_moreInforArray addObject:@"Google Plus"];
    [_moreInforArray addObject:@"Evernote"];
    [_moreInforArray addObject:@"Pocket"];
    [_moreInforArray addObject:@"Buffer"];
    [_moreInforArray addObject:@"Instapaper"];
    [self.moreTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return self.moreInforArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MoreViewCell *cell = (MoreViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.name.text = [_moreInforArray objectAtIndex:indexPath.row];
    if(indexPath.row == 1) {
        cell.iconImage.image = [UIImage imageNamed:@"twitter"];
    } else {
        cell.iconImage.image = [UIImage imageNamed:[_moreInforArray objectAtIndex:indexPath.row]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"did select more tableview");
    if(indexPath.row == 0) {
        [self targetedShare:SLServiceTypeFacebook];
    } else if(indexPath.row == 1) {
        [self targetedShare:SLServiceTypeTwitter];
    } else if(indexPath.row == 2) {
        [self targetedShare:@""];
    }
    
    
    
//    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
//    {
//        SLComposeViewController *tweetSheet = [SLComposeViewController
//                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
//        [tweetSheet setInitialText:@"Great fun to learn iOS programming at appcoda.com!"];
//        [self presentViewController:tweetSheet animated:YES completion:nil];
//    } else if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
//        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
//            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
//            
//            [controller setInitialText:@"First post from my iPhone app"];
//           // [controller set];
//            [self presentViewController:controller animated:YES completion:Nil];
//        }
//    } else {
//        NSLog(@"share else part");
//    }
}

-(void)targetedShare:(NSString *)serviceType {
    if(serviceType.length > 0 && [SLComposeViewController isAvailableForServiceType:serviceType]){
        SLComposeViewController *shareView = [SLComposeViewController composeViewControllerForServiceType:serviceType];
        
        [shareView setInitialText:self.articleTitle];
//        UIImageView *image = [[UIImageView alloc]init];
//        [image sd_setImageWithURL:[NSURL URLWithString:self.articleImageUrl] placeholderImage:[UIImage imageNamed:@"FI"]];
//        [shareView addImage:image.image];
        //[shareView removeAllImages];
        [shareView addURL:[NSURL URLWithString:self.articleUrl]];
        [self presentViewController:shareView animated:YES completion:nil];
    } else {
        
        UIAlertView *alert;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"You do not have this service"
                 message:nil
                 delegate:self
                 cancelButtonTitle:@"OK"
                 otherButtonTitles:nil];
        
        [alert show];
    }
}
@end
