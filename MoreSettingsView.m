//
//  MoreSettingsView.m
//  FullIntel
//
//  Created by Arul on 3/20/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
// ip6- 375 6p-414 5 -320

#import "MoreSettingsView.h"
#import "MoreSettingsCell.h"
#import <Social/Social.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "FIUtils.h"
#import "SocialWebView.h"
#import <TwitterKit/TwitterKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <Fabric/Fabric.h>
#import "FISharedResources.h"
#define valFor5 295
#define valFor6 350
#define valFor6p 389

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))


#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define kPictureFrameHorizontalOffseta +35

@interface MoreSettingsView ()

@end

@implementation MoreSettingsView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _moreInforArray = [[NSMutableArray alloc]init];
    self.moreTableView.layer.cornerRadius = 5;
    self.moreTableView.layer.masksToBounds = YES;
//    CGFloat ptx =self.moreTableView.frame.origin.x;
//    CGFloat pty =self.moreTableView.frame.origin.y;
//    CGFloat ptw =self.moreTableView.frame.size.width;
//    CGFloat pth =self.moreTableView.frame.size.height;
// self.moreTableView.frame = CGRectMake(self.moreTableView.frame.origin.x-160,self.moreTableView.frame.origin.y, self.moreTableView.frame.size.width, self.moreTableView.frame.size.height);
//    UIBezierPath* trianglePath = [UIBezierPath bezierPath];
//    if (IS_IPHONE_5) {
//        [trianglePath moveToPoint:CGPointMake(valFor5, 55)];
//
//    } else if(IS_IPHONE_6){
//        [trianglePath moveToPoint:CGPointMake(valFor6, 55)];
//
//    }else if(IS_IPHONE_6P){
//        [trianglePath moveToPoint:CGPointMake(valFor6p, 55)];
//    }

    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnTableView)];
    tap.delegate = self;
    [self.bgView addGestureRecognizer:tap];

    
    UIBezierPath* trianglePath = [UIBezierPath bezierPath];
    NSLog(@"%f",SCREEN_WIDTH-125);
    [trianglePath moveToPoint:CGPointMake(SCREEN_WIDTH-24, 55)];

    [trianglePath addLineToPoint:CGPointMake(SCREEN_WIDTH-34, self.moreTableView.frame.origin.y)];
    [trianglePath addLineToPoint:CGPointMake(SCREEN_WIDTH-14, self.moreTableView.frame.origin.y)];
    [trianglePath closePath];
    
    CAShapeLayer *triangleMaskLayer = [CAShapeLayer layer];
    [triangleMaskLayer setPath:trianglePath.CGPath];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    
    view.backgroundColor = [UIColor whiteColor];
    view.layer.mask = triangleMaskLayer;
    [self.view addSubview:view];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];

    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        [_moreInforArray addObject:@"Unread"];
        [_moreInforArray addObject:@"Last 24 Hours"];


    }
    else{
        [_moreInforArray addObject:@"Unread"];
        [_moreInforArray addObject:@"Last 24 Hours"];

    }
    
    
    self.moreTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.moreTableView reloadData];
}
- (void)deviceOrientationDidChange:(NSNotification *)notification {
    CATransition* transition = [CATransition animation];
    
    transition.duration = 0.3;
    transition.type = kCATransitionFade;
    
    [self.view.layer addAnimation:transition forKey:kCATransition];
    [self dismissViewControllerAnimated:NO completion:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeAlphaVal" object:nil];

    
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:self.moreTableView.superview];
    CGPoint location = [gesture locationInView:self.moreTableView];
    NSIndexPath *path = [self.moreTableView indexPathForRowAtPoint:location];
    
    if(path)
    {
        // tap was on existing row, so pass it to the delegate method
        [self tableView:self.moreTableView didSelectRowAtIndexPath:path];
    }
    else
    {
        // handle tap on empty space below existing rows however you want
    }

    return !CGRectContainsPoint(self.moreTableView.frame, point);
}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    if ([touch.view isDescendantOfView:self.view]) {
//        
//        // Don't let selections of auto-complete entries fire the
//        // gesture recognizer
//        return NO;
// 
//    }
//    
//    return YES;
//}
-(void)didTapOnTableView
{
    
    CATransition* transition = [CATransition animation];
    
    transition.duration = 0.3;
    transition.type = kCATransitionFade;
    
    [self.view.layer addAnimation:transition forKey:kCATransition];
    [self dismissViewControllerAnimated:NO completion:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeAlphaVal" object:nil];
}
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    
//    CGFloat ptx =self.moreTableView.frame.origin.x;
//    CGFloat pty =self.moreTableView.frame.origin.y;
//    CGFloat ptw =self.moreTableView.frame.size.width;
//    CGFloat pth =self.moreTableView.frame.size.height;
//    
//    CATransition* transition = [CATransition animation];
//    
//    transition.duration = 0.3;
//    transition.type = kCATransitionFade;
//    
//    [self.view.layer addAnimation:transition forKey:kCATransition];
//    [self dismissViewControllerAnimated:NO completion:nil];
//
////    [UIView animateWithDuration:0.3
////                          delay:0.0
////                        options:0
////                     animations:^{
////                         self.view.frame = CGRectMake(0, 0, ptw, pth);
////                         [self.view layoutIfNeeded];
////                     } completion:^(BOOL finished){
////                         [self dismissViewControllerAnimated:YES completion:nil];
////
////                     }];
//
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeAlphaVal" object:nil];

//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return self.moreInforArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MoreSettingsCell *cell = (MoreSettingsCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.name.text = [_moreInforArray objectAtIndex:indexPath.row];
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        if(indexPath.row == 1) {
            cell.iconImage.image = [UIImage imageNamed:@"clockIcon"];
        } else  {
            cell.iconImage.image = [UIImage imageNamed:@"mailICons"];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    else{
        if(indexPath.row == 1) {
            cell.iconImage.image = [UIImage imageNamed:@"clockIcon"];
        } else  {
            cell.iconImage.image = [UIImage imageNamed:@"mailICons"];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
         NSLog(@"tableview%@",indexPath);
    
        if(indexPath.row == 1) {
            NSLog(@"tableview,indexPath 1");
            [[NSNotificationCenter defaultCenter]postNotificationName:@"notifyForLast24" object:nil];


        }else{
            NSLog(@"tableview,indexPath0");
            [[NSNotificationCenter defaultCenter]postNotificationName:@"notifyForUnreadMenu" object:nil];

        }
//
//
//            [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"LinkedInShareClick"];
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"linkedinSelection" object:nil userInfo:@{@"artileUrl":self.articleUrl,@"articleTitle":self.articleTitle,@"articleDescription":self.articleDesc}];
//        } else if(indexPath.row == 3) {
//            
//            [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"FacebookShareClick"];
//            
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"fbSelection" object:nil userInfo:@{@"artileUrl":self.articleUrl,@"articleTitle":self.articleTitle,@"articleDescription":self.articleDesc}];
//            
//            
//        } else if(indexPath.row == 2) {
//            //[self targetedShare:@""];
//            [self targetedShare:SLServiceTypeTwitter];
//        } else if(indexPath.row == 0) {
//            //Mail Button Click
//            [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"MailButtonClick"];
//            
//            NSString *mailBodyStr;
//            if(self.articleUrl.length != 0) {
//                mailBodyStr = [NSString stringWithFormat:@"Forwarded from FullIntel\n\n%@\n\n%@\n\n%@",self.articleTitle,self.articleDesc,self.articleUrl];
//            } else {
//                mailBodyStr = [NSString stringWithFormat:@"Forwarded from FullIntel\n\n%@\n\n%@\n",self.articleTitle,self.articleDesc];
//            }
//            // NSLog(@"mail body string:%@ and title:%@",mailBodyStr,self.selectedArticleTitle);
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"mailButtonClick" object:nil userInfo:@{@"articleId":self.articleId,@"title":self.articleTitle,@"body":mailBodyStr}];
//            //}
//        }else {
//            [self targetedShare:@""];
//        }
//
//    }
//    else{
//        // NSLog(@"did select more tableview");
//        if(indexPath.row == 0) {
//            
//            
//            [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"LinkedInShareClick"];
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"linkedinSelection" object:nil userInfo:@{@"artileUrl":self.articleUrl,@"articleTitle":self.articleTitle,@"articleDescription":self.articleDesc}];
//        } else if(indexPath.row == 2) {
//            
//            [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"FacebookShareClick"];
//            
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"fbSelection" object:nil userInfo:@{@"artileUrl":self.articleUrl,@"articleTitle":self.articleTitle,@"articleDescription":self.articleDesc}];
//            
//            
//        } else if(indexPath.row == 1) {
//            //[self targetedShare:@""];
//            [self targetedShare:SLServiceTypeTwitter];
//        } else {
//            [self targetedShare:@""];
//        }
//
//    }
    
}

-(void)targetedShare:(NSString *)serviceType {
//    if(serviceType.length > 0 && [SLComposeViewController isAvailableForServiceType:serviceType]){
//        [[FISharedResources sharedResourceManager]saveDetailsInLocalyticsWithName:@"TwitterShareClick"];
//        SLComposeViewController *shareView = [SLComposeViewController composeViewControllerForServiceType:serviceType];
//        
//        // define the range you're interested in
//        
//        NSString *twitterTitleString = [NSString stringWithFormat:@"Shared from @FullIntel : %@",self.articleTitle];
//        
//        NSRange stringRange = {0, MIN([twitterTitleString length], 94)};
////        
////        // adjust the range to include dependent chars
//        stringRange = [twitterTitleString rangeOfComposedCharacterSequencesForRange:stringRange];
////        
////        // Now you can create the short string
//        NSString *shortString = [twitterTitleString substringWithRange:stringRange];
//        NSLog(@"article title:%@",shortString);
//        //NSLog(@"short string:%@",shortString);
//        //NSLog(@"article image url:%@",self.articleImageUrl);
//        [shareView setInitialText:shortString];
//        UIImageView *image = [[UIImageView alloc]init];
//        [image sd_setImageWithURL:[NSURL URLWithString:self.articleImageUrl] placeholderImage:[UIImage imageNamed:@"FI"]];
//        [shareView addImage:image.image];
//        //[shareView removeAllImages];
//        [shareView addURL:[NSURL URLWithString:self.articleUrl]];
//        [self presentViewController:shareView animated:YES completion:nil];
//    } else {
//        
//        UIAlertView *alert;
//        alert = [[UIAlertView alloc]
//                 initWithTitle:@"Twitter"
//                 message:@"You can't send a tweet right now. Please make sure you have at least one Twitter account setup in device Settings -> Twitter -> Add Account."
//                 delegate:self
//                 cancelButtonTitle:@"Settings"
//                 otherButtonTitles:@"OK",nil];
//        
//        [alert show];
//    }
}

- (void) drawLine: (CGContextRef) context from: (CGPoint) from to: (CGPoint) to
{
    double slopy, cosy, siny;
    // Arrow size
    double length = 10.0;
    double width = 5.0;
    
    slopy = atan2((from.y - to.y), (from.x - to.x));
    cosy = cos(slopy);
    siny = sin(slopy);
    
    //draw a line between the 2 endpoint
    CGContextMoveToPoint(context, from.x - length * cosy, from.y - length * siny );
    CGContextAddLineToPoint(context, to.x + length * cosy, to.y + length * siny);
    //paints a line along the current path
    CGContextStrokePath(context);
    
    //here is the tough part - actually drawing the arrows
    //a total of 6 lines drawn to make the arrow shape
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context,
                            from.x + ( - length * cosy - ( width / 2.0 * siny )),
                            from.y + ( - length * siny + ( width / 2.0 * cosy )));
    CGContextAddLineToPoint(context,
                            from.x + (- length * cosy + ( width / 2.0 * siny )),
                            from.y - (width / 2.0 * cosy + length * siny ) );
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
    /*/-------------similarly the the other end-------------/*/
    CGContextMoveToPoint(context, to.x, to.y);
    CGContextAddLineToPoint(context,
                            to.x +  (length * cosy - ( width / 2.0 * siny )),
                            to.y +  (length * siny + ( width / 2.0 * cosy )) );
    CGContextAddLineToPoint(context,
                            to.x +  (length * cosy + width / 2.0 * siny),
                            to.y -  (width / 2.0 * cosy - length * siny) );
    CGContextClosePath(context);
    CGContextStrokePath(context);
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}


- (IBAction)requestButtonClick:(id)sender {
//    [sender setSelected:YES];
//    [FIUtils callRequestionUpdateWithModuleId:10 withFeatureId:10];
}


@end
