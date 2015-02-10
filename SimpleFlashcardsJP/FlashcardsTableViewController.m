//
//  FlashcardsTableViewController.m
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/11/23.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import "FlashcardsTableViewController.h"
#import "AddFileTableViewController.h"
#import "Folder_FileTableViewCell.h"
#import "Folder_File6TableViewCell.h"
#import "Folder_File6PlusTableViewCell.h"
#import "FoldernameDB.h"
#import "FilenameDB.h"
#import "CardNumber.h"
#import "CardText.h"

@interface FlashcardsTableViewController ()

@property (nonatomic, strong) FoldernameDB *dbFolderManager;
@property (nonatomic, strong) NSArray *folderInfoDB;
@property (nonatomic, strong) NSString *cellText;
@property (nonatomic, strong) NSArray *actionButtonItems;
@property (nonatomic, strong) FilenameDB *dbFileManager;
@property (nonatomic, strong) NSArray *dbFileInfo;
@property (nonatomic, assign) BOOL editIsTapped;
@property (nonatomic, strong) NSArray *updatedFoldername;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, assign) NSInteger countNum;
@property (nonatomic, strong) NSArray *detectFileID;
@property (nonatomic, strong) NSArray *countFile;
@property (nonatomic, strong) CardNumber *dbCardNumber;
@property (nonatomic, strong) CardText *cardTextManager;

-(void)loadData;

@end

@implementation FlashcardsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    self.tableView.rowHeight = 44;
    
    //@selector()で指定メソッドをコール
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFolder:)];
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editingButtonPressed:)];
    
    self.actionButtonItems = @[editItem, addItem];
    self.navigationItem.rightBarButtonItems = self.actionButtonItems;
    self.editIsTapped = NO;
    
    // Initialize the dbManager property.
    self.dbFolderManager = [[FoldernameDB alloc] initWithDatabaseFilename:@"FoldernameDB.sql"];
    self.dbFileManager = [[FilenameDB alloc] initWithDatabaseFilename:@"FilenameDB.sql"];
    self.dbCardNumber = [[CardNumber alloc] initWithDatabaseFilename:@"CardNumberDB.sql"];
    self.cardTextManager = [[CardText alloc] initWithDatabaseFilename:@"CardText.sql"];
    
    [self loadData];
    
    //NSLog(@"width=%f",self.view.bounds.size.width);
    //NSLog(@"height=%f",self.view.bounds.size.height);
}

-(void)addFolder: (UIBarButtonItem *)sender{
    CreateFolderTableViewController *createFolder =[[CreateFolderTableViewController alloc] init];
    createFolder.folderDelegate = self;
    
    [self performSegueWithIdentifier:@"CreateFolderTableViewController" sender:sender];
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

//didSelectにすると値が渡せない。値を渡す時はwillSelectとする。戻り値はindexPath。indexPathRowの数だけ処理が繰り返される。
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSInteger indexOfFoldername = [self.dbFolderManager.arrColumnNames indexOfObject:@"foldername"];
    self.cellText = [NSString stringWithFormat:@"%@", [[self.folderInfoDB objectAtIndex:indexPath.row] objectAtIndex:indexOfFoldername]];
    
    //NSLog(@"indexPath %ld", indexPath.row);
    self.selectedRow = indexPath.row;
    
    return indexPath;
}

/*
- (void)detectSelectedNumber{
    for (int i = 0 ; i < self.selectedRow; i++) {
        NSString *selectedStr = [NSString stringWithFormat:@"%@", [[self.folderInfoDB objectAtIndex:i] objectAtIndex:[self.dbFolderManager.arrColumnNames indexOfObject:@"foldername"]]];
        if ([selectedStr isEqualToString:self.cellText]) {
            self.countNum += 1;
        }
    }
}*/

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"CreateFolderTableViewController"]) {
        CreateFolderTableViewController *createFolder = [segue destinationViewController];
        createFolder.folderDelegate = self;
    }else if ([[segue identifier] isEqualToString:@"AddFileTableViewController"]){
        AddFileTableViewController *fileView = [segue destinationViewController];
        fileView.foldernameData = self.cellText;
        fileView.AddFileTableViewDelegate = self;
        
        // Prepare the query.
        NSInteger indexOfID = [self.dbFolderManager.arrColumnNames indexOfObject:@"folderInfoID"];
        NSInteger folderID = [[[self.folderInfoDB objectAtIndex:self.selectedRow] objectAtIndex:indexOfID] integerValue];
        
        fileView.folderID = folderID;
        //NSLog(@"folderID %ld", folderID);
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the selected record.
        // Find the filename.
        
        //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSInteger indexOfFoldername = [self.dbFolderManager.arrColumnNames indexOfObject:@"foldername"];
        self.cellText = [NSString stringWithFormat:@"%@", [[self.folderInfoDB objectAtIndex:indexPath.row] objectAtIndex:indexOfFoldername]];
        self.selectedRow = indexPath.row;
        //NSLog(@"%ld", self.selectedRow);
        
        // Prepare the query.フォルダーを削除。
        NSInteger indexOfID = [self.dbFolderManager.arrColumnNames indexOfObject:@"folderInfoID"];
        NSInteger checkFolderID = [[[self.folderInfoDB objectAtIndex:self.selectedRow] objectAtIndex:indexOfID] integerValue];
        //NSLog(@"selectedRow checkFolderID %ld", checkFolderID);
        NSString *queryFolderID = [NSString stringWithFormat:@"delete from folderInfo where folderInfoID = %ld", checkFolderID];
        [self.dbFolderManager executeQuery:queryFolderID];
        
        //選択したセルのfileIDを特定する。
        NSString *queryForFileID = [NSString stringWithFormat:@"select * from filenameInfo where foldername = '%@' ", [NSString stringWithFormat:@"%ld", checkFolderID]];
        self.detectFileID = [self.dbFileManager loadDataFromDB:queryForFileID];
        if (self.detectFileID.count != 0) {
            for (int i = 0; i < self.detectFileID.count; i++) {
                NSInteger indexOfFileID = [self.dbFileManager.arrColumnNames indexOfObject:@"fileInfoID"];
                NSInteger fileID = [[[self.detectFileID objectAtIndex:i] objectAtIndex:indexOfFileID] integerValue];
                //NSLog(@"fileID %ld", fileID);
                
                //カード番号を削除。
                NSString *queryCardNum = [NSString stringWithFormat:@"delete from cardNumberInfo where filename = '%@' ", [NSString stringWithFormat:@"%ld", fileID]];
                [self.dbCardNumber executeQuery:queryCardNum];
                //カードテキストを削除。
                NSString *queryCardTxt = [NSString stringWithFormat:@"delete from cardTextInfo where filename = '%@' ", [NSString stringWithFormat:@"%ld", fileID]];
                [self.cardTextManager executeQuery:queryCardTxt];
            }
        }
        //ファイルを削除。
        NSString *queryForFile = [NSString stringWithFormat:@"delete from filenameInfo where foldername = '%@' ", [NSString stringWithFormat:@"%ld", checkFolderID]];
        [self.dbFileManager executeQuery:queryForFile];
        
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
    return self.folderInfoDB.count;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath{
    //セルのinsetをゼロにする。
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"FolderFileCell";
    Folder_FileTableViewCell *cell = (Folder_FileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Folder_FileTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSInteger indexOfFoldername = [self.dbFolderManager.arrColumnNames indexOfObject:@"foldername"];
    cell.textLabel_1.text = [NSString stringWithFormat:@"%@", [[self.folderInfoDB objectAtIndex:indexPath.row] objectAtIndex:indexOfFoldername]];
    
    //各フォルダーのファイル数を表示。選択したセルのfolderIDを特定する。
    NSInteger indexOfID = [self.dbFolderManager.arrColumnNames indexOfObject:@"folderInfoID"];
    NSInteger checkFolderID = [[[self.folderInfoDB objectAtIndex:indexPath.row] objectAtIndex:indexOfID] integerValue];
    //NSLog(@"indexPath checkFolderID %ld", checkFolderID);
    
    NSString *queryForFileID = [NSString stringWithFormat:@"select * from filenameInfo where foldername = '%@' ", [NSString stringWithFormat:@"%ld", checkFolderID]];
    self.countFile = [self.dbFileManager loadDataFromDB:queryForFileID];
    
    if (self.countFile.count == 0) {
        cell.textLabel_2.text = [NSString stringWithFormat:@"%d Files", 0];
        //cell.textLabel_2.text = [NSString stringWithFormat:@"%d Files", (arc4random() % 20)];
    }else{
        if (99 < self.countFile.count) {
            cell.textLabel_2.text = [NSString stringWithFormat:@"%ld", self.countFile.count];
        }else{
            cell.textLabel_2.text = [NSString stringWithFormat:@"%ld Files", self.countFile.count];
        }
    }
    
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    
    if (iOSDeviceScreenSize.height == 667) {
        static NSString *cellIdentifier = @"FolderFileCell6";
        Folder_FileTableViewCell *cell = (Folder_FileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Folder_File6TableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.textLabel_1.text = [NSString stringWithFormat:@"%@", [[self.folderInfoDB objectAtIndex:indexPath.row] objectAtIndex:indexOfFoldername]];
        if (self.countFile.count == 0) {
            cell.textLabel_2.text = [NSString stringWithFormat:@"%d Files", 0];
            //cell.textLabel_2.text = [NSString stringWithFormat:@"%d Files", (arc4random() % 20)];
        }else{
            if (99 < self.countFile.count) {
                cell.textLabel_2.text = [NSString stringWithFormat:@"%ld", self.countFile.count];
            }else{
                cell.textLabel_2.text = [NSString stringWithFormat:@"%ld Files", self.countFile.count];
            }
        }
        
        return cell;
        
    }else if (iOSDeviceScreenSize.height == 736) {
        static NSString *cellIdentifier = @"FolderFileCell6Plus";
        Folder_FileTableViewCell *cell = (Folder_FileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Folder_File6PlusTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.textLabel_1.text = [NSString stringWithFormat:@"%@", [[self.folderInfoDB objectAtIndex:indexPath.row] objectAtIndex:indexOfFoldername]];
        if (self.countFile.count == 0) {
            cell.textLabel_2.text = [NSString stringWithFormat:@"%d Files", 0];
            //cell.textLabel_2.text = [NSString stringWithFormat:@"%d Files", (arc4random() % 20)];
        }else{
            if (99 < self.countFile.count) {
                cell.textLabel_2.text = [NSString stringWithFormat:@"%ld", self.countFile.count];
            }else{
                cell.textLabel_2.text = [NSString stringWithFormat:@"%ld Files", self.countFile.count];
            }
        }
        
        return cell;
    }
    
    return cell;
}

//CustomCellを設定したのでdidSelectRowでsegueを実行する。didSelectRowを呼ばないと遷移されない。
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"AddFileTableViewController" sender:self.tableView];
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
    NSString *query = @"select * from folderInfo";
    NSString *queryForFile = @"select * from filenameInfo";
    
    // Get the results.
    if (self.folderInfoDB != nil) {
        self.folderInfoDB = nil;
    }
    if (self.dbFileInfo != nil) {
        self.dbFileInfo = nil;
    }
    
    self.folderInfoDB = [[NSArray alloc] initWithArray:[self.dbFolderManager loadDataFromDB:query]];
    self.dbFileInfo = [[NSArray alloc] initWithArray:[self.dbFileManager loadDataFromDB:queryForFile]];
    //NSLog(@"%ld", self.folderInfoDB.count);
    
    //reloadDataでcellForRowAtIndexPath...等が再度呼ばれてデータが更新される。
    [self.tableView reloadData];
}

-(void)folderEditingInfoWasFinished{
    // Reload the data.
    //NSLog(@"called editing");
    [self loadData];
}

-(void)editingFolderInfoWasFinished{
    // Reload the data.
    //NSLog(@"called editing");
    [self loadData];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 
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
