//
//  CardListTableViewController.h
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/12/13.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditCardTableViewController.h"

@interface CardListTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource, EditCardTableViewControllerDelegate>

@property (nonatomic, strong) NSString *filenameData;
//@property (nonatomic) int recordIDToEdit;

@end
