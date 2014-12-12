//
//  EditCardTableViewController.m
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/12/11.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import "EditCardTableViewController.h"
#import "EnterCardnameTableViewController.h"
#import "CardText.h"

@interface EditCardTableViewController ()

@property (nonatomic, strong) NSString *titlenumberOfThis;
@property (nonatomic, strong) CardText *cardTextManager;
@property (nonatomic, strong) NSArray *cardTextInfo;
@property (nonatomic, strong) NSString *cellText;

@end

@implementation EditCardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize the dbManager object.
    self.cardTextManager = [[CardText alloc] initWithDatabaseFilename:@"CardText.sql"];
    
    NSLog(@"%@", self.filenameData);
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"EnterCardnameTableViewController1"]) {
        EnterCardnameTableViewController *cardnameView = [segue destinationViewController];
        cardnameView.titleNumber = @"1";
        cardnameView.filenameData = self.filenameData;
        cardnameView.cellText = self.cellText;
    }else if ([[segue identifier] isEqualToString:@"EnterCardnameTableViewController2"]) {
        EnterCardnameTableViewController *cardnameView = [segue destinationViewController];
        cardnameView.titleNumber = @"2";
        cardnameView.filenameData = self.filenameData;
        cardnameView.cellText = self.cellText;
    }else if ([[segue identifier] isEqualToString:@"EnterCardnameTableViewController3"]) {
        EnterCardnameTableViewController *cardnameView = [segue destinationViewController];
        cardnameView.titleNumber = @"3";
        cardnameView.filenameData = self.filenameData;
        cardnameView.cellText = self.cellText;
    }else if ([[segue identifier] isEqualToString:@"EnterCardnameTableViewController4"]) {
        EnterCardnameTableViewController *cardnameView = [segue destinationViewController];
        cardnameView.titleNumber = @"4";
        cardnameView.filenameData = self.filenameData;
        cardnameView.cellText = self.cellText;
    }else if ([[segue identifier] isEqualToString:@"EnterCardnameTableViewController5"]) {
        EnterCardnameTableViewController *cardnameView = [segue destinationViewController];
        cardnameView.titleNumber = @"5";
        cardnameView.filenameData = self.filenameData;
        cardnameView.cellText = self.cellText;
    }
}

//didSelectにすると値が渡せない。値を渡す時はwillSelectとする。戻り値はindexPath。
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.cellText = cell.textLabel.text;
    return indexPath;
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

@end
