//
//  SearchResultsTableViewController.m
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/12/23.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import "SearchResultsTableViewController.h"
#import "CardListTableViewController.h"
#import "CardListTableViewCell.h"
#import "EditCardTableViewController.h"
#import "CardNumber.h" 
#import "CardText.h"

@interface SearchResultsTableViewController ()

@property (nonatomic, strong) NSArray *cards;
@property (nonatomic, strong) NSArray *cardTextSearch;
@property (nonatomic, strong) NSArray *cardNumberSearch;
@property (nonatomic, strong) NSArray *cardTextInfo;
@property (nonatomic, strong) CardText *dbCardText;
@property (nonatomic, strong) CardNumber *dbCardNumber;

@end

@implementation SearchResultsTableViewController

-(void)viewWillAppear:(BOOL)animated{
    if (self.newSearch == 1) {
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchResults count];
}

// numberOfRowsで指定したRowの数だけ処理を繰り返す。
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ListCell";
    
    CardListTableViewCell *cell = (CardListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CardListTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    
   /*
    // Load the first Data
    NSString *queryZero = [NSString stringWithFormat:@"select cardText from cardTextInfo where textNumber = %d", 0];
    self.cardTextInfo = [[NSArray alloc] initWithArray:[self.dbCardText loadDataFromDB:queryZero]];
    NSInteger indexOfcardText = [self.dbCardText.arrColumnNames indexOfObject:@"cardText"];
    //stringArrを初期化。
    self.stringArr = [[NSMutableArray alloc] init];
    self.stringArr = [NSMutableArray array];
    for (int i = 0 ; i < self.cardTextInfo.count; i++) {
        self.checkStr = [NSString stringWithFormat:@"%@", [[self.cardTextInfo objectAtIndex:i] objectAtIndex:indexOfcardText]];
        if ([self.checkStr isEqualToString:@""]) {
            self.checkStr = @"(blank)";
        }
        [self.stringArr insertObject:self.checkStr atIndex:i];
        //NSLog(@"%@", self.checkStr);
    }
    //NSLog(@"%ld", self.stringArr.count);
    
    // Load the second Data
    NSString *queryOne = [NSString stringWithFormat:@"select cardText from cardTextInfo where textNumber = %d", 1];
    self.cardTextInfo_1 = [[NSArray alloc] initWithArray:[self.dbCardText loadDataFromDB:queryOne]];
    NSInteger indexOfcardText_1 = [self.dbCardText.arrColumnNames indexOfObject:@"cardText"];
    //stringArrを初期化。
    self.stringArr_1 = [[NSMutableArray alloc] init];
    self.stringArr_1 = [NSMutableArray array];
    for (int i = 0 ; i < self.cardTextInfo_1.count; i++) {
        self.checkStr_1 = [NSString stringWithFormat:@"%@", [[self.cardTextInfo_1 objectAtIndex:i] objectAtIndex:indexOfcardText_1]];
        if ([self.checkStr_1 isEqualToString:@""]) {
            self.checkStr_1 = @"(blank)";
        }
        [self.stringArr_1 insertObject:self.checkStr_1 atIndex:i];
        //NSLog(@"%@", self.checkStr_1);
    }*/
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EditCardTableViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"EditCardTableViewController"];
    [self.presentingViewController.navigationController pushViewController:vc animated:YES];
}

@end
