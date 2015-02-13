//
//  EntriesController.h
//  Science Journal
//
//  Created by Evan Teague on 8/19/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddEntryController.h"

@interface EntriesController : UITableViewController <AddEntryControllerDelegate>{
    //UserEntryDatabase *database;
}
   
@property (strong, nonatomic) NSMutableArray *allEntryNames;
@property (strong, nonatomic) NSMutableArray *allEntryDates;
@property (strong, nonatomic) NSMutableArray *allProjectNames;
@property (strong, nonatomic) NSMutableArray *allGoals;
@property (strong, nonatomic) NSMutableArray *allLats;
@property (strong, nonatomic) NSMutableArray *allLongs;
@property (strong, nonatomic) NSMutableArray *allWeather;
@property (strong, nonatomic) NSMutableArray *allMagnets;
@property (strong, nonatomic) NSMutableArray *allPartners;
@property (strong, nonatomic) NSMutableArray *allPermissions;
@property (strong, nonatomic) NSMutableArray *allOutcrops;
@property (strong, nonatomic) NSMutableArray *allStructuralData;
@property (strong, nonatomic) NSMutableArray *allSampleNums;
@property (strong, nonatomic) NSMutableArray *allNotes;
@property (strong, nonatomic) NSMutableDictionary *sections;


@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic) int recordIDToEdit;
-(void)loadData;
@property (nonatomic, strong) NSArray *allEntriesFromDB;

@end
