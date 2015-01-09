//
//  ScrollTwoViewController.h
//  SimpleFlashcardsJP
//
//  Created by Teru on 2015/01/09.
//  Copyright (c) 2015年 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollTwoViewController : UIViewController<UITextViewDelegate>

//数据源
@property(nonatomic,strong) NSArray *sourceArrry;
@property(nonatomic) NSInteger currentSelectIndex;
@property(nonatomic, strong) UITextView *textView;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, assign) int textNumber;
@property(nonatomic, strong) NSString *textData;

@end
