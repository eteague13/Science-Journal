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
#import "ExportController.h"
#import <DropboxSDK/DropboxSDK.h>
#import <QuartzCore/QuartzCore.h>


@interface ProjectsController : UITableViewController <AddProjectControllerDelegate, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate, DBRestClientDelegate>{
    NSString *oldProjectName;
    int oldProjectID;
    NSString *localPath;
    BOOL fileExists;
    ExportController *exporter;


}

//IBOutlets

//IBActions

//Variables
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSMutableArray *allProjectsFromDB;
@property (nonatomic, strong) ProjectCell *projectCellToDelete;
@property (nonatomic) int projectIDToEdit;
@property (nonatomic, strong) NSMutableArray *selectedProjectsToExport;
@property (nonatomic, strong) UIBarButtonItem *cancelExport;
@property (nonatomic, strong) UIBarButtonItem *exportItem;
@property (nonatomic, strong) UIBarButtonItem *addItem;
@property (nonatomic, strong) UIBarButtonItem *finishedSelection;
@property (nonatomic, strong) NSMutableArray *dropboxFilesToUpload;


//Methods




@end
