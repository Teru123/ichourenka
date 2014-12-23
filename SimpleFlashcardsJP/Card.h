//
//  Card.h
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/12/22.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *number;

+ (instancetype)cardWithCN:(NSString *)type name:(NSString *)name;
- (NSArray *)allCards;

@end
