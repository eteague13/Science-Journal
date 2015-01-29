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

@interface ExportController : UIViewController <DBRestClientDelegate, MFMailComposeViewControllerDelegate>
- (IBAction)exportGooglEarth:(id)sender;
@property (nonatomic, strong) DBRestClient *restClient;
- (IBAction)syncDropbox:(id)sender;
@property (nonatomic, strong) DBManager *dbManager;

@end
