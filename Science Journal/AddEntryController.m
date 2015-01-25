//
//  AddEntryController.m
//  Science Journal
//
//  Created by Evan Teague on 12/23/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import "AddEntryController.h"
#import "Entry.h"
#import "datepickerController.h"
#import "textEntryController.h"
#import "LocationAndWeatherController.h"
#import "SettingsController.h"
#import "MagneticDecController.h"

@interface AddEntryController ()

@end

@implementation AddEntryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"entriesdb.sql"];
    NSLog(@"adding num: %d", self.recordIDToEdit);
    if (self.recordIDToEdit != -1) {
        [self loadInfoToEdit];
    }
    if (isEditEntry){
        _entryTitleLabel.title = @"Edit Entry";
    }
    
    
    
    
    
    bool geoMagDecSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:@"SwitchGeoMagDec"];
    if (geoMagDecSwitch) {
        _geoMagneticCell.hidden = NO;
    }else{
        _geoMagneticCell.hidden = YES;
    }
    
    bool geoOutcropSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:@"SwitchGeoOutcrop"];
    if (geoOutcropSwitch) {
        _geoOutcropCell.hidden = NO;
    }else{
        _geoOutcropCell.hidden = YES;
    }
    bool geoStopNumSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:@"SwitchGeoStopNum"];
    if (geoStopNumSwitch) {
        _geoStopNumCell.hidden = NO;
    }else{
        _geoStopNumCell.hidden = YES;
    }
    bool geoStructSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:@"SwitchGeoStructData"];
    if (geoStructSwitch) {
        _geoStructCell.hidden = NO;
    }else{
        _geoStructCell.hidden = YES;
    }
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self.entryNameField becomeFirstResponder];
    }
}

- (IBAction)cancelButton:(id)sender {
    [self.delegate AddEntryControllerDidCancel:self];
    
    
}

- (IBAction)saveButton:(id)sender {
    _name = _entryNameField.text;
    _projectName = _projectNameField.text;
    _stopNum = _stopNumField.text;
    _date = _dateLabelField.text;
    _sampleNum = _sampleNumberField.text;
    /*
        NSMutableString *printString = [NSMutableString stringWithFormat:@"Entry name: %@; Date: %@; Project Name: %@; Goal: %@; Latitude: %@; Longitude: %@; Weather: %@; Magnetic Field: %@; Partners: %@; Permissions: %@; Outcrop: %@; Structural: %@; Sample Number: %@; Notes: %@; Stop Number: %@", _name, _date, _projectName, _goal, _latitude, _longitude, _weather, _magnet, _partners, _permissions, _outcrop, _structuralData, _sampleNum, _notes, _stopNum];
        
        
        NSError *error;
        
        
        NSString *documentsDirectory = [NSHomeDirectory()
                                        stringByAppendingPathComponent:@"Documents"];
        NSString *fileName = [NSMutableString stringWithFormat:@"%@%@", _name, @".txt"];
        NSString *filePath = [documentsDirectory
                              stringByAppendingPathComponent:fileName];
        
        NSLog(@"string to write:%@", printString);
        
        [printString writeToFile:filePath atomically:YES
                        encoding:NSUTF8StringEncoding error:&error];
        
        NSLog(@"%@", filePath);
        
        */
        // Prepare the query string.
        //It's not working because it can't store photo and sketch
        //http://www.appcoda.com/sqlite-database-ios-app-tutorial/
        //NSData *photoData = UIImagePNGRepresentation(_photo);
        //NSData *sketchData = UIImagePNGRepresentation(_sketch);
        
        NSString *query;
        if(self.recordIDToEdit == -1){
            query = [NSString stringWithFormat:@"insert into entriesBasic values(null, '%@', '%@', '%@','%@', '%@', '%@','%@', '%@', '%@','%@', '%@', '%@', '%@')",_name,_projectName, _date, _goal, _latitude, _longitude, _weather, _sketch, _picture, _notes, _permissions, _sampleNum, _partners];
        }else{
            query = [NSString stringWithFormat:@"update set name='%@', projectName='%@', date='%@',goal='%@', latitude='%@', longitude='%@',weather='%@', sketch='%@', picture='%@',notes='%@',permissions='%@', sampleNum='%@', partners='%@' where entriesID=%d",_name,_projectName, _date, _goal, _latitude, _longitude, _weather, _sketch, _picture, _notes, _permissions, _sampleNum, _partners, self.recordIDToEdit];
        }
        

        [self.dbManager executeQuery:query];

        if (self.dbManager.affectedRows != 0) {
            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        }
        else{
            NSLog(@"Could not execute the query.");
        }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)datepickerControllerCancel:(datepickerController *) controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)datepickerControllerSave:(datepickerController *)controller didSaveDate:(NSString*) date{
    _dateLabelField.text = date;
    _date = date;
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)textEntryControllerCancel:(textEntryController *) controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//Need to figure out how this relates to the SQLite database
- (void)textEntryControllerSave:(textEntryController *)controller didSaveText:(NSString*) text rowSelected:(int)row sectionSelected:(int)section{
    
    if (section == 0){
        switch (row) {
            case 3:
                _goal = text;
                break;
            case 7:
                _notes = text;
                break;
            case 8:
                _permissions = text;
                break;
            default:
                NSLog(@"Default");
                break;
        }
    }else if (section == 1){
        switch (row) {
            case 2:
                _outcrop = text;
                break;
            case 3:
                _structuralData = text;
                break;
            default:
                break;
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)LocationAndWeatherCancel:(LocationAndWeatherController *) controller {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)LocationAndWeatherSave:(LocationAndWeatherController *)controller lat:(NSString*) lat longitude:(NSString*)longitude weather:(NSString*) weather{
    _latitude = lat;
    _longitude = longitude;
    _weather = weather;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddDate"]) {
        datepickerController* dateController = segue.destinationViewController;
        dateController.delegate = self;
        [dateController setDateValue:_date];
        
    }else if ([segue.identifier isEqualToString:@"TextEntry"]) {
        textEntryController* textController = segue.destinationViewController;
        textController.delegate = self;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        int rowSelected = (int)indexPath.row;
        int sectionSelected = (int)indexPath.section;
        [textController updateRowSelected:rowSelected updateSectionSelected:sectionSelected];
        
        if (sectionSelected == 0){
            switch (rowSelected) {
                case 3:
                    [textController setTextValue:_goal];
                    break;
                case 7:
                    [textController setTextValue:_notes];
                    break;
                case 8:
                    [textController setTextValue:_permissions];
                    break;
                default:
                    NSLog(@"Default");
                    break;
            }
        }else if (sectionSelected == 1){
            switch (rowSelected) {
                case 2:
                    [textController setTextValue:_outcrop];
                    break;
                case 3:
                    [textController setTextValue:_structuralData];
                    break;
                default:
                    break;
            }
        }
    }else if ([segue.identifier isEqualToString:@"LocationAndWeather"]){
        LocationAndWeatherController* locationController = segue.destinationViewController;
        locationController.delegate = self;
        [locationController setLat:_latitude setLong:_longitude setWeather:_weather];
    }else if ([segue.identifier isEqualToString:@"Sketch"]){
        SketchController *sketchController = segue.destinationViewController;
        sketchController.delegate = self;
        //Sketch still isn't working
        [sketchController setSketch: _sketch];
    }else if ([segue.identifier isEqualToString:@"Photo"]){
        CameraController *cameraController = segue.destinationViewController;
        cameraController.delegate = self;
        [cameraController setPhoto:_picture];
    }else if ([segue.identifier isEqualToString:@"Magnet"]){
        MagneticDecController *magnetController = segue.destinationViewController;
        magnetController.delegate = self;
        [magnetController setVal1:_magneticValue1 setVal2:_magneticValue2 setType:_magneticType];
    }
}

-(void)setEditEntry:(BOOL)value{
    isEditEntry = value;
    
}

- (void) sketchControllerSave:(SketchController *)controller didFinishSketch:(UIImage *)item{
    _sketch = item;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sketchControllerCancel:(SketchController *) controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cameraControllerCancel:(CameraController *) controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)cameraControllerSave:(CameraController *)controller didSavePhoto:(UIImage*) photo{
    _picture = photo;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)magDecControllerCancel:(MagneticDecController *) controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)magDecControllerSave:(MagneticDecController *)controller value1:(NSString*)v1 value2:(NSString*)v2 type:(NSString*)type{
    _magneticValue1 = v1;
    _magneticValue2 = v2;
    _magneticType = type;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell == _geoMagneticCell){
        if(_geoMagneticCell.hidden){
            return 0;
        }else{
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];
        }
    }else if (cell == _geoOutcropCell){
        if(_geoOutcropCell.hidden){
            return 0;
        }else{
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];
        }
    }else if (cell == _geoStopNumCell){
        if(_geoStopNumCell.hidden){
            return 0;
        }else{
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];
        }
    }else if (cell == _geoStructCell){
        if(_geoStructCell.hidden){
            return 0;
        }else{
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];
        }
    
    }else{
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
}
-(void)loadInfoToEdit{
    
    
    NSString *query = [NSString stringWithFormat:@"select * from entriesBasic where entriesID = %d", self.recordIDToEdit];
    NSLog(@"Query: %@", query);
    
   
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSLog(@"results in info edit: %@", results);
    _name = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"name"]];

    _date = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"date"]];
    _projectName = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"projectName"]];
    _goal = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"goal"]];
    _latitude = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"latitude"]];
    _longitude = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"longitude"]];
    _weather = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"weather"]];
    _partners = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"partners"]];
    _permissions = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"permissions"]];
    _sampleNum = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"sampleNum"]];
    _notes = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"notes"]];
    _picture = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"picture"]];
    _sketch = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"sketch"]];
    
    _entryNameField.text = _name;
    _projectNameField.text = _projectName;
    _dateLabelField.text = _date;
    _sampleNumberField.text = _sampleNum;
    _stopNumField.text = _stopNum;
}


@end
