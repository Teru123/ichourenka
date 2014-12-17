//
//  TempCardText.h
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/12/17.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TempCardText : NSObject

@property (nonatomic, strong) NSMutableArray *arrColumnNames;
@property (nonatomic) int affectedRows;
@property (nonatomic) long long lastInsertedRowID;

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;
-(NSArray *)loadDataFromDB:(NSString *)query;
-(void)executeQuery:(NSString *)query;

@end
