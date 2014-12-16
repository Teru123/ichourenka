//
//  EnterCardnameTableViewController.m
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/12/11.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import "EnterCardnameTableViewController.h"
#import "CardText.h"
#import "CardNumber.h"

@interface EnterCardnameTableViewController ()

@property (nonatomic, assign) int currentIndex;
@property (nonatomic, strong) NSArray *titleList;
@property (nonatomic, strong) CardText *cardTextManager;
@property (nonatomic, strong) NSArray *cardTextInfo;
@property (nonatomic, strong) CardNumber *dbCardNumber;
@property (nonatomic, strong) NSArray *cardNumberInfo;
//@property (nonatomic, strong) NSArray *textNumberInfo;
@property (nonatomic, assign) int cardNumberToEdit;
//@property (nonatomic, assign) int textNumberToEdit;

- (void)loadInfoToEdit;

@end

@implementation EnterCardnameTableViewController

- (void)viewWillAppear:(BOOL)animated {
    //テキスト入力画面表示
    [self.cardText becomeFirstResponder];
    
    //set bounds of the textview
    self.cardText.bounds = [self editingRectForBounds:self.cardText.bounds];
    //改行するとずれるのでInsetの初期設定を調整
    self.cardText.contentInset = UIEdgeInsetsMake(-10,-5,0,0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Make self the delegate of the textfields .h <UITextViewDelegate>
    self.cardText.delegate = self;
    
    //@selector()で指定メソッドをコール
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextItem:)];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneItem:)];
    
    NSArray *actionButtonItems = @[doneItem, nextItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    NSString *titleOne = [NSString stringWithFormat:@"Text 1"];
    NSString *titleTwo = [NSString stringWithFormat:@"Text 2"];
    NSString *titleThree = [NSString stringWithFormat:@"Text 3"];
    NSString *titleFour = [NSString stringWithFormat:@"Text 4"];
    NSString *titleFive = [NSString stringWithFormat:@"Text 5"];
    
    self.titleList = @[titleOne, titleTwo, titleThree, titleFour, titleFive];
    
    if ([self.titleNumber isEqualToString:@"1"]) {
        self.currentIndex = 0;
        self.navigationItem.title = [self.titleList objectAtIndex:self.currentIndex];
    }else if ([self.titleNumber isEqualToString:@"2"]) {
        self.currentIndex = 1;
        self.navigationItem.title = [self.titleList objectAtIndex:self.currentIndex];
    }else if ([self.titleNumber isEqualToString:@"3"]) {
        self.currentIndex = 2;
        self.navigationItem.title = [self.titleList objectAtIndex:self.currentIndex];
    }else if ([self.titleNumber isEqualToString:@"4"]) {
        self.currentIndex = 3;
        self.navigationItem.title = [self.titleList objectAtIndex:self.currentIndex];
    }else if ([self.titleNumber isEqualToString:@"5"]) {
        self.currentIndex = 4;
        self.navigationItem.title = [self.titleList objectAtIndex:self.currentIndex];
    }

    // Initialize the dbManager object.
    self.cardTextManager = [[CardText alloc] initWithDatabaseFilename:@"CardText.sql"];
    self.dbCardNumber = [[CardNumber alloc] initWithDatabaseFilename:@"CardNumber.sql"];
    
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
        self.cardNumberToEdit = [[[self.cardNumberInfo objectAtIndex:numberCount] objectAtIndex:0] intValue];
        NSLog(@"cardNumberToEdit %d", self.cardNumberToEdit);
        
        if (self.cardNumberToEdit == self.recordIDToEdit){
            [self loadInfoToEdit];
        }
    }
    
    /*
    //Load the Data.
    //Create the query.
    NSString *queryForTN = [NSString stringWithFormat:@"select textNumber from cardTextInfo where cardNumber = %d ", self.recordIDToEdit];
    // Get the results.
    if (self.textNumberInfo != nil) {
        self.textNumberInfo = nil;
    }
    // Load the relevant data.
    self.textNumberInfo = [[NSArray alloc] initWithArray:[self.cardTextManager loadDataFromDB:queryForTN]];
    if (self.textNumberInfo.count) {
        // Get the last object of cardNumberInfo.
        //countは1から数える。objectAtIndexは0からなので、-1せずにそのまま使うとRangeExceptionエラーとなる。
        NSInteger numberCount = [self.textNumberInfo count] - 1;
        // Get the cardNumber of the selected filename and set it to the cardNumberToEdit property.
        // ...objectAtIndex:0] intValue] == CNinfoID NSInteger primary key
        self.textNumberToEdit = [[[self.textNumberInfo objectAtIndex:numberCount] objectAtIndex:0] intValue];
        NSLog(@"textNumberToEdit %d", self.textNumberToEdit);
    }*/
}

// text position: inset for the textfield
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 5 , 10 );
}

-(void)nextItem: (UIBarButtonItem *)sender{
    self.currentIndex += 1;
    if (self.currentIndex > 4) {
        self.currentIndex = 0;
        self.navigationItem.title = [self.titleList objectAtIndex:self.currentIndex];
    }else{
        self.navigationItem.title = [self.titleList objectAtIndex:self.currentIndex];
    }
}

- (void)doneItem:(UIBarButtonItem *)sender {
    /*
    // If the recordIDToEdit property has value other than -1, then create an update query. Otherwise create an insert query.
    NSString *queryForCardNumber;
    if (self.recordIDToEdit == -1) {
        queryForCardNumber = [NSString stringWithFormat:@"insert into cardNumberInfo values(null, '%@')", self.filenameData];
        // Execute the query.
        [self.dbCardNumber executeQuery:queryForCardNumber];
        
        if (self.dbCardNumber.affectedRows != 0) {
            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbCardNumber.affectedRows);
        }else{
            NSLog(@"Could not execute the query.");
        }
    }
   
    //Load the Data.
    //Create the query.
    NSString *queryForCN = [NSString stringWithFormat:@"select cardNumberInfoID from cardNumberInfo where filename = '%@' ", self.filenameData];
    // Get the results.
    if (self.cardNumberInfo != nil) {
        self.cardNumberInfo = nil;
    }
    // Load the relevant data.
    self.cardNumberInfo = [[NSArray alloc] initWithArray:[self.dbCardNumber loadDataFromDB:queryForCN]];
    // Get the last object of cardNumberInfo.
    //countは1から数える。objectAtIndexは0からなので、-1せずにそのまま使うとRangeExceptionエラーとなる。
    NSInteger numberCount = [self.cardNumberInfo count] - 1;
    // Get the cardNumber of the selected filename and set it to the cardNumberToEdit property.
    // ...objectAtIndex:0] intValue] == CNinfoID NSInteger primary key
    self.cardNumberToEdit = [[[self.cardNumberInfo objectAtIndex:numberCount] objectAtIndex:0] intValue];
    NSLog(@"cardNumberToEdit %d", self.cardNumberToEdit);
    */
    
    //Load the Data.
    NSString *queryForLoad = [NSString stringWithFormat:@"select * from cardTextInfo where cardNumber = %d AND textNumber = %d", self.recordIDToEdit, 0];
    self.cardTextInfo = [[NSArray alloc] initWithArray:[self.cardTextManager loadDataFromDB:queryForLoad]];
    // Prepare the query string.
    NSString *query;
    if (self.cardTextInfo.count == 0 && self.currentIndex == 0){
        query = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", self.cardText.text, self.currentIndex, self.filenameData, self.recordIDToEdit];
        // Execute the query.
        [self.cardTextManager executeQuery:query];
    }else if (self.cardTextInfo.count == 0 && self.currentIndex == 1){
        query = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", @"", 0, self.filenameData, self.recordIDToEdit];
        // Execute the query.
        [self.cardTextManager executeQuery:query];
        query = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", self.cardText.text, self.currentIndex, self.filenameData, self.recordIDToEdit];
        // Execute the query.
        [self.cardTextManager executeQuery:query];
    }else if (self.cardTextInfo.count == 0 && self.currentIndex == 2){
        query = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", @"", 0, self.filenameData, self.recordIDToEdit];
        // Execute the query.
        [self.cardTextManager executeQuery:query];
        query = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", @"", 1, self.filenameData, self.recordIDToEdit];
        // Execute the query.
        [self.cardTextManager executeQuery:query];
        query = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", self.cardText.text, self.currentIndex, self.filenameData, self.recordIDToEdit];
        // Execute the query.
        [self.cardTextManager executeQuery:query];
    }else if (self.cardTextInfo.count == 0 && self.currentIndex == 3){
        query = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", @"", 0, self.filenameData, self.recordIDToEdit];
        // Execute the query.
        [self.cardTextManager executeQuery:query];
        query = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", @"", 1, self.filenameData, self.recordIDToEdit];
        // Execute the query.
        [self.cardTextManager executeQuery:query];
        query = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", @"", 2, self.filenameData, self.recordIDToEdit];
        // Execute the query.
        [self.cardTextManager executeQuery:query];
        query = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", self.cardText.text, self.currentIndex, self.filenameData, self.recordIDToEdit];
        // Execute the query.
        [self.cardTextManager executeQuery:query];
    }else if (self.cardTextInfo.count == 0 && self.currentIndex == 4){
        query = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", @"", 0, self.filenameData, self.recordIDToEdit];
        // Execute the query.
        [self.cardTextManager executeQuery:query];
        query = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", @"", 1, self.filenameData, self.recordIDToEdit];
        // Execute the query.
        [self.cardTextManager executeQuery:query];
        query = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", @"", 2, self.filenameData, self.recordIDToEdit];
        // Execute the query.
        [self.cardTextManager executeQuery:query];
        query = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", @"", 3, self.filenameData, self.recordIDToEdit];
        // Execute the query.
        [self.cardTextManager executeQuery:query];
        query = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", self.cardText.text, self.currentIndex, self.filenameData, self.recordIDToEdit];
        // Execute the query.
        [self.cardTextManager executeQuery:query];
    }else{
        NSString *query = [NSString stringWithFormat:@"select * from cardTextInfo where cardNumber = %d AND textNumber = %d", self.recordIDToEdit, self.currentIndex];
        self.cardTextInfo = [[NSArray alloc] initWithArray:[self.cardTextManager loadDataFromDB:query]];
        // Set the loaded data to the textfields.
        //データがある場合は更新。
        if (self.cardTextInfo.count && self.currentIndex == 0) {
            query = [NSString stringWithFormat:@"update cardTextInfo set cardText = '%@' where textNumber = %d AND cardNumber = %d", self.cardText.text, self.currentIndex, self.recordIDToEdit];
            // Execute the query.
            [self.cardTextManager executeQuery:query];
        }else if (self.cardTextInfo.count && self.currentIndex == 1) {
            query = [NSString stringWithFormat:@"update cardTextInfo set cardText = '%@' where textNumber = %d AND cardNumber = %d", self.cardText.text, self.currentIndex, self.recordIDToEdit];
            // Execute the query.
            [self.cardTextManager executeQuery:query];
        }else if (self.cardTextInfo.count && self.currentIndex == 2) {
            query = [NSString stringWithFormat:@"update cardTextInfo set cardText = '%@' where textNumber = %d AND cardNumber = %d", self.cardText.text, self.currentIndex, self.recordIDToEdit];
            // Execute the query.
            [self.cardTextManager executeQuery:query];
        }else if (self.cardTextInfo.count && self.currentIndex == 3) {
            query = [NSString stringWithFormat:@"update cardTextInfo set cardText = '%@' where textNumber = %d AND cardNumber = %d", self.cardText.text, self.currentIndex, self.recordIDToEdit];
            // Execute the query.
            [self.cardTextManager executeQuery:query];
        }else if (self.cardTextInfo.count && self.currentIndex == 4) {
            query = [NSString stringWithFormat:@"update cardTextInfo set cardText = '%@' where textNumber = %d AND cardNumber = %d", self.cardText.text, self.currentIndex, self.recordIDToEdit];
            // Execute the query.
            [self.cardTextManager executeQuery:query];
        //データがない場合は新規保存。
        }else if (!self.cardTextInfo.count && self.currentIndex == 0){
            query = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", self.cardText.text, self.currentIndex, self.filenameData, self.recordIDToEdit];
            // Execute the query.
            [self.cardTextManager executeQuery:query];
        }else if (!self.cardTextInfo.count && self.currentIndex == 1){
            query = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", self.cardText.text, self.currentIndex, self.filenameData, self.recordIDToEdit];
            // Execute the query.
            [self.cardTextManager executeQuery:query];
        }else if (!self.cardTextInfo.count && self.currentIndex == 2){
            query = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", self.cardText.text, self.currentIndex, self.filenameData, self.recordIDToEdit];
            // Execute the query.
            [self.cardTextManager executeQuery:query];
        }else if (!self.cardTextInfo.count && self.currentIndex == 3){
            query = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", self.cardText.text, self.currentIndex, self.filenameData, self.recordIDToEdit];
            // Execute the query.
            [self.cardTextManager executeQuery:query];
        }else if (!self.cardTextInfo.count && self.currentIndex == 4){
            query = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", self.cardText.text, self.currentIndex, self.filenameData, self.recordIDToEdit];
            // Execute the query.
            [self.cardTextManager executeQuery:query];
        }
    }
    
    // If the query was successfully executed then pop the view controller.
    if (self.cardTextManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.cardTextManager.affectedRows);
        
        // Inform the delegate that the editing was finished.
        //[self.delegate editingInfoWasFinished];
    }else{
        NSLog(@"Could not execute the query.");
    }
    
    [self.cardTextDelegate editingCardTextInfoWasFinished];
    
    // Pop the view controller.
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadInfoToEdit{
    // Create the query.
    NSString *query = [NSString stringWithFormat:@"select * from cardTextInfo where cardNumber = %d AND textNumber = %d", self.recordIDToEdit, self.currentIndex];
    // Load the relevant data.
    self.cardTextInfo = [[NSArray alloc] initWithArray:[self.cardTextManager loadDataFromDB:query]];
    //NSLog(@"count %ld, index %d, id %d", self.cardTextInfo.count, self.currentIndex, self.recordIDToEdit);
    if (self.cardTextInfo.count) {
        self.cardText.text = [[self.cardTextInfo objectAtIndex:0] objectAtIndex:[self.cardTextManager.arrColumnNames indexOfObject:@"cardText"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
