//
//  ChangeFoldernameTableViewController.m
//  SimpleFlashcardsJP
//
//  Created by Teru on 2015/01/14.
//  Copyright (c) 2015年 Self. All rights reserved.
//

#import "ChangeFoldernameTableViewController.h"
#import "FoldernameDB.h"

@interface ChangeFoldernameTableViewController ()

@property (nonatomic, strong) FoldernameDB *dbFolderManager;
@property (nonatomic, strong) NSString *folderIDStr;

@end

@implementation ChangeFoldernameTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //FileDB初期化。
    self.dbFolderManager = [[FoldernameDB alloc] initWithDatabaseFilename:@"FoldernameDB.sql"];
    
    //filename取得。
    if (self.foldernameData != nil) {
        self.textField.text = self.foldernameData;
    }
    self.folderIDStr = [NSString stringWithFormat:@"%ld", self.folderID];
    //NSLog(@"folderIDStr %@", self.folderIDStr);
    
    // Make self the delegate of the textfields .h <UITextFieldDelegate>
    self.textField.delegate = self;
    
    //set bounds of the textfield
    self.textField.bounds = [self editingRectForBounds:self.textField.bounds];
    
    [self.textField becomeFirstResponder];
}

// text position: inset for the textfield
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 5 , 10 );
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        //single quoteがあるかチェック。あればtwo single quotesにしてsyntax errorを避ける。
        self.textField.text = [self.textField.text stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        
        //クエリー作成。
        NSString *queryUpdate = [NSString stringWithFormat:@"update folderInfo set foldername ='%@' where folderInfoID = %ld ", self.textField.text, self.folderID];
        [self.dbFolderManager executeQuery:queryUpdate];
        
        //NSLog(@"folderIDStr %@", self.folderIDStr);
        
        // Inform the delegate that the editing was finished.
        [self.delegate editingFolderInfoWasFinished];
        
        // Pop the view controller.
        [self.navigationController popViewControllerAnimated:YES];
        
        return NO;
    }
    
    return YES;
}

- (IBAction)cancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveAction:(id)sender {
    //single quoteがあるかチェック。あればtwo single quotesにしてsyntax errorを避ける。
    self.textField.text = [self.textField.text stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    
    //クエリー作成。
    NSString *queryUpdate = [NSString stringWithFormat:@"update folderInfo set foldername ='%@' where folderInfoID = %ld ", self.textField.text, self.folderID];
    [self.dbFolderManager executeQuery:queryUpdate];
    
    //NSLog(@"folderIDStr %@", self.folderIDStr);
    
    // Inform the delegate that the editing was finished.
    [self.delegate editingFolderInfoWasFinished];
    
    // Pop the view controller.
    [self.navigationController popViewControllerAnimated:YES];
}

/*
// text position: inset for the textfield
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 15 , 15 );
}

//ready to implement a simple delegate method and know when the Done button of the keyboard gets tapped
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //クエリー作成。
    NSString *queryUpdate = [NSString stringWithFormat:@"update folderInfo set foldername ='%@' where folderInfoID = %ld ", self.textField.text, self.folderID];
    [self.dbFolderManager executeQuery:queryUpdate];
    
    NSLog(@"folderIDStr %@", self.folderIDStr);
    
    // Inform the delegate that the editing was finished.
    [self.delegate editingFolderInfoWasFinished];
    
    // Pop the view controller.
    [self.navigationController popViewControllerAnimated:YES];
    
    return YES;
}*/

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
