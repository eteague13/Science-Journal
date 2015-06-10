//
//  EntriesController.h
//  Science Journal
//
//  Created by Evan Teague on 8/19/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddEntryController.h"

@interface EntriesController : UITableViewController <AddEntryControllerDelegate>

//IBOutlets

//IBActions

//Variables
@property (strong, nonatomic) NSMutableDictionary *sections;
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic) int recordIDToEdit;
@property (nonatomic, strong) NSArray *allEntriesFromDB;
@property (nonatomic, strong) NSString *projectNameList;

//Methods
-(void)setProjectName:(NSString *)projectNameList;

@end
