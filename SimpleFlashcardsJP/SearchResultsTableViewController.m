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

@interface SearchResultsTableViewController () <UISearchResultsUpdating, UISearchBarDelegate>

@property (nonatomic, strong) NSArray *cards;
@property (nonatomic, strong) NSArray *cardTextSearch;
@property (nonatomic, strong) NSArray *cardNumberSearch;
@property (nonatomic, strong) NSArray *cardTextInfo;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) CardText *dbCardText;
@property (nonatomic, strong) CardNumber *dbCardNumber;
@property (nonatomic, strong) NSArray *cardTextInfo_1;
@property (nonatomic, strong) NSArray *CNInfo;
@property (nonatomic, strong) NSArray *CTInfo;
@property (nonatomic, strong) NSArray *CTInfo_1;
@property (nonatomic, strong) NSMutableArray *stringArr;
@property (nonatomic, strong) NSMutableArray *stringArr_1;
@property (nonatomic, strong) NSArray *arrCNInfo;
@property (nonatomic, strong) NSArray *cardNumberInfo;
@property (nonatomic, strong) NSMutableArray *cardNumber;

@end

@implementation SearchResultsTableViewController

-(void)viewWillAppear:(BOOL)animated{
    // ハイライト解除
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear called");
    
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
    vc.recordIDToEdit = self.recordIDToEdit;
    vc.newCard = self.newCard;
    vc.editCardDelegate = self;
    [self.presentingViewController.navigationController pushViewController:vc animated:YES];
}

-(void)cardEditingInfoWasFinished{
    // Reload the data.
    [self loadData];
    
    [self updateSearchResultsForSearchController:self.searchController];
    [self.tableView numberOfRowsInSection:self.searchResults.count];
    NSLog(@"count %ld", self.searchResults.count);
    [self.tableView reloadData];
    NSLog(@"cardEditingInfoWasFinished_2 called");
}

-(void)loadData{
    // Form the query.
    NSString *query = @"select * from cardNumberInfo";
    
    // Get the results.
    if (self.arrCNInfo != nil) {
        self.arrCNInfo = nil;
    }
    self.arrCNInfo = [[NSArray alloc] initWithArray:[self.dbCardNumber loadDataFromDB:query]];
    
    //NSLog(@"%ld", self.arrCNInfo.count);
    
    if (self.newCard == -1) {
        self.newCard = 1;
    }
    
    // Edit後に各種データを検索等に使用する為、更新する。
    
    // Initialize the dbManager property.
    self.dbCardNumber = [[CardNumber alloc] initWithDatabaseFilename:@"CardNumber.sql"];
    self.dbCardText = [[CardText alloc] initWithDatabaseFilename:@"CardText.sql"];
    
    // Load the first Data
    NSString *queryText = [NSString stringWithFormat:@"select cardText from cardTextInfo"];
    self.cardTextSearch = [[NSArray alloc] initWithArray:[self.dbCardText loadDataFromDB:queryText]];
    NSString *queryNumber = [NSString stringWithFormat:@"select cardNumber from cardTextInfo"];
    self.cardNumberSearch = [[NSArray alloc] initWithArray:[self.dbCardText loadDataFromDB:queryNumber]];
    
    //cardText, cardNumberを配列にinsert。resultsに使用。
    self.cardText = [[NSMutableArray alloc] init];
    self.cardText = [NSMutableArray array];
    self.cardNumber = [[NSMutableArray alloc] init];
    self.cardNumber = [NSMutableArray array];
    for (int i = 0; i < self.cardNumberSearch.count; i++) {
        [self.cardText insertObject:[self.cardTextSearch objectAtIndex:i] atIndex:i];
        [self.cardNumber insertObject:[self.cardNumberSearch objectAtIndex:i] atIndex:i];
    }
    
    // Create a mutable array to contain products for the search results table.
    self.searchResults = [NSMutableArray arrayWithCapacity:[self.cardText count]];
    
    // Load the first Data
    NSString *queryZero = [NSString stringWithFormat:@"select cardText from cardTextInfo where textNumber = %d", 0];
    self.cardTextInfo = [[NSArray alloc] initWithArray:[self.dbCardText loadDataFromDB:queryZero]];
    NSInteger indexOfcardText = [self.dbCardText.arrColumnNames indexOfObject:@"cardText"];
    //stringArrを初期化。
    self.stringArr = [[NSMutableArray alloc] init];
    self.stringArr = [NSMutableArray array];
    for (int i = 0 ; i < self.cardTextInfo.count; i++) {
        NSString *checkStr = [NSString stringWithFormat:@"%@", [[self.cardTextInfo objectAtIndex:i] objectAtIndex:indexOfcardText]];
        if ([checkStr isEqualToString:@""]) {
            checkStr = @"(blank)";
        }
        [self.stringArr insertObject:checkStr atIndex:i];
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
        NSString *checkStr_1 = [NSString stringWithFormat:@"%@", [[self.cardTextInfo_1 objectAtIndex:i] objectAtIndex:indexOfcardText_1]];
        if ([checkStr_1 isEqualToString:@""]) {
            checkStr_1 = @"(blank)";
        }
        [self.stringArr_1 insertObject:checkStr_1 atIndex:i];
    }
    
    //NSLog(@"Load The Data");
    
    // Reload the table view.
    [self.tableView reloadData];
}

//searchResultsをSearchResultsTableViewControllerに渡す。
#pragma mark - UISearchResultsUpdating
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = [self.searchController.searchBar text];
    NSString *scope = nil;
    
    [self updateFilteredContentForProductName:searchString type:scope];
    
    if (self.searchController.searchResultsController) {
        
        if (![searchString isEqualToString:@""] && self.searchResults.count != 0) {
            
            // NSMutableArrayを初期化。
            self.searchResultsString = [[NSMutableArray alloc] init];
            self.searchResultsString = [NSMutableArray array];
            self.searchResultsString_1 = [[NSMutableArray alloc] init];
            self.searchResultsString_1 = [NSMutableArray array];
            self.searchResultsNumber = [[NSMutableArray alloc] init];
            self.searchResultsNumber = [NSMutableArray array];
            
            for (int i = 0; i < self.searchResults.count; i++) {
                // searchResultsのデータを渡す為に不要なStringを削除する。
                NSString *checkTheString = [NSString stringWithFormat:@"%@", [self.searchResults objectAtIndex:i]];
                checkTheString = [checkTheString stringByReplacingOccurrencesOfString:@"(" withString:@""];
                checkTheString = [checkTheString stringByReplacingOccurrencesOfString:@")" withString:@""];
                checkTheString = [checkTheString stringByReplacingOccurrencesOfString:@" " withString:@""];
                checkTheString = [checkTheString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                //NSLog(@"%@", checkTheString);
                
                // searchResultsのカード番号を取得。
                NSString *queryBlank = [NSString stringWithFormat:@"select cardNumber from cardTextInfo where cardText = '%@' ", checkTheString];
                self.CNInfo = [[NSArray alloc] initWithArray:[self.dbCardText loadDataFromDB:queryBlank]];
                NSString *checkNumber = [NSString stringWithFormat:@"%@", [self.CNInfo objectAtIndex:0]];
                
                // searchResultsのカード番号を渡す為に不要なStringを削除する。
                checkNumber = [checkNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
                checkNumber = [checkNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
                checkNumber = [checkNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
                checkNumber = [checkNumber stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                NSInteger indexOfcardText = [checkNumber integerValue];
                NSLog(@"%ld", indexOfcardText);
                NSString *indexOfcardString = [NSString stringWithFormat:@"%ld", indexOfcardText];
                
                //cardNumberをarrayに渡す。
                [self.searchResultsNumber addObject:indexOfcardString];
                
                // searchResultsのカード番号とtextNumber0の値を取得。
                NSString *queryZero = [NSString stringWithFormat:@"select cardText from cardTextInfo where cardNumber = %ld AND textNumber = %d", indexOfcardText, 0];
                self.CTInfo = [[NSArray alloc] initWithArray:[self.dbCardText loadDataFromDB:queryZero]];
                // 直接arrayにaddObjectするとstringByReplacingOccurrencesOfStringが実行されないので、一旦NSStringに値を渡す。
                NSString *checkTheStr = [NSString stringWithFormat:@"%@", [self.CTInfo objectAtIndex:0]];
                
                // searchResultsのStringを渡す為に不要なStringを削除する。
                checkTheStr = [checkTheStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
                checkTheStr = [checkTheStr stringByReplacingOccurrencesOfString:@")" withString:@""];
                checkTheStr = [checkTheStr stringByReplacingOccurrencesOfString:@" " withString:@""];
                checkTheStr = [checkTheStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                
                // Checking if a string is equal to "
                if ([checkTheStr isEqualToString:@"\"\""]) {
                    checkTheStr = @"(blank)";
                }
                
                //cell.textに表示する文字列をarrayに渡す。
                [self.searchResultsString addObject:checkTheStr];
                
                // searchResultsのカード番号とtextNumber1の値を取得。
                NSString *queryOne = [NSString stringWithFormat:@"select cardText from cardTextInfo where cardNumber = %ld AND textNumber = %d", indexOfcardText, 1];
                self.CTInfo_1 = [[NSArray alloc] initWithArray:[self.dbCardText loadDataFromDB:queryOne]];
                // 直接arrayにaddObjectするとstringByReplacingOccurrencesOfStringが実行されないので、一旦NSStringに値を渡す。
                NSString *checkTheStrOne = [NSString stringWithFormat:@"%@", [self.CTInfo_1 objectAtIndex:0]];
                
                // searchResultsのStringを渡す為に不要なStringを削除する。
                checkTheStrOne = [checkTheStrOne stringByReplacingOccurrencesOfString:@"(" withString:@""];
                checkTheStrOne = [checkTheStrOne stringByReplacingOccurrencesOfString:@")" withString:@""];
                checkTheStrOne = [checkTheStrOne stringByReplacingOccurrencesOfString:@" " withString:@""];
                checkTheStrOne = [checkTheStrOne stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                
                // Checking if a string is equal to "
                if ([checkTheStrOne isEqualToString:@"\"\""]) {
                    checkTheStrOne = @"(blank)";
                }
                
                //cell.textに表示する文字列をarrayに渡す。
                [self.searchResultsString_1 addObject:checkTheStrOne];
                
                NSLog(@"%@", [self.searchResultsNumber objectAtIndex:i]);
            }
        }
    }
}

// Workaround for bug: -updateSearchResultsForSearchController: is not called when scope buttons change
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self.searchController];
}

#pragma mark - Content Filtering

- (void)updateFilteredContentForProductName:(NSString *)name type:(NSString *)typeName{
    
    NSString *confirmNumberWithZero;
    // Update the filtered array based on the search text and scope.
    if ([name length] == 0) {
        // If there is no search string and the scope is "All".
        if (typeName == nil) {
            self.searchResults = [self.cardText mutableCopy];
        } else {
            // If there is no search string and the scope is chosen.
            NSMutableArray *searchResults = [[NSMutableArray alloc] init];
            for (int i = 0; i < self.cardText.count; i++) {
                NSString *checkString = [NSString stringWithFormat:@"%@", [self.cardText objectAtIndex:i]];
                NSString *checkNumber = [NSString stringWithFormat:@"%@", [self.cardNumber objectAtIndex:i]];
                if ([checkString isEqualToString:typeName]) {
                    if (![confirmNumberWithZero isEqualToString:checkNumber] || confirmNumberWithZero == nil) {
                        [searchResults addObject:checkString];
                        confirmNumberWithZero = checkNumber;
                    }
                }
            }
            self.searchResults = searchResults;
        }
        return;
    }
    
    
    [self.searchResults removeAllObjects]; // First clear the filtered array.
    
    // NSCharacterSet, stringByTrimmingCharactersInSetでスペースだけでないかチェック。
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    
    //Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
    NSString *confirmNumber;
    for (int i = 0; i < self.cardText.count; i++) {
        NSString *checkString = [NSString stringWithFormat:@"%@", [self.cardText objectAtIndex:i]];
        NSString *checkNumber = [NSString stringWithFormat:@"%@", [self.cardNumber objectAtIndex:i]];
        //NSLog(@"%@", checkNumber);
        if ((typeName == nil) || [checkString isEqualToString:typeName]) {
            if (![[[self.searchController.searchBar text] stringByTrimmingCharactersInSet: set] length] == 0) {
                NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
                NSRange productNameRange = NSMakeRange(0, checkString.length);
                NSRange foundRange = [checkString rangeOfString:name options:searchOptions range:productNameRange];
                if (foundRange.length > 0) {
                    if (![confirmNumber isEqualToString:checkNumber] || confirmNumber == nil) {
                        [self.searchResults addObject:checkString];
                        confirmNumber = checkNumber;
                        //NSLog(@"%@", confirmNumber);
                    }
                }
            }
        }
    }
}

@end
