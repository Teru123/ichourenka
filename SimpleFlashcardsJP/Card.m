//
//  Card.m
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/12/22.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import "Card.h"
#import "CardNumber.h"
#import "CardText.h"

@interface Card ()

@property (nonatomic, strong) CardText *dbCardText;
//@property (nonatomic, strong) CardNumber *dbCardNumber;
@property (nonatomic, strong) NSArray *cardNumberInfo;
@property (nonatomic, strong) NSArray *cardTextInfo;
@property (nonatomic, strong) NSArray *cardInfo;

@end

@implementation Card

- (NSArray *)allCards{
    // Initialize the dbManager property.
    //self.dbCardNumber = [[CardNumber alloc] initWithDatabaseFilename:@"CardNumber.sql"];
    self.dbCardText = [[CardText alloc] initWithDatabaseFilename:@"CardText.sql"];
    
    // Load the first Data
    NSString *queryText = [NSString stringWithFormat:@"select cardText from cardTextInfo"];
    self.cardTextInfo = [[NSArray alloc] initWithArray:[self.dbCardText loadDataFromDB:queryText]];
    NSString *queryNumber = [NSString stringWithFormat:@"select cardNumber from cardTextInfo"];
    self.cardNumberInfo = [[NSArray alloc] initWithArray:[self.dbCardText loadDataFromDB:queryNumber]];
    
    for (int i = 0; i < self.cardNumberInfo.count; i++) {
        self.cardInfo = @[[Card cardWithCN:[self.cardNumberInfo objectAtIndex:i] name:[self.cardTextInfo objectAtIndex:i]]];
    }
    return self.cardInfo;
}

+ (instancetype)cardWithCN:(NSString *)number name:(NSString *)name{
    Card *newCard = [[self alloc] init];
    newCard.number = number;
    newCard.name = name;
    return newCard;
}

@end
