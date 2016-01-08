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
#import "FIUtils.h"
#import "SocialWebView.h"
#import <TwitterKit/TwitterKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <Fabric/Fabric.h>
#import "FISharedResources.h"
@interface MorePopoverView ()

@end

@implementation MorePopoverView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _moreInforArray = [[NSMutableArray alloc]init];

    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        [_moreInforArray addObject:@"Email"];
        [_moreInforArray addObject:@"Linkedin"];
        [_moreInforArray addObject:@"Twitter"];
        [_moreInforArray addObject:@"Facebook"];

    }
    else{
        [_moreInforArray addObject:@"Linkedin"];
        [_moreInforArray addObject:@"Twitter"];
        [_moreInforArray addObject:@"Facebook"];

    }
    
//    [_moreInforArray addObject:@"Google Plus"];
//    [_moreInforArray addObject:@"Evernote"];
//    [_moreInforArray addObject:@"Pocket"];
//    [_moreInforArray addObject:@"Buffer"];
//    [_moreInforArray addObject:@"Instapaper"];
    
    self.moreTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
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
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        if(indexPath.row == 2) {
            cell.iconImage.image = [UIImage imageNamed:@"twitter"];
        } else if(indexPath.row == 0) {
            cell.iconImage.image = [UIImage imageNamed:@"mail_filled"];
            
        }else {
            cell.iconImage.image = [UIImage imageNamed:[_moreInforArray objectAtIndex:indexPath.row]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    else{
        if(indexPath.row == 1) {
            cell.iconImage.image = [UIImage imageNamed:@"twitter"];
        } else {
            cell.iconImage.image = [UIImage imageNamed:[_moreInforArray objectAtIndex:indexPath.row]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        // NSLog(@"did select more tableview");
        if(indexPath.row == 1) {
            
            
            [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"LinkedInShareClick"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"linkedinSelection" object:nil userInfo:@{@"artileUrl":self.articleUrl,@"articleTitle":self.articleTitle,@"articleDescription":self.articleDesc}];
        } else if(indexPath.row == 3) {
            
            [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"FacebookShareClick"];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"fbSelection" object:nil userInfo:@{@"artileUrl":self.articleUrl,@"articleTitle":self.articleTitle,@"articleDescription":self.articleDesc}];
            
            
        } else if(indexPath.row == 2) {
            //[self targetedShare:@""];
            [self targetedShare:SLServiceTypeTwitter];
        } else if(indexPath.row == 0) {
            //Mail Button Click
            [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"MailButtonClick"];
            
            NSString *mailBodyStr;
            if(self.articleUrl.length != 0) {
                mailBodyStr = [NSString stringWithFormat:@"Forwarded from FullIntel\n\n%@\n\n%@\n\n%@",self.articleTitle,self.articleDesc,self.articleUrl];
            } else {
                mailBodyStr = [NSString stringWithFormat:@"Forwarded from FullIntel\n\n%@\n\n%@\n",self.articleTitle,self.articleDesc];
            }
            // NSLog(@"mail body string:%@ and title:%@",mailBodyStr,self.selectedArticleTitle);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"mailButtonClick" object:nil userInfo:@{@"articleId":self.articleId,@"title":self.articleTitle,@"body":mailBodyStr}];
            //}
        }else {
            [self targetedShare:@""];
        }

    }
    else{
        // NSLog(@"did select more tableview");
        if(indexPath.row == 0) {
            
            
            [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"LinkedInShareClick"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"linkedinSelection" object:nil userInfo:@{@"artileUrl":self.articleUrl,@"articleTitle":self.articleTitle,@"articleDescription":self.articleDesc}];
        } else if(indexPath.row == 2) {
            
            [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"FacebookShareClick"];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"fbSelection" object:nil userInfo:@{@"artileUrl":self.articleUrl,@"articleTitle":self.articleTitle,@"articleDescription":self.articleDesc}];
            
            
        } else if(indexPath.row == 1) {
            //[self targetedShare:@""];
            [self targetedShare:SLServiceTypeTwitter];
        } else {
            [self targetedShare:@""];
        }

    }
    
}

-(void)targetedShare:(NSString *)serviceType {
    if(serviceType.length > 0 && [SLComposeViewController isAvailableForServiceType:serviceType]){
        [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"TwitterShareClick"];
        SLComposeViewController *shareView = [SLComposeViewController composeViewControllerForServiceType:serviceType];
        
        // define the range you're interested in
        
        NSString *twitterTitleString = [NSString stringWithFormat:@"Shared from @FullIntel : %@",self.articleTitle];
        
        NSRange stringRange = {0, MIN([twitterTitleString length], 94)};
//        
//        // adjust the range to include dependent chars
        stringRange = [twitterTitleString rangeOfComposedCharacterSequencesForRange:stringRange];
//        
//        // Now you can create the short string
        NSString *shortString = [twitterTitleString substringWithRange:stringRange];
        NSLog(@"article title:%@",shortString);
        //NSLog(@"short string:%@",shortString);
        //NSLog(@"article image url:%@",self.articleImageUrl);
        [shareView setInitialText:shortString];
        UIImageView *image = [[UIImageView alloc]init];
        [image sd_setImageWithURL:[NSURL URLWithString:self.articleImageUrl] placeholderImage:[UIImage imageNamed:@"FI"]];
        [shareView addImage:image.image];
        //[shareView removeAllImages];
        [shareView addURL:[NSURL URLWithString:self.articleUrl]];
        [self presentViewController:shareView animated:YES completion:nil];
    } else {
        
        UIAlertView *alert;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Twitter"
                 message:@"You can't send a tweet right now. Please make sure you have at least one Twitter account setup in device Settings -> Twitter -> Add Account."
                 delegate:self
                 cancelButtonTitle:@"Settings"
                 otherButtonTitles:@"OK",nil];
        
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}


- (IBAction)requestButtonClick:(id)sender {
    [sender setSelected:YES];
    [FIUtils callRequestionUpdateWithModuleId:10 withFeatureId:10];
}
@end
