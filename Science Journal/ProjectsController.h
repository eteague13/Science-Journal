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

@interface ProjectsController : UITableViewController <AddProjectControllerDelegate>


@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSMutableArray *allProjectsFromDB;


@end
