//
//  AddFileTableViewController.h
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/12/04.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateFileTableViewController.h"
#import "CardTableViewController.h"

@interface AddFileTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource, CreateFileTableViewControllerDelegate, CardTableViewControllerDelegate>

@property (nonatomic, strong) NSString *foldernameData;

@end
