//
//  UIColor+CustomColor.m
//  RANE
//
//  Created by CapeStart Apple on 6/2/16.
//  Copyright © 2016 CapeStart. All rights reserved.
//

#import "UIColor+CustomColor.h"
#import "FIUtils.h"
#import "FISharedResources.h"

@implementation UIColor (CustomColor)

+(UIColor *)headerBackgroundColor {
    NSString *headerBackgroundColor = [[NSUserDefaults standardUserDefaults]objectForKey:@"headerBgColor"];
    if(headerBackgroundColor.length == 0) {
        headerBackgroundColor = @"#616264";
    }
    const char *cStr = [headerBackgroundColor cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    return [UIColor colorWithHex:x];
}

+(UIColor *)headerTextColor {
    
    NSString *headerTextColor = [[NSUserDefaults standardUserDefaults]objectForKey:@"headerFgColor"];
    if(headerTextColor.length == 0) {
        headerTextColor = @"#FFFFFF";
    }
    const char *cStr = [headerTextColor cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    return [UIColor colorWithHex:x];
   
}

+(UIColor *)menuBackgroundColor {
    
    NSString *menuBackgroundColor = [[NSUserDefaults standardUserDefaults]objectForKey:@"menuBgColor"];
    if(menuBackgroundColor.length == 0) {
        menuBackgroundColor = @"#edf0f0";
    }
    const char *cStr = [menuBackgroundColor cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    return [UIColor colorWithHex:x];
    
}

+(UIColor *)menuTextColor {
    
    NSString *menuTextColor = [[NSUserDefaults standardUserDefaults]objectForKey:@"textColor"];
    if(menuTextColor.length == 0) {
        menuTextColor = @"#666E73";
    }
    const char *cStr = [menuTextColor cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    return [UIColor colorWithHex:x];
    
}

+(UIColor *)highlightMenuBackgroundColor {
    
    NSString *highlightMenuBackgroundColor = [[NSUserDefaults standardUserDefaults]objectForKey:@"highlightBgColor"];
    if(highlightMenuBackgroundColor.length == 0) {
        highlightMenuBackgroundColor = @"#1e8cd4";
    }
    const char *cStr = [highlightMenuBackgroundColor cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    return [UIColor colorWithHex:x];
    
}

+(UIColor *)highlightMenuTextColor {
    
    NSString *highlightMenuTextColor = [[NSUserDefaults standardUserDefaults]objectForKey:@"highlightFgColor"];
    if(highlightMenuTextColor.length == 0) {
        highlightMenuTextColor = @"#62ABDA";
    }
    const char *cStr = [highlightMenuTextColor cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    return [UIColor colorWithHex:x];
    
}

+(UIColor *)notificationBackgroundColor {
    
    NSString *notificationBackgroundColor = [[NSUserDefaults standardUserDefaults]objectForKey:@"notificationBgColor"];
    if(notificationBackgroundColor.length == 0) {
        notificationBackgroundColor = @"#F55567";
    }
    const char *cStr = [notificationBackgroundColor cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    return [UIColor colorWithHex:x];
    
}

+(UIColor *)notificationTextColor {
    
    NSString *notificationTextColor = [[NSUserDefaults standardUserDefaults]objectForKey:@"notificationFgColor"];
    if(notificationTextColor.length == 0) {
        notificationTextColor = @"#FFFFFF";
    }
    const char *cStr = [notificationTextColor cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    return [UIColor colorWithHex:x];
    
}

+(UIColor *)buttonBackgroundColor {
    
    NSString *buttonBackgroundColor = [[NSUserDefaults standardUserDefaults]objectForKey:@"buttonBgColor"];
    if(buttonBackgroundColor.length == 0) {
        buttonBackgroundColor = @"#3487FA";
    }
    const char *cStr = [buttonBackgroundColor cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    return [UIColor colorWithHex:x];
    
}

+(UIColor *)buttonTextColor {
    
    NSString *buttonTextColor = [[NSUserDefaults standardUserDefaults]objectForKey:@"buttonFgColor"];
    if(buttonTextColor.length == 0) {
        buttonTextColor = @"#FFFFFF";
    }
    const char *cStr = [buttonTextColor cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    return [UIColor colorWithHex:x];
    
}

+ (UIColor *)colorWithHex:(UInt32)col {
    unsigned char r, g, b;
    b = col & 0xFF;
    g = (col >> 8) & 0xFF;
    r = (col >> 16) & 0xFF;
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1];
}

@end
