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

//IBOutlets
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
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
@property (weak, nonatomic) IBOutlet UISwitch *strikeDipSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *stopNumSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *outcropSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *structuralDataSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *trendPlungeSwitch;
@property (weak, nonatomic) IBOutlet UILabel *dropboxStatusLabel;

//IBActions
- (IBAction)stopNumFlip:(id)sender;
- (IBAction)outcropFlip:(id)sender;
- (IBAction)structDataFlip:(id)sender;
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
- (IBAction)strikeDipFlip:(id)sender;
- (IBAction)trendPlungeFlip:(id)sender;

//Variables
@property (nonatomic, strong) DBRestClient *restClient;

//Methods


@end
