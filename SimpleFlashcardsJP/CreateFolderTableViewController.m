//
//  CreateFolderTableViewController.m
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/11/25.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import "CreateFolderTableViewController.h"
#import "EnterFolderNameTableViewController.h"
#import "FolderName.h"
#import "FoldernameDB.h"

@interface CreateFolderTableViewController ()

@property (nonatomic, strong) FolderName *tempFolderManager;
@property (nonatomic, strong) NSArray *tempFolderInfo;
@property (nonatomic, strong) FoldernameDB *dbFolderManager;
@property (nonatomic, strong) NSArray *folderInfoDB;
@property (nonatomic, strong) NSArray *folderIDInfo;
@property (nonatomic, assign) NSInteger indexOfFolder;
@property (nonatomic, assign) NSInteger indexOfID;

-(void)loadData;

@end

@implementation CreateFolderTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    // Initialize the dbManager property.
    //FolderNameDB初期化
    self.tempFolderManager = [[FolderName alloc] initWithDatabaseFilename:@"FolderName.sql"];
    //FolderDB初期化
    self.dbFolderManager = [[FoldernameDB alloc] initWithDatabaseFilename:@"FoldernameDB.sql"];
    //FolderDBの読込み
    NSString *queryToSave = @"select * from folderInfo";
    self.folderInfoDB = [[NSArray alloc] initWithArray:[self.dbFolderManager loadDataFromDB:queryToSave]];
    
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
    
    //NSLog(@"%ld", self.countNum);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    EnterFolderNameTableViewController *editInfoViewController = [segue destinationViewController];
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
    self.tempFolderInfo = [[NSArray alloc] initWithArray:[self.tempFolderManager loadDataFromDB:query]];
    
    // Get the results.
    if (self.tempFolderInfo.count != 0) {
        self.folderName.text = [NSString stringWithFormat:@"%@", [[self.tempFolderInfo objectAtIndex:0] objectAtIndex:[self.tempFolderManager.arrColumnNames indexOfObject:@"foldername"]]];
        //_folderName.text = [NSString stringWithFormat:@"Folder Name   %@", [[self.folderInfo objectAtIndex:0] objectAtIndex:0]];
    }
   
    // Reload the table view.
    [self.tableView reloadData];
}

#pragma mark - Table view data source
//セルが選択された時の挙動を決定する。
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    if (indexPath.row == 1 && ![[self.folderName.text stringByTrimmingCharactersInSet: set] length] == 0) {
        //作成タップでフォルダーに表示する名前をFolderName.sqlからFolderDB.sqlに移す
        NSString *queryInsert;
        //FolderName.sqlから
        self.indexOfFolder = [self.tempFolderManager.arrColumnNames indexOfObject:@"foldername"];
        self.indexOfID = [self.dbFolderManager.arrColumnNames indexOfObject:@"folderInfoID"];
        
        if (self.folderInfoDB.count == 0) {
            NSString *foldername = [[self.tempFolderInfo objectAtIndex:0] objectAtIndex:self.indexOfFolder];
            //single quoteがあるかチェック。あればtwo single quotesにしてsyntax errorを避ける。
            foldername = [foldername stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            //NSLog(@"foldername %@", foldername);
            queryInsert = [NSString stringWithFormat:@"insert into folderInfo values(null, '%@', %d)", foldername, 0];
            // Execute the query.
            [self.dbFolderManager executeQuery:queryInsert];
        }else{
            /*
            for (int i = 0; i < self.folderInfoDB.count; i++) {
                NSString *checkFoldername = [NSString stringWithFormat:@"%@", [[self.folderInfoDB objectAtIndex:i] objectAtIndex:self.indexOfFolder]];
                NSString *tempFoldername = [NSString stringWithFormat:@"%@", [[self.tempFolderInfo objectAtIndex:0] objectAtIndex:self.indexOfFolder]];
                
                if ([checkFoldername isEqualToString:tempFoldername]) {
                    //NSLog(@"check %@, temp %@", checkFoldername, tempFoldername);
                    
                    NSInteger checkFolderID = [[NSString stringWithFormat:@"%@", [[self.folderInfoDB objectAtIndex:i] objectAtIndex:self.indexOfID]] integerValue];
                    
                    NSString *query = [NSString stringWithFormat:@"update folderInfo set selectedNumber = %ld where folderInfoID = %ld ", self.countNum, checkFolderID];
                    //NSLog(@"%@", query);
                    
                    // Execute the query.
                    [self.dbFolderManager executeQuery:query];
                    
                    self.countNum += 1;
                    
             
                    if (self.dbFolderManager.affectedRows != 0) {
                        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbFolderManager.affectedRows);
                    }
                    else{
                        NSLog(@"Could not execute the query.");
                    }
                }
            }*/
            
            //同一名の合計に１を足して保存。
            NSString *foldername = [[self.tempFolderInfo objectAtIndex:0] objectAtIndex:self.indexOfFolder];
            //single quoteがあるかチェック。あればtwo single quotesにしてsyntax errorを避ける。
            foldername = [foldername stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            //NSLog(@"foldername %@", foldername);
            queryInsert = [NSString stringWithFormat:@"insert into folderInfo values(null, '%@', %d)", foldername, 0];
            // Execute the query.
            [self.dbFolderManager executeQuery:queryInsert];
        }
        
        //Load specific data to delete
        NSString *queryLoad = @"select * from FolderNameInfo";
        self.tempFolderInfo = [[NSArray alloc] initWithArray:[self.tempFolderManager loadDataFromDB:queryLoad]];
        
        if (self.tempFolderInfo.count != 0) {
            // Prepare the query.
            NSString *query = [NSString stringWithFormat:@"delete from FolderNameInfo where foldernameinfoID=%d", 1];
            //NSLog(@"%@", query);
            
            // Execute the query.
            [self.tempFolderManager executeQuery:query];
        }
        
        // Inform the delegate that the editing was finished.
        [self.folderDelegate folderEditingInfoWasFinished];
        //self.folderName.text = [NSString stringWithFormat:@""];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if (indexPath.row == 1 && [[self.folderName.text stringByTrimmingCharactersInSet: set] length] == 0) {
        //ハイライト解除
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        UIAlertView *alertName = [[UIAlertView alloc] initWithTitle:@"" message:@"フォルダー名を入力してください。" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertName show];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 * テーブル全体のセクションの数を返す
 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}*/

/*指定されたセクションの項目数を返す
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    // 行の数
    return [self.sectionList count];
}*/

/**
 * 指定されたセクションのセクション名を返す
 
 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
 {
 return [self.sectionList objectAtIndex:section];
 }*/

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //セルの生成時に、forIndexPath:indexPathを渡さないよう変更
    //static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //_2 cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
  
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    FolderNameTableViewCell *cell = (FolderNameTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        //_2 custom cellの場合はNibを渡す
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FolderNameTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
 
    return cell;
}*/


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
