//
//  EditCardTableViewController.m
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/12/11.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import "EditCardTableViewController.h"
#import "EnterCardnameTableViewController.h"
#import "SearchResultsTableViewController.h"
#import "CardText.h"
#import "CardNumber.h"

@interface EditCardTableViewController ()

@property (nonatomic, strong) NSString *titlenumberOfThis;
@property (nonatomic, strong) CardText *cardTextManager;
@property (nonatomic, strong) NSArray *cardTextInfo;
@property (nonatomic, strong) NSString *cellText;
@property (nonatomic, strong) CardNumber *dbCardNumber;
@property (nonatomic, strong) NSArray *arrCNInfo;
@property (nonatomic, strong) NSArray *cardNumberInfo;
@property (nonatomic, assign) int cardNumberToEdit;
@property (nonatomic, assign) int customCellHeight;
@property (nonatomic, assign) int customCellHeight_1;
@property (nonatomic, assign) int customCellHeight_2;
@property (nonatomic, assign) int customCellHeight_3;
@property (nonatomic, assign) int customCellHeight_4;

-(void)loadInfoToEdit;
-(void)justLoadInfo;
- (void)setCellHeightAndCellText;

@end

@implementation EditCardTableViewController

- (void)viewWillAppear:(BOOL)animated{
    // ハイライト解除
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    // Delegate先のviewで変更した値を与える。通知しないとDelegate先にデータを渡せない。
    [self.editCardDelegate cardEditingInfoWasFinished];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize the dbManager object.
    self.cardTextManager = [[CardText alloc] initWithDatabaseFilename:@"CardText.sql"];
    self.dbCardNumber = [[CardNumber alloc] initWithDatabaseFilename:@"CardNumber.sql"];
    
    //Load the Data.
    //Create the query.
    NSString *queryForCN = [NSString stringWithFormat:@"select cardNumberInfoID from cardNumberInfo where filename = '%@' ", self.filenameData];
    
    //Get the results.
    if (self.cardNumberInfo != nil) {
        self.cardNumberInfo = nil;
    }
    
    // Load the relevant data.
    self.cardNumberInfo = [[NSArray alloc] initWithArray:[self.dbCardNumber loadDataFromDB:queryForCN]];
    
    NSLog(@"count %ld", self.cardNumberInfo.count);
    if (self.cardNumberInfo.count) {
        [self justLoadInfo];
    }
   
    [self.tableView reloadData];
    
    NSLog(@"%@", self.filenameData);
    NSLog(@"recordID %d", self.recordIDToEdit);
    NSLog(@"card %d", self.newCard);
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"EnterCardnameTableViewController1"]) {
        EnterCardnameTableViewController *cardnameView = [segue destinationViewController];
        cardnameView.titleNumber = @"1";
        cardnameView.filenameData = self.filenameData;
        cardnameView.cellText = self.cellText;
        cardnameView.recordIDToEdit = self.recordIDToEdit;
        cardnameView.newCard = self.newCard;
        cardnameView.cardTextDelegate = self;
    }else if ([[segue identifier] isEqualToString:@"EnterCardnameTableViewController2"]) {
        EnterCardnameTableViewController *cardnameView = [segue destinationViewController];
        cardnameView.titleNumber = @"2";
        cardnameView.filenameData = self.filenameData;
        cardnameView.cellText = self.cellText;
        cardnameView.recordIDToEdit = self.recordIDToEdit;
        cardnameView.newCard = self.newCard;
        cardnameView.cardTextDelegate = self;
    }else if ([[segue identifier] isEqualToString:@"EnterCardnameTableViewController3"]) {
        EnterCardnameTableViewController *cardnameView = [segue destinationViewController];
        cardnameView.titleNumber = @"3";
        cardnameView.filenameData = self.filenameData;
        cardnameView.cellText = self.cellText;
        cardnameView.recordIDToEdit = self.recordIDToEdit;
        cardnameView.newCard = self.newCard;
        cardnameView.cardTextDelegate = self;
    }else if ([[segue identifier] isEqualToString:@"EnterCardnameTableViewController4"]) {
        EnterCardnameTableViewController *cardnameView = [segue destinationViewController];
        cardnameView.titleNumber = @"4";
        cardnameView.filenameData = self.filenameData;
        cardnameView.cellText = self.cellText;
        cardnameView.recordIDToEdit = self.recordIDToEdit;
        cardnameView.newCard = self.newCard;
        cardnameView.cardTextDelegate = self;
    }else if ([[segue identifier] isEqualToString:@"EnterCardnameTableViewController5"]) {
        EnterCardnameTableViewController *cardnameView = [segue destinationViewController];
        cardnameView.titleNumber = @"5";
        cardnameView.filenameData = self.filenameData;
        cardnameView.cellText = self.cellText;
        cardnameView.recordIDToEdit = self.recordIDToEdit;
        cardnameView.newCard = self.newCard;
        cardnameView.cardTextDelegate = self;
    }
}

//didSelectにすると値が渡せない。値を渡す時はwillSelectとする。戻り値はindexPath。
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.cellText = cell.textLabel.text;
    return indexPath;
}

-(void)justLoadInfo{
    [self setCellHeightAndCellText];
}

-(void)loadInfoToEdit{
    
    if (self.newCard == -1) {
        //追加、編集するカード番号を保存。
        NSString *queryForCardNumber = [NSString stringWithFormat:@"insert into cardNumberInfo values(null, '%@')", self.filenameData];
        // Execute the query.
        [self.dbCardNumber executeQuery:queryForCardNumber];
        
        if (self.dbCardNumber.affectedRows != 0) {
            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbCardNumber.affectedRows);
        }else{
            NSLog(@"Could not execute the query.");
        }
    }

    [self setCellHeightAndCellText];
    
    if (self.newCard == -1) {
        self.newCard = 1;
    }
    
    //NSLog(@"newCard %d", self.newCard);
    
    [self.tableView reloadData];
}

- (void)setCellHeightAndCellText{
    // Form the query.
    for (int i = 0; i < 5; i++) {
        // Load the Data
        NSString *query = [NSString stringWithFormat:@"select * from cardTextInfo where cardNumber = %d AND textNumber = %d", self.recordIDToEdit, i];
        self.cardTextInfo = [[NSArray alloc] initWithArray:[self.cardTextManager loadDataFromDB:query]];
        //NSLog(@"count %ld", self.cardTextInfo.count);
        
        // Set the loaded data to the textfields.
        if (self.cardTextInfo.count && i == 0) {
            
            self.textOne.text = [[self.cardTextInfo objectAtIndex:0] objectAtIndex:[self.cardTextManager.arrColumnNames indexOfObject:@"cardText"]];
            
            //改行 new line を数える。
            NSInteger length = [[self.textOne.text  componentsSeparatedByCharactersInSet:
                                 [NSCharacterSet newlineCharacterSet]] count];
            //NSLog(@"lines %ld text %ld", length, self.textOne.text.length);
            
            /*改行 new line を数える別の手段。
             NSInteger lineNum = 0;
             NSString *string = @"abcde\nfghijk\nlmnopq\nrstu";
             NSInteger length = [string length];
             NSRange range = NSMakeRange(0, length);
             while (range.location < length) {
             range = [string lineRangeForRange:NSMakeRange(range.location, 0)];
             range.location = NSMaxRange(range);
             lineNum += 1;
             }
             }*/
            
            if (length == 0) {
                //cellの高さを指定。
                self.customCellHeight = 44;
            }else if (length == 1){
                if (20 < self.textOne.text.length) {
                    self.customCellHeight = 88;
                }else{
                    self.customCellHeight = 44;
                }
            }else if (length == 2){
                if (45 < self.textOne.text.length) {
                    self.customCellHeight = 100;
                }else{
                    self.customCellHeight = 88;
                }
            }else if (length == 3){
                if (80 < self.textOne.text.length) {
                    self.customCellHeight = 176;
                }else{
                    self.customCellHeight = 100;
                }
            }else if (length > 3){
                self.customCellHeight = 176;
            }
            
            //表示可能最大行数を指定する。= 3;　最大３行に指定。= 0;　無制限。
            self.textOne.numberOfLines = 0;
            //Resizes and moves the receiver view so it just encloses its subviews.
            [self.textOne sizeToFit];
            
        }else if (self.cardTextInfo.count && i == 1) {
            self.textTwo.text = [[self.cardTextInfo objectAtIndex:0] objectAtIndex:[self.cardTextManager.arrColumnNames indexOfObject:@"cardText"]];
            
            //改行 new line を数える。
            NSInteger length = [[self.textTwo.text  componentsSeparatedByCharactersInSet:
                                 [NSCharacterSet newlineCharacterSet]] count];
            //NSLog(@"lines %ld text %ld", length, self.textOne.text.length);
            
            if (length == 0) {
                //cellの高さを指定。
                self.customCellHeight_1 = 44;
            }else if (length == 1){
                if (20 < self.textTwo.text.length) {
                    self.customCellHeight_1 = 88;
                }else{
                    self.customCellHeight_1 = 44;
                }
            }else if (length == 2){
                if (45 < self.textTwo.text.length) {
                    self.customCellHeight_1 = 100;
                }else{
                    self.customCellHeight_1 = 88;
                }
            }else if (length == 3){
                if (80 < self.textTwo.text.length) {
                    self.customCellHeight_1 = 176;
                }else{
                    self.customCellHeight_1 = 100;
                }
            }else if (length > 3){
                self.customCellHeight_1 = 176;
            }
            
            //表示可能最大行数を指定する。= 3;　最大３行に指定。= 0;　無制限。
            self.textTwo.numberOfLines = 0;
            //Resizes and moves the receiver view so it just encloses its subviews.
            [self.textTwo sizeToFit];
            
        }else if (self.cardTextInfo.count && i == 2) {
            self.textThree.text = [[self.cardTextInfo objectAtIndex:0] objectAtIndex:[self.cardTextManager.arrColumnNames indexOfObject:@"cardText"]];
            
            //改行 new line を数える。
            NSInteger length = [[self.textThree.text  componentsSeparatedByCharactersInSet:
                                 [NSCharacterSet newlineCharacterSet]] count];
            //NSLog(@"lines %ld text %ld", length, self.textOne.text.length);
            
            if (length == 0) {
                //cellの高さを指定。
                self.customCellHeight_2 = 44;
            }else if (length == 1){
                if (20 < self.textThree.text.length) {
                    self.customCellHeight_2 = 88;
                }else{
                    self.customCellHeight_2 = 44;
                }
            }else if (length == 2){
                if (45 < self.textThree.text.length) {
                    self.customCellHeight_2 = 100;
                }else{
                    self.customCellHeight_2 = 88;
                }
            }else if (length == 3){
                if (80 < self.textThree.text.length) {
                    self.customCellHeight_2 = 176;
                }else{
                    self.customCellHeight_2 = 100;
                }
            }else if (length > 3){
                self.customCellHeight_2 = 176;
            }
            
            //表示可能最大行数を指定する。= 3;　最大３行に指定。= 0;　無制限。
            self.textThree.numberOfLines = 0;
            //Resizes and moves the receiver view so it just encloses its subviews.
            [self.textThree sizeToFit];
            
        }else if (self.cardTextInfo.count && i == 3) {
            self.textFour.text = [[self.cardTextInfo objectAtIndex:0] objectAtIndex:[self.cardTextManager.arrColumnNames indexOfObject:@"cardText"]];
            
            //改行 new line を数える。
            NSInteger length = [[self.textFour.text  componentsSeparatedByCharactersInSet:
                                 [NSCharacterSet newlineCharacterSet]] count];
            //NSLog(@"lines %ld text %ld", length, self.textOne.text.length);
            
            if (length == 0) {
                //cellの高さを指定。
                self.customCellHeight_3 = 44;
            }else if (length == 1){
                if (20 < self.textFour.text.length) {
                    self.customCellHeight_3 = 88;
                }else{
                    self.customCellHeight_3 = 44;
                }
            }else if (length == 2){
                if (45 < self.textFour.text.length) {
                    self.customCellHeight_3 = 100;
                }else{
                    self.customCellHeight_3 = 88;
                }
            }else if (length == 3){
                if (80 < self.textFour.text.length) {
                    self.customCellHeight_3 = 176;
                }else{
                    self.customCellHeight_3 = 100;
                }
            }else if (length > 3){
                self.customCellHeight_3 = 176;
            }
            
            //表示可能最大行数を指定する。= 3;　最大３行に指定。= 0;　無制限。
            self.textFour.numberOfLines = 0;
            //Resizes and moves the receiver view so it just encloses its subviews.
            [self.textFour sizeToFit];
            
        }else if (self.cardTextInfo.count && i == 4) {
            self.textFive.text = [[self.cardTextInfo objectAtIndex:0] objectAtIndex:[self.cardTextManager.arrColumnNames indexOfObject:@"cardText"]];
            
            //改行 new line を数える。
            NSInteger length = [[self.textFive.text  componentsSeparatedByCharactersInSet:
                                 [NSCharacterSet newlineCharacterSet]] count];
            //NSLog(@"lines %ld text %ld", length, self.textOne.text.length);
            
            if (length == 0) {
                //cellの高さを指定。
                self.customCellHeight_4 = 44;
            }else if (length == 1){
                if (20 < self.textFive.text.length) {
                    self.customCellHeight_4 = 88;
                }else{
                    self.customCellHeight_4 = 44;
                }
            }else if (length == 2){
                if (45 < self.textFive.text.length) {
                    self.customCellHeight_4 = 100;
                }else{
                    self.customCellHeight_4 = 88;
                }
            }else if (length == 3){
                if (80 < self.textFive.text.length) {
                    self.customCellHeight_4 = 176;
                }else{
                    self.customCellHeight_4 = 100;
                }
            }else if (length > 3){
                self.customCellHeight_4 = 176;
            }
            
            //表示可能最大行数を指定する。= 3;　最大３行に指定。= 0;　無制限。
            self.textFive.numberOfLines = 0;
            //Resizes and moves the receiver view so it just encloses its subviews.
            [self.textFive sizeToFit];
            
        }else if (self.cardTextInfo.count == 0 && i == 0) {
            self.textOne.text = @"";
        }else if (self.cardTextInfo.count == 0 && i == 1) {
            self.textTwo.text = @"";
        }else if (self.cardTextInfo.count == 0 && i == 2) {
            self.textThree.text = @"";
        }else if (self.cardTextInfo.count == 0 && i == 3) {
            self.textFour.text = @"";
        }else if (self.cardTextInfo.count == 0 && i == 4) {
            self.textFive.text = @"";
        }
    }
}

-(void)editingCardTextInfoWasFinished{
    [self loadInfoToEdit];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.customCellHeight != 0 && indexPath.row == 0) {
        return self.customCellHeight;
    }else if (self.customCellHeight_1 != 0 && indexPath.row == 1) {
        return self.customCellHeight_1;
    }else if (self.customCellHeight_2 != 0 && indexPath.row == 2) {
        return self.customCellHeight_2;
    }else if (self.customCellHeight_3 != 0 && indexPath.row == 3) {
        return self.customCellHeight_3;
    }else if (self.customCellHeight_4 != 0 && indexPath.row == 4) {
        return self.customCellHeight_4;
    }
    return 44.0;
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

@end
