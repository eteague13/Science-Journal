//
//  SettingsController.m
//  Science Journal
//
//  Created by Evan Teague on 6/15/15.
//  Copyright (c) 2015 Evan Teague. All rights reserved.
//

#import "SettingsController.h"

@interface SettingsController ()

@end

@implementation SettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"FieldBookdb.sql"];

    [self loadSettings];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Saves the settings
- (IBAction)saveSettings:(id)sender {
    NSArray *settings = @[[NSNumber numberWithBool:_dateSwitch.isOn],[NSNumber numberWithBool:_goalSwitch.isOn], [NSNumber numberWithBool:_locationSwitch.isOn], [NSNumber numberWithBool:_dateSwitch.isOn], [NSNumber numberWithBool:_dateSwitch.isOn], [NSNumber numberWithBool:_notesSwitch.isOn], [NSNumber numberWithBool:_permissionsSwitch.isOn], [NSNumber numberWithBool:_sampleNumSwitch.isOn], [NSNumber numberWithBool:_partnersSwitch.isOn], [NSNumber numberWithBool:_strikeDipSwitch.isOn], [NSNumber numberWithBool:_stopNumSwitch.isOn], [NSNumber numberWithBool:_outcropSwitch.isOn], [NSNumber numberWithBool:_structuralSwitch.isOn], [NSNumber numberWithBool:_datasheetSwitch.isOn], [NSNumber numberWithBool:_trendPlungeSwitch.isOn]];
    
    [self.delegate settingsControllerUpdate:self settingsArray:settings];
}

//Sets the project name to be able to get the associated settings
-(void)setProjectSettingsName:(NSString*)pn {
    projectName = pn;
}

//Loads the existing settings
-(void)loadSettings{
    NSString *settingsQuery = [NSString stringWithFormat:@"select * from projectSettings where projectName='%@'", projectName];
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:settingsQuery]];
    _dateSwitch.on = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"date"]] intValue];
    _goalSwitch.on = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"goal"]] intValue];
    _locationSwitch.on = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"locationWeather"]] intValue];
    _sketchSwitch.on = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"sketch"]] intValue];
    _pictureSwitch.on = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"picture"]] intValue];
    _notesSwitch.on = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"notes"]] intValue];
    _permissionsSwitch.on = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"permissions"]] intValue];
    _sampleNumSwitch.on = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"sampleNum"]] intValue];
    _partnersSwitch.on = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"partners"]] intValue];
    _strikeDipSwitch.on = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"strikeDip"]] intValue];
    _stopNumSwitch.on = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"stopNum"]] intValue];
    _outcropSwitch.on = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"outcrop"]] intValue];
    _structuralSwitch.on = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"structuralData"]] intValue];
    _datasheetSwitch.on = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"dataSheet"]] intValue];
    _trendPlungeSwitch.on = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"trendPlunge"]] intValue];
}
@end
