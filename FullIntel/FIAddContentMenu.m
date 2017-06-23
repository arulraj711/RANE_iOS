//
//  FIAddContentMenu.m
//  RANE
//
//  Created by Arul on 23/06/17.
//  Copyright © 2017 CapeStart. All rights reserved.
//

#import "FIAddContentMenu.h"
#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })
@implementation FIAddContentMenu


+(FIAddContentMenu *)recursiveAddContentMenu:(NSDictionary *)dic {
    //NSLog(@"dic in model name:%@ and count:%@",[dic objectForKey:@"name"],[dic objectForKey:@"unReadCount"]);
    FIAddContentMenu *menu = [[FIAddContentMenu alloc]init];
    menu.name = NULL_TO_NIL([dic objectForKey:@"name"]);
    menu.nodeId = NULL_TO_NIL([dic objectForKey:@"id"]);
    menu.isSubscribed = [[dic objectForKey:@"isSubscribed"] boolValue];
    menu.companyId = NULL_TO_NIL([dic objectForKey:@"companyId"]);
    menu.contentTypeForCustomerId =  NULL_TO_NIL([dic objectForKey:@"contentTypeForCustomerId"]);
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSArray *menuArray = [dic objectForKey:@"subList"];
    for(NSDictionary *dict in menuArray) {
        FIAddContentMenu *insideMenu = [self recursiveAddContentMenu:dict];
        [array addObject:insideMenu];
    }
    menu.subList = array;
    
    return menu;
}

@end
