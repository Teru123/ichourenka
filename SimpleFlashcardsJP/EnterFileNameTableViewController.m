//
//  EnterFileNameTableViewController.m
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/12/04.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import "EnterFileNameTableViewController.h"
#import "CreateFileTableViewController.h"
#import "FolderNameDB.h"

@interface EnterFileNameTableViewController ()

@property (nonatomic, strong) FolderNameDB *dbFolderManager;
@property (nonatomic, strong) NSArray *folderInfo;
//@property (nonatomic, strong) NSString *checkData;
- (void)loadInfoToEdit;

@end

@implementation EnterFileNameTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.filenameText becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Make self the delegate of the textfields .h <UITextFieldDelegate>
    self.filenameText.delegate = self;
    // Initialize the dbManager object.
    //set bounds of the textfield
    self.filenameText.bounds = [self editingRectForBounds:self.filenameText.bounds];
    
    // Initialize the dbManager object.
    self.dbFolderManager = [[FolderNameDB alloc] initWithDatabaseFilename:@"FolderName.sql"];
    
    //Load specific data
    NSString *queryLoad = @"select * from FolderNameInfo";
    self.folderInfo = [[NSArray alloc] initWithArray:[self.dbFolderManager loadDataFromDB:queryLoad]];
    
    if (self.folderInfo.count != 0) {
        [self loadInfoToEdit];
    }
}

// text position: inset for the textfield
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
        query = [NSString stringWithFormat:@"insert into FolderNameInfo values(%d, '%@')", 1, self.filenameText.text];
    }
    else{
        query = [NSString stringWithFormat:@"update FolderNameInfo set foldername='%@' ", self.filenameText.text];
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
}

- (IBAction)cancelButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveButton:(id)sender {
    // Prepare the query string.
    // If the recordIDToEdit property has value other than -1, then create an update query. Otherwise create an insert query.
    NSString *query;
    
    if (self.folderInfo.count == 0){
        query = [NSString stringWithFormat:@"insert into FolderNameInfo values(null, '%@')", self.filenameText.text];
    }
    else{
        query = [NSString stringWithFormat:@"update FolderNameInfo set foldername='%@' ", self.filenameText.text];
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
}

-(void)loadInfoToEdit{
    // Create the query.
    NSString *query = [NSString stringWithFormat:@"select * from FolderNameInfo"];
    
    // Load the relevant data.
    self.folderInfo = [[NSArray alloc] initWithArray:[self.dbFolderManager loadDataFromDB:query]];
    NSInteger indexOfFoldername = [self.dbFolderManager.arrColumnNames indexOfObject:@"foldername"];
    _filenameText.text = [NSString stringWithFormat:@"%@", [[self.folderInfo objectAtIndex:0] objectAtIndex:indexOfFoldername]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/*
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
