//
//  FIFolder.m
//  FullIntel
//
//  Created by Capestart on 6/30/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "FIFolder.h"
#import "FIUtils.h"

@implementation FIFolder

-(void)createFolderFromDic:(NSDictionary *)dictionary {
    self.folderId = [dictionary objectForKey:@"id"];
    self.folderName = [dictionary objectForKey:@"folderName"];
    self.defaultFlag = [dictionary objectForKey:@"default"];
    self.rssFeedUrl = [dictionary objectForKey:@"rssFeedUrl"];
    if(self.rssFeedUrl.length != 0) {
        [[NSUserDefaults standardUserDefaults]setObject:self.rssFeedUrl forKey:@"RSSURL"];
    }
    NSString *createdDateString = [FIUtils getDateFromTimeStamp:[[dictionary objectForKey:@"createdAt"] doubleValue]];
    //NSLog(@"created date:%@",createdDateString);
    self.createdDate = createdDateString;
    //NSMutableArray *array = [[NSMutableArray alloc]init];
    NSArray *menuArray = [dictionary objectForKey:@"folderArticles"];
    self.folderArticlesIDArray = [[NSMutableArray alloc]init];
    for(NSDictionary *dict in menuArray) {
       // FIMenu *insideMenu = [self recursiveMenu:dict];
        [self.folderArticlesIDArray addObject:[dict objectForKey:@"articleId"]];
    }
   // menu.listArray = array;
}


- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.folderId forKey:@"id"];
    [coder encodeObject:self.defaultFlag forKey:@"default"];
    [coder encodeObject:self.folderName forKey:@"folderName"];
    [coder encodeObject:self.rssFeedUrl forKey:@"rssFeedUrl"];
    [coder encodeObject:self.folderArticlesIDArray forKey:@"folderArticles"];
    [coder encodeObject:self.createdDate forKey:@"createdAt"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.folderId = [coder decodeObjectForKey:@"id"];
        self.defaultFlag = [coder decodeObjectForKey:@"default"];
        self.folderName = [coder decodeObjectForKey:@"folderName"];
        self.rssFeedUrl = [coder decodeObjectForKey:@"rssFeedUrl"];
        self.folderArticlesIDArray = [coder decodeObjectForKey:@"folderArticles"];
        self.createdDate = [coder decodeObjectForKey:@"createdAt"];
    }
    return self;
}

@end
