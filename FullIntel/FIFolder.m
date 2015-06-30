//
//  FIFolder.m
//  FullIntel
//
//  Created by Capestart on 6/30/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import "FIFolder.h"

@implementation FIFolder

-(void)createFolderFromDic:(NSDictionary *)dictionary {
    self.folderId = [dictionary objectForKey:@"id"];
    self.folderName = [dictionary objectForKey:@"folderName"];
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
    [coder encodeObject:self.folderName forKey:@"folderName"];
    [coder encodeObject:self.folderArticlesIDArray forKey:@"folderArticles"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.folderId = [coder decodeObjectForKey:@"id"];
        self.folderName = [coder decodeObjectForKey:@"folderName"];
        self.folderArticlesIDArray = [coder decodeObjectForKey:@"folderArticles"];
    }
    return self;
}

@end
