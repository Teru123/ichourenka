//
//  OptionsTableViewController.m
//  SimpleFlashcardsJP
//
//  Created by Teru on 2015/01/18.
//  Copyright (c) 2015年 Self. All rights reserved.
//

#import "OptionsTableViewController.h"
#import "Options.h"

@interface OptionsTableViewController ()

@property (nonatomic, strong) Options *dbOptions;
@property (nonatomic, strong) NSArray *dbOptionInfo;

@end

@implementation OptionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    self.tableView.rowHeight = 44;
    
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
}

- (void)viewWillAppear:(BOOL)animated{
    // Initialize the dbManager object.
    self.dbOptions = [[Options alloc] initWithDatabaseFilename:@"options.sql"];
    //クエリー作成。
    NSString *queryOrder = [NSString stringWithFormat:@"select * from optionInfo"];
    //データを読み込んで配列に追加。
    self.dbOptionInfo = [[NSArray alloc] initWithArray:[self.dbOptions loadDataFromDB:queryOrder]];
    //arrColumnNamesでselectedopstrのindexを取得。
    NSInteger opIndex = [self.dbOptions.arrColumnNames indexOfObject:@"selectedopstr"];
    //dbOptionsの*番目の値を取得。
    self.orderDetail.text = [NSString stringWithFormat:@"%@", [[self.dbOptionInfo objectAtIndex:0] objectAtIndex:opIndex]];
    self.fontsizeDetail.text = [NSString stringWithFormat:@"%@", [[self.dbOptionInfo objectAtIndex:1] objectAtIndex:opIndex]];
    self.backcolorDetail.text = [NSString stringWithFormat:@"%@", [[self.dbOptionInfo objectAtIndex:2] objectAtIndex:opIndex]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            //ウェブサイト
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.sokusyueitango.com"]];
        }else if (indexPath.row == 1) {
            //速習英単語1のDLページ
            // AppStoreのレビューURLを開く (引数に AppStoreのアプリIDを指定)
            // レビュー画面の URL
            NSString *reviewUrl;
            
            // iOSのバージョンを判別
            NSString *osversion = [UIDevice currentDevice].systemVersion;
            NSArray *a = [osversion componentsSeparatedByString:@"."];
            BOOL isIOS7 = [(NSString *)[a objectAtIndex:0] intValue] >= 7;
            if (isIOS7) {
                // iOS 7以降
                reviewUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", @"783634975"];
            } else {
                // iOS 7未満
                reviewUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software", @"783634975"];
            }
            
            // レビュー画面へ遷移
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewUrl]];
        }else if (indexPath.row == 2){
            //速習英単語2のDLページ
            // AppStoreのレビューURLを開く (引数に AppStoreのアプリIDを指定)
            // レビュー画面の URL
            NSString *reviewUrl;
            
            // iOSのバージョンを判別
            NSString *osversion = [UIDevice currentDevice].systemVersion;
            NSArray *a = [osversion componentsSeparatedByString:@"."];
            BOOL isIOS7 = [(NSString *)[a objectAtIndex:0] intValue] >= 7;
            if (isIOS7) {
                // iOS 7以降
                reviewUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", @"894481309"];
            } else {
                // iOS 7未満
                reviewUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software", @"894481309"];
            }
            
            // レビュー画面へ遷移
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewUrl]];
            
            //[self toggleMenu];
        }
    }
    
    [tableView reloadData];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
