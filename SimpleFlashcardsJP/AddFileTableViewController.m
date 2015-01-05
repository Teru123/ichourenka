//
//  AddFileTableViewController.m
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/12/04.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import "AddFileTableViewController.h"
#import "CreateFileTableViewController.h"
#import "CardTableViewController.h"
#import "FilenameDB.h"
#import "CardNumber.h"
#import "CardText.h"

@interface AddFileTableViewController ()

@property (nonatomic, strong) FilenameDB *dbFileManager;
@property (nonatomic, strong) NSArray *dbFileInfo;
@property (nonatomic, strong) NSArray *actionButtonItems;
@property (nonatomic, strong) NSString *cellText;
@property (nonatomic, assign) BOOL editIsTapped;
@property (nonatomic, strong) CardText *dbCardText;
@property (nonatomic, strong) CardNumber *dbCardNumber;

-(void)loadData;

@end

@implementation AddFileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    //@selector()で指定メソッドをコール
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFile:)];
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editingButtonPressed:)];
    
    self.actionButtonItems = @[editItem, addItem];
    self.navigationItem.rightBarButtonItems = self.actionButtonItems;
    self.editIsTapped = NO;
    
    //NSLog(@"%@", self.foldernameData);
    
    // Initialize the dbManager property.
    self.dbFileManager = [[FilenameDB alloc] initWithDatabaseFilename:@"FilenameDB.sql"];
    self.dbCardNumber = [[CardNumber alloc] initWithDatabaseFilename:@"CardNumber.sql"];
    self.dbCardText = [[CardText alloc] initWithDatabaseFilename:@"CardText.sql"];
    
    [self loadData];
}

-(void)addFile: (UIBarButtonItem *)sender{
    //self.navigationcontroller it's not navigationcontroller in this case
    //sender: The object that you want to use to initiate the segue.
    [self performSegueWithIdentifier:@"CreateFileTableViewController" sender:sender];
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
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFile:)];
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editingButtonPressed:)];
    
    self.actionButtonItems = @[editItem, addItem];
    self.navigationItem.rightBarButtonItems = self.actionButtonItems;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"CreateFileTableViewController"]){
        CreateFileTableViewController *fileView = [segue destinationViewController];
        fileView.foldernameData = self.foldernameData;
        fileView.filenameData = self.cellText;
        fileView.fileDelegate = self;
    }else if ([[segue identifier] isEqualToString:@"AddToEditCards"]){
        CardTableViewController *editCards = [segue destinationViewController];
        
        //CardListTableViewControllerに遷移させないようにeditCardsOrNotを設定。
        editCards.editCardsOrNot = @"CardListTableViewController";
        
        editCards.filenameData = self.cellText;
        editCards.foldernameData = self.foldernameData;
        editCards.delegate = self;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the selected record.
        // Prepare the query.
        NSString *query = [NSString stringWithFormat:@"delete from filenameInfo where filename = '%@' ", self.cellText];
        NSLog(@"%@", query);
        // Execute the query.
        [self.dbFileManager executeQuery:query];
        
        // Prepare the query.
        NSString *queryCN = [NSString stringWithFormat:@"delete from cardNumberInfo where filename = '%@' ", self.cellText];
        // Execute the query.
        [self.dbCardNumber executeQuery:queryCN];
        
        NSString *queryText = [NSString stringWithFormat:@"delete from cardTextInfo where filename = '%@' ", self.cellText];
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.cellText = cell.textLabel.text;

    return indexPath;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dbFileInfo.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FileViewCell" forIndexPath:indexPath];
    
    NSInteger indexOfFoldername = [self.dbFileManager.arrColumnNames indexOfObject:@"filename"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.dbFileInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfFoldername]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", 0];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)loadData{
    // Form the query.
    NSString *query = [NSString stringWithFormat:@"select * from filenameInfo where foldername = '%@' ", self.foldernameData];
    self.dbFileInfo = [[NSArray alloc] initWithArray:[self.dbFileManager loadDataFromDB:query]];
    
    //NSLog(@"%ld", self.dbFileInfo.count);
    
    [self.tableView reloadData];
}

-(void)editingFileInfoWasFinished{
    [self loadData];
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
