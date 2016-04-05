//
//  NumberFormatterExtn.m
//  FullIntel
//
//  Created by cape start on 01/03/16.
//  Copyright © 2016 CapeStart. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NumberFormatterExtn : NSNumberFormatter
{
}
@end


@implementation NumberFormatterExtn


- (NSString *) stringFromNumber:(NSNumber *)number
{
    NSString *abbrevNum;
    float inumber = [number floatValue];
    
    //Prevent numbers smaller than 1000 to return NULL
    if (inumber >= 1000) {
        NSArray *abbrev = @[@"K", @"M", @"B"];
        
        for (int i = abbrev.count - 1; i >= 0; i--) {
            
            // Convert array index to "1000", "1000000", etc
            int size = pow(10,(i+1)*3);
            
            if(size <= inumber) {
                // Removed the round and dec to make sure small numbers are included like: 1.1K instead of 1K
                inumber = inumber/size;
                NSString *numberString = [self floatToString:inumber];
                
                // Add the letter for the abbreviation
                abbrevNum = [NSString stringWithFormat:@"%@%@", numberString, [abbrev objectAtIndex:i]];
            }
            
        }
    } else {
        
        // Numbers like: 999 returns 999 instead of NULL
        abbrevNum = [NSString stringWithFormat:@"%d", (int)inumber];
    }
    
    return abbrevNum;
}

- (NSString *) floatToString:(float) val {
    NSString *ret = [NSString stringWithFormat:@"%.1f", val];
    unichar c = [ret characterAtIndex:[ret length] - 1];
    
    while (c == 48) { // 0
        ret = [ret substringToIndex:[ret length] - 1];
        c = [ret characterAtIndex:[ret length] - 1];
        
        //After finding the "." we know that everything left is the decimal number, so get a substring excluding the "."
        if(c == 46) { // .
            ret = [ret substringToIndex:[ret length] - 1];
        }
    }
    
    return ret;
}
@end