//
//  EntriesController.h
//  Science Journal
//
//  Created by Evan Teague on 8/19/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EntriesController : UITableViewController
@property (strong, nonatomic) NSArray *allEntryNames;
@property (strong, nonatomic) NSArray *allEntryDates;
@property (strong, nonatomic) NSArray *allProjectNames;
@property (strong, nonatomic) NSArray *allGoals;
@property (strong, nonatomic) NSArray *allLats;
@property (strong, nonatomic) NSArray *allLongs;
@property (strong, nonatomic) NSArray *allWeather;
@property (strong, nonatomic) NSArray *allMagnets;
@property (strong, nonatomic) NSArray *allPartners;
@property (strong, nonatomic) NSArray *allPermissions;
@property (strong, nonatomic) NSArray *allOutcrops;
@property (strong, nonatomic) NSArray *allStructuralData;
@property (strong, nonatomic) NSArray *allSampleNums;
@property (strong, nonatomic) NSArray *allNotes;
    

@end
