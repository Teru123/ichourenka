//
//  CardTableViewController.h
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/12/10.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChangeFilenameTableViewController.h"

@protocol CardTableViewControllerDelegate

-(void)editingFileInfoWasFinished;

@end

@interface CardTableViewController : UITableViewController <ChangeFilenameTableViewControllerDelegate>

@property (nonatomic, strong) id<CardTableViewControllerDelegate> delegate;

@property (nonatomic, strong) NSString *foldernameData;
@property (nonatomic, strong) NSString *filenameData;
@property (nonatomic, strong) NSString *editCardsOrNot;
@property (nonatomic, strong) NSString *fixedFilename;

@property (weak, nonatomic) IBOutlet UILabel *filenameLabel;

@end
