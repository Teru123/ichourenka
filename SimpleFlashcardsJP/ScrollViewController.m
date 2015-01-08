//
//  ScrollViewController.m
//  SimpleFlashcardsJP
//
//  Created by Teru on 2015/01/08.
//  Copyright (c) 2015年 Self. All rights reserved.
//

#import "ScrollViewController.h"
#import "DataViewController.h"

@interface ScrollViewController ()

@end

@implementation ScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 224, 420)];
    [self.view addSubview:self.textView ];
    self.textView .backgroundColor = [UIColor lightGrayColor];
    self.textView.text = self.sourceArrry[self.currentSelectIndex];
    self.textView.font = [UIFont systemFontOfSize:20];
    
    self.textView .editable = NO;
}

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
