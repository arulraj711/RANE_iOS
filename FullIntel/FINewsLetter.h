//
//  FINewsLetter.h
//  FullIntel
//
//  Created by Prabhu on 30/06/1937 SAKA.
//  Copyright (c) 1937 SAKA CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FINewsLetter : NSObject
@property (nonatomic,strong) NSString *createdDate;
@property (nonatomic,strong) NSString *modifiedDate;
@property (nonatomic,strong) NSNumber *newsLetterId;
@property (nonatomic,strong) NSString *newsLetterSubject;
@property (nonatomic,strong) NSMutableArray *newsLetterArticles;

-(void)setNewsLetterFromDictionary:(NSDictionary *)dic;
@end
