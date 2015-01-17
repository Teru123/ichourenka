//
//  EnterCardnameTableViewController.h
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/12/11.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EnterCardnameTableViewControllerDelegate

-(void)editingCardTextInfoWasFinished;

@end

@interface EnterCardnameTableViewController : UITableViewController <UITextViewDelegate>

@property (nonatomic, strong) id<EnterCardnameTableViewControllerDelegate> cardTextDelegate;
@property (nonatomic, strong) NSString *cellText;
@property (nonatomic, strong) NSString *filenameData;
@property (nonatomic, strong) NSString *titleNumber;
@property (nonatomic, assign) NSInteger folderID;
@property (nonatomic, assign) NSInteger fileID;
@property (nonatomic) int recordIDToEdit;
@property (nonatomic) int newCard;
@property (weak, nonatomic) IBOutlet UITextView *cardText;
- (IBAction)doneAction:(id)sender;

- (IBAction)cancelButton:(id)sender;

@end
