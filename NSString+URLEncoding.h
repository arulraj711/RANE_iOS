//
//  NSString+URLEncoding.h
//  FullIntel
//
//  Created by CapeStart Apple on 5/18/16.
//  Copyright © 2016 CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncoding)
- (nullable NSString *)stringByAddingPercentEncodingForRFC3986;
@end
