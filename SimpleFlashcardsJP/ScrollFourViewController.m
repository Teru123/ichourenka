//
//  ScrollFourViewController.m
//  SimpleFlashcardsJP
//
//  Created by Teru on 2015/01/11.
//  Copyright (c) 2015年 Self. All rights reserved.
//

#import "ScrollFourViewController.h"

@interface ScrollFourViewController ()

@end

@implementation ScrollFourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView.editable = YES;
    
    self.textView.delegate = self;
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 224, 420)];
    [self.view addSubview:self.textView];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.text = @"";
    //sourceArry *番目の配列の*番目を渡す。
    self.textView.text = self.sourceArrry[3];
    
    self.textView.font = [UIFont systemFontOfSize:20];
    
    self.textView.editable = NO;
    
    //NSLog(@"call");
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
