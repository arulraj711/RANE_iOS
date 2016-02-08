//
//  SearchWebView.h
//  TheSearcher
//
//  Created by Scott Kohlert on 11-10-08.
//  Copyright (c) 2011 The Creation Station. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SearchWebView : UIWebView

- (NSInteger)highlightAllOccurencesOfString:(NSString*)str;
- (void)removeAllHighlights;

@end
