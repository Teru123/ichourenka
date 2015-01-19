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

@interface AppDelegate ()

@property (nonatomic, strong) FolderName *dbFolderManager;
@property (nonatomic, strong) NSArray *folderInfo;
@property (nonatomic, strong) Options *dbOptions;
@property (nonatomic, strong) NSArray *dbOptionInfo;

@end

@implementation AppDelegate


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
        NSString *queryForBackcolor = [NSString stringWithFormat:@"insert into optionInfo values(%d, %d, '%@')", 2, 0, @"青色"];
        // Execute the query.
        [self.dbOptions executeQuery:queryForBackcolor];
        
        //背景色を保存。
        NSString *queryForLanguage = [NSString stringWithFormat:@"insert into optionInfo values(%d, %d, '%@')", 3, 0, @"en"];
        // Execute the query.
        [self.dbOptions executeQuery:queryForLanguage];
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
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    // Initialize the dbManager property.
    self.dbFolderManager = [[FolderName alloc] initWithDatabaseFilename:@"FolderName.sql"];
    
    //Load specific data to delete
    NSString *queryLoad = @"select * from FolderNameInfo";
    self.folderInfo = [[NSArray alloc] initWithArray:[self.dbFolderManager loadDataFromDB:queryLoad]];
    //NSLog(@"%ld", self.folderInfo.count);

    if (self.folderInfo.count != 0) {
        // Prepare the query.
        NSString *query = [NSString stringWithFormat:@"delete from FolderNameInfo"];
        NSLog(@"%@", query);
        
        // Execute the query.
        [self.dbFolderManager executeQuery:query];
    }

}

@end
