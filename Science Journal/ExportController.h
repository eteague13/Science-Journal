//
//  ExportController.h
//  Science Journal
//
//  Created by Evan Teague on 8/18/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import <MessageUI/MessageUI.h>
#import <DropboxSDK/DropboxSDK.h>
#import "ProjectCell.h"

@interface ExportController : UIViewController <MFMailComposeViewControllerDelegate> {
    NSString *selectedProject;
}

//IBOutlets


//IBActions

//Variables
@property (nonatomic, strong) DBManager *dbManager;

//Methods
-(void) exportSelectedProjects:(NSMutableArray *) projects;
-(void) exportAllProjects;

@end
