//
//  ExportController.h
//  Science Journal
//
//  Created by Evan Teague on 8/18/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import "DBManager.h"
#import <MessageUI/MessageUI.h>

@interface ExportController : UIViewController <DBRestClientDelegate, MFMailComposeViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
    NSMutableArray *pickerData;
    NSString *selectedProject;
}
- (IBAction)exportGooglEarth:(id)sender;
//@property (nonatomic, strong) DBRestClient *restClient;
//- (IBAction)syncDropbox:(id)sender;
@property (nonatomic, strong) DBManager *dbManager;
@property (weak, nonatomic) IBOutlet UIPickerView *projectPicker;
- (IBAction)emailProject:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *exportAllButton;
@property (weak, nonatomic) IBOutlet UIButton *exportProjectButton;

@end
