//
//  Options.h
//  SimpleFlashcardsJP
//
//  Created by Teru on 2015/01/19.
//  Copyright (c) 2015年 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Options : NSObject

@property (nonatomic, strong) NSMutableArray *arrColumnNames;
@property (nonatomic) int affectedRows;
@property (nonatomic) long long lastInsertedRowID;

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;
-(NSArray *)loadDataFromDB:(NSString *)query;
-(void)executeQuery:(NSString *)query;
-(void)alterDB;

@end
