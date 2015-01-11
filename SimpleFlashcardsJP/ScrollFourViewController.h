//
//  ScrollFourViewController.h
//  SimpleFlashcardsJP
//
//  Created by Teru on 2015/01/11.
//  Copyright (c) 2015年 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollFourViewController : UIViewController <UITextViewDelegate>

//数据源
@property(nonatomic,strong) NSArray *sourceArrry;
@property(nonatomic) NSInteger currentSelectIndex;
@property(nonatomic, strong) UITextView *textView;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, assign) int textNumber;
@property(nonatomic, strong) NSString *textData;

@end
