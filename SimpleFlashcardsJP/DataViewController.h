//
//  DataViewController.h
//  SimpleFlashcardsJP
//
//  Created by Teru on 2015/01/03.
//  Copyright (c) 2015年 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "GADBannerView.h"

@interface DataViewController : UIViewController <UITextViewDelegate, UIAlertViewDelegate, GADBannerViewDelegate>
{
    Reachability* internetReachable;
    Reachability* hostReachable;
    GADBannerView *bannerView_;
}

@property (nonatomic, strong) id dataObject;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSString *filenameData;
@property (nonatomic, assign) NSInteger folderID;
@property (nonatomic, assign) NSInteger fileID;

@property (weak, nonatomic) IBOutlet UITextView *textView;
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
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;

- (IBAction)backAction:(id)sender;
- (IBAction)changeTextAction:(id)sender;
- (IBAction)movePageAction:(id)sender;
- (IBAction)crossAction:(id)sender;

-(void) checkNetworkStatus:(NSNotification *)notice;

@end
