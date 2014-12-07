//
//  FilenameDB.h
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/12/07.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilenameDB : NSObject

@property (nonatomic, strong) NSMutableArray *arrColumnNames;
@property (nonatomic) int affectedRows;
@property (nonatomic) long long lastInsertedRowID;

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;
-(NSArray *)loadDataFromDB:(NSString *)query;
-(void)executeQuery:(NSString *)query;

@end
