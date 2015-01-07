//
//  ExportController.h
//  Science Journal
//
//  Created by Evan Teague on 8/18/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserEntryDatabase.h"
#import "Entry.h"
#import <DropboxSDK/DropboxSDK.h>

@interface ExportController : UIViewController <DBRestClientDelegate>
@property (strong, nonatomic) UserEntryDatabase *database;
- (IBAction)exportGooglEarth:(id)sender;
@property (nonatomic, strong) DBRestClient *restClient;
- (IBAction)syncDropbox:(id)sender;

@end
