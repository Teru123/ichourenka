//
//  HelpViewController.m
//  SimpleFlashcardsJP
//
//  Created by Teru on 2015/01/20.
//  Copyright (c) 2015年 Self. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.textView.text = @"使い方\n(1)フォルダーとファイルを作成\n(2)\"カードを編集\"でカードを追加\n(3)\"カードを見る\"でカードを表示\n\n・\"カードを見る\"の使い方\n左右スワイプでカードを移動。青い矢印の上を上下スワイプでテキストを移動。\n\n・\"カードを見る\"で3~5番目のテキストを表示するには、\"カードを編集\"でText 2にテキストを入力してください。";
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
