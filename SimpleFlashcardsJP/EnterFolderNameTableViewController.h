//
//  EnterFolderNameTableViewController.h
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/11/25.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnterFolderNameTableViewController : UITableViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *folderNameText;
- (IBAction)backToCreateFolder:(id)sender;
- (IBAction)saveFolderName:(id)sender;

@end
