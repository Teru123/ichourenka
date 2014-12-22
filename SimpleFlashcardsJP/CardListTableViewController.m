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
#import "CardNumber.h"
#import "CardText.h"

@interface CardListTableViewController ()

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
    
    // Load the data.
    [self loadData];
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
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
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
