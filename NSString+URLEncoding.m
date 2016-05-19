//
//  NSString+URLEncoding.m
//  FullIntel
//
//  Created by CapeStart Apple on 5/18/16.
//  Copyright © 2016 CapeStart. All rights reserved.
//

#import "NSString+URLEncoding.h"

@implementation NSString (URLEncoding)

- (nullable NSString *)stringByAddingPercentEncodingForRFC3986 {
    NSString *unreserved = @"-._~/?";
    NSMutableCharacterSet *allowed = [NSMutableCharacterSet
                                      alphanumericCharacterSet];
    [allowed addCharactersInString:unreserved];
    return [self
            stringByAddingPercentEncodingWithAllowedCharacters:
            allowed];
}

@end
