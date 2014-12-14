//
//  EditCardTableViewController.h
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/12/11.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditCardTableViewControllerDelegate

-(void)cardEditingInfoWasFinished;

@end

@interface EditCardTableViewController : UITableViewController

@property (nonatomic, strong) id<EditCardTableViewControllerDelegate> editCardDelegate;
@property (nonatomic, strong) NSString *filenameData;
@property (nonatomic) int recordIDToEdit;

@end
