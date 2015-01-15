//
//  CardTableViewController.h
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/12/10.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChangeFilenameTableViewController.h"
#import "ChangeFoldernameTableViewController.h"
#import "CardListTableViewController.h"

@protocol CardTableViewControllerDelegate

-(void)editingFileInfoWasFinished;
-(void)editingFolderInfoWasFinished;

@end

@interface CardTableViewController : UITableViewController <ChangeFilenameTableViewControllerDelegate, ChangeFoldernameTableViewControllerDelegate>

@property (nonatomic, strong) id<CardTableViewControllerDelegate> cardTableViewDelegate;

@property (nonatomic, strong) NSString *folderID;
@property (nonatomic, strong) NSString *fileID;
@property (nonatomic, strong) NSString *foldernameData;
@property (nonatomic, strong) NSString *filenameData;
@property (nonatomic, strong) NSString *fixedFilename;
@property (nonatomic, strong) NSString *fixedFoldername;

@property (weak, nonatomic) IBOutlet UILabel *filenameLabel;
@property (weak, nonatomic) IBOutlet UILabel *foldernameLabel;

@end
