//
//  EnterFolderNameTableViewController.h
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/11/25.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EnterFolderNameTableViewControllerDelegate

-(void)editingInfoWasFinished;

@end

@interface EnterFolderNameTableViewController : UITableViewController<UITextFieldDelegate>
{

}

@property (nonatomic, strong) id<EnterFolderNameTableViewControllerDelegate> delegate;
@property (nonatomic) int recordIDToEdit;
@property (weak, nonatomic) IBOutlet UITextField *folderNameText;

- (IBAction)backToCreateFolder:(id)sender;
- (IBAction)saveFolderName:(id)sender;

@end
