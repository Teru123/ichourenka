//
//  HelpViewController.h
//  SimpleFlashcardsJP
//
//  Created by Teru on 2015/01/20.
//  Copyright (c) 2015年 Self. All rights reserved.
//

@import GoogleMobileAds;

#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerViewFour;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView6;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView6Plus;

@end
