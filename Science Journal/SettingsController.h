//
//  SettingsController.h
//  Science Journal
//
//  Created by Evan Teague on 8/18/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface SettingsController : UIViewController <DBRestClientDelegate>
@property (nonatomic, strong) DBRestClient *restClient;
- (IBAction)syncDropbox:(id)sender;



@end
