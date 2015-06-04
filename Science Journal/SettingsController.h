//
//  SettingsController.h
//  Science Journal
//
//  Created by Evan Teague on 8/18/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DBManager.h"
#import <DropboxSDK/DropboxSDK.h>



@interface SettingsController : UIViewController <UIScrollViewDelegate, DBRestClientDelegate> {
    NSString *fileRevision;
    NSString *localPath;
    NSString *filename;
}


@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (weak, nonatomic) IBOutlet UISwitch *geoMagDecSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *geoStopNumSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *geoOutcropSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *geoStructDataSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *dateSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *goalSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *locationWeatherSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *sketchSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *pictureSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *notesSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *permissionSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *sampleSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *partnersSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *dataSheetSwitch;
- (IBAction)geoMagDecFlip:(id)sender;
- (IBAction)geoStopNumFlip:(id)sender;
- (IBAction)geoOutcropFlip:(id)sender;
- (IBAction)geoStructDataFlip:(id)sender;
- (IBAction)dateFlip:(id)sender;
- (IBAction)goalFlip:(id)sender;
- (IBAction)locationWeatherFlip:(id)sender;
- (IBAction)sketchFlip:(id)sender;
- (IBAction)pictureFlip:(id)sender;
- (IBAction)notesFlip:(id)sender;
- (IBAction)permissionsFlip:(id)sender;
- (IBAction)sampleNumFlip:(id)sender;
- (IBAction)partnersFlip:(id)sender;
- (IBAction)linkDropbox:(id)sender;
- (IBAction)unlinkDropbox:(id)sender;
- (IBAction)dataSheetFlip:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *dropboxStatusLabel;

@property (nonatomic, strong) DBRestClient *restClient;





@end
