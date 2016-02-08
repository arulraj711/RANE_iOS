//
//  SearchWebView.m
//  TheSearcher
//
//  Created by Scott Kohlert on 11-10-08.
//  Copyright (c) 2011 The Creation Station. All rights reserved.
//

#import "SearchWebView.h"

@implementation SearchWebView

- (NSInteger)highlightAllOccurencesOfString:(NSString*)str
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"UIWebViewSearch" ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self stringByEvaluatingJavaScriptFromString:jsCode];
    
    NSString *startSearch = [NSString stringWithFormat:@"uiWebview_HighlightAllOccurencesOfString('%@')",str];
    [self stringByEvaluatingJavaScriptFromString:startSearch];
    
    NSString *result = [self stringByEvaluatingJavaScriptFromString:@"uiWebview_SearchResultCount"];
    return [result integerValue];
}

- (void)removeAllHighlights
{
    [self stringByEvaluatingJavaScriptFromString:@"uiWebview_RemoveAllHighlights()"];
}

@end
