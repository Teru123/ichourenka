//
//  CreateFileTableViewController.h
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/12/04.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnterFileNameTableViewController.h"

@interface CreateFileTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource, EnterFileNameTableViewControllerDelegate>

@property (nonatomic, strong) NSString *foldernameData;
@property (weak, nonatomic) IBOutlet UILabel *fileName;

@end
