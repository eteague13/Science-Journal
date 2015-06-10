//
//  TablesViewController.h
//  Science Journal
//
//  Created by Evan Teague on 1/12/15.
//  Copyright (c) 2015 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddReferenceController.h"
#import "DBManager.h"
#import "EntriesCell.h"
#import "ViewReferenceController.h"


@interface ReferenceViewController : UITableViewController <AddReferenceControllerDelegate, ViewReferenceControllerDelegate> {
    
}

//IBOutlets
@property (strong, nonatomic) IBOutlet UITableView *referenceTable;

//IBActions

//Variables
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *allReferencesFromDB;

//Methods


    

@end
