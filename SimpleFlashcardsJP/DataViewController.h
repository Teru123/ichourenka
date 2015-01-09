//
//  DataViewController.h
//  SimpleFlashcardsJP
//
//  Created by Teru on 2015/01/03.
//  Copyright (c) 2015年 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DataViewControllerDelegate

-(void)dataInfoWasFinished;

@end

@interface DataViewController : UIViewController <UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (nonatomic, strong) id<DataViewControllerDelegate> dataDelegate;
@property (nonatomic, strong) id dataObject;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) int showMoveSlider;

@property (weak, nonatomic) IBOutlet UIView *textView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *gearButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UIButton *moveButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *pageCountLabel;
@property (weak, nonatomic) IBOutlet UISlider *movePageSlider;
@property (weak, nonatomic) IBOutlet UIView *horizontalView;
@property (weak, nonatomic) IBOutlet UIButton *crossButton;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UITextView *changeText;

- (IBAction)backAction:(id)sender;
- (IBAction)changeTextAction:(id)sender;
- (IBAction)movePageAction:(id)sender;
- (IBAction)crossAction:(id)sender;
- (IBAction)playAction:(id)sender;
- (IBAction)pauseAction:(id)sender;
- (IBAction)stopAction:(id)sender;

@end
