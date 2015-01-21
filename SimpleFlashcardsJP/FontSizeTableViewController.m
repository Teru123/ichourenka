//
//  FontSizeTableViewController.m
//  SimpleFlashcardsJP
//
//  Created by Teru on 2015/01/18.
//  Copyright (c) 2015年 Self. All rights reserved.
//

#import "FontSizeTableViewController.h"
#import "CardListTableViewCell.h"
#import "Options.h"

@interface FontSizeTableViewController ()

@property (nonatomic, strong) NSIndexPath* lastIndexPath;
@property (nonatomic, strong) Options *dbOptions;
@property (nonatomic, strong) NSArray *dbOptionInfo;
@property (nonatomic, assign) BOOL loadedCell;

@end

@implementation FontSizeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 44;
    
    // Initialize the dbManager object.
    self.dbOptions = [[Options alloc] initWithDatabaseFilename:@"options.sql"];
    //クエリー作成。
    NSString *queryOrder = [NSString stringWithFormat:@"select * from optionInfo where optionInfoID = %d", 1];
    //データを読み込んで配列に追加。
    self.dbOptionInfo = [[NSArray alloc] initWithArray:[self.dbOptions loadDataFromDB:queryOrder]];
    
    self.loadedCell = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.loadedCell == NO) {
        //arrColumnNamesでselectedopstrのindexを取得。
        NSInteger opIndex = [self.dbOptions.arrColumnNames indexOfObject:@"selectedop"];
        //dbOptionsの0番目の値を取得。
        NSInteger selectedOP = [[[self.dbOptionInfo objectAtIndex:0] objectAtIndex:opIndex] integerValue];
        //NSLog(@"selectedOP %ld", selectedOP);
        
        if (selectedOP == 0) {
            //NSLog(@"check");
            if (indexPath.row == 0) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                //self.lastIndexPath = indexPath;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }else if (selectedOP == 1){
            //NSLog(@"check");
            if (indexPath.row == 1) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                //self.lastIndexPath = indexPath;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }else if (selectedOP == 2){
            //NSLog(@"check");
            if (indexPath.row == 2) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                //self.lastIndexPath = indexPath;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }else if (selectedOP == 3){
            //NSLog(@"check");
            if (indexPath.row == 3) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                //self.lastIndexPath = indexPath;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ListCell";
    
    CardListTableViewCell *cell = (CardListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CardListTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if ([indexPath compare:self.lastIndexPath] == NSOrderedSame)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        if (indexPath.row == 0) {
            //クエリー作成。
            NSString *queryUpdate = [NSString stringWithFormat:@"update optionInfo set selectedop = %ld where optionInfoID = %d ", indexPath.row, 1];
            NSString *queryUpdateStr = [NSString stringWithFormat:@"update optionInfo set selectedopstr = '%@' where optionInfoID = %d ", @"小", 1];
            //NSLog(@"queryUpdate %@", queryUpdate);
            [self.dbOptions executeQuery:queryUpdate];
            [self.dbOptions executeQuery:queryUpdateStr];
        }else if (indexPath.row == 1) {
            //クエリー作成。
            NSString *queryUpdate = [NSString stringWithFormat:@"update optionInfo set selectedop = %ld where optionInfoID = %d ", indexPath.row, 1];
            NSString *queryUpdateStr = [NSString stringWithFormat:@"update optionInfo set selectedopstr = '%@' where optionInfoID = %d ", @"中", 1];
            //NSLog(@"queryUpdate %@", queryUpdate);
            [self.dbOptions executeQuery:queryUpdate];
            [self.dbOptions executeQuery:queryUpdateStr];
        }else if (indexPath.row == 2) {
            //クエリー作成。
            NSString *queryUpdate = [NSString stringWithFormat:@"update optionInfo set selectedop = %ld where optionInfoID = %d ", indexPath.row, 1];
            NSString *queryUpdateStr = [NSString stringWithFormat:@"update optionInfo set selectedopstr = '%@' where optionInfoID = %d ", @"大", 1];
            //NSLog(@"queryUpdate %@", queryUpdate);
            [self.dbOptions executeQuery:queryUpdate];
            [self.dbOptions executeQuery:queryUpdateStr];
        }else if (indexPath.row == 3) {
            //クエリー作成。
            NSString *queryUpdate = [NSString stringWithFormat:@"update optionInfo set selectedop = %ld where optionInfoID = %d ", indexPath.row, 1];
            NSString *queryUpdateStr = [NSString stringWithFormat:@"update optionInfo set selectedopstr = '%@' where optionInfoID = %d ", @"特大", 1];
            //NSLog(@"queryUpdate %@", queryUpdate);
            [self.dbOptions executeQuery:queryUpdate];
            [self.dbOptions executeQuery:queryUpdateStr];
        }
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    NSArray *textArr = @[@"小", @"中", @"大", @"特大"];
    // Configure the cell...
    cell.textLabel_1.text = [NSString stringWithFormat:@"%@", [textArr objectAtIndex:indexPath.row]];
    
    return cell;
}

// UITableView Delegate Method
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.lastIndexPath = indexPath;
    self.loadedCell = YES;
    [tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
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
