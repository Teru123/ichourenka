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
#import "CardList6TableViewCell.h"
#import "CardList6PlusTableViewCell.h"
#import "EditCardTableViewController.h"
#import "CardNumber.h" 
#import "CardText.h"

@interface SearchResultsTableViewController ()

@property (nonatomic, strong) NSArray *cards;
@property (nonatomic, strong) NSArray *cardTextSearch;
@property (nonatomic, strong) NSArray *cardNumberSearch;
@property (nonatomic, strong) NSArray *cardTextInfo;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) CardText *dbCardText;
@property (nonatomic, strong) CardNumber *dbCardNumber;

@end

@implementation SearchResultsTableViewController

-(void)viewWillAppear:(BOOL)animated{
    // ハイライト解除
    [super viewWillAppear:animated];
    //NSLog(@"viewWillAppear called");
    
    self.tableView.rowHeight = 44;
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"%ld", self.searchResults.count);
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
    
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    
    if (iOSDeviceScreenSize.height == 667) {
        static NSString *cellIdentifier = @"ListCell6";
        CardList6TableViewCell *cell = (CardList6TableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CardList6TableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        if (self.newSearch == 1) {
            // Configure the cell...
            cell.textLabelSiz6_1.text = [NSString stringWithFormat:@"%@", [self.searchResultsString objectAtIndex:indexPath.row]];
            cell.textLabelSiz6_2.text = [NSString stringWithFormat:@"%@", [self.searchResultsString_1 objectAtIndex:indexPath.row]];
        }
        return cell;
        
    }else if (iOSDeviceScreenSize.height == 736) {
        static NSString *cellIdentifier = @"ListCell6Plus";
        CardList6PlusTableViewCell *cell = (CardList6PlusTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CardList6PlusTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        if (self.newSearch == 1) {
            // Configure the cell...
            cell.textLabelSize6Plus_1.text = [NSString stringWithFormat:@"%@", [self.searchResultsString objectAtIndex:indexPath.row]];
            cell.textLabelSize6Plus_2.text = [NSString stringWithFormat:@"%@", [self.searchResultsString_1 objectAtIndex:indexPath.row]];
        }
        return cell;
    }
    
    return cell;
}

//didSelectにすると値が渡せない。値を渡す時はwillSelectとする。戻り値はindexPath。
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //indexPath.row番目のCardNumberを取得。
    self.recordIDToEdit = [[self.searchResultsNumber objectAtIndex:indexPath.row] intValue];
    //NSLog(@"recordIDToEdit %d", self.recordIDToEdit);
    
    return indexPath;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EditCardTableViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"EditCardTableViewController"];
    vc.filenameData = self.filenameData;
    vc.fileID = self.fileID;
    vc.folderID = self.folderID;
    vc.recordIDToEdit = self.recordIDToEdit;
    vc.newCard = self.newCard;
    vc.editCardDelegate = self;
    [self.presentingViewController.navigationController pushViewController:vc animated:YES];
}

-(void)cardEditingInfoWasFinished{
    // CardListに編集したことを知らせる。
    [self.searchCardDelegate searchEditingInfoWasFinished];

    //NSLog(@"count %ld", self.searchResults.count);
    [self.tableView reloadData];
    //NSLog(@"cardEditingInfoWasFinished_2 called");
}

-(void)madeTheCard{
    //他のdelegate先で使用しているメソッド。
}

@end
