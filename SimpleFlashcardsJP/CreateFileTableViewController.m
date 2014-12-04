//
//  CreateFileTableViewController.m
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/12/04.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import "CreateFileTableViewController.h"
#import "EnterFileNameTableViewController.h"
#import "FolderNameDB.h"
#import "FileDB.h"

@interface CreateFileTableViewController ()

@property (nonatomic, strong) FolderNameDB *dbFolderManager;
@property (nonatomic, strong) NSArray *folderInfo;
@property (nonatomic, strong) FileDB *dbFileManager;
//@property (nonatomic, strong) NSArray *folderInfoDB;
@property (nonatomic, assign) NSInteger indexOfFolder;
@property (nonatomic, assign) NSInteger indexOfFolderMenu;

-(void)loadData;

@end

@interface CreateFileTableViewController ()

@end

@implementation CreateFileTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    // Initialize the dbManager property.
    //FolderNameDB初期化
    self.dbFolderManager = [[FolderNameDB alloc] initWithDatabaseFilename:@"FolderName.sql"];
    //FileDB初期化
    self.dbFileManager = [[FileDB alloc] initWithDatabaseFilename:@"FileDB.sql"];
    //FileDBの読込み
    //NSString *queryToSave = @"select * from folderInfo";
    //self.folderInfoDB = [[NSArray alloc] initWithArray:[self.dbFileManager loadDataFromDB:queryToSave]];
    
    // Load the data.
    [self loadData];
    [super viewDidLoad];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    EnterFileNameTableViewController *editInfoViewController = [segue destinationViewController];
    editInfoViewController.delegate = self;
}

-(void)editingInfoWasFinished{
    // Reload the data.
    [self loadData];
}

-(void)loadData{
    // Form the query.
    NSString *query = @"select * from FolderNameInfo";
    
    //Load specific data
    NSString *queryLoad = @"select * from FolderNameInfo";
    self.folderInfo = [[NSArray alloc] initWithArray:[self.dbFolderManager loadDataFromDB:queryLoad]];
    
    // Get the results.
    if (self.folderInfo.count != 0) {
        self.folderInfo = [[NSArray alloc] initWithArray:[self.dbFolderManager loadDataFromDB:query]];
        NSInteger indexOfFoldername = [self.dbFolderManager.arrColumnNames indexOfObject:@"foldername"];
        _fileName.text = [NSString stringWithFormat:@"ファイル名   %@", [[self.folderInfo objectAtIndex:0] objectAtIndex:indexOfFoldername]];
        //_folderName.text = [NSString stringWithFormat:@"Folder Name   %@", [[self.folderInfo objectAtIndex:0] objectAtIndex:0]];
    }
    
    
    // Reload the table view.
    [self.tableView reloadData];
}

#pragma mark - Table view data source
//セルが選択された時の挙動を決定する。
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        //作成タップでフォルダーに表示する名前をFolderName.sqlからFileDB.sqlに移す
        NSString *queryInsert;
        //FolderName.sqlから
        self.indexOfFolder = [self.dbFolderManager.arrColumnNames indexOfObject:@"foldername"];
        //FileDB.sqlへ
        //self.indexOfFolderMenu = [self.dbFileManager.arrColumnNames indexOfObject:@"fileInfoID"];
        
        queryInsert = [NSString stringWithFormat:@"insert into fileInfo values(null, '%@')", [[self.folderInfo objectAtIndex:0] objectAtIndex:self.indexOfFolder]];
        // Execute the query.
        [self.dbFileManager executeQuery:queryInsert];
        
        /*else if (self.folderInfoDB.count == 0){
         queryInsert = [NSString stringWithFormat:@"insert into folderInfo values(%d, '%@')", 0, [[self.folderInfo objectAtIndex:0] objectAtIndex:self.indexOfFolderMenu]];
         // Execute the query.
         [self.dbFileManager executeQuery:queryInsert];
         }*/
        
        //Load specific data to delete
        NSString *queryLoad = @"select * from FolderNameInfo";
        self.folderInfo = [[NSArray alloc] initWithArray:[self.dbFolderManager loadDataFromDB:queryLoad]];
        
        if (self.folderInfo.count != 0) {
            // Prepare the query.
            NSString *query = [NSString stringWithFormat:@"delete from FolderNameInfo where foldernameinfoID=%d", 1];
            NSLog(@"%@", query);
            
            // Execute the query.
            [self.dbFolderManager executeQuery:query];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
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
    return 1;
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
