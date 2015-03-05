//
//  OptionsTableViewController.h
//  SimpleFlashcardsJP
//
//  Created by Teru on 2015/01/18.
//  Copyright (c) 2015年 Self. All rights reserved.
//

@import GoogleMobileAds;

#import <UIKit/UIKit.h>

@interface OptionsTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *orderDetail;
@property (weak, nonatomic) IBOutlet UILabel *fontsizeDetail;
@property (weak, nonatomic) IBOutlet UILabel *backcolorDetail;
@property (weak, nonatomic) IBOutlet UILabel *languageDetail;

@property (weak, nonatomic) IBOutlet GADBannerView *bannerViewFour;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView6;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView6Plus;

@end
