//
//  SettingsController.h
//  Science Journal
//
//  Created by Evan Teague on 8/18/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DBManager.h"



@interface SettingsController : UIViewController <UIScrollViewDelegate>


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

@property (weak, nonatomic) IBOutlet UISlider *brushSizeSlider;
@property (weak, nonatomic) IBOutlet UISlider *brushOpacitySlider;




@end
