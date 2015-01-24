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
    databaseCopy = [UserEntryDatabase userEntryDatabase];
    if (isEditEntry){
        _entryTitleLabel.title = @"Edit Entry";
    }
    
    /*
    _name = _associatedEntry.name;
    _date = _associatedEntry.date;
    _projectName = _associatedEntry.projectName;
    _goal = _associatedEntry.goal;
    _latitude = _associatedEntry.latitude;
    _longitude = _associatedEntry.longitude;
    _weather = _associatedEntry.weather;
    _magnet = _associatedEntry.magnet;
    _partners = _associatedEntry.partners;
    _permissions = _associatedEntry.permissions;
    _outcrop = _associatedEntry.outcrop;
    _structuralData = _associatedEntry.structuralData;
    _sampleNum = _associatedEntry.sampleNum;
    _notes = _associatedEntry.notes;
    _photo = _associatedEntry.photo;
    _sketch = _associatedEntry.sketch;
    
    _entryNameField.text = _name;
    _projectNameField.text = _projectName;
    _dateLabelField.text = _date;
    _sampleNumberField.text = _sampleNum;
    _stopNumField.text = _stopNum;
    _magneticValue1 = _associatedEntry.magneticValue1;
    _magneticValue2 = _associatedEntry.magneticValue2;
    _magneticType = _associatedEntry.magneticType;
     */
    
    NSLog(@"Inside edit entry%@", _date);
    
    
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
    

    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"entriesdb.sql"];
    if (self.recordIDToEdit != -1) {
        // Load the record with the specific ID from the database.
        [self loadInfoToEdit];
    }
    
    
     
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}
 */

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self.entryNameField becomeFirstResponder];
    }
}

- (IBAction)cancelButton:(id)sender {
    NSLog(@"%@", [self.delegate description]);
    [self.delegate AddEntryControllerDidCancel:self];
    
    
}

- (IBAction)saveButton:(id)sender {
    /*Need to add a check and code to see if you're saving an existing entry in Edit Entry mode */
    _name = _entryNameField.text;
    _projectName = _projectNameField.text;
    _stopNum = _stopNumField.text;
    _date = _dateLabelField.text;
    _sampleNum = _sampleNumberField.text;
    if (!isEditEntry) {
        Entry *newEntry = [[Entry alloc] init];
        newEntry.name = _name;
        newEntry.date = _date;
        newEntry.projectName = _projectName;
        newEntry.goal = _goal;
        newEntry.latitude = _latitude;
        newEntry.longitude = _longitude;
        newEntry.weather = _weather;
        newEntry.notes =_notes;
        newEntry.photo = _photo;
        newEntry.sketch = _sketch;
        newEntry.outcrop = _outcrop;
        newEntry.structuralData = _structuralData;
        newEntry.sampleNum = _sampleNum;
        newEntry.stopNum = _stopNum;
        newEntry.magneticValue1 = _magneticValue1;
        newEntry.magneticValue2 = _magneticValue2;
        newEntry.magneticType = _magneticType;
        
        
        NSLog(@"name text: %@", _entryNameField.text);
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
        
        [self.delegate AddEntryController:self didSaveEntry:newEntry];
        
        // Prepare the query string.
        //It's not working because it can't store photo and sketch
        //http://www.appcoda.com/sqlite-database-ios-app-tutorial/
        //NSData *photoData = UIImagePNGRepresentation(_photo);
        //NSData *sketchData = UIImagePNGRepresentation(_sketch);
        
        NSString *query;
        if(self.recordIDToEdit == -1){
            query = [NSString stringWithFormat:@"insert into entriesBasic values(null, '%@', '%@', '%@','%@', '%@', '%@','%@', '%@', '%@','%@', '%@', '%@', '%@')",_name,_projectName, _date, _goal, _latitude, _longitude, _weather, _sketch, _photo, _notes, _permissions, _sampleNum, _partners];
        }else{
            query = [NSString stringWithFormat:@"update set name='%@', projectName='%@', date='%@',goal='%@', latitude='%@', longitude='%@',weather='%@', sketch='%@', photo='%@',notes='%@',permissions='%@', sampleNum='%@', partners='%@' where entriesID=%d",_name,_projectName, _date, _goal, _latitude, _longitude, _weather, _sketch, _photo, _notes, _permissions, _sampleNum, _partners, self.recordIDToEdit];
        }
        
       
        
        //name text, projectName text, date text, goal text, latitude text, longitude text, weather text, sketch blob, picture blob, notes text, permissions text, sampleNum text, partners text);
        
        // Execute the query.
        [self.dbManager executeQuery:query];
        
        // If the query was successfully executed then pop the view controller.
        if (self.dbManager.affectedRows != 0) {
            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        }
        else{
            NSLog(@"Could not execute the query.");
        }
    }else{
        Entry *tempEntry = [[Entry alloc] init];
        tempEntry.name = _entryNameField.text;
        tempEntry.date = _date;
        tempEntry.projectName = _projectNameField.text;
        tempEntry.goal = _goal;
        tempEntry.latitude = _latitude;
        tempEntry.longitude = _longitude;
        tempEntry.weather = _weather;
        tempEntry.notes =_notes;
        tempEntry.photo = _photo;
        tempEntry.sketch = _sketch;
        tempEntry.outcrop = _outcrop;
        tempEntry.structuralData = _structuralData;
        tempEntry.sampleNum = _sampleNum;
        tempEntry.stopNum = _stopNum;
        tempEntry.magneticValue1 = _magneticValue1;
        tempEntry.magneticValue2 = _magneticValue2;
        tempEntry.magneticType = _magneticType;
        [self.delegate AddEntryController:self didUpdateEntry:tempEntry];
        
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
        NSLog(@"Calling date segue: %@", _date);
        
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
        [cameraController setPhoto:_photo];
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
    _photo = photo;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)magDecControllerCancel:(MagneticDecController *) controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)magDecControllerSave:(MagneticDecController *)controller value1:(NSString*)v1 value2:(NSString*)v2 type:(NSString*)type{
    _magneticValue1 = v1;
    _magneticValue2 = v2;
    _magneticType = type;
    NSLog(@"Magnetic: %@ %@ %@", v1, v2, type);
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
    NSLog(@"results: %@", results);
    _name = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"name"]];
    _entryNameField.text = _name;
}


@end
