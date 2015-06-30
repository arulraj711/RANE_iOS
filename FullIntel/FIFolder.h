//
//  FIFolder.h
//  FullIntel
//
//  Created by Capestart on 6/30/15.
//  Copyright (c) 2015 CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FIFolder : NSObject
@property (nonatomic,strong) NSNumber *folderId;
@property (nonatomic,strong) NSString *folderName;
@property (nonatomic,strong) NSMutableArray *folderArticlesIDArray;
-(void)createFolderFromDic:(NSDictionary *)dictionary;
@end
