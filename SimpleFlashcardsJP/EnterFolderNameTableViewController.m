//
//  EnterFolderNameTableViewController.m
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/11/25.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import "EnterFolderNameTableViewController.h"
#import "CreateFolderTableViewController.h"
#import "FolderName.h"

@interface EnterFolderNameTableViewController ()

@property (nonatomic, strong) FolderName *dbFolderManager;
@property (nonatomic, strong) NSArray *folderInfo;
@property (nonatomic, strong) NSString *checkData;
- (void)loadInfoToEdit;

@end

@implementation EnterFolderNameTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.folderNameText becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Make self the delegate of the textfields .h <UITextFieldDelegate>
    self.folderNameText.delegate = self;
    // Initialize the dbManager object.
    //set bounds of the textfield
    self.folderNameText.bounds = [self editingRectForBounds:self.folderNameText.bounds];

    // Initialize the dbManager object.
    self.dbFolderManager = [[FolderName alloc] initWithDatabaseFilename:@"FolderName.sql"];
    
    //Load specific data
    NSString *queryLoad = @"select * from FolderNameInfo";
    self.folderInfo = [[NSArray alloc] initWithArray:[self.dbFolderManager loadDataFromDB:queryLoad]];
    
    if (self.folderInfo.count != 0) {
        [self loadInfoToEdit];
    }
    
}

// text position: inset for the textfield
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 5 , 10 );
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        // Prepare the query string.
        // If the recordIDToEdit property has value other than -1, then create an update query. Otherwise create an insert query.
        NSString *query;
        
        if (self.folderInfo.count == 0) {
            query = [NSString stringWithFormat:@"insert into FolderNameInfo values(null, '%@')", self.folderNameText.text];
        }
        else{
            query = [NSString stringWithFormat:@"update FolderNameInfo set foldername='%@' ", self.folderNameText.text];
        }
        
        
        // Execute the query.
        [self.dbFolderManager executeQuery:query];
        
        // If the query was successfully executed then pop the view controller.
        if (self.dbFolderManager.affectedRows != 0) {
            //NSLog(@"Query was executed successfully. Affected rows = %d", self.dbFolderManager.affectedRows);
            
            // Inform the delegate that the editing was finished.
            [self.delegate editingInfoWasFinished];
        }
        else{
            //NSLog(@"Could not execute the query.");
        }
        
        // Pop the view controller.
        [self.navigationController popViewControllerAnimated:YES];
        
        return NO;
    }
    
    return YES;
}


/* text position: inset for the textfield
 - (CGRect)editingRectForBounds:(CGRect)bounds {
 return CGRectInset( bounds , 15 , 15 );
 }

//ready to implement a simple delegate method and know when the Done button of the keyboard gets tapped
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    // Prepare the query string.
    // If the recordIDToEdit property has value other than -1, then create an update query. Otherwise create an insert query.
    NSString *query;
    
    if (self.folderInfo.count == 0) {
        query = [NSString stringWithFormat:@"insert into FolderNameInfo values(null, '%@')", self.folderNameText.text];
    }
    else{
        query = [NSString stringWithFormat:@"update FolderNameInfo set foldername='%@' ", self.folderNameText.text];
    }
    
    
    // Execute the query.
    [self.dbFolderManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbFolderManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbFolderManager.affectedRows);
        
        // Inform the delegate that the editing was finished.
        [self.delegate editingInfoWasFinished];
    }
    else{
        NSLog(@"Could not execute the query.");
    }
    
    // Pop the view controller.
    [self.navigationController popViewControllerAnimated:YES];
    return YES;
}*/

- (IBAction)backToCreateFolder:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveFolderName:(id)sender {
    // Prepare the query string.
    // If the recordIDToEdit property has value other than -1, then create an update query. Otherwise create an insert query.
    NSString *query;
   
    if (self.folderInfo.count == 0){
        query = [NSString stringWithFormat:@"insert into FolderNameInfo values(null, '%@')", self.folderNameText.text];
    }
    else{
        query = [NSString stringWithFormat:@"update FolderNameInfo set foldername='%@' ", self.folderNameText.text];
    }
    
    
    // Execute the query.
    [self.dbFolderManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbFolderManager.affectedRows != 0) {
        //NSLog(@"Query was executed successfully. Affected rows = %d", self.dbFolderManager.affectedRows);
        
        // Inform the delegate that the editing was finished.
        [self.delegate editingInfoWasFinished];
    }
    else{
        //NSLog(@"Could not execute the query.");
    }
    
    // Pop the view controller.
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadInfoToEdit{
    //NSInteger indexOfFoldername = [self.dbFolderManager.arrColumnNames indexOfObject:@"foldername"];
    self.folderNameText.text = [NSString stringWithFormat:@"%@", [[self.folderInfo objectAtIndex:0] objectAtIndex:[self.dbFolderManager.arrColumnNames indexOfObject:@"foldername"]]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}*/

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
