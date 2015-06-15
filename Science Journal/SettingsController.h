//
//  SettingsController.h
//  Science Journal
//
//  Created by Evan Teague on 6/15/15.
//  Copyright (c) 2015 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"


//Delegate
@class SettingsController;
@protocol SettingsControllerDelegate <NSObject>
- (void)settingsControllerUpdate:(SettingsController *) controller settingsArray:(NSArray*)settings;

@end

@interface SettingsController : UITableViewController {
    NSString *projectName;
}
    
- (IBAction)saveSettings:(id)sender;

//IBOutlets
@property (weak, nonatomic) IBOutlet UISwitch *dateSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *goalSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *locationSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *sketchSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *pictureSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *notesSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *permissionsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *sampleNumSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *partnersSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *strikeDipSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *stopNumSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *outcropSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *structuralSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *datasheetSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *trendPlungeSwitch;


//Variables
@property (nonatomic, weak) id <SettingsControllerDelegate> delegate;
@property (nonatomic, strong) DBManager *dbManager;

//Methods
-(void)setProjectSettingsName:(NSString*)pn;

@end
