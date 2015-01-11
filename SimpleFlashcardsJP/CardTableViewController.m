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


@interface CardTableViewController ()

@property (nonatomic, strong) FilenameDB *dbFileManager;
@property (nonatomic, strong) NSArray *updatedFilename;

@end

@implementation CardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //filename取得。
    self.filenameLabel.text = self.filenameData;
    
    //AddFileTableViewからCardListTableViewControllerに直接遷移阻止。editCardsOrNotのStringで判断。
    if (![self.editCardsOrNot isEqualToString:@"CardListTableViewController"]) {
        [self performSegueWithIdentifier:@"CardListTableViewController" sender:self];
        
    }
    
    //NSLog(@"filenameData %@", self.filenameData);
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.delegate editingFileInfoWasFinished];
    //NSLog(@"called");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"CardListTableViewController"]) {
        CardListTableViewController *listView = [segue destinationViewController];
        listView.filenameData = self.filenameData;
        //NSLog(@"filename %@", listView.filenameData);
        
    }else if([[segue identifier] isEqualToString:@"ChangeFilenameTableViewController"]){
        ChangeFilenameTableViewController *changeFilenameViewController = [segue destinationViewController];
        
        if (self.fixedFilename != nil) {
            changeFilenameViewController.filenameData = self.fixedFilename;
        }else{
            changeFilenameViewController.filenameData = self.filenameData;
        }
        changeFilenameViewController.foldernameData = self.foldernameData;
        changeFilenameViewController.delegate = self;
        
    }else if([[segue identifier] isEqualToString:@"DataViewController"]){
        //DataViewController *dataViewController = [segue destinationViewController];
        
        
    }
}

-(void)editingFileInfoWasFinished{
    // Reload the data.
    [self loadData];
}

-(void)loadData{
    //FileDB初期化。
    self.dbFileManager = [[FilenameDB alloc] initWithDatabaseFilename:@"FilenameDB.sql"];
    NSString *queryLoad = [NSString stringWithFormat:@"select filename from filenameInfo where foldername = '%@' ", self.foldernameData];
    
    //arrColumnNamesでfoldernameのindexを取得。
    //NSInteger indexOfFoldername = [self.dbFileManager.arrColumnNames indexOfObject:@"foldername"];
    
    //データを読み込んで配列に追加。
    self.updatedFilename = [[NSArray alloc] initWithArray:[self.dbFileManager loadDataFromDB:queryLoad]];
    
    self.fixedFilename = [NSString stringWithFormat:@"%@", [self.updatedFilename objectAtIndex:0]];
    
    // searchResultsのデータを渡す為に不要なStringを削除する。
    self.fixedFilename = [self.fixedFilename stringByReplacingOccurrencesOfString:@"(" withString:@""];
    self.fixedFilename = [self.fixedFilename stringByReplacingOccurrencesOfString:@")" withString:@""];
    //最初の文字までの不要なStringを削除する。
    if ([self.fixedFilename rangeOfString:@" " options:0 range:NSMakeRange(0, 5)].location != NSNotFound) {
        self.fixedFilename = [self.fixedFilename stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@""];
    }
    //最後列の改行だけを削除する。
    self.fixedFilename = [self.fixedFilename stringByReplacingCharactersInRange:NSMakeRange(self.fixedFilename.length - 1, 1) withString:@""];
    //Stringに変わった改行を改行と認識させる。
    self.fixedFilename = [self.fixedFilename stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    self.fixedFilename = [self.fixedFilename stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    NSLog(@"%@", self.fixedFilename);
    
    self.filenameLabel.text = [NSString stringWithFormat:@"%@", self.fixedFilename];
    self.filenameData = self.filenameLabel.text;
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
