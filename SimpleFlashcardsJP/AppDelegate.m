//
//  AppDelegate.m
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/11/23.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import "AppDelegate.h"
#import "FolderName.h"
#import "Options.h"
#import "FoldernameDB.h"
#import "FilenameDB.h"
#import "CardText.h"
#import "CardNumber.h"

@interface AppDelegate ()

@property (nonatomic, strong) FolderName *tempFolderManager;
@property (nonatomic, strong) NSArray *tempFolderInfo;
@property (nonatomic, strong) Options *dbOptions;
@property (nonatomic, strong) NSArray *dbOptionInfo;
@property (nonatomic, strong) FoldernameDB *dbFolderManager;
@property (nonatomic, strong) FilenameDB *dbFileManager;
@property (nonatomic, strong) CardText *cardTextManager;
@property (nonatomic, strong) NSArray *cardTextInfo;
@property (nonatomic, strong) CardNumber *dbCardNumber;
@property (nonatomic, strong) NSArray *cardNumberInfo;

@end

@implementation AppDelegate

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:0.9]
#define UIColorAlphaFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:0.0]

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Initialize the dbManager object.
    self.dbOptions = [[Options alloc] initWithDatabaseFilename:@"options.sql"];
    //クエリー作成。
    NSString *queryLoadOp = [NSString stringWithFormat:@"select * from optionInfo"];
    //データを読み込んで配列に追加。
    self.dbOptionInfo = [[NSArray alloc] initWithArray:[self.dbOptions loadDataFromDB:queryLoadOp]];
    
    if (self.dbOptionInfo.count == 0) {
        //NSLog(@"self.dbOptionInfo.count %ld", self.dbOptionInfo.count);
        
        //カードの順序を保存。
        NSString *queryForOrder = [NSString stringWithFormat:@"insert into optionInfo values(%d, %d, '%@')", 0, 0, @"順序通り"];
        // Execute the query.
        [self.dbOptions executeQuery:queryForOrder];
    
        //文字サイズを保存。
        NSString *queryForFontsize = [NSString stringWithFormat:@"insert into optionInfo values(%d, %d, '%@')", 1, 1, @"中"];
        // Execute the query.
        [self.dbOptions executeQuery:queryForFontsize];
        
        //背景色を保存。
        NSString *queryForBackcolor = [NSString stringWithFormat:@"insert into optionInfo values(%d, %d, '%@')", 2, 1, @"茶色"];
        // Execute the query.
        [self.dbOptions executeQuery:queryForBackcolor];
        
        //FolderDB初期化
        self.dbFolderManager = [[FoldernameDB alloc] initWithDatabaseFilename:@"FoldernameDB.sql"];
        NSString *queryFolder;
        queryFolder = [NSString stringWithFormat:@"insert into folderInfo values(null, '%@', %d)", @"Sample Folder", 0];
        // Execute the query.
        [self.dbFolderManager executeQuery:queryFolder];
        
        //FileDB初期化
        self.dbFileManager = [[FilenameDB alloc] initWithDatabaseFilename:@"FilenameDB.sql"];
        NSString *queryFile;
        queryFile = [NSString stringWithFormat:@"insert into filenameInfo values(null, '%@', '%@')", @"Sample File", @"1"];
        // Execute the query.
        [self.dbFileManager executeQuery:queryFile];
        
        // Initialize the dbManager object.
        self.cardTextManager = [[CardText alloc] initWithDatabaseFilename:@"CardText.sql"];
        self.dbCardNumber = [[CardNumber alloc] initWithDatabaseFilename:@"CardNumberDB.sql"];
        NSString *queryCT1_1;
        NSString *queryCT1_2;
        queryCT1_1 = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", @"Sample Card 1 Text 1\n\n\"カードを見る\"の使い方\n左右スワイプでカードを移動。青い矢印の上を上下スワイプでテキストを移動。", 0, @"1", 1];
        queryCT1_2 = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", @"Sample Card 1 Text 2\n\n\"カードを見る\"で3~5番目のテキストを表示するには、\"カードを編集\"でText 2にテキストを入力してください。", 1, @"1", 1];
        // Execute the query.
        [self.cardTextManager executeQuery:queryCT1_1];
        [self.cardTextManager executeQuery:queryCT1_2];
        NSString *queryCT2_1;
        NSString *queryCT2_2;
        NSString *queryCT2_3;
        NSString *queryCT2_4;
        NSString *queryCT2_5;
        queryCT2_1 = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", @"Sample Card 2 Text 1", 0, @"1", 2];
        queryCT2_2 = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", @"Sample Card 2 Text 2", 1, @"1", 2];
        queryCT2_3 = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", @"Sample Card 2 Text 3", 2, @"1", 2];
        queryCT2_4 = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", @"Sample Card 2 Text 4", 3, @"1", 2];
        queryCT2_5 = [NSString stringWithFormat:@"insert into cardTextInfo values(null, '%@', %d, '%@', %d)", @"Sample Card 2 Text 5", 4, @"1", 2];
        // Execute the query.
        [self.cardTextManager executeQuery:queryCT2_1];
        [self.cardTextManager executeQuery:queryCT2_2];
        [self.cardTextManager executeQuery:queryCT2_3];
        [self.cardTextManager executeQuery:queryCT2_4];
        [self.cardTextManager executeQuery:queryCT2_5];
        
        NSString *queryForCN_1 = [NSString stringWithFormat:@"insert into cardNumberInfo values(null, '%@', '%@')", @"1", @"1"];
        NSString *queryForCN_2 = [NSString stringWithFormat:@"insert into cardNumberInfo values(null, '%@', '%@')", @"1", @"1"];
        // Execute the query.
        [self.dbCardNumber executeQuery:queryForCN_1];
        [self.dbCardNumber executeQuery:queryForCN_2];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"使い方" message:@"1. フォルダーとファイルを作成\n2. \"カードを編集\"でカードを追加\n3. \"カードを見る\"でカードを表示" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
    }
    
    //以下、デザイン。
    // Uncomment to change the background color of navigation bar
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x065db5)];
    
    // Uncomment to change the color of back button
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    // Uncomment to change the font style of the title
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName, nil]];
    
    [UITableViewCell appearance].separatorInset = UIEdgeInsetsZero;
    
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    
    if (iOSDeviceScreenSize.height == 480)
    {
        // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone35
        UIStoryboard *iPhone4Storyboard = [UIStoryboard storyboardWithName:@"iPhone4" bundle:nil];
        
        // Instantiate the initial view controller object from the storyboard
        UIViewController *initialViewController = [iPhone4Storyboard instantiateInitialViewController];
        
        // Instantiate a UIWindow object and initialize it with the screen size of the iOS device
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        // Set the initial view controller to be the root view controller of the window object
        self.window.rootViewController  = initialViewController;
        
        // Set the window object to be the key window and show it
        [self.window makeKeyAndVisible];
    }
    
    if (iOSDeviceScreenSize.height == 568)
    {   // iPhone 5 and iPod Touch 5th generation: 4 inch screen
        // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone4
        UIStoryboard *iPhone5Storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        UIViewController *initialViewController = [iPhone5Storyboard instantiateInitialViewController];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController  = initialViewController;
        [self.window makeKeyAndVisible];
    }
    
    if (iOSDeviceScreenSize.height == 667)
    {   // iPhone 5 and iPod Touch 5th generation: 4 inch screen
        // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone4
        UIStoryboard *iPhone6Storyboard = [UIStoryboard storyboardWithName:@"iPhone6" bundle:nil];
        
        UIViewController *initialViewController = [iPhone6Storyboard instantiateInitialViewController];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController  = initialViewController;
        [self.window makeKeyAndVisible];
    }
    
    if (iOSDeviceScreenSize.height == 736)
    {   // iPhone 5 and iPod Touch 5th generation: 4 inch screen
        // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone4
        UIStoryboard *iPhone6PlusStoryboard = [UIStoryboard storyboardWithName:@"iPhone6Plus" bundle:nil];
        
        UIViewController *initialViewController = [iPhone6PlusStoryboard instantiateInitialViewController];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController  = initialViewController;
        [self.window makeKeyAndVisible];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    self.dbCardNumber = [[CardNumber alloc] initWithDatabaseFilename:@"CardNumberDB.sql"];
    
    if ([self.dbCardNumber checkColumnExists] == false) {
        [self.dbCardNumber alterDB];
    }
    
    self.dbOptions = [[Options alloc] initWithDatabaseFilename:@"options.sql"];
    [self.dbOptions alterDB];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    // Initialize the dbManager property.
    self.tempFolderManager = [[FolderName alloc] initWithDatabaseFilename:@"FolderName.sql"];
    
    //Load specific data to delete
    NSString *queryLoad = @"select * from FolderNameInfo";
    self.tempFolderInfo = [[NSArray alloc] initWithArray:[self.tempFolderManager loadDataFromDB:queryLoad]];
    //NSLog(@"%ld", self.folderInfo.count);

    if (self.tempFolderInfo.count != 0) {
        // Prepare the query.
        NSString *query = [NSString stringWithFormat:@"delete from FolderNameInfo"];
        //NSLog(@"%@", query);
        
        // Execute the query.
        [self.tempFolderManager executeQuery:query];
    }

}

@end
