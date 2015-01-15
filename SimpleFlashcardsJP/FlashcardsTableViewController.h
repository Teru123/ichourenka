//
//  FlashcardsTableViewController.h
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/11/23.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateFolderTableViewController.h"
#import "AddFileTableViewController.h"

@interface FlashcardsTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, CreateFolderTableViewControllerDelegate, AddFileTableViewControllerDelegate>
{

}


@end
