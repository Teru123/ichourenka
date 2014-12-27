//
//  SearchResultsTableViewController.h
//  SimpleFlashcardsJP
//
//  Created by Teru on 2014/12/23.
//  Copyright (c) 2014年 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultsTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *searchResults;// Filtered search results
@property (nonatomic, strong) NSMutableArray *searchResultsString;
@property (nonatomic, strong) NSMutableArray *searchResultsString_1;
@property (nonatomic, strong) NSMutableArray *searchResultsNumber;
@property (nonatomic, strong) NSMutableArray *cardText;
@property (nonatomic, strong) NSString *filenameData;
@property (nonatomic, assign) int recordIDToEdit;
@property (nonatomic, assign) int newCard;
@property (nonatomic) int newSearch;

@end
