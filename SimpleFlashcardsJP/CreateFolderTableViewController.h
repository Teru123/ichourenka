//
//  CreateFolderTableViewController.h
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/11/25.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnterFolderNameTableViewController.h"

@protocol CreateFolderTableViewControllerDelegate

-(void)folderEditingInfoWasFinished;

@end

@interface CreateFolderTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, EnterFolderNameTableViewControllerDelegate>

@property (nonatomic, strong) id<CreateFolderTableViewControllerDelegate> folderDelegate;
@property (nonatomic, assign) NSInteger countNum;

@property (weak, nonatomic) IBOutlet UILabel *folderName;

@end
