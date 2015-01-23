//
//  ChangeFilenameTableViewController.h
//  SimpleFlashcardsJP
//
//  Created by Teru on 2015/01/05.
//  Copyright (c) 2015年 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChangeFilenameTableViewControllerDelegate

-(void)editingFileInfoWasFinished;

@end

@interface ChangeFilenameTableViewController : UITableViewController <UITextViewDelegate>

@property (nonatomic, strong) id<ChangeFilenameTableViewControllerDelegate> delegate;

@property (nonatomic, assign) NSInteger folderID;
@property (nonatomic, assign) NSInteger fileID;
@property (nonatomic, strong) NSString *foldernameData;
@property (nonatomic, strong) NSString *filenameData;

@property (weak, nonatomic) IBOutlet UITextView *textField;
- (IBAction)cancelAction:(id)sender;
- (IBAction)saveAction:(id)sender;

@end
