//
//  AddFileTableViewController.m
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/12/04.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import "AddFileTableViewController.h"
#import "FilenameDB.h"
#import "CreateFileTableViewController.h"

@interface AddFileTableViewController ()

@property (nonatomic, strong) FilenameDB *dbFileManager;
@property (nonatomic, strong) NSArray *dbFileInfo;

-(void)loadData;

@end

@implementation AddFileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    //@selector()で指定メソッドをコール
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFile:)];
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:nil];
    
    NSArray *actionButtonItems = @[editItem, addItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    NSLog(@"%@", self.foldernameData);
    // Initialize the dbManager property.
    self.dbFileManager = [[FilenameDB alloc] initWithDatabaseFilename:@"FilenameDB.sql"];
    [self loadData];
}

-(void)addFile: (UIBarButtonItem *)sender{
    //self.navigationcontroller it's not navigationcontroller in this case
    //sender: The object that you want to use to initiate the segue.
    [self performSegueWithIdentifier:@"CreateFileTableViewController" sender:sender];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"CreateFileTableViewController"]){
        CreateFileTableViewController *fileView = [segue destinationViewController];
        fileView.foldernameData = self.foldernameData;
    }
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

/*
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
