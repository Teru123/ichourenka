//
//  ScrollViewController.m
//  SimpleFlashcardsJP
//
//  Created by Teru on 2015/01/08.
//  Copyright (c) 2015年 Self. All rights reserved.
//

#import "ScrollViewController.h"

@interface ScrollViewController ()

@end

@implementation ScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView.editable = YES;

    self.textView.delegate = self;
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 224, 420)];
    [self.view addSubview:self.textView];
    self.textView.backgroundColor = [UIColor lightGrayColor];
    self.textView.text = @"";
    //sourceArry *番目の配列の*番目を渡す。
    self.textView.text = self.sourceArrry[0];
    
    self.textView.font = [UIFont systemFontOfSize:20];
    
    self.textView.editable = NO;
    
    NSLog(@"call");
    
    //DataViewController *dataView = [self.storyboard instantiateViewControllerWithIdentifier:@"DataViewController"];
    //dataView.dataDelegate = self;
}

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _sourceArrry.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell...
    static NSString *cellider = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellider];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellider];
    }
    cell.textLabel.text = _sourceArrry[indexPath.row];
    return cell;
}*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
