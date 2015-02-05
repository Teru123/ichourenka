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
@property (nonatomic, assign) int cardNumberToEdit;
@property (nonatomic, strong) NSArray *allCardTextInfo;

- (void)loadInfoToEdit;

@end

@implementation EnterCardnameTableViewController

- (void)viewWillAppear:(BOOL)animated {
    //テキスト入力画面表示
    [self.cardText becomeFirstResponder];
    
    //set bounds of the textview
    self.cardText.bounds = [self editingRectForBounds:self.cardText.bounds];
    //TextViewは改行するとずれるのでInsetの初期設定を調整
    self.cardText.contentInset = UIEdgeInsetsMake(-10,-5,0,0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Make self the delegate of the textfields .h <UITextViewDelegate>
    self.cardText.delegate = self;
    
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
    self.dbCardNumber = [[CardNumber alloc] initWithDatabaseFilename:@"CardNumberDB.sql"];
    
    //Load the Data.
    //Create the query.
    NSString *queryForCN = [NSString stringWithFormat:@"select cardNumberInfoID from cardNumberInfo where filename = '%@' AND foldername = '%@' ", [NSString stringWithFormat:@"%ld", self.fileID], [NSString stringWithFormat:@"%ld", self.folderID]];
    // Get the results.
    if (self.cardNumberInfo != nil) {
        self.cardNumberInfo = nil;
    }
    // Load the relevant data.
    self.cardNumberInfo = [[NSArray alloc] initWithArray:[self.dbCardNumber loadDataFromDB:queryForCN]];
    if (self.cardNumberInfo.count && self.newCard != -1) {
                
        [self loadInfoToEdit];
    }
}

-(void)loadInfoToEdit{
    // Create the query.
    NSString *query = [NSString stringWithFormat:@"select * from cardTextInfo where cardNumber = %d AND textNumber = %d", self.recordIDToEdit, self.currentIndex];
    // Load the relevant data.
    self.cardTextInfo = [[NSArray alloc] initWithArray:[self.cardTextManager loadDataFromDB:query]];
    //NSLog(@"count %ld, index %d, id %d", self.cardTextInfo.count, self.currentIndex, self.recordIDToEdit);
    if (self.cardTextInfo.count) {
        if ([[[self.cardTextInfo objectAtIndex:0] objectAtIndex:[self.cardTextManager.arrColumnNames indexOfObject:@"cardText"]] isEqualToString:@"(blank)"]) {
            self.cardText.text = @"";
        }else{
            self.cardText.text = [[self.cardTextInfo objectAtIndex:0] objectAtIndex:[self.cardTextManager.arrColumnNames indexOfObject:@"cardText"]];
        }
    }
}

// text position: inset for the textfield
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 5 , 10 );
}

- (IBAction)doneAction:(id)sender {
    //single quoteがあるかチェック。あればtwo single quotesにしてsyntax errorを避ける。
    self.cardText.text = [self.cardText.text stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    
    //NSLog(@"%@", self.cardText.text);
    
    //Load the Data.
    NSString *queryForLoad = [NSString stringWithFormat:@"select * from cardTextInfo where cardNumber = %d AND textNumber = %d", self.recordIDToEdit, 0];
    self.cardTextInfo = [[NSArray alloc] initWithArray:[self.cardTextManager loadDataFromDB:queryForLoad]];
    // Prepare the query string.
    NSString *query;
    NSString *queryOne;
    NSString *queryTwo;
    NSString *queryThree;
    NSString *queryFour;
        
    if (self.cardTextInfo.count == 0 && self.currentIndex == 0){
        query = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", self.cardText.text, self.currentIndex, [NSString stringWithFormat:@"%ld", self.fileID], self.recordIDToEdit];
        queryOne = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", @"", 1, [NSString stringWithFormat:@"%ld", self.fileID], self.recordIDToEdit];
        // Execute the query.
        [self.cardTextManager executeQuery:query];
        [self.cardTextManager executeQuery:queryOne];
    }else if (self.cardTextInfo.count == 0 && self.currentIndex == 1){
        query = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", @"", 0, [NSString stringWithFormat:@"%ld", self.fileID], self.recordIDToEdit];
        queryOne = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", self.cardText.text, self.currentIndex, [NSString stringWithFormat:@"%ld", self.fileID], self.recordIDToEdit];
        // Execute the query.
        [self.cardTextManager executeQuery:query];
        [self.cardTextManager executeQuery:queryOne];
    }else if (self.cardTextInfo.count == 0 && self.currentIndex == 2){
        query = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", @"", 0, [NSString stringWithFormat:@"%ld", self.fileID], self.recordIDToEdit];
        queryOne = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", @"", 1, [NSString stringWithFormat:@"%ld", self.fileID], self.recordIDToEdit];
        queryTwo = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", self.cardText.text, self.currentIndex, [NSString stringWithFormat:@"%ld", self.fileID], self.recordIDToEdit];
        // Execute the query.
        [self.cardTextManager executeQuery:query];
        [self.cardTextManager executeQuery:queryOne];
        [self.cardTextManager executeQuery:queryTwo];
    }else if (self.cardTextInfo.count == 0 && self.currentIndex == 3){
        query = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", @"", 0, [NSString stringWithFormat:@"%ld", self.fileID], self.recordIDToEdit];
        queryOne = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", @"", 1, [NSString stringWithFormat:@"%ld", self.fileID], self.recordIDToEdit];
        queryTwo = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", @"", 2, [NSString stringWithFormat:@"%ld", self.fileID], self.recordIDToEdit];
        queryThree = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", self.cardText.text, self.currentIndex, [NSString stringWithFormat:@"%ld", self.fileID], self.recordIDToEdit];
        // Execute the query.
        [self.cardTextManager executeQuery:query];
        [self.cardTextManager executeQuery:queryOne];
        [self.cardTextManager executeQuery:queryTwo];
        [self.cardTextManager executeQuery:queryThree];
    }else if (self.cardTextInfo.count == 0 && self.currentIndex == 4){
        query = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", @"", 0, [NSString stringWithFormat:@"%ld", self.fileID], self.recordIDToEdit];
        queryOne = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", @"", 1, [NSString stringWithFormat:@"%ld", self.fileID], self.recordIDToEdit];
        queryTwo = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", @"", 2, [NSString stringWithFormat:@"%ld", self.fileID], self.recordIDToEdit];
        queryThree = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", @"", 3, [NSString stringWithFormat:@"%ld", self.fileID], self.recordIDToEdit];
        queryFour = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", self.cardText.text, self.currentIndex, [NSString stringWithFormat:@"%ld", self.fileID], self.recordIDToEdit];
        // Execute the query.
        [self.cardTextManager executeQuery:query];
        [self.cardTextManager executeQuery:queryOne];
        [self.cardTextManager executeQuery:queryTwo];
        [self.cardTextManager executeQuery:queryThree];
        [self.cardTextManager executeQuery:queryFour];
    }else{
        //Load the All Data.
        NSString *queryForLoadAll = [NSString stringWithFormat:@"select * from cardTextInfo where cardNumber = %d", self.recordIDToEdit];
        self.allCardTextInfo = [[NSArray alloc] initWithArray:[self.cardTextManager loadDataFromDB:queryForLoadAll]];
        //Load the selected Data.
        NSString *queryForLoad = [NSString stringWithFormat:@"select * from cardTextInfo where cardNumber = %d AND textNumber = %d", self.recordIDToEdit, self.currentIndex];
        self.cardTextInfo = [[NSArray alloc] initWithArray:[self.cardTextManager loadDataFromDB:queryForLoad]];
        // Set the loaded data to the textfields.
        //該当データがある場合は更新。
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
            //該当データがない場合は新規保存。
        }else if (!self.cardTextInfo.count && self.currentIndex == 0){
            query = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", self.cardText.text, self.currentIndex, [NSString stringWithFormat:@"%ld", self.fileID], self.recordIDToEdit];
            // Execute the query.
            [self.cardTextManager executeQuery:query];
        }else if (!self.cardTextInfo.count && self.currentIndex == 1){
            query = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", self.cardText.text, self.currentIndex, [NSString stringWithFormat:@"%ld", self.fileID], self.recordIDToEdit];
            // Execute the query.
            [self.cardTextManager executeQuery:query];
        }else if (!self.cardTextInfo.count && self.currentIndex == 2){
            query = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", self.cardText.text, self.currentIndex, [NSString stringWithFormat:@"%ld", self.fileID], self.recordIDToEdit];
            // Execute the query.
            [self.cardTextManager executeQuery:query];
        }else if (!self.cardTextInfo.count && self.currentIndex == 3){
            if (self.allCardTextInfo.count == 2) {
                queryThree = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", @"", 2, [NSString stringWithFormat:@"%ld", self.fileID], self.recordIDToEdit];
                // Execute the query.
                [self.cardTextManager executeQuery:queryThree];
            }
            query = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", self.cardText.text, self.currentIndex, [NSString stringWithFormat:@"%ld", self.fileID], self.recordIDToEdit];
            // Execute the query.
            [self.cardTextManager executeQuery:query];
        }else if (!self.cardTextInfo.count && self.currentIndex == 4){
            if (self.allCardTextInfo.count == 2) {
                queryThree = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", @"", 2, [NSString stringWithFormat:@"%ld", self.fileID], self.recordIDToEdit];
                queryFour = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", @"", 3, [NSString stringWithFormat:@"%ld", self.fileID], self.recordIDToEdit];
                // Execute the query.
                [self.cardTextManager executeQuery:queryThree];
                [self.cardTextManager executeQuery:queryFour];
            }else if(self.allCardTextInfo.count == 3){
                queryFour = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", @"", 3, [NSString stringWithFormat:@"%ld", self.fileID], self.recordIDToEdit];
                // Execute the query.
                [self.cardTextManager executeQuery:queryFour];
            }
            query = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", self.cardText.text, self.currentIndex, [NSString stringWithFormat:@"%ld", self.fileID], self.recordIDToEdit];
            // Execute the query.
            [self.cardTextManager executeQuery:query];
        }
    }
    
    if (self.cardTextManager.affectedRows != 0) {
        //NSLog(@"Query was executed successfully. Affected rows = %d", self.cardTextManager.affectedRows);
    }else{
        //NSLog(@"Could not execute the query.");
    }
    
    //Delegate先のviewで変更したい値を与える。
    [self.cardTextDelegate editingCardTextInfoWasFinished];
    
    // Pop the view controller.
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
