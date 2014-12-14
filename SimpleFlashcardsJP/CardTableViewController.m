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

@interface CardTableViewController ()

@end

@implementation CardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![self.editCardsOrNot isEqualToString:@"EditCardname"]) {
        [self performSegueWithIdentifier:@"EditCardTableViewController" sender:self];
    }
    
    NSLog(@"%@", self.filenameData);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"EditCardTableViewController"]) {
        EditCardTableViewController *editView = [segue destinationViewController];
        editView.filenameData = self.filenameData;
    }else if ([[segue identifier] isEqualToString:@"CardListTableViewController"]) {
        CardListTableViewController *listView = [segue destinationViewController];
        listView.filenameData = self.filenameData;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
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
