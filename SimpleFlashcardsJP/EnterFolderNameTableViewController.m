//
//  EnterFolderNameTableViewController.m
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/11/25.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import "EnterFolderNameTableViewController.h"
#import "CreateFolderTableViewController.h"
#import "FolderNameDB.h"

@interface EnterFolderNameTableViewController ()

@property (nonatomic, strong) FolderNameDB *folderNameDB;

-(void)loadInfoToEdit;

@end

@interface EnterFolderNameTableViewController ()

@property (strong, nonatomic)CreateFolderTableViewController *createFolderView;

-(void)setCreateFolderView;

@end

@implementation EnterFolderNameTableViewController

-(void)setCreateFolderView{
    _createFolderView  = [[CreateFolderTableViewController alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.folderNameText becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCreateFolderView];
    
    // Make self the delegate of the textfields .h <UITextFieldDelegate>
    self.folderNameText.delegate = self;
    // Initialize the dbManager object.
    self.FolderNameDB = [[FolderNameDB alloc] initWithDatabaseFilename:@"FolderNameDB.sql"];
    //set bounds of the textfield
    self.folderNameText.bounds = [self editingRectForBounds:self.folderNameText.bounds];

    /* add textfield on imageView
     UIImageView *textImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WhiteTextViewRectangle.png"]];
     [self.view addSubview:textImageView];
     textImageView.frame = CGRectMake(0, 35, 320, 220);
     [textImageView addSubview:_folderNameText];
     */
}

// text position: inset for the textfield
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 15 , 15 );
}

//ready to implement a simple delegate method and know when the Done button of the keyboard gets tapped
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    //self.createFolderView.tempFolderName = self.folderNameText.text;
    [_createFolderView setTempFolderName:[NSString stringWithFormat:@"%@", self.folderNameText.text]];
    NSLog(@"%@", self.createFolderView.tempFolderName);
    [self.navigationController popViewControllerAnimated:YES];
    return YES;
}

- (IBAction)backToCreateFolder:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveFolderName:(id)sender {
    //self.createFolderView.tempFolderName = self.folderNameText.text;
    [_createFolderView setTempFolderName:[NSString stringWithFormat:@"%@", self.folderNameText.text]] ;
    NSLog(@"%@", self.createFolderView.tempFolderName);
    [self.navigationController popViewControllerAnimated:YES];
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
