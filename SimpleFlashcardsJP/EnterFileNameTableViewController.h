//
//  EnterFileNameTableViewController.h
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/12/04.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EnterFileNameTableViewControllerDelegate

-(void)editingInfoWasFinished;

@end

@interface EnterFileNameTableViewController : UITableViewController <UITextViewDelegate>

@property (nonatomic, strong) id<EnterFileNameTableViewControllerDelegate> delegate;
@property (nonatomic) int recordIDToEdit;
@property (weak, nonatomic) IBOutlet UITextView *filenameText;


- (IBAction)cancelButton:(id)sender;
- (IBAction)saveButton:(id)sender;

@end
