//
//  CreateFileTableViewController.h
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/12/04.
//  Copyright (c) 2014年 Self. All rights reserved.
//

@import GoogleMobileAds;

#import <UIKit/UIKit.h>
#import "EnterFileNameTableViewController.h"

@protocol CreateFileTableViewControllerDelegate

-(void)editingFileInfoWasFinished;

@end

@interface CreateFileTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource, EnterFileNameTableViewControllerDelegate>

@property (nonatomic, strong) id<CreateFileTableViewControllerDelegate> fileDelegate;
@property (nonatomic, strong) NSString *foldernameData;
@property (nonatomic, strong) NSString *filenameData;
@property (nonatomic, assign) NSInteger folderID;
@property (weak, nonatomic) IBOutlet UILabel *fileName;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerViewFour;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView6;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView6Plus;

@end
