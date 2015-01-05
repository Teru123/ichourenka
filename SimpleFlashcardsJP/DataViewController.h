//
//  DataViewController.h
//  SimpleFlashcardsJP
//
//  Created by Teru on 2015/01/03.
//  Copyright (c) 2015年 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, strong) id dataObject;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *gearButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UIButton *moveButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) IBOutlet UIView *backView;
- (IBAction)backAction:(id)sender;

@end
