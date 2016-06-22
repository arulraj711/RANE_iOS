//
//  UIImage+CustomNavIconImage.m
//  RANE
//
//  Created by cape start on 20/06/16.
//  Copyright © 2016 CapeStart. All rights reserved.
//

#import "UIImage+CustomNavIconImage.h"
#import "UIColor+CustomColor.h"

@implementation UIImage (CustomNavIconImage)
+(UIImage *)createCustomNavIconFromImage:(NSString *)iconImageName {
    UIImageView *searchImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 16, 15)];
    [searchImageView setTintColor:[UIColor redColor]];
    [searchImageView setImage:[[UIImage imageNamed:iconImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    
    UIImage *newImage = [searchImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIGraphicsBeginImageContextWithOptions(searchImageView.image.size, NO, newImage.scale);
    [[UIColor headerTextColor] set];
    [newImage drawInRect:CGRectMake(0, 0, searchImageView.image.size.width, newImage.size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


+(UIImage *)createCustomExpandButtonFromImage:(NSString *)iconImageName {
    UIImageView *searchImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
    [searchImageView setTintColor:[UIColor redColor]];
    [searchImageView setImage:[[UIImage imageNamed:iconImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    
    UIImage *newImage = [searchImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIGraphicsBeginImageContextWithOptions(searchImageView.image.size, NO, newImage.scale);
    [[UIColor menuTextColor] set];
    [newImage drawInRect:CGRectMake(0, 0, searchImageView.image.size.width, newImage.size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
