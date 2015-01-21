//
//  CardListTableViewController.h
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/12/13.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditCardTableViewController.h"
#import "SearchResultsTableViewController.h"

@protocol CardListTableViewControllerDelegate

-(void)addingCardInfoWasFinished;
-(void)deletingCardInfoWasFinished;

@end

@interface CardListTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource, EditCardTableViewControllerDelegate, SearchResultsTableViewControllerDelegate>

@property (nonatomic, strong) id<CardListTableViewControllerDelegate> cardListTableViewDelegate;

@property (nonatomic, strong) NSString *filenameData;
@property (nonatomic, strong) NSMutableArray *cardText;
@property (nonatomic, strong) NSMutableArray *cardNumber;
@property (nonatomic, strong) NSMutableArray *cardInfo;
@property (nonatomic, copy) NSString *cardnumber;
@property (nonatomic, assign) NSInteger folderID;
@property (nonatomic, assign) NSInteger fileID;

@end
