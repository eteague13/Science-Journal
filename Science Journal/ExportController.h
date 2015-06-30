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
#import <CoreText/CoreText.h>
#import <Foundation/Foundation.h>


@interface ExportController : UIViewController <MFMailComposeViewControllerDelegate, DBRestClientDelegate> {
    NSString *selectedProject;
    int numRows;
    int numColumns;

    
}

//IBOutlets


//IBActions

//Variables
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSMutableDictionary *dataArray;
@property (nonatomic, strong) DBRestClient *restClient;

//Methods
-(void) exportSelectedProjects:(NSMutableArray *) projects;
-(void) exportAllProjects;
-(void) drawImage:(UIImage*)image inRect:(CGRect)rect;
-(void) exportAllToPDF;
-(void)dropboxFileToSync:(NSString *)name withPath:(NSString *)namePath;
-(void)createDropboxProjectFolders;



@end
