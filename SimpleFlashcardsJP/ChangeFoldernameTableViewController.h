//
//  ChangeFoldernameTableViewController.h
//  SimpleFlashcardsJP
//
//  Created by Teru on 2015/01/14.
//  Copyright (c) 2015年 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChangeFoldernameTableViewControllerDelegate

-(void)editingFolderInfoWasFinished;

@end

@interface ChangeFoldernameTableViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, strong) id<ChangeFoldernameTableViewControllerDelegate> delegate;

@property (nonatomic, assign) NSInteger folderID;
@property (nonatomic, strong) NSString *foldernameData;
@property (weak, nonatomic) IBOutlet UITextField *textField;

- (IBAction)cancelAction:(id)sender;
- (IBAction)saveAction:(id)sender;

@end
