//
//  ProjectsController.h
//  Science Journal
//
//  Created by Evan Teague on 6/5/15.
//  Copyright (c) 2015 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "ProjectCell.h"
#import "EntriesController.h"
#import "AddProjectController.h"

@interface ProjectsController : UITableViewController <AddProjectControllerDelegate, UIGestureRecognizerDelegate>{
    NSString *oldProjectName;
    int oldProjectID;
}

//IBOutlets

//IBActions

//Variables
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSMutableArray *allProjectsFromDB;
@property (nonatomic, strong) ProjectCell *projectCellToDelete;
@property (nonatomic) int projectIDToEdit;

//Methods


@end
