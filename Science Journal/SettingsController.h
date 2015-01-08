//
//  SettingsController.h
//  Science Journal
//
//  Created by Evan Teague on 8/18/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>



@interface SettingsController : UIViewController <DBRestClientDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) DBRestClient *restClient;
- (IBAction)syncDropbox:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (weak, nonatomic) IBOutlet UISwitch *geoMagDecSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *geoStopNumSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *geoOutcropSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *geoStructDataSwitch;
- (IBAction)geoMagDecFlip:(id)sender;
- (IBAction)geoStopNumFlip:(id)sender;
- (IBAction)geoOutcropFlip:(id)sender;
- (IBAction)geoStructDataFlip:(id)sender;





@end
