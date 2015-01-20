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
