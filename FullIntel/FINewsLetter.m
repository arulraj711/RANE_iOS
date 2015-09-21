//
//  FINewsLetter.m
//  FullIntel
//
//  Created by Prabhu on 30/06/1937 SAKA.
//  Copyright (c) 1937 SAKA CapeStart. All rights reserved.
//

#import "FINewsLetter.h"
#import "FIUtils.h"
@implementation FINewsLetter
-(void)setNewsLetterFromDictionary:(NSDictionary *)dic {
    NSString *createdDateString = [FIUtils getDateFromTimeStamp:[[dic objectForKey:@"createdAt"] doubleValue]];
    self.createdDate = createdDateString;
    self.modifiedDate = [dic objectForKey:@"modifiedAt"];
    self.newsLetterId = [dic objectForKey:@"id"];
    self.newsLetterSubject = [dic objectForKey:@"newsLetterSubject"];
    NSArray *newsIdArray = [dic objectForKey:@"newsletterArticles"];
    self.newsLetterArticles = [[NSMutableArray alloc]init];
    for(NSString *newsLetterId in newsIdArray) {
        // FIMenu *insideMenu = [self recursiveMenu:dict];
        [self.newsLetterArticles addObject:newsLetterId];
    }
}
@end
