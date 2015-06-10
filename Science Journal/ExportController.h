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

@interface ExportController : UIViewController <MFMailComposeViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, DBRestClientDelegate> {
    NSMutableArray *pickerData;
    NSString *selectedProject;
    
    NSString *fileRevision;
    NSString *localPath;
    NSString *filename;
}

//IBOutlets
@property (weak, nonatomic) IBOutlet UIPickerView *projectPicker;
@property (weak, nonatomic) IBOutlet UIButton *exportAllButton;
@property (weak, nonatomic) IBOutlet UIButton *exportProjectButton;

//IBActions
- (IBAction)exportGooglEarth:(id)sender;
- (IBAction)emailProject:(id)sender;
- (IBAction)syncDropbox:(id)sender;

//Variables
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) DBRestClient *restClient;

//Methods

@end
