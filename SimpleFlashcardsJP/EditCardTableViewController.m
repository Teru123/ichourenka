//
//  EditCardTableViewController.m
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/12/11.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import "EditCardTableViewController.h"
#import "EnterCardnameTableViewController.h"
#import "CardText.h"
#import "CardNumber.h"

@interface EditCardTableViewController ()

@property (nonatomic, strong) NSString *titlenumberOfThis;
@property (nonatomic, strong) CardText *cardTextManager;
@property (nonatomic, strong) NSArray *cardTextInfo;
@property (nonatomic, strong) NSString *cellText;
@property (nonatomic, strong) CardNumber *dbCardNumber;
@property (nonatomic, strong) NSArray *arrCNInfo;

-(void)loadInfoToEdit;

@end

@implementation EditCardTableViewController

- (void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize the dbManager object.
    self.cardTextManager = [[CardText alloc] initWithDatabaseFilename:@"CardText.sql"];
    self.dbCardNumber = [[CardNumber alloc] initWithDatabaseFilename:@"CardNumber.sql"];
    
    // Check if should load specific record for editing.
    if (self.recordIDToEdit != -1) {
        // Load the record with the specific ID from the database.
        [self loadInfoToEdit];
    }
    NSLog(@"%@", self.filenameData);
    NSLog(@"recordID %d", self.recordIDToEdit);
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"EnterCardnameTableViewController1"]) {
        EnterCardnameTableViewController *cardnameView = [segue destinationViewController];
        cardnameView.titleNumber = @"1";
        cardnameView.filenameData = self.filenameData;
        cardnameView.cellText = self.cellText;
        cardnameView.recordIDToEdit = self.recordIDToEdit;
        cardnameView.cardTextDelegate = self;
    }else if ([[segue identifier] isEqualToString:@"EnterCardnameTableViewController2"]) {
        EnterCardnameTableViewController *cardnameView = [segue destinationViewController];
        cardnameView.titleNumber = @"2";
        cardnameView.filenameData = self.filenameData;
        cardnameView.cellText = self.cellText;
        cardnameView.recordIDToEdit = self.recordIDToEdit;
        cardnameView.cardTextDelegate = self;
    }else if ([[segue identifier] isEqualToString:@"EnterCardnameTableViewController3"]) {
        EnterCardnameTableViewController *cardnameView = [segue destinationViewController];
        cardnameView.titleNumber = @"3";
        cardnameView.filenameData = self.filenameData;
        cardnameView.cellText = self.cellText;
        cardnameView.recordIDToEdit = self.recordIDToEdit;
        cardnameView.cardTextDelegate = self;
    }else if ([[segue identifier] isEqualToString:@"EnterCardnameTableViewController4"]) {
        EnterCardnameTableViewController *cardnameView = [segue destinationViewController];
        cardnameView.titleNumber = @"4";
        cardnameView.filenameData = self.filenameData;
        cardnameView.cellText = self.cellText;
        cardnameView.recordIDToEdit = self.recordIDToEdit;
        cardnameView.cardTextDelegate = self;
    }else if ([[segue identifier] isEqualToString:@"EnterCardnameTableViewController5"]) {
        EnterCardnameTableViewController *cardnameView = [segue destinationViewController];
        cardnameView.titleNumber = @"5";
        cardnameView.filenameData = self.filenameData;
        cardnameView.cellText = self.cellText;
        cardnameView.recordIDToEdit = self.recordIDToEdit;
        cardnameView.cardTextDelegate = self;
    }
}

//didSelectにすると値が渡せない。値を渡す時はwillSelectとする。戻り値はindexPath。
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.cellText = cell.textLabel.text;
    return indexPath;
}

-(void)loadInfoToEdit{
    // Form the query.
    for (int i = 0; i < 5; i++) {
        NSString *query = [NSString stringWithFormat:@"select * from cardTextInfo where cardNumber = %d AND textNumber = %d", self.recordIDToEdit, i];
        self.cardTextInfo = [[NSArray alloc] initWithArray:[self.cardTextManager loadDataFromDB:query]];
        NSLog(@"count %ld", self.cardTextInfo.count);
        
        // Set the loaded data to the textfields.
        if (self.cardTextInfo.count && i == 0) {
            self.textOne.text = [[self.cardTextInfo objectAtIndex:0] objectAtIndex:[self.cardTextManager.arrColumnNames indexOfObject:@"cardText"]];
        }else if (self.cardTextInfo.count && i == 1) {
            self.textTwo.text = [[self.cardTextInfo objectAtIndex:0] objectAtIndex:[self.cardTextManager.arrColumnNames indexOfObject:@"cardText"]];
        }else if (self.cardTextInfo.count && i == 2) {
            self.textThree.text = [[self.cardTextInfo objectAtIndex:0] objectAtIndex:[self.cardTextManager.arrColumnNames indexOfObject:@"cardText"]];
        }else if (self.cardTextInfo.count && i == 3) {
            self.textFour.text = [[self.cardTextInfo objectAtIndex:0] objectAtIndex:[self.cardTextManager.arrColumnNames indexOfObject:@"cardText"]];
        }else if (self.cardTextInfo.count && i == 4) {
            self.textFive.text = [[self.cardTextInfo objectAtIndex:0] objectAtIndex:[self.cardTextManager.arrColumnNames indexOfObject:@"cardText"]];
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
    
    [self.tableView reloadData];
}

-(void)editingCardTextInfoWasFinished{
    [self loadInfoToEdit];
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
