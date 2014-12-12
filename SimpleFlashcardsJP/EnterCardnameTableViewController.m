//
//  EnterCardnameTableViewController.m
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/12/11.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import "EnterCardnameTableViewController.h"

@interface EnterCardnameTableViewController ()

@property (nonatomic, assign) int currentIndex;
@property (nonatomic, strong) NSArray *titleList;

@end

@implementation EnterCardnameTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.cardText becomeFirstResponder];
    //set bounds of the textview
    self.cardText.bounds = [self editingRectForBounds:self.cardText.bounds];
    //改行するとずれるのでInsetの初期設定を調整
    self.cardText.contentInset = UIEdgeInsetsMake(-10,-5,0,0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Make self the delegate of the textfields .h <UITextFieldDelegate>
    self.cardText.delegate = self;
    
    //@selector()で指定メソッドをコール
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextItem:)];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneItem:)];
    
    NSArray *actionButtonItems = @[doneItem, nextItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    NSString *titleOne = [NSString stringWithFormat:@"Text 1"];
    NSString *titleTwo = [NSString stringWithFormat:@"Text 2"];
    NSString *titleThree = [NSString stringWithFormat:@"Text 3"];
    NSString *titleFour = [NSString stringWithFormat:@"Text 4"];
    NSString *titleFive = [NSString stringWithFormat:@"Text 5"];
    
    self.titleList = @[titleOne, titleTwo, titleThree, titleFour, titleFive];
    
    if ([self.titleNumber isEqualToString:@"1"]) {
        self.currentIndex = 0;
        self.navigationItem.title = [self.titleList objectAtIndex:self.currentIndex];
    }else if ([self.titleNumber isEqualToString:@"2"]) {
        self.currentIndex = 1;
        self.navigationItem.title = [self.titleList objectAtIndex:self.currentIndex];
    }else if ([self.titleNumber isEqualToString:@"3"]) {
        self.currentIndex = 2;
        self.navigationItem.title = [self.titleList objectAtIndex:self.currentIndex];
    }else if ([self.titleNumber isEqualToString:@"4"]) {
        self.currentIndex = 3;
        self.navigationItem.title = [self.titleList objectAtIndex:self.currentIndex];
    }else if ([self.titleNumber isEqualToString:@"5"]) {
        self.currentIndex = 4;
        self.navigationItem.title = [self.titleList objectAtIndex:self.currentIndex];
    }

}

// text position: inset for the textfield
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 5 , 10 );
}

-(void)nextItem: (UIBarButtonItem *)sender{
    self.currentIndex += 1;
    if (self.currentIndex > 4) {
        self.currentIndex = 0;
        self.navigationItem.title = [self.titleList objectAtIndex:self.currentIndex];
    }else{
        self.navigationItem.title = [self.titleList objectAtIndex:self.currentIndex];
    }
}

- (void)doneItem:(UIBarButtonItem *)sender {
    //[sender setText:@"Done" forState:UIControlStateNormal];
    
}

- (IBAction)cancelButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
