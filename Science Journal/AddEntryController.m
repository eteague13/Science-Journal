//
//  AddEntryController.m
//  Science Journal
//
//  Created by Evan Teague on 12/23/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import "AddEntryController.h"
#import "datepickerController.h"
#import "textEntryController.h"
#import "LocationAndWeatherController.h"
#import "SettingsController.h"
#import "MagneticDecController.h"
#import "SketchController.h"

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
    
//self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Sandcropped1.jpg"]];
    //self.tableView.backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Sandcropped1.jpg"]];
[self.tableView setSeparatorColor:[UIColor blackColor]];

    
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
    NSString *savedSketchLocation;
    if (_sketch != nil){
        NSString *sketchname = [NSMutableString stringWithFormat:@"%@%@", _name, @"_sketch.png"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        savedSketchLocation = [documentsDirectory stringByAppendingPathComponent:sketchname];
        NSData *sketchData = UIImagePNGRepresentation(_sketch);
        [sketchData writeToFile:savedSketchLocation atomically:NO];
    }
    NSString *savedPictureLocation;
    if (_picture != nil){
        NSString *picturename = [NSMutableString stringWithFormat:@"%@%@", _name, @"_picture.png"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        savedPictureLocation = [documentsDirectory stringByAppendingPathComponent:picturename];
        NSData *pictureData = UIImagePNGRepresentation(_picture);
        [pictureData writeToFile:savedPictureLocation atomically:NO];
    }
    
   
    
    if ([_date length] == 0){
        _date = @"";
    }
    if ([_goal length] == 0){
        _goal = @"";
    }
    if ([_latitude length] == 0){
        _latitude = @"";
    }
    if ([_longitude length] == 0){
        _longitude = @"";
    }
    if ([_weather length] == 0){
        _weather = @"";
    }
    if ([_notes length] == 0){
        _notes = @"";
    }
    if ([_permissions length] == 0){
        _permissions = @"";
    }
    if ([_sampleNum length] == 0){
        _sampleNum = @"";
    }
    if ([_partners length] == 0){
        _partners = @"";
    }
    if ([_outcrop length] == 0){
        _outcrop = @"";
    }
    if ([_structuralData length] == 0){
        _structuralData = @"";
    }
    if ([_magneticValue1 length] == 0){
        _magneticValue1 = @"";
    }
    if ([_magneticValue2 length] == 0){
        _magneticValue2 = @"";
    }
    if ([_magneticType length] == 0){
        _magneticType = @"";
    }
    if ([_stopNum length] == 0){
        _stopNum = @"";
    }
    NSString *queryBasic;
    NSString *queryGeology;
    if(self.recordIDToEdit == -1){
        queryBasic = [NSString stringWithFormat:@"insert into entriesBasic values(null, '%@', '%@', '%@','%@', '%@', '%@','%@', '%@', '%@','%@', '%@', '%@', '%@')",_name,_projectName, _date, _goal, _latitude, _longitude, _weather, savedSketchLocation, savedPictureLocation, _notes, _permissions, _sampleNum, _partners];
        queryGeology = [NSString stringWithFormat:@"insert into entriesGeology values(null, '%@', '%@','%@','%@','%@','%@')",_outcrop, _structuralData, _magneticValue1, _magneticValue2, _magneticType, _stopNum];
    }else{
        queryBasic = [NSString stringWithFormat:@"update entriesBasic set name='%@', projectName='%@', date='%@',goal='%@', latitude='%@', longitude='%@',weather='%@', sketch='%@', picture='%@',notes='%@',permissions='%@', sampleNum='%@', partners='%@' where entriesID=%d",_name,_projectName, _date, _goal, _latitude, _longitude, _weather, savedSketchLocation, savedPictureLocation, _notes, _permissions, _sampleNum, _partners, self.recordIDToEdit];
        queryGeology = [NSString stringWithFormat:@"update entriesGeology set outcrop='%@', structuralData='%@',magneticValue1='%@',magneticValue2='%@',magneticType='%@',stopNum='%@' where entriesID=%d",_outcrop, _structuralData, _magneticValue1, _magneticValue2, _magneticType, _stopNum, self.recordIDToEdit];
    }
    
        
    if ([_projectName length] == 0){
        NSLog(@"Empty project name");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Entry Error" message: @"You need to add a Project Name" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }else{
        [self.dbManager executeQuery:queryBasic];

        if (self.dbManager.affectedRows != 0) {
            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
    }
        else{
            NSLog(@"Could not execute the query.");
        }
    
        [self.dbManager executeQuery:queryGeology];
    
        if (self.dbManager.affectedRows != 0) {
            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        }
        else{
            NSLog(@"Could not execute the query.");
        }
    
        [self.delegate AddEntryControllerDidSave:self];
    }
    //[self dismissViewControllerAnimated:YES completion:nil];
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
            case 10:
                _partners = text;
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
    [self reloadPreviewStrings];

}

- (void)LocationAndWeatherCancel:(LocationAndWeatherController *) controller {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)LocationAndWeatherSave:(LocationAndWeatherController *)controller lat:(NSString*) lat longitude:(NSString*)longitude weather:(NSString*) weather{
    _latitude = lat;
    _longitude = longitude;
    _weather = weather;
    [self dismissViewControllerAnimated:YES completion:nil];
    [self reloadPreviewStrings];

    
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
        NSLog(@"row selected: %d", rowSelected);
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
                case 10:
                    [textController setTextValue:_partners];
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

- (void) sketchControllerSave:(SketchController *)controller didFinishSketch:(UIImage*)item{
    _sketch = item;
    NSLog(@"Passed back sketch");
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
    
    
    NSString *query = [NSString stringWithFormat:@"select * from entriesBasic inner join entriesGeology on entriesBasic.entriesID = entriesGeology.entriesID where entriesBasic.entriesID = %d", self.recordIDToEdit];
    
   
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    //NSLog(@"results in info edit: %@", results);
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
    _partners = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"partners"]];
    NSString *pictureFilePath = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"picture"]];
    _picture = [UIImage imageWithContentsOfFile:pictureFilePath];
    NSString *sketchFilePath = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"sketch"]];
    _sketch = [UIImage imageWithContentsOfFile:sketchFilePath];
    
    _entryNameField.text = _name;
    _projectNameField.text = _projectName;
    _dateLabelField.text = _date;
    _sampleNumberField.text = _sampleNum;
    _stopNumField.text = _stopNum;
    
    
    
    
    
    _outcrop = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"outcrop"]];
    _structuralData = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"structuralData"]];
    _magneticValue1 = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"magneticValue1"]];
    _magneticValue2 = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"magneticValue2"]];
    _magneticType = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"magneticType"]];
    _stopNum = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"stopNum"]];
    _stopNumField.text = _stopNum;
    
    [self reloadPreviewStrings];
    
    
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Sandcropped1.jpg"]];
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow.png"]];
    cell.accessoryView = arrow;
    
    
}

-(void)reloadPreviewStrings{
    if ([_goal length] != 0){
        if ([_goal length] > 25){
            _goalLabelField.text = [[_goal substringToIndex:25] stringByAppendingString:@"..."];
        }else{
            _goalLabelField.text = _goal;
        }
    }
    if ([_weather length] != 0){
        _locWeatherField.text = [_weather substringToIndex:5];
    }
    if ([_partners length] != 0){
        if ([_partners length] > 25){
            _partnersField.text = [[_partners substringToIndex:25] stringByAppendingString:@"..."];
        }else{
            _partnersField.text = _partners;
        }
    }
    if ([_permissions length] != 0){
        if ([_permissions length] > 25){
            _permissionsField.text = [[_permissions substringToIndex:25] stringByAppendingString:@"..."];
        }else{
            _permissionsField.text = _permissions;
        }
    }
    if ([_notes length] != 0){
        if ([_notes length] > 25){
            _notesField.text = [[_notes substringToIndex:25] stringByAppendingString:@"..."];
        }else{
            _notesField.text = _notes;
        }
    }
    if ([_outcrop length] != 0){
        if ([_outcrop length] > 25){
            _outcropField.text = [[_outcrop substringToIndex:25] stringByAppendingString:@"..."];
        }else{
            _outcropField.text = _outcrop;
        }
    }
    if ([_structuralData length] != 0){
        NSLog(@"Struct");
        if ([_structuralData length] > 25){
            _structuralField.text = [[_structuralData substringToIndex:25] stringByAppendingString:@"..."];
        }else{
            _structuralField.text = _structuralData;
        }
    }
}



@end
