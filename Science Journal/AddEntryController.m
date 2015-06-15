//
//  AddEntryController.m
//  Science Journal
//
//  Created by Evan Teague on 12/23/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import "AddEntryController.h"
#import "datepickerController.h"

#import "LocationAndWeatherController.h"
#import "SettingsController.h"
#import "SketchController.h"

@interface AddEntryController ()

@end

@implementation AddEntryController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Initialize the database connection
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"entriesdb.sql"];
    NSLog(@"adding num: %d", self.recordIDToEdit);
    self.projectNameField.text = projectNameList;
    _projectName = projectNameList;
    
    if (self.recordIDToEdit != -1) {
        [self loadInfoToEdit];
        _entryTitleLabel.title = @"Edit Entry";
    }else{
        _date = @"";
        _goal = @"";
        _latitude = @"";
        _longitude = @"";
        _weather = @"";
        _notes = @"";
        _permissions = @"";
        _sampleNum = @"";
        _partners = @"";
        _outcrop = @"";
        _structuralData = @"";
        _strike = @"";
        _dip = @"";
        _trend = @"";
        _plunge = @"";
        _stopNum = @"";
        _dataSheet = @"";
    }
    
    //Adjusts which components are on based on the Settings
    
    NSString *settingsQuery = [NSString stringWithFormat:@"select * from projectSettings where projectName='%@'", _projectName];
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:settingsQuery]];
    NSLog(@"results: %@", results);
    int outcropSwitch = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"outcrop"]] intValue];
     NSLog(@"results1: %d", outcropSwitch);
    if (outcropSwitch == 1) {
        NSLog(@"True");
        _outcropCell.hidden = NO;
    }else{
        _outcropCell.hidden = YES;
        NSLog(@"false");
    }
    int stopNumSwitch = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"stopNum"]] intValue];
    NSLog(@"results2: %d", stopNumSwitch);
    if (stopNumSwitch == 1) {
        _stopNumCell.hidden = NO;
    }else{
        _stopNumCell.hidden = YES;
    }
    int structSwitch = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"structuralData"]] intValue];
    if (structSwitch == 1) {
        _structuralDataCell.hidden = NO;
    }else{
        _structuralDataCell.hidden = YES;
    }
    int strikeDipSwitch = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"strikeDip"]] intValue];
    if (strikeDipSwitch == 1) {
        _strikeDipCell.hidden = NO;
    }else{
        _strikeDipCell.hidden = YES;
    }
    int trendPlungeSwitch = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"trendPlunge"]] intValue];
    if (trendPlungeSwitch == 1) {
        _trendPlungeCell.hidden = NO;
    }else{
        _trendPlungeCell.hidden = YES;
    }
    
    int dateSwitch = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"date"]] intValue];
    if (dateSwitch == 1) {
        _dateCell.hidden = NO;
    }else{
        _dateCell.hidden = YES;
    }
    int goalSwitch = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"goal"]] intValue];
    if (goalSwitch == 1) {
        _goalCell.hidden = NO;
    }else{
        _goalCell.hidden = YES;
    }
    int locationSwitch = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"locationWeather"]] intValue];
    if (locationSwitch == 1) {
        _locationWeatherCell.hidden = NO;
    }else{
        _locationWeatherCell.hidden = YES;
    }
    int sketchSwitch = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"sketch"]]intValue];
    if (sketchSwitch == 1) {
        _sketchCell.hidden = NO;
    }else{
        _sketchCell.hidden = YES;
    }
    int pictureSwitch = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"picture"]] intValue];
    if (pictureSwitch == 1) {
        _pictureCell.hidden = NO;
    }else{
        _pictureCell.hidden = YES;
    }
    int notesSwitch = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"notes"]] intValue];
    if (notesSwitch == 1) {
        _notesCell.hidden = NO;
    }else{
        _notesCell.hidden = YES;
    }
    int permissionsSwitch = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"permissions"]] intValue];
    if (permissionsSwitch == 1) {
        _permissionsCell.hidden = NO;
    }else{
        _permissionsCell.hidden = YES;
    }
    int sampleNumSwitch = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"sampleNum"]] intValue];
    if (sampleNumSwitch == 1) {
        _sampleNumCell.hidden = NO;
    }else{
        _sampleNumCell.hidden = YES;
    }
    int partnersSwitch = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"partners"]] intValue];
    if (partnersSwitch == 1) {
        _partnersCell.hidden = NO;
    }else{
        _partnersCell.hidden = YES;
    }
    int dataSheetSwitch = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"dataSheet"]] intValue];
    if (dataSheetSwitch == 1) {
        _dataSheetCell.hidden = NO;
    }else{
        _dataSheetCell.hidden = YES;
    }
    
//self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Sandcropped1.jpg"]];
//[self.tableView setSeparatorColor:[UIColor blackColor]];
//[self.tableView setSeparatorInset:UIEdgeInsetsZero];

    /*
    _entryNameField.delegate = self;
    _projectNameField.delegate = self;
    _sampleNumberField.delegate = self;
    _stopNumField.delegate = self;
    */
    
    [self checkEntryContents];
    
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
    //Gets the values from the textfields
    NSLog(@"Testing save values: %@", _date);
    _name = _entryNameField.text;
    _projectName = _projectNameField.text;
    _stopNum = _stopNumField.text;
    _sampleNum = _sampleNumberField.text;
    
    //Determine if there is a sketch
    NSString *savedSketchLocation;
    NSLog(@"Sketch 2: %@", _sketch);
    if (_sketch != nil){
        NSString *sketchname = [NSMutableString stringWithFormat:@"%@%@", _name, @"_sketch.png"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        savedSketchLocation = [documentsDirectory stringByAppendingPathComponent:sketchname];
        NSData *sketchData = UIImagePNGRepresentation(_sketch);
        [sketchData writeToFile:savedSketchLocation atomically:NO];
    }
    //Determine if there is a picture
    NSString *savedPictureLocation;
    if (_picture != nil){
        NSString *picturename = [NSMutableString stringWithFormat:@"%@%@", _name, @"_picture.png"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        savedPictureLocation = [documentsDirectory stringByAppendingPathComponent:picturename];
        NSData *pictureData = UIImagePNGRepresentation(_picture);
        [pictureData writeToFile:savedPictureLocation atomically:NO];
    }
    
   
    
    NSString *queryBasic;
    
    //If this is adding a new entry
    if(self.recordIDToEdit == -1){
        queryBasic = [NSString stringWithFormat:@"insert into entriesBasic values(null, '%@', '%@', '%@','%@', '%@', '%@','%@', '%@', '%@','%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",_name,_projectName, _date, _goal, _latitude, _longitude, _weather, savedSketchLocation, savedPictureLocation, _notes, _permissions, _sampleNum, _partners, _dataSheet, _outcrop, _structuralData, _strike, _dip, _trend, _plunge, _stopNum];
        NSLog(@"Query in adding new entry %@", queryBasic);
    //If this is updating an existing entry
    }else{
        queryBasic = [NSString stringWithFormat:@"update entriesBasic set name='%@', projectName='%@', date='%@',goal='%@', latitude='%@', longitude='%@',weather='%@', sketch='%@', picture='%@',notes='%@',permissions='%@', sampleNum='%@', partners='%@', dataSheet='%@', outcrop='%@', structuralData='%@', strike='%@', dip='%@', trend='%@', plunge='%@', stopNum='%@' where entriesID=%d",_name,_projectName, _date, _goal, _latitude, _longitude, _weather, savedSketchLocation, savedPictureLocation, _notes, _permissions, _sampleNum, _partners, _dataSheet, _outcrop, _structuralData, _strike, _dip, _trend, _plunge, _stopNum, self.recordIDToEdit];
        NSLog(@"Query in editing entry %@", queryBasic);
    }
    //Each entry has to have an entry name and project. If it does, then it performs the query
    if ([_name length] == 0){
        NSLog(@"No Entry name");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Entry Error" message: @"You need to add an Entry Name" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }else if ([_projectName length] == 0){
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
    
    
        [self.delegate AddEntryControllerDidSave:self];
    }
}

- (void)datepickerControllerCancel:(datepickerController *) controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)datepickerControllerSave:(datepickerController *)controller didSaveDate:(NSString*) date{
    _dateLabelField.text = date;
    _date = date;
    NSLog(@"Date saved?%@", _date);
    [self.tableView reloadData];
    [self checkEntryContents];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)textEntryControllerCancel:(textEntryController *) controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textEntryControllerSave:(textEntryController *)controller didSaveText:(NSString*) text cellSelected:(NSString *)cellID{
    //Updates the correct field based on what was entered in the TextEntryController
    
    NSLog(@"Text item passed back: %@. Cell selected: %@", text, cellID);
    if ([cellID isEqualToString:@"GoalID"]){
        _goal = text;
    }else if ([cellID isEqualToString:@"NotesID"]){
        _notes = text;
    }else if ([cellID isEqualToString:@"PermissionsID"]){
        _permissions = text;
    }else if ([cellID isEqualToString:@"PartnersID"]){
        _partners = text;
    }else if ([cellID isEqualToString:@"OutcropID"]){
        _outcrop = text;
    }else if ([cellID isEqualToString:@"StructuralDataID"]){
        _structuralData = text;
    }
        
    [self checkEntryContents];
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)LocationAndWeatherCancel:(LocationAndWeatherController *) controller {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)LocationAndWeatherSave:(LocationAndWeatherController *)controller lat:(NSString*) lat longitude:(NSString*)longitude weather:(NSString*) weather{
    //Saves the weather information
    _latitude = lat;
    _longitude = longitude;
    _weather = weather;
    NSLog(@"printing weather stuff: %@%@%@", _latitude, _longitude, _weather);
    [self checkEntryContents];
    [self dismissViewControllerAnimated:YES completion:nil];

    
}

- (void)dataSheetControllerCancel:(DataSheetController *) controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)dataSheetControllerSave:(DataSheetController *)controller didSaveArray:(NSMutableDictionary*) array{
    
    for (id key in array){
        NSLog(@"Key: %@, Value: %@", key, [array objectForKey:key]);
    }
    NSError *error;
    NSData *tempData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonDataSheet = [[NSString alloc] initWithData:tempData encoding:NSUTF8StringEncoding];
    self.dataSheet = jsonDataSheet;
    [self checkEntryContents];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //The various segues
    if ([segue.identifier isEqualToString:@"AddDate"]) {
        datepickerController* dateController = segue.destinationViewController;
        dateController.delegate = self;
        [dateController setDateValue:_date];
        
    }else if ([segue.identifier isEqualToString:@"TextEntry"]) {
        textEntryController* textController = segue.destinationViewController;
        textController.delegate = self;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        EntriesCell *entryName = (EntriesCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [textController updateCellSelected:entryName.reuseIdentifier];
        if ([entryName.reuseIdentifier isEqualToString:@"GoalID"]){
            [textController setTextValue:_goal];
        }else if ([entryName.reuseIdentifier isEqualToString:@"NotesID"]){
            [textController setTextValue:_notes];
        }else if ([entryName.reuseIdentifier isEqualToString:@"PermissionsID"]){
            [textController setTextValue:_permissions];
        }else if ([entryName.reuseIdentifier isEqualToString:@"PartnersID"]){
            [textController setTextValue:_partners];
        }else if ([entryName.reuseIdentifier isEqualToString:@"OutcropID"]){
            [textController setTextValue:_outcrop];
        }else if ([entryName.reuseIdentifier isEqualToString:@"StructuralDataID"]){
            [textController setTextValue:_structuralData];
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
    }else if ([segue.identifier isEqualToString:@"DataSheet"]){
        DataSheetController *dataSheetController = segue.destinationViewController;
        dataSheetController.delegate = self;
        [dataSheetController setSheetData:_dataSheet];
    }else if ([segue.identifier isEqualToString:@"StrikeDipSegue"]) {
        StrikeDipController *strikeDip = segue.destinationViewController;
        strikeDip.delegate = self;
        [strikeDip setStrike:_strike setDip:_dip];
    }else if ([segue.identifier isEqualToString:@"TrendPlungeSegue"]) {
        TrendPlungeController *trendPlunge = segue.destinationViewController;
        trendPlunge.delegate = self;
        [trendPlunge setTrend:_trend setPlunge:_plunge];
    }
        
}

-(void)setEditEntry:(BOOL)value{
    isEditEntry = value;
    
}

- (void) sketchControllerSave:(SketchController *)controller didFinishSketch:(UIImage*)item{
    NSLog(@"Sketch: %@", item);
    _sketch = item;
    [self checkEntryContents];
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
    [self checkEntryContents];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Adjusts the height of each cell based on if the user has enabled the component setting
    UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell == _strikeDipCell){
        if(_strikeDipCell.hidden){
            return 0;
        }else{
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];
        }
    }else if (cell == _trendPlungeCell){
        if(_trendPlungeCell.hidden){
            return 0;
        }else{
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];
        }
    }else if (cell == _outcropCell){
        if(_outcropCell.hidden){
            return 0;
        }else{
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];
        }
    }else if (cell == _stopNumCell){
        if(_stopNumCell.hidden){
            return 0;
        }else{
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];
        }
    }else if (cell == _structuralDataCell){
        if(_structuralDataCell.hidden){
            return 0;
        }else{
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];
        }
    }else if (cell == _dateCell){
        if(_dateCell.hidden){
            return 0;
        }else{
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];
        }
    }else if (cell == _goalCell){
        if(_goalCell.hidden){
            return 0;
        }else{
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];
        }
    }else if (cell == _locationWeatherCell){
        if(_locationWeatherCell.hidden){
            return 0;
        }else{
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];
        }
    }else if (cell == _sketchCell){
        if(_sketchCell.hidden){
            return 0;
        }else{
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];
        }
    }else if (cell == _pictureCell){
        if(_pictureCell.hidden){
            return 0;
        }else{
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];
        }
    }else if (cell == _notesCell){
        if(_notesCell.hidden){
            return 0;
        }else{
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];
        }
    }else if (cell == _permissionsCell){
        if(_permissionsCell.hidden){
            return 0;
        }else{
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];
        }
    }else if (cell == _sampleNumCell){
        if(_sampleNumCell.hidden){
            return 0;
        }else{
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];
        }
    }else if (cell == _partnersCell){
        if(_partnersCell.hidden){
            return 0;
        }else{
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];
        }
    }else if (cell == _dataSheetCell){
        if(_dataSheetCell.hidden){
            return 0;
        }else{
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];
        }
    
    }else{
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
}
-(void)loadInfoToEdit{
    
    //Loads the info if the user is editing an entry
    NSString *query = [NSString stringWithFormat:@"select * from entriesBasic where entriesBasic.entriesID = %d", self.recordIDToEdit];
    
   
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    //Basic information
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
    _dataSheet = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"dataSheet"]];
    _entryNameField.text = _name;
    _projectNameField.text = _projectName;
    _dateLabelField.text = _date;
    _sampleNumberField.text = _sampleNum;
    _stopNumField.text = _stopNum;
    
    _outcrop = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"outcrop"]];
    _structuralData = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"structuralData"]];
    _strike = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"strike"]];
    _dip = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"dip"]];
    _trend = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"trend"]];
    _plunge = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"plunge"]];
    _stopNum = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"stopNum"]];
    _stopNumField.text = _stopNum;
    
    [self checkEntryContents];
    
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    //cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Sandcropped1.jpg"]];
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow.png"]];
    
    //Do not add an accessory arrow in certain conditions 
    if ([cell.reuseIdentifier isEqualToString:@"stopNumCell"] || [cell.reuseIdentifier isEqualToString:@"sampleNumCell"]){
        
    }else{
        cell.accessoryView = arrow;
    }
     */
    
}

-(void)checkEntryContents{
    UIImage *fieldFilled = [UIImage imageNamed:@"checkmark-100.png"];
    UIImage *fieldEmpty = [UIImage imageNamed:@"close-100.png"];
    if ([_date length] > 0){
        [_dateContentsLabel setImage:fieldFilled forState:UIControlStateNormal];
        [_dateContentsLabel setEnabled:NO];
    }else{
        [_dateContentsLabel setImage:fieldEmpty forState:UIControlStateNormal];
        [_dateContentsLabel setEnabled:NO];
    }
    if ([_goal length] > 0){
        [_goalContentsLabel setImage:fieldFilled forState:UIControlStateNormal];
        [_goalContentsLabel setEnabled:NO];
    }else{
        [_goalContentsLabel setImage:fieldEmpty forState:UIControlStateNormal];
        [_goalContentsLabel setEnabled:NO];
    }
    if ([_latitude length] > 0 || [_longitude length] > 0 || [_weather length] > 0){
        [_locationContentsLabel setImage:fieldFilled forState:UIControlStateNormal];
        [_locationContentsLabel setEnabled:NO];
    }else{
        [_locationContentsLabel setImage:fieldEmpty forState:UIControlStateNormal];
        [_locationContentsLabel setEnabled:NO];
    }
    if (_sketch != nil ){
        [_sketchContentsLabel setImage:fieldFilled forState:UIControlStateNormal];
        [_sketchContentsLabel setEnabled:NO];
    }else{
        [_sketchContentsLabel setImage:fieldEmpty forState:UIControlStateNormal];
        [_sketchContentsLabel setEnabled:NO];
    }
    if (_picture != nil ){
        [_pictureContentsLabel setImage:fieldFilled forState:UIControlStateNormal];
        [_pictureContentsLabel setEnabled:NO];
    }else{
        [_pictureContentsLabel setImage:fieldEmpty forState:UIControlStateNormal];
        [_pictureContentsLabel setEnabled:NO];
    }
    if ([_notes length] > 0){
        [_notesContentsLabel setImage:fieldFilled forState:UIControlStateNormal];
        [_notesContentsLabel setEnabled:NO];
    }else{
        [_notesContentsLabel setImage:fieldEmpty forState:UIControlStateNormal];
        [_notesContentsLabel setEnabled:NO];
    }
    if ([_permissions length] > 0){
        [_permissionsContentsLabel setImage:fieldFilled forState:UIControlStateNormal];
        [_permissionsContentsLabel setEnabled:NO];
    }else{
        [_permissionsContentsLabel setImage:fieldEmpty forState:UIControlStateNormal];
        [_permissionsContentsLabel setEnabled:NO];
    }
    if ([_partners length] > 0){
        [_partnersContentsLabel setImage:fieldFilled forState:UIControlStateNormal];
        [_partnersContentsLabel setEnabled:NO];
    }else{
        [_partnersContentsLabel setImage:fieldEmpty forState:UIControlStateNormal];
        [_partnersContentsLabel setEnabled:NO];
    }
    if ([_dataSheet length] > 0){
        [_dataSheetContentsLabel setImage:fieldFilled forState:UIControlStateNormal];
        [_dataSheetContentsLabel setEnabled:NO];
    }else{
        [_dataSheetContentsLabel setImage:fieldEmpty forState:UIControlStateNormal];
        [_dataSheetContentsLabel setEnabled:NO];
    }
    if ([_outcrop length] > 0){
        [_outcropContentsLabel setImage:fieldFilled forState:UIControlStateNormal];
        [_outcropContentsLabel setEnabled:NO];
    }else{
        [_outcropContentsLabel setImage:fieldEmpty forState:UIControlStateNormal];
        [_outcropContentsLabel setEnabled:NO];
    }
    if ([_structuralData length] > 0){
        [_structuralContentsLabel setImage:fieldFilled forState:UIControlStateNormal];
        [_structuralContentsLabel setEnabled:NO];
    }else{
        [_structuralContentsLabel setImage:fieldEmpty forState:UIControlStateNormal];
        [_structuralContentsLabel setEnabled:NO];
    }
    if ([_strike length] > 0 || [_dip length] > 0){
        [_strikeDipContentsLabel setImage:fieldFilled forState:UIControlStateNormal];
        [_strikeDipContentsLabel setEnabled:NO];
    }else{
        [_strikeDipContentsLabel setImage:fieldEmpty forState:UIControlStateNormal];
        [_strikeDipContentsLabel setEnabled:NO];
    }
    if ([_trend length] > 0 || [_plunge length] > 0){
        [_trendPlungeContentsLabel setImage:fieldFilled forState:UIControlStateNormal];
        [_trendPlungeContentsLabel setEnabled:NO];
    }else{
        [_trendPlungeContentsLabel setImage:fieldEmpty forState:UIControlStateNormal];
        [_trendPlungeContentsLabel setEnabled:NO];
    }
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)setProjectNameList:(NSString *) pnl
{
    projectNameList = pnl;
}

- (void)strikeDipCancel:(StrikeDipController *) controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)strikeDipSave:(StrikeDipController *)controller strike:(NSString *)st dip:(NSString *)dp{
    _strike = st;
    _dip = dp;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)trendPlungeCancel:(TrendPlungeController *) controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)trendPlungeSave:(TrendPlungeController *)controller trend:(NSString *)tr plunge:(NSString *)pl{
    _trend = tr;
    _plunge = pl;
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
