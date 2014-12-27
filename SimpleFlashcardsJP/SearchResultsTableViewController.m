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
    
    if (self.newSearch == 1) {
        // Configure the cell...
        cell.textLabel_1.text = [NSString stringWithFormat:@"%@", [self.searchResultsString objectAtIndex:indexPath.row]];
        cell.textLabel_2.text = [NSString stringWithFormat:@"%@", [self.searchResultsString_1 objectAtIndex:indexPath.row]];
    
    }
    
    return cell;
}

//didSelectにすると値が渡せない。値を渡す時はwillSelectとする。戻り値はindexPath。
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //indexPath.row番目のCardNumberを取得。
    self.recordIDToEdit = [[self.searchResultsNumber objectAtIndex:indexPath.row] intValue];
    NSLog(@"recordIDToEdit %d", self.recordIDToEdit);
    
    return indexPath;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EditCardTableViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"EditCardTableViewController"];
    vc.filenameData = self.filenameData;
    vc.recordIDToEdit = self.recordIDToEdit;
    vc.newCard = self.newCard;
    [self.presentingViewController.navigationController pushViewController:vc animated:YES];
}

@end
