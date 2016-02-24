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
    int i;
}
@end

@implementation MoreSettingsView

- (void)viewDidLoad {
    
    [super viewDidLoad];
    i=0;
    SelectedCellBGColor = [FIUtils colorWithHexString:@"F55567"];
    NotSelectedCellBGColor = [UIColor clearColor];

    // Do any additional setup after loading the view from its nib.
    _moreInforArray = [[NSMutableArray alloc]init];
    self.moreTableView.layer.cornerRadius = 5;
    self.moreTableView.layer.masksToBounds = YES;
    



    
//    self.moreTableView.frame = CGRectMake(self.xPositions, self.yPositions, self.moreTableView.frame.size.width, self.moreTableView.frame.size.height);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];

    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        
        UIBezierPath* trianglePath = [UIBezierPath bezierPath];
        NSLog(@"%f",SCREEN_WIDTH-125);
        [trianglePath moveToPoint:CGPointMake(_xPositions+10, _yPositions+40)];
        [trianglePath addLineToPoint:CGPointMake(_xPositions+20 , self.moreTableView.frame.origin.y)];
        [trianglePath addLineToPoint:CGPointMake(_xPositions, self.moreTableView.frame.origin.y)];
        [trianglePath closePath];
        
        CAShapeLayer *triangleMaskLayer = [CAShapeLayer layer];
        [triangleMaskLayer setPath:trianglePath.CGPath];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
        
        view.backgroundColor = [UIColor whiteColor];
        view.layer.mask = triangleMaskLayer;
        [self.view addSubview:view];
        
        CGFloat xPosOfMoreTblVw = self.view.frame.origin.x;
        CGFloat yPosOfMoreTblVw = self.view.frame.origin.y;
        CGFloat wPosOfMoreTblVw = self.view.frame.size.width;
        CGFloat hPosOfMoreTblVw = self.view.frame.size.height;
        
        NSLog(@"_______%f, %f, %f,%f_______",xPosOfMoreTblVw,yPosOfMoreTblVw,wPosOfMoreTblVw,hPosOfMoreTblVw);
        self.tableHeightConstraint.constant = 0;
        self.tableWidthConstraint.constant = 0;

        POPSpringAnimation *layoutAnimations = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
        layoutAnimations.springSpeed = 10.0f;
        layoutAnimations.springBounciness = 5.0f;
        layoutAnimations.toValue = @(155);
        [self.tableWidthConstraint pop_addAnimation:layoutAnimations forKey:@"detailsContainerWidthAnimates"];
        
        POPSpringAnimation *layoutAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
        layoutAnimation.springSpeed = 10.0f;
        layoutAnimation.springBounciness = 5.0f;
        layoutAnimation.toValue = @(120);
        [self.tableHeightConstraint pop_addAnimation:layoutAnimation forKey:@"detailsContainerWidthAnimate"];
        
        
        
        
        //this will work if everything else fails
        //        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
        //        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        //        anim.fromValue = @(0.0);
        //        anim.toValue = @(1.0);
        //        [self.view pop_addAnimation:anim forKey:@"fade"];
        
        [self performSelector:@selector(assignValueWithDelay) withObject:nil afterDelay:0.2];

    }
    else{
                
        if(self.dropDownValue == 1) {
            //filter
            self.tableHeightConstraint.constant = 120;
            [_moreInforArray addObject:@"All articles"];
            [_moreInforArray addObject:@"Unread"];
            [_moreInforArray addObject:@"Last 24 Hours"];
        } else if(self.dropDownValue == 2) {
            //actions
            self.tableHeightConstraint.constant = 80;
            [_moreInforArray addObject:@"ADD TO FOLDER"];
            [_moreInforArray addObject:@"MARK AS READ"];
        }
        
    }

    self.moreTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.moreTableView reloadData];
}
-(void)assignValueWithDelay{
    
    [_moreInforArray addObject:@"All articles"];
    [_moreInforArray addObject:@"Unread"];
    [_moreInforArray addObject:@"Last 24 Hours"];
    [self.moreTableView reloadData];

}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    fromView.userInteractionEnabled = NO;
    
    UIView *dimmingView = [[UIView alloc] initWithFrame:fromView.bounds];
    dimmingView.backgroundColor = [UIColor redColor];
    dimmingView.layer.opacity = 0.0;
    
    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    toView.frame = CGRectMake(0,
                              0,
                              CGRectGetWidth(transitionContext.containerView.bounds) - 104.f,
                              CGRectGetHeight(transitionContext.containerView.bounds) - 288.f);
    toView.center = CGPointMake(transitionContext.containerView.center.x, -transitionContext.containerView.center.y);
    
    [transitionContext.containerView addSubview:dimmingView];
    [transitionContext.containerView addSubview:toView];
    
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionAnimation.toValue = @(transitionContext.containerView.center.y);
    positionAnimation.springBounciness = 10;
    [positionAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.springBounciness = 20;
    scaleAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.2, 1.4)];
    
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(0.2);
    
    [toView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    [toView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    [dimmingView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    CATransition* transition = [CATransition animation];
    
    transition.duration = 0.3;
    transition.type = kCATransitionFade;
    
    [self.view.layer addAnimation:transition forKey:kCATransition];
    [self dismissViewControllerAnimated:NO completion:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeAlphaVal" object:nil];

    
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"ended");
    if (i==1) {
            i=0;
    } else {
            UITouch *touch = [[event allTouches] anyObject];
        //  CGPoint touchLocation = [touch locationInView:touch.view];
        //  CGPoint point = [touch locationInView:self.moreTableView.superview];
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
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"began");
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"moved");
    i=1;

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
    
    
    
    if(self.dropDownValue == 1){
        NSInteger selectionValue = [[NSUserDefaults standardUserDefaults] integerForKey:@"selectionValue"];
        cell.iconWidthConstraint.constant = 15;
        
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
                cell.lastLineImage.hidden = YES;
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
                cell.lastLineImage.hidden = YES;
                
            }
            
        }
    } else {
        cell.iconWidthConstraint.constant = 0;
        cell.iconImage.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self didTapOnTableView];
    MoreSettingsCell *cells = [tableView cellForRowAtIndexPath:indexPath];
    if(self.dropDownValue == 1) {
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
    } else {
        if(indexPath.row == 0) {
            //trigger Add to folder
            [[NSNotificationCenter defaultCenter]postNotificationName:@"notifyForAddToFolder" object:nil];
        } else if(indexPath.row == 1) {
            //Trigger Mark as Read
            [[NSNotificationCenter defaultCenter]postNotificationName:@"notifyForMarkAsRead" object:nil];
        }
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
