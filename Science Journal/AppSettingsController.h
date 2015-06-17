//
//  AppSettingsController.h
//  Science Journal
//
//  Created by Evan Teague on 6/16/15.
//  Copyright (c) 2015 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface AppSettingsController : UITableViewController <DBNetworkRequestDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *dropboxSwitch;
- (IBAction)loginToDropbox:(id)sender;

@end
