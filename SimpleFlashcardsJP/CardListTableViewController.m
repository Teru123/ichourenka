//
//  CardListTableViewController.m
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/12/13.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import "CardListTableViewController.h"
#import "EditCardTableViewController.h"
#import "CardListTableViewCell.h"
#import "SearchResultsTableViewController.h"
#import "MultibyteDescription.h"
#import "CardNumber.h"
#import "CardText.h"

@interface CardListTableViewController () <UISearchResultsUpdating, UISearchBarDelegate>

@property (nonatomic, strong) NSArray *actionButtonItems;
@property (nonatomic, assign) BOOL editIsTapped;
@property (nonatomic, strong) CardNumber *dbCardNumber;
@property (nonatomic, strong) NSArray *arrCNInfo;
@property (nonatomic, strong) NSArray *cardNumberInfo;
@property (nonatomic, assign) int recordIDToEdit;
@property (nonatomic, strong) CardText *dbCardText;
@property (nonatomic, assign) int newCard;
@property (nonatomic, assign) int flag;
@property (nonatomic, strong) NSArray *cardTextInfo;
@property (nonatomic, strong) NSArray *cardTextInfo_1;
@property (nonatomic, strong) NSArray *CNInfo;
@property (nonatomic, strong) NSArray *CTInfo;
@property (nonatomic, strong) NSArray *CTInfo_1;
@property (nonatomic, strong) NSMutableArray *stringArr;
@property (nonatomic, strong) NSMutableArray *stringArr_1;
@property (nonatomic, strong) NSArray *cards;
@property (nonatomic, strong) NSArray *cardTextSearch;
@property (nonatomic, strong) NSArray *cardNumberSearch;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;// Filtered search results
@property (nonatomic, strong) NSMutableArray *searchResultsString;
@property (nonatomic, strong) NSMutableArray *searchResultsString_1;
@property (nonatomic, strong) NSMutableArray *searchResultsNumber;
@property (nonatomic, assign) NSInteger indexOfcardText;
@property (nonatomic, strong) NSMutableArray *confirmNumber;

-(void)loadData;

@end

@implementation CardListTableViewController

-(void)viewWillAppear:(BOOL)animated{
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
    
    self.tableView.rowHeight = 44;
    
    [MultibyteDescription install];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    //@selector()で指定メソッドをコール
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFolder:)];
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editingButtonPressed:)];
    
    self.actionButtonItems = @[editItem, addItem];
    self.navigationItem.rightBarButtonItems = self.actionButtonItems;
    self.editIsTapped = NO;
    
    // Initialize the dbManager property.
    self.dbCardNumber = [[CardNumber alloc] initWithDatabaseFilename:@"CardNumber.sql"];
    self.dbCardText = [[CardText alloc] initWithDatabaseFilename:@"CardText.sql"];
    
    // Load the first Data
    NSString *queryText = [NSString stringWithFormat:@"select cardText from cardTextInfo"];
    self.cardTextSearch = [[NSArray alloc] initWithArray:[self.dbCardText loadDataFromDB:queryText]];
    NSString *queryNumber = [NSString stringWithFormat:@"select cardNumber from cardTextInfo"];
    self.cardNumberSearch = [[NSArray alloc] initWithArray:[self.dbCardText loadDataFromDB:queryNumber]];
    
    //cardText, cardNumberを初期化、配列にinsert。resultsに使用。
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
    
    // The table view controller is in a nav controller, and so the containing nav controller is the 'search results controller'
    UINavigationController *searchResultsController = [[self storyboard] instantiateViewControllerWithIdentifier:@"TableSearchResultsNavController"];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.searchController.searchBar.delegate = self;
    self.definesPresentationContext = YES;
    
    // Need to set dimsBackgroundDuringPresentation to NO since the search results are presented on the same table view controller.
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    NSLog(@"searchResults %ld", self.cardText.count);
    
    // Load the data.
    [self loadData];
}

//searchResultsをSearchResultsTableViewControllerに渡す。
#pragma mark - UISearchResultsUpdating
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = [self.searchController.searchBar text];
    NSString *scope = nil;
    
    [self updateFilteredContentForProductName:searchString type:scope];
    
    if (self.searchController.searchResultsController) {
        UINavigationController *navController = (UINavigationController *)self.searchController.searchResultsController;
        
        SearchResultsTableViewController *vc = (SearchResultsTableViewController *)navController.topViewController;
        vc.searchResults = self.searchResults;
        
        if (![searchString isEqualToString:@""] && self.searchResults.count) {
            
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
                //最初の文字までの不要なStringを削除する。
                if ([checkTheString rangeOfString:@" " options:0 range:NSMakeRange(0, 5)].location != NSNotFound) {
                    checkTheString = [checkTheString stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@""];
                }
                //最後列の改行だけを削除する。
                checkTheString = [checkTheString stringByReplacingCharactersInRange:NSMakeRange(checkTheString.length - 1, 1) withString:@""];
                //Stringに変わった改行を改行と認識させる。
                checkTheString = [checkTheString stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
                checkTheString = [checkTheString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                
                //言語判定。
                //[self languageForString:checkTheString];
                
                // searchResultsのカード番号を取得。
                NSString *queryBlank = [NSString stringWithFormat:@"select cardNumber from cardTextInfo where cardText = '%@' ", checkTheString];
                self.CNInfo = [[NSArray alloc] initWithArray:[self.dbCardText loadDataFromDB:queryBlank]];
                //NSLog(@"count %ld queryBlank %@", self.CNInfo.count, queryBlank);
                
                for (int k = 0; k < self.CNInfo.count; k++) {
                    NSString *checkNumber = [NSString stringWithFormat:@"%@", [self.CNInfo objectAtIndex:k]];
                    
                    // searchResultsのカード番号を渡す為に不要なStringを削除する。
                    checkNumber = [checkNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
                    checkNumber = [checkNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
                    checkNumber = [checkNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
                    checkNumber = [checkNumber stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    //checkNumberをqueryとして認識させる為にintegerにする。
                    self.indexOfcardText = [checkNumber integerValue];
                    //checkNumberをstringにする。
                    NSString *indexOfcardString = [NSString stringWithFormat:@"%ld", self.indexOfcardText];
                    
                    //cardNumberをarrayに渡す。
                    [self.searchResultsNumber addObject:indexOfcardString];
                    
                    
                    // searchResultsのカード番号とtextNumber0の値を取得。
                    NSString *queryZero = [NSString stringWithFormat:@"select cardText from cardTextInfo where cardNumber = %ld AND textNumber = %d", self.indexOfcardText, 0];
                    self.CTInfo = [[NSArray alloc] initWithArray:[self.dbCardText loadDataFromDB:queryZero]];
                    // 直接arrayにaddObjectするとstringByReplacingOccurrencesOfStringが実行されないので、一旦NSStringに値を渡す。
                    NSString *checkTheStr = [NSString stringWithFormat:@"%@", [self.CTInfo objectAtIndex:0]];
                    
                    // searchResultsのStringを渡す為に不要なStringを削除する。
                    checkTheStr = [checkTheStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
                    checkTheStr = [checkTheStr stringByReplacingOccurrencesOfString:@")" withString:@""];
                    if ([checkTheStr rangeOfString:@" " options:0 range:NSMakeRange(0, 5)].location != NSNotFound) {
                        checkTheStr = [checkTheStr stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@""];
                    }
                    checkTheStr = [checkTheStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    checkTheStr = [checkTheStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    checkTheStr = [checkTheStr stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
                    
                    // Checking if a string is equal to "
                    if ([checkTheStr isEqualToString:@""]) {
                        checkTheStr = @"(blank)";
                    }
                    
                    //cell.textに表示する文字列をarrayに渡す。
                    [self.searchResultsString addObject:checkTheStr];
                    
                    // searchResultsのカード番号とtextNumber1の値を取得。
                    NSString *queryOne = [NSString stringWithFormat:@"select cardText from cardTextInfo where cardNumber = %ld AND textNumber = %d", self.indexOfcardText, 1];
                    self.CTInfo_1 = [[NSArray alloc] initWithArray:[self.dbCardText loadDataFromDB:queryOne]];
                    // 直接arrayにaddObjectするとstringByReplacingOccurrencesOfStringが実行されないので、一旦NSStringに値を渡す。
                    NSString *checkTheStrOne = [NSString stringWithFormat:@"%@", [self.CTInfo_1 objectAtIndex:0]];
                    
                    // searchResultsのStringを渡す為に不要なStringを削除する。
                    checkTheStrOne = [checkTheStrOne stringByReplacingOccurrencesOfString:@"(" withString:@""];
                    checkTheStrOne = [checkTheStrOne stringByReplacingOccurrencesOfString:@")" withString:@""];
                    if ([checkTheStrOne rangeOfString:@" " options:0 range:NSMakeRange(0, 5)].location != NSNotFound) {
                        checkTheStrOne = [checkTheStrOne stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@""];
                    }
                    checkTheStrOne = [checkTheStrOne stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    checkTheStrOne = [checkTheStrOne stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    checkTheStrOne = [checkTheStrOne stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
                    
                    // Checking if a string is equal to "
                    if ([checkTheStrOne isEqualToString:@""]) {
                        checkTheStrOne = @"(blank)";
                    }
                    
                    //NSLog(@"count %ld checkTheStrOne%@", self.CNInfo.count, checkTheStrOne);
                    
                    //cell.textに表示する文字列をarrayに渡す。
                    [self.searchResultsString_1 addObject:checkTheStrOne];
                    
                    //NSLog(@"searchResultsNumber %@", [self.searchResultsNumber objectAtIndex:i]);
                    
                    vc.newSearch = 1;
                }
            }
        }else{
            vc.newSearch = -1;
        }
        
        vc.searchResultsString = self.searchResultsString;
        vc.searchResultsString_1 = self.searchResultsString_1;
        vc.searchResultsNumber = self.searchResultsNumber;
        
        vc.filenameData = self.filenameData;
        vc.recordIDToEdit = self.recordIDToEdit;
        self.newCard = 1;
        vc.newCard = self.newCard;
        vc.searchCardDelegate = self;
        
        [vc.tableView reloadData];
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
    //NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    
    //Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
    //配列を初期化。
    self.confirmNumber = [[NSMutableArray alloc] init];
    self.confirmNumber = [NSMutableArray array];
    
    for (int i = 0; i < self.cardText.count; i++) {
        NSString *checkString = [NSString stringWithFormat:@"%@", [self.cardText objectAtIndex:i]];
        NSString *checkNumber = [NSString stringWithFormat:@"%@", [self.cardNumber objectAtIndex:i]];
        //NSLog(@"checkNumber %@", checkNumber);
        if ((typeName == nil) || [checkString isEqualToString:typeName]) {
            //if (![[[self.searchController.searchBar text] stringByTrimmingCharactersInSet: set] length] == 0) {
                NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
                NSRange productNameRange = NSMakeRange(0, checkString.length);
                NSRange foundRange = [checkString rangeOfString:name options:searchOptions range:productNameRange];
                if (foundRange.length > 0) {
                    if (self.confirmNumber.count) {
                        for (int k = 0; k < self.confirmNumber.count; k++) {
                            //confirmNumberにcheckNumberが含まれているかチェック。
                            if (![self.confirmNumber containsObject:checkNumber]) {
                                [self.searchResults addObject:checkString];
                                [self.confirmNumber addObject:checkNumber];
                                NSLog(@"checkNumber %@ count %ld", checkNumber, self.confirmNumber.count);
                            }
                        }
                    }else if (self.confirmNumber.count == 0){
                        [self.searchResults addObject:checkString];
                        [self.confirmNumber addObject:checkNumber];
                        //NSLog(@"checkNumber %@ count %ld", checkNumber, self.confirmNumber.count);
                    }
                }
            
        }
    }
}

/*
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //NSLog(@"%@",text);
    self.languageText = text;
    return YES;
}

- (NSString *)languageForString:(NSString *) text{
    
    if (text.length < 100) {
        
        return (NSString *)CFBridgingRelease(CFStringTokenizerCopyBestStringLanguage((CFStringRef)text, CFRangeMake(0, text.length)));
    } else {
        
        return (NSString *)CFBridgingRelease(CFStringTokenizerCopyBestStringLanguage((CFStringRef)text, CFRangeMake(0, 100)));
    }
}*/

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"EditCardTableViewController"]) {
        EditCardTableViewController *editView = [segue destinationViewController];
        editView.filenameData = self.filenameData;
        editView.recordIDToEdit = self.recordIDToEdit;
        editView.newCard = self.newCard;
        editView.editCardDelegate = self;
    }
}

//CustomCellを設定したのでdidSelectRowでsegueを実行する。didSelectRowを呼ばないと遷移されない。
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"EditCardTableViewController" sender:self.tableView];
}

-(void)addFolder: (UIBarButtonItem *)sender{
    EditCardTableViewController *editCard =[[EditCardTableViewController alloc] init];
    editCard.editCardDelegate = self;
    
    //Load the Data.
    //Create the query.
    NSString *queryForCN = [NSString stringWithFormat:@"select cardNumberInfoID from cardNumberInfo where filename = '%@' ", self.filenameData];
    //NSLog(@"%@", queryForCN);
    // Get the results.
    if (self.cardNumberInfo != nil) {
        self.cardNumberInfo = nil;
    }
    // Load the relevant data.
    self.cardNumberInfo = [[NSArray alloc] initWithArray:[self.dbCardNumber loadDataFromDB:queryForCN]];
    if (self.cardNumberInfo.count) {
        // Get the last object of cardNumberInfo.
        //countは1から数える。objectAtIndexは0からなので、-1せずにそのまま使うとRangeExceptionエラーとなる。
        NSInteger numberCount = [self.cardNumberInfo count] - 1;
        // Get the cardNumber of the selected filename and set it to the cardNumberToEdit property.
        // ...objectAtIndex:0] intValue] == CNinfoID NSInteger primary key
        self.recordIDToEdit = [[[self.cardNumberInfo objectAtIndex:numberCount] objectAtIndex:0] intValue];
        //最後尾オブジェクトの番号に一を足して編集せずに新しいカードを作る。
        self.recordIDToEdit += 1;
        NSLog(@"recordIDToEdit %d", self.recordIDToEdit);
        self.newCard = -1;
    }else if (self.cardNumberInfo.count == 0){
        //追加、編集するカード番号を保存。
        self.recordIDToEdit = 1;
        self.newCard = -1;
    }
    
    [self performSegueWithIdentifier:@"EditCardTableViewController" sender:sender];
}

- (void)editingButtonPressed:(UIBarButtonItem *)sender {
    //[sender setText:@"Done" forState:UIControlStateNormal];
    self.editIsTapped = YES;
    [self setEditing:YES animated:YES];
    self.navigationItem.rightBarButtonItems = nil;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(loadButtonItems:)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

-(void)loadButtonItems: (UIBarButtonItem *)sender{
    self.editIsTapped = NO;
    [self setEditing:NO animated:YES];
    
    //@selector()で指定メソッドをコール
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFolder:)];
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editingButtonPressed:)];
    
    self.actionButtonItems = @[editItem, addItem];
    self.navigationItem.rightBarButtonItems = self.actionButtonItems;
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrCNInfo.count;
}

// indexPath.rowはnumberOfRowsで指定したRowの数だけ処理を繰り返す。
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell" forIndexPath:indexPath];
    
    static NSString *cellIdentifier = @"ListCell";
    
    CardListTableViewCell *cell = (CardListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CardListTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    // Configure the cell...
    cell.textLabel_1.text = [NSString stringWithFormat:@"%@", [self.stringArr objectAtIndex:indexPath.row]];
    cell.textLabel_2.text = [NSString stringWithFormat:@"%@", [self.stringArr_1 objectAtIndex:indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the selected record.
        // Prepare the query.
        self.recordIDToEdit = [[[self.arrCNInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
        NSString *query = [NSString stringWithFormat:@"delete from cardNumberInfo where cardNumberInfoID = %d ", self.recordIDToEdit];
        // Execute the query.
        [self.dbCardNumber executeQuery:query];
        
        NSString *queryText = [NSString stringWithFormat:@"delete from cardTextInfo where cardNumber = %d ", self.recordIDToEdit];
        NSLog(@"%@", queryText);
        // Execute the query.
        [self.dbCardText executeQuery:queryText];
        
        // Reload the table view.
        [self loadData];
    }
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(!self.editIsTapped) {
        //UITableViewCellEditingStyleNone will NOT support delete (in your case, the first row is returning this)
        return UITableViewCellEditingStyleNone;
    }
    
    //UITableViewCellEditingStyleDelete will support delete (in your case, all but the first row is returning this)
    return UITableViewCellEditingStyleDelete;
}

//didSelectにすると値が渡せない。値を渡す時はwillSelectとする。戻り値はindexPath。
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //indexPath.row番目のCardNumberを取得。
    self.recordIDToEdit = [[[self.arrCNInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
    NSLog(@"recordIDToEdit %d", [[[self.arrCNInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue]);
    
    return indexPath;
}

-(void)cardEditingInfoWasFinished{
    // Reload the data.
    [self loadData];
    
    [self updateSearchResultsForSearchController:self.searchController];
    NSLog(@"cardEditingInfoWasFinished_1 called");
}

-(void)searchEditingInfoWasFinished{
    // Reload the data.
    [self loadData];
    
    [self updateSearchResultsForSearchController:self.searchController];
    [self.searchController.searchBar becomeFirstResponder];
    NSLog(@"searchEditingInfoWasFinished called");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end
