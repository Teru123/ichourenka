//
//  CreateFolderTableViewController.m
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/11/25.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import "CreateFolderTableViewController.h"

@interface CreateFolderTableViewController ()

@property (strong, nonatomic)CreateFolderTableViewController *createFolderView;

-(void)setCreateFolderView;
-(void)setTempFolderName:(NSString *)tempFolderName;

@end

@implementation CreateFolderTableViewController

-(void)setCreateFolderView{
    self.createFolderView  = [[CreateFolderTableViewController alloc] init];
}

-(void)setTempFolderName:(NSString *)tempFolderName{
    _tempFolderName = tempFolderName;
    //tempFolderNameがnullでなければ処理実行
    if (self.createFolderView.tempFolderName) {
        //folderNameにtempFolderNameを追加
        self.folderName.text = [self.folderName.text stringByAppendingString:self.createFolderView.tempFolderName];
        NSLog(@"%@", self.createFolderView.tempFolderName);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    NSLog(@"%@", self.tempFolderName);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createFolderView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
//セルが選択された時の挙動を決定する。
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
