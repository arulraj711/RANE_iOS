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
#import "FIUtils.h"
#import <pop/POP.h>
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
{
    NSInteger selectedIndexPath;
    UIColor *SelectedCellBGColor;
    UIColor *NotSelectedCellBGColor;
}
@end

@implementation MoreSettingsView

- (void)viewDidLoad {
    
    [super viewDidLoad];
    SelectedCellBGColor = [FIUtils colorWithHexString:@"F55567"];
    NotSelectedCellBGColor = [UIColor clearColor];

    // Do any additional setup after loading the view from its nib.
    _moreInforArray = [[NSMutableArray alloc]init];
    self.moreTableView.layer.cornerRadius = 5;
    self.moreTableView.layer.masksToBounds = YES;
    
//    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
//    anim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)];
//    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 155, 120)];
//    [self.moreTableView pop_addAnimation:anim forKey:@"size"];
    
//    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
//    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    anim.fromValue = @(0.4);
//    anim.toValue = @(1.0);
//    [self.moreTableView pop_addAnimation:anim forKey:@"fade"];



   
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnTableView)];
//    tap.delegate = self;
//    [self.bgView addGestureRecognizer:tap];

    
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
    
    POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    sprintAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(310, 0)];
    sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
    sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
    sprintAnimation.springBounciness = 5.f;
    [self.moreTableView pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
    [self.view pop_addAnimation:sprintAnimation forKey:@"springAnimation"];

//    POPSpringAnimation *ssprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
//    ssprintAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(1, 0.1)];
//    ssprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
//    ssprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
//    ssprintAnimation.springBounciness = 5.f;
//    [view pop_addAnimation:ssprintAnimation forKey:@"springAnimation"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];

    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        [_moreInforArray addObject:@"All articles"];
        [_moreInforArray addObject:@"Unread"];
        [_moreInforArray addObject:@"Last 24 Hours"];

    }
    else{
        [_moreInforArray addObject:@"All articles"];
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
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
//    CGPoint touchLocation = [touch locationInView:touch.view];
//    CGPoint point = [touch locationInView:self.moreTableView.superview];
    CGPoint location = [touch locationInView:self.moreTableView];
    NSIndexPath *path = [self.moreTableView indexPathForRowAtPoint:location];

    if(path){
        [self tableView:self.moreTableView didSelectRowAtIndexPath:path];

    }
    else
    {
        CATransition* transition = [CATransition animation];
        
        transition.duration = 0.3;
        transition.type = kCATransitionFade;
        
        [self.view.layer addAnimation:transition forKey:kCATransition];
        [self dismissViewControllerAnimated:NO completion:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"changeAlphaVal" object:nil];

            // handle tap on empty space below existing rows however you want
    }

}


-(void)didTapOnTableView
{
    
    CATransition* transition = [CATransition animation];
    
    transition.duration = 0.3;
    transition.type = kCATransitionFade;
    
    [self.view.layer addAnimation:transition forKey:kCATransition];
    [self dismissViewControllerAnimated:NO completion:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeAlphaVal" object:nil];
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
    MoreSettingsCell *cell = (MoreSettingsCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSLog(@"%@",indexPath);
    NSLog(@"%ld",(long)selectedIndexPath);
    cell.name.text = [_moreInforArray objectAtIndex:indexPath.row];
    
    NSInteger selectionValue = [[NSUserDefaults standardUserDefaults] integerForKey:@"selectionValue"];
    NSLog(@"%ld",(long)selectionValue);
    NSLog(@"%ld",indexPath.row);

    
    if (selectionValue  == indexPath.row) {
        if (cell.name.textColor == SelectedCellBGColor) {
        cell.name.textColor = [UIColor lightGrayColor];
        }
    else {
        cell.name.textColor = SelectedCellBGColor;
         }
    }
    
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        if(indexPath.row == 0){
            cell.iconImage.image = [UIImage imageNamed:@"NoArticles"];
        }
        else if(indexPath.row == 1) {
            cell.iconImage.image = [UIImage imageNamed:@"mailICons"];
        }
        else if(indexPath.row == 2){
            cell.iconImage.image = [UIImage imageNamed:@"clockIcon"];
        }

    }
    else{
        if(indexPath.row == 0){
            cell.iconImage.image = [UIImage imageNamed:@"NoArticles"];
        }
        else if(indexPath.row == 1) {
            cell.iconImage.image = [UIImage imageNamed:@"mailICons"];
        }
        else if(indexPath.row == 2){
            cell.iconImage.image = [UIImage imageNamed:@"clockIcon"];
        }
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self didTapOnTableView];
    MoreSettingsCell *cells = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%ld",(long)indexPath.row);
    NSLog(@"%@",cells);

    for (int i = 0; i < [tableView numberOfRowsInSection:indexPath.section]; i++) {
        if (i != indexPath.row) {
            MoreSettingsCell* cellse = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
            cellse.name.textColor = [UIColor lightGrayColor];
            [tableView reloadData];
        }
    }
    if (cells.isSelected == YES)
    {
        if (cells.name.textColor ==SelectedCellBGColor) {
        } else {
            cells.name.textColor = SelectedCellBGColor;
        }
        

        
    }
    NSLog(@"tableview%@",indexPath);
    if(indexPath.row == 0){
        NSLog(@"tableview,indexPath 1");
        [[NSNotificationCenter defaultCenter]postNotificationName:@"notifyForAll" object:nil];
        [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:@"selectionValue"];
        NSLog(@"tableview%@",indexPath);

    }
    
    else if(indexPath.row == 1) {
        NSLog(@"tableview,indexPath 1");
        [[NSNotificationCenter defaultCenter]postNotificationName:@"notifyForUnreadMenu" object:nil];
        [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:@"selectionValue"];
        NSLog(@"tableview%@",indexPath);

    }
    else if(indexPath.row == 2){
        NSLog(@"tableview,indexPath0");
        [[NSNotificationCenter defaultCenter]postNotificationName:@"notifyForLast24" object:nil];
        [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:@"selectionValue"];
        NSLog(@"tableview%@",indexPath);

    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreSettingsCell *cells = [tableView cellForRowAtIndexPath:indexPath];
    cells.name.textColor = [UIColor lightGrayColor];

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





@end
