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
@property (nonatomic, strong) NSArray *cardTextInfo;
@property (nonatomic, strong) NSArray *cardTextInfo_1;
@property (nonatomic, strong) NSMutableArray *stringArr;
@property (nonatomic, strong) NSString *checkStr;
@property (nonatomic, strong) NSMutableArray *stringArr_1;
@property (nonatomic, strong) NSString *checkStr_1;
@property (nonatomic, strong) NSArray *cards;
@property (nonatomic, strong) NSArray *cardTextSearch;
@property (nonatomic, strong) NSArray *cardNumberSearch;
@property (nonatomic, strong) NSArray *textNumberSearch;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults; // Filtered search results

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
    }
    //NSLog(@"%ld", self.stringArr_1.count);
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
    
    // Initialize the dbManager property.
    //self.dbCardNumber = [[CardNumber alloc] initWithDatabaseFilename:@"CardNumber.sql"];
    self.dbCardText = [[CardText alloc] initWithDatabaseFilename:@"CardText.sql"];
    
    // Load the first Data
    NSString *queryText = [NSString stringWithFormat:@"select cardText from cardTextInfo"];
    self.cardTextSearch = [[NSArray alloc] initWithArray:[self.dbCardText loadDataFromDB:queryText]];
    NSString *queryNumber = [NSString stringWithFormat:@"select cardNumber from cardTextInfo"];
    self.cardNumberSearch = [[NSArray alloc] initWithArray:[self.dbCardText loadDataFromDB:queryNumber]];
    NSString *queryTextNumber = [NSString stringWithFormat:@"select textNumber from cardTextInfo"];
    self.textNumberSearch = [[NSArray alloc] initWithArray:[self.dbCardText loadDataFromDB:queryTextNumber]];
    
    //cardText, cardNumber, textNumberを配列にinsert。resultsに使用。
    self.cardText = [[NSMutableArray alloc] init];
    self.cardText = [NSMutableArray array];
    self.cardNumber = [[NSMutableArray alloc] init];
    self.cardNumber = [NSMutableArray array];
    self.textNumber = [[NSMutableArray alloc] init];
    self.textNumber = [NSMutableArray array];
    for (int i = 0; i < self.cardNumberSearch.count; i++) {
        [self.cardText insertObject:[self.cardTextSearch objectAtIndex:i] atIndex:i];
        [self.cardNumber insertObject:[self.cardNumberSearch objectAtIndex:i] atIndex:i];
        [self.textNumber insertObject:[self.textNumberSearch objectAtIndex:i] atIndex:i];
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
    
    NSLog(@"searchResults %ld %@", self.cardText.count, [NSString stringWithFormat:@"%@", [self.cardText objectAtIndex:0]]);
    
    // Load the data.
    [self loadData];
}

#pragma mark - UISearchResultsUpdating
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [self.searchController.searchBar text];
    NSString *scope = nil;
    [self updateFilteredContentForProductName:searchString type:scope];
    NSLog(@"searchString %@", searchString);
    
    if (self.searchController.searchResultsController) {
        UINavigationController *navController = (UINavigationController *)self.searchController.searchResultsController;
        
        SearchResultsTableViewController *vc = (SearchResultsTableViewController *)navController.topViewController;
        vc.searchResults = self.searchResults;
        [vc.tableView reloadData];
    }
}

// Workaround for bug: -updateSearchResultsForSearchController: is not called when scope buttons change
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self.searchController];
}

#pragma mark - Content Filtering

- (void)updateFilteredContentForProductName:(NSString *)name type:(NSString *)typeName{
    
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
                if ([checkString isEqualToString:typeName]) {
                    [searchResults addObject:checkString];
                }
            }
            self.searchResults = searchResults;
        }
        return;
    }
    
    
    [self.searchResults removeAllObjects]; // First clear the filtered array.
    
    //Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
     
    for (int i = 0; i < self.cardText.count; i++) {
        NSString *checkString = [NSString stringWithFormat:@"%@", [self.cardText objectAtIndex:i]];
        if ((typeName == nil) || [checkString isEqualToString:typeName]) {
            NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
            NSRange productNameRange = NSMakeRange(0, checkString.length);
            NSRange foundRange = [checkString rangeOfString:name options:searchOptions range:productNameRange];
            if (foundRange.length > 0) {
                [self.searchResults addObject:checkString];
            }
        }
    }
    NSLog(@"%ld", self.searchResults.count);
}

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
    
    // Reload the table view.
    [self.tableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrCNInfo.count;
}

//indexPath.rowはnumberOfRowsで指定したRowの数だけ処理を繰り返す。
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
