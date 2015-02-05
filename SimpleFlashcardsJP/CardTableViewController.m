//
//  CardTableViewController.m
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/12/10.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import "CardTableViewController.h"
#import "CardListTableViewController.h"
#import "EditCardTableViewController.h"
#import "DataViewController.h"
#import "FilenameDB.h"
#import "FoldernameDB.h"

@interface CardTableViewController ()

@property (nonatomic, strong) FilenameDB *dbFileManager;
@property (nonatomic, strong) FoldernameDB *dbFolderManager;
@property (nonatomic, strong) NSArray *updatedFilename;
@property (nonatomic, strong) NSArray *updatedFoldername;

@end

@implementation CardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //filename取得。
    self.filenameLabel.text = self.filenameData;
    
    self.foldernameLabel.text = self.foldernameData;
    
    //NSLog(@"%@", self.folderID);
    //NSLog(@"filenameData %@", self.filenameData);
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.cardTableViewDelegate editingFileInfoWasFinished];
    //NSLog(@"called");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"CardListTableViewController"]) {
        CardListTableViewController *listView = [segue destinationViewController];
        listView.filenameData = self.filenameData;
        listView.folderID = self.folderID;
        listView.fileID = self.fileID;
        listView.cardListTableViewDelegate = self;
        //NSLog(@"filename %@", listView.filenameData);
        
    }else if([[segue identifier] isEqualToString:@"ChangeFilenameTableViewController"]){
        ChangeFilenameTableViewController *filenameViewController = [segue destinationViewController];
        if (self.fixedFilename != nil) {
            filenameViewController.filenameData = self.fixedFilename;
        }else{
            filenameViewController.filenameData = self.filenameData;
        }
        filenameViewController.foldernameData = self.foldernameData;
        filenameViewController.folderID = self.folderID;
        filenameViewController.fileID = self.fileID;
        filenameViewController.delegate = self;
    }else if([[segue identifier] isEqualToString:@"DataViewController"]){
        DataViewController *dataViewController = [segue destinationViewController];
        dataViewController.filenameData = self.filenameData;
        dataViewController.folderID = self.folderID;
        dataViewController.fileID = self.fileID;
    }else if([[segue identifier] isEqualToString:@"ChangeFoldernameTableViewController"]){
        ChangeFoldernameTableViewController *foldernameViewController = [segue destinationViewController];
        foldernameViewController.foldernameData = self.foldernameData;
        foldernameViewController.folderID = self.folderID;
        foldernameViewController.delegate = self;
    }
}

-(void)editingFileInfoWasFinished{
    // Reload the data.
    [self loadData];
}

-(void)editingFolderInfoWasFinished{
    
    //NSLog(@"self.folderID %ld", self.folderID);
    //FileDB初期化。
    self.dbFolderManager = [[FoldernameDB alloc] initWithDatabaseFilename:@"FoldernameDB.sql"];
    //クエリー作成。arrColumnNamesでindexOfObjectを指定してデータを受け取るにはselect *としなければならない。
    NSString *queryLoad = [NSString stringWithFormat:@"select * from folderInfo where folderInfoID = %ld ", self.folderID];
    //データを読み込んで配列に追加。
    self.updatedFoldername = [[NSArray alloc] initWithArray:[self.dbFolderManager loadDataFromDB:queryLoad]];
    //updatedFoldername0番目のindexOfTextを表示。
    self.foldernameData = [NSString stringWithFormat:@"%@", [[self.updatedFoldername objectAtIndex:0] objectAtIndex:[self.dbFolderManager.arrColumnNames indexOfObject:@"foldername"]]];
    self.foldernameLabel.text = self.foldernameData;
    
    [self.cardTableViewDelegate editingFolderInfoWasFinished];
    
    //self.fixedFoldername = [NSString stringWithFormat:@"%@", [self.updatedFoldername objectAtIndex:0]];
    //self.foldernameLabel.text = self.fixedFoldername;
}

-(void)loadData{
    //FileDB初期化。
    self.dbFileManager = [[FilenameDB alloc] initWithDatabaseFilename:@"FilenameDB.sql"];
    //クエリー作成。
    NSString *queryLoad = [NSString stringWithFormat:@"select * from filenameInfo where fileInfoID = %ld ", self.fileID];
    //NSLog(@"%ld", self.fileID);
    
    //arrColumnNamesでfoldernameのindexを取得。
    //NSInteger indexOfFoldername = [self.dbFileManager.arrColumnNames indexOfObject:@"foldername"];
    
    //データを読み込んで配列に追加。
    self.updatedFilename = [[NSArray alloc] initWithArray:[self.dbFileManager loadDataFromDB:queryLoad]];
    self.fixedFilename = [NSString stringWithFormat:@"%@", [[self.updatedFilename objectAtIndex:0] objectAtIndex:[self.dbFileManager.arrColumnNames indexOfObject:@"filename"]]];
    //NSLog(@"fixedFilename %@", self.fixedFilename);
    
    self.filenameLabel.text = self.fixedFilename;
    self.filenameData = self.filenameLabel.text;
}

-(void)deletingCardInfoWasFinished{
    [self.cardTableViewDelegate reloadTheCard];
}

-(void)addingCardInfoWasFinished{
    [self.cardTableViewDelegate reloadTheCard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 }
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CardTableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
 
 #pragma mark - Table view data source
 
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 // Return the number of sections.
 return 0;
 }
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 // Return the number of rows in the section.
 return 0;
 }
 
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
