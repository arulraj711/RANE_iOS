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
    [_moreInforArray addObject:@"Linkedin"];
    [_moreInforArray addObject:@"Twitter"];
    [_moreInforArray addObject:@"Facebook"];
    [_moreInforArray addObject:@"Mail"];
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
    if(indexPath.row == 1) {
        cell.iconImage.image = [UIImage imageNamed:@"twitter"];
    } else if(indexPath.row == 3) {
        cell.iconImage.image = [UIImage imageNamed:@"mail30.png"];
        
    }else {
        cell.iconImage.image = [UIImage imageNamed:[_moreInforArray objectAtIndex:indexPath.row]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   // NSLog(@"did select more tableview");
    if(indexPath.row == 0) {
        
        
        [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"LinkedInShareClick"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"linkedinSelection" object:nil userInfo:@{@"artileUrl":self.articleUrl,@"articleTitle":self.articleTitle,@"articleDescription":self.articleDesc}];
        
//        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"CorporateNewsListView" bundle:nil];
//        
//        UINavigationController *modalController = [storyBoard instantiateViewControllerWithIdentifier:@"SocialWebView"];
//        SocialWebView *socialWebViewObj=(SocialWebView *)[[modalController viewControllers]objectAtIndex:0];
//        socialWebViewObj.titleStr=@"LinkedIn Share";
//        NSString *urlString = [NSString stringWithFormat:@"https://www.linkedin.com/shareArticle?mini=true&url=%@&title=%@&summary=%@&source=LinkedIn",self.articleUrl,self.articleTitle,self.articleDesc];
//        NSLog(@"linked in url:%@",urlString);
//       NSString* urlTextEscaped = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSLog(@"after link:%@",urlTextEscaped);
//        socialWebViewObj.urlString=urlTextEscaped;
//        modalController.modalPresentationStyle = UIModalPresentationCustom;
//        
//        [self presentViewController:modalController animated:NO completion:^{
//           // [self dismissViewControllerAnimated:YES completion:nil];
//        }];
        
    } else if(indexPath.row == 2) {
        
       // FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
//        content.contentURL = [NSURL URLWithString:self.articleUrl];
//        [FBSDKShareDialog showFromViewController:self
//                                     withContent:content
//                                        delegate:nil];
        
//        FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
//        dialog.fromViewController = self;
//         dialog.content = content;
//        dialog.mode = FBSDKShareDialogModeShareSheet;
//        [dialog show];
        
//        FBSDKShareLinkContent *content = [FBSDKShareLinkContent new];
//        content.contentURL = [NSURL URLWithString:self.articleUrl];
//        content.contentTitle =self.articleTitle;
//        content.contentDescription =self.articleDesc;
//        FBSDKShareDialog *shareDialog = [FBSDKShareDialog new];
//        [shareDialog setMode:FBSDKShareDialogModeAutomatic];
//        [shareDialog setShareContent:content];
//        [shareDialog setFromViewController:self];
//        [shareDialog show];
        
      //  [self targetedShare:SLServiceTypeFacebook];
        
        [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"FacebookShareClick"];
        
                [[NSNotificationCenter defaultCenter]postNotificationName:@"fbSelection" object:nil userInfo:@{@"artileUrl":self.articleUrl,@"articleTitle":self.articleTitle,@"articleDescription":self.articleDesc}];
        
        
    } else if(indexPath.row == 1) {
        //[self targetedShare:@""];
       [self targetedShare:SLServiceTypeTwitter];
        
//            [[Twitter sharedInstance] logInWithCompletion:^
//             (TWTRSession *session, NSError *error) {
//                 if (session) {
//                     NSLog(@"signed in as %@", [session userName]);
//                    // [logInButton removeFromSuperview];
//                     
//                     TWTRComposer *composer = [[TWTRComposer alloc] init];
//                     
//                     [composer setText:self.articleTitle];
//                     UIImageView *image = [[UIImageView alloc]init];
//                     NSLog(@"article image:%@",self.articleImageUrl);
//                     [image sd_setImageWithURL:[NSURL URLWithString:self.articleImageUrl] placeholderImage:[UIImage imageNamed:@"FI"]];
//                     [composer setImage:image.image];
//                     [composer setURL:[NSURL URLWithString:self.articleUrl]];
//                     [composer showWithCompletion:^(TWTRComposerResult result) {
//                         if (result == TWTRComposerResultCancelled) {
//                             NSLog(@"Tweet composition cancelled");
//                         }
//                         else {
//                             NSLog(@"Sending Tweet!");
//                         }
//                     }];
//                     
//                 } else {
//                 }
//             }];
        
        
    } else if(indexPath.row == 3) {
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
