//
//  CreateFileTableViewController.m
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/12/04.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import "CreateFileTableViewController.h"
#import "EnterFileNameTableViewController.h"
#import "CardTableViewController.h"
#import "FolderNameDB.h"
#import "FilenameDB.h"

@interface CreateFileTableViewController ()

@property (nonatomic, strong) FoldernameDB *dbFolderManager;
@property (nonatomic, strong) NSArray *folderInfo;
@property (nonatomic, strong) FilenameDB *dbFileManager;
@property (nonatomic, assign) NSInteger indexOfFolder;
@property (nonatomic, assign) NSInteger indexOfFolderMenu;
@property (nonatomic, strong) NSString *cellText;

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
    self.dbFolderManager = [[FoldernameDB alloc] initWithDatabaseFilename:@"FolderName.sql"];
    //FileDB初期化
    self.dbFileManager = [[FilenameDB alloc] initWithDatabaseFilename:@"FilenameDB.sql"];
    
    //NSLog(@"%@", self.foldernameData);
    
    // 画面上部に標準サイズのビューを作成する
    // 利用可能な広告サイズの定数値は GADAdSize.h で説明されている
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    
    if (iOSDeviceScreenSize.height == 667) {
        // Replace this ad unit ID with your own ad unit ID.
        self.bannerView6.adUnitID = @"ca-app-pub-9302632653080358/9670618628";
        self.bannerView6.rootViewController = self;
        
        GADRequest *request = [GADRequest request];
        
        // Requests test ads on devices you specify. Your test device ID is printed to the console when
        // an ad request is made. GADBannerView automatically returns test ads when running on a
        // simulator.
        //request.testDevices = @[@"2077ef9a63d2b398840261c8221a0c9a"  // Eric's iPod Touch];
        
        [self.bannerView6 loadRequest:request];
    }else if (iOSDeviceScreenSize.height == 736) {
        // Replace this ad unit ID with your own ad unit ID.
        self.bannerView6Plus.adUnitID = @"ca-app-pub-9302632653080358/9670618628";
        self.bannerView6Plus.rootViewController = self;
        
        GADRequest *request = [GADRequest request];
        
        // Requests test ads on devices you specify. Your test device ID is printed to the console when
        // an ad request is made. GADBannerView automatically returns test ads when running on a
        // simulator.
        //request.testDevices = @[@"2077ef9a63d2b398840261c8221a0c9a"  // Eric's iPod Touch];
        
        [self.bannerView6Plus loadRequest:request];
    }else if (iOSDeviceScreenSize.height == 480){
        // Replace this ad unit ID with your own ad unit ID.
        self.bannerViewFour.adUnitID = @"ca-app-pub-9302632653080358/9670618628";
        self.bannerViewFour.rootViewController = self;
        
        GADRequest *request = [GADRequest request];
        
        // Requests test ads on devices you specify. Your test device ID is printed to the console when
        // an ad request is made. GADBannerView automatically returns test ads when running on a
        // simulator.
        //request.testDevices = @[@"2077ef9a63d2b398840261c8221a0c9a"  // Eric's iPod Touch];
        
        [self.bannerViewFour loadRequest:request];
    }else if (iOSDeviceScreenSize.height == 568){
        // Replace this ad unit ID with your own ad unit ID.
        self.bannerView.adUnitID = @"ca-app-pub-9302632653080358/9670618628";
        self.bannerView.rootViewController = self;
        
        GADRequest *request = [GADRequest request];
        
        // Requests test ads on devices you specify. Your test device ID is printed to the console when
        // an ad request is made. GADBannerView automatically returns test ads when running on a
        // simulator.
        //request.testDevices = @[@"2077ef9a63d2b398840261c8221a0c9a"  // Eric's iPod Touch];
        
        [self.bannerView loadRequest:request];
    }else{
        // Replace this ad unit ID with your own ad unit ID.
        self.bannerView.adUnitID = @"ca-app-pub-9302632653080358/9670618628";
        self.bannerView.rootViewController = self;
        
        GADRequest *request = [GADRequest request];
        
        // Requests test ads on devices you specify. Your test device ID is printed to the console when
        // an ad request is made. GADBannerView automatically returns test ads when running on a
        // simulator.
        //request.testDevices = @[@"2077ef9a63d2b398840261c8221a0c9a"  // Eric's iPod Touch];
        
        [self.bannerView loadRequest:request];
    }
    
    // Load the data.
    [self loadData];
    [super viewDidLoad];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"EnterFileNameTableViewController"]){
        EnterFileNameTableViewController *editInfoViewController = [segue destinationViewController];
        editInfoViewController.delegate = self;
    }
}

-(void)editingInfoWasFinished{
    // Reload the data.
    [self loadData];
}

-(void)loadData{
    // Form the query.
    NSString *query = @"select * from FolderNameInfo";
    self.folderInfo = [[NSArray alloc] initWithArray:[self.dbFolderManager loadDataFromDB:query]];
    
    // Get the results.
    if (self.folderInfo.count != 0) {
        self.folderInfo = [[NSArray alloc] initWithArray:[self.dbFolderManager loadDataFromDB:query]];
        //arrColumnNamesでfoldernameのindexを取得。
        NSInteger indexOfFoldername = [self.dbFolderManager.arrColumnNames indexOfObject:@"foldername"];
        //foldernameの0番目の値を取得。
        self.fileName.text = [NSString stringWithFormat:@"%@", [[self.folderInfo objectAtIndex:0] objectAtIndex:indexOfFoldername]];
    }
    //NSLog(@"%@", self.foldernameData);
    
    // Reload the table view.
    [self.tableView reloadData];
}

#pragma mark - Table view data source
//セルが選択された時の挙動を決定する。
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSCharacterSet, stringByTrimmingCharactersInSetでスペースだけでないかチェック。
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    if (indexPath.row == 1 && ![[self.fileName.text stringByTrimmingCharactersInSet: set] length] == 0) {
        //作成タップでフォルダーに表示する名前をFolderName.sqlからFileDB.sqlに移す
        NSString *queryInsert;
        //FolderName.sqlから
        self.indexOfFolder = [self.dbFolderManager.arrColumnNames indexOfObject:@"foldername"];
        //FileDB.sqlへ
        NSString *folderIDStr = [NSString stringWithFormat:@"%ld", self.folderID];
        
        NSString *filename = [[self.folderInfo objectAtIndex:0] objectAtIndex:self.indexOfFolder];
        //single quoteがあるかチェック。あればtwo single quotesにしてsyntax errorを避ける。
        filename = [filename stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        //NSLog(@"filename %@", filename);
        queryInsert = [NSString stringWithFormat:@"insert into filenameInfo values(null, '%@', '%@')", filename, folderIDStr];
        // Execute the query.
        [self.dbFileManager executeQuery:queryInsert];
        
        //Load specific data to delete
        NSString *queryLoad = @"select * from FolderNameInfo";
        self.folderInfo = [[NSArray alloc] initWithArray:[self.dbFolderManager loadDataFromDB:queryLoad]];
        
        //新しいfoldernameを作る為に古いのを消す
        if (self.folderInfo.count != 0) {
            // Prepare the query.
            NSString *query = [NSString stringWithFormat:@"delete from FolderNameInfo where foldernameinfoID=%d", 1];
            //NSLog(@"%@", query);
            
            // Execute the query.
            [self.dbFolderManager executeQuery:query];
        }
        
        // Inform the delegate that the editing was finished.
        [self.fileDelegate editingFileInfoWasFinished];
        
        self.fileName.text = [NSString stringWithFormat:@""];
        //前画面に戻る。
        [self.navigationController popViewControllerAnimated:YES];
    }else if (indexPath.row == 1 && [[self.fileName.text stringByTrimmingCharactersInSet: set] length] == 0) {
        //ハイライト解除
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        UIAlertView *alertName = [[UIAlertView alloc] initWithTitle:@"" message:@"ファイル名を入力してください。" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertName show];
        
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"CardTableViewController"]) {
        // perform your computation to determine whether segue should occur
        NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
        if ([[self.fileName.text stringByTrimmingCharactersInSet: set] length] == 0) {
            // prevent segue from occurring
            return NO;
        }
    }
    
    // by default perform the segue transition
    return YES;
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

*/

@end
