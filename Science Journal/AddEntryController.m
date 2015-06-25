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
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"FieldBookdb.sql"];
    
    //Labels the project field with the project name
    self.projectNameField.text = projectNameList;
    _projectName = projectNameList;
    
    //If the record ID is -1, create a new entry. Otherwise, edit the entry
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

    //Sets the delegates so the textfields can be first responders
    _entryNameField.delegate = self;
    _projectNameField.delegate = self;
    _sampleNumberField.delegate = self;
    _stopNumField.delegate = self;
    
    //Auto capitalize the first word of sentences
    _entryNameField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    _projectNameField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    _sampleNumberField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    _stopNumField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    
    [self checkProjectSettings];
    [self checkEntryContents];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//When a user taps a specified cell, it will automatically select the associated textfield
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:@"sampleNumCell"]) {
        [self.sampleNumberField becomeFirstResponder];
    }else if ([cell.reuseIdentifier isEqualToString:@"ProjectNameID"]) {
        [self.projectNameField becomeFirstResponder];
    }else if ([cell.reuseIdentifier isEqualToString:@"StopNumID"]) {
        [self.stopNumField becomeFirstResponder];
    }else if ([cell.reuseIdentifier isEqualToString:@"EntryNameID"]) {
        [self.entryNameField becomeFirstResponder];
    }

}
//Cancels adding/editing the entry
- (IBAction)cancelButton:(id)sender {
    [self.delegate AddEntryControllerDidCancel:self];
    
}
//Saves the entry
- (IBAction)saveButton:(id)sender {
    //Gets the values from the textfields
    _name = _entryNameField.text;
    _projectName = _projectNameField.text;
    _stopNum = _stopNumField.text;
    _sampleNum = _sampleNumberField.text;
    
    //Determine if there is a sketch
    NSString *savedSketchLocation;
    NSString *savedSketchName;
    NSLog(@"Sketch 2: %@", _sketch);
    if (_sketch != nil){
        NSString *sketchname = [NSMutableString stringWithFormat:@"%@%@", _name, @"_sketch.png"];
        NSString *documentsDirectory = [NSHomeDirectory()
                                        stringByAppendingPathComponent:@"Documents"];
        savedSketchLocation = [documentsDirectory stringByAppendingPathComponent:sketchname];
        savedSketchName = sketchname;
        NSData *sketchData = UIImagePNGRepresentation(_sketch);
        [sketchData writeToFile:savedSketchLocation atomically:NO];
    }
    //Determine if there is a picture
    NSString *savedPictureLocation;
    NSString *savedPictureName;
    if (_picture != nil){
        NSString *picturename = [NSMutableString stringWithFormat:@"%@%@", _name, @"_picture.png"];
        NSString *documentsDirectory = [NSHomeDirectory()
                                        stringByAppendingPathComponent:@"Documents"];
        savedPictureLocation = [documentsDirectory stringByAppendingPathComponent:picturename];
        savedPictureName = picturename;
        NSData *pictureData = UIImagePNGRepresentation(_picture);
        [pictureData writeToFile:savedPictureLocation atomically:NO];
    }
    
    NSString *queryBasic;
    
    //If this is adding a new entry
    if(self.recordIDToEdit == -1){
        queryBasic = [NSString stringWithFormat:@"insert into entriesBasic values(null, '%@', '%@', '%@','%@', '%@', '%@','%@', '%@', '%@','%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",_name,_projectName, _date, _goal, _latitude, _longitude, _weather, savedSketchName, savedPictureName, _notes, _permissions, _sampleNum, _partners, _dataSheet, _outcrop, _structuralData, _strike, _dip, _trend, _plunge, _stopNum];
        NSLog(@"Query in adding new entry %@", queryBasic);
    //If this is updating an existing entry
    }else{
        queryBasic = [NSString stringWithFormat:@"update entriesBasic set name='%@', projectName='%@', date='%@',goal='%@', latitude='%@', longitude='%@',weather='%@', sketch='%@', picture='%@',notes='%@',permissions='%@', sampleNum='%@', partners='%@', dataSheet='%@', outcrop='%@', structuralData='%@', strike='%@', dip='%@', trend='%@', plunge='%@', stopNum='%@' where entriesID=%d",_name,_projectName, _date, _goal, _latitude, _longitude, _weather, savedSketchName, savedPictureName, _notes, _permissions, _sampleNum, _partners, _dataSheet, _outcrop, _structuralData, _strike, _dip, _trend, _plunge, _stopNum, self.recordIDToEdit];
        NSLog(@"Query in editing entry %@", queryBasic);
    }
    //Each entry has to have an entry name and project. If it does, then it performs the query
    if ([_name length] == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Entry Error" message: @"You need to add an Entry Name" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }else if ([_projectName length] == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Entry Error" message: @"You need to add a Project Name" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }else{
        //Check if the project exists
        NSString *checkProjects = @"select projectName from projects";
        NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:checkProjects]];
        bool projectExists = NO;
        for (id key in results){
            if ([[key objectAtIndex:0] isEqualToString:_projectName]){
                projectExists = YES;
            }
        }
        //Check if the entry already exists
        NSString *checkEntries = [NSString stringWithFormat:@"select name from entriesBasic where projectName = %@", _projectName];
        NSArray *results2 = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:checkEntries]];
        bool entryExists = NO;
        for (id key in results2){
            if ([[key objectAtIndex:0] isEqualToString:_name]){
                entryExists = YES;
            }
        }
        //If it exists, the entry can be moved to that project
        if (projectExists && !entryExists){
            [self.dbManager executeQuery:queryBasic];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Entry Saved" message: @"" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [self.delegate AddEntryControllerDidSave:self];
        //If it doesn't exist, the entry cannot be moved to that project
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Either project doesn't exist or you can't add an entry with the same name" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }

        //Internal testing code for the database
        if (self.dbManager.affectedRows != 0) {
            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        }
        else{
            NSLog(@"Could not execute the query.");
        }
    }
}


//The various segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddDate"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        datepickerController* dateController = [navigationController viewControllers][0];
        dateController.delegate = self;
        [dateController setDateValue:_date];
        
    }else if ([segue.identifier isEqualToString:@"TextEntry"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        textEntryController* textController = [navigationController viewControllers][0];
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
        UINavigationController *navigationController = segue.destinationViewController;
        LocationAndWeatherController* locationController = [navigationController viewControllers][0];
        locationController.delegate = self;
        [locationController setLat:_latitude setLong:_longitude setWeather:_weather];
    }else if ([segue.identifier isEqualToString:@"Sketch"]){
        UINavigationController *navigationController = segue.destinationViewController;
        SketchController *sketchController = [navigationController viewControllers][0];
        sketchController.delegate = self;
        [sketchController setSketch: _sketch];
    }else if ([segue.identifier isEqualToString:@"Photo"]){
        UINavigationController *navigationController = segue.destinationViewController;
        CameraController *cameraController = [navigationController viewControllers][0];
        cameraController.delegate = self;
        [cameraController setPhoto:_picture];
    }else if ([segue.identifier isEqualToString:@"DataSheet"]){
        UINavigationController *navigationController = segue.destinationViewController;
        DataSheetController *dataSheetController = [navigationController viewControllers][0];
        dataSheetController.delegate = self;
        [dataSheetController setSheetData:_dataSheet];
    }else if ([segue.identifier isEqualToString:@"StrikeDipSegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        StrikeDipController *strikeDip = [navigationController viewControllers][0];
        strikeDip.delegate = self;
        [strikeDip setStrike:_strike setDip:_dip];
    }else if ([segue.identifier isEqualToString:@"TrendPlungeSegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        TrendPlungeController *trendPlunge = [navigationController viewControllers][0];
        trendPlunge.delegate = self;
        [trendPlunge setTrend:_trend setPlunge:_plunge];
    }
        
}

//Sets the value for if this is editng an existing entry
-(void)setEditEntry:(BOOL)value{
    isEditEntry = value;
    
}

//The textfield should be
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)setProjectNameList:(NSString *) pnl
{
    projectNameList = pnl;
}




//Adjusts the height of each cell based on if the user has enabled the component setting
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
//Loads the info if the user is editing an entry
-(void)loadInfoToEdit{
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
    _outcrop = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"outcrop"]];
    _structuralData = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"structuralData"]];
    _strike = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"strike"]];
    _dip = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"dip"]];
    _trend = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"trend"]];
    _plunge = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"plunge"]];
    _stopNum = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"stopNum"]];
    _stopNumField.text = _stopNum;
    _dataSheet = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"dataSheet"]];
    NSString *documentsDirectory = [NSHomeDirectory()
                                    stringByAppendingPathComponent:@"Documents"];
    NSString *pictureFilePath = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"picture"]];
    NSString *savedPictureLocation = [documentsDirectory stringByAppendingPathComponent:pictureFilePath];
    _picture = [UIImage imageWithContentsOfFile:savedPictureLocation];
    NSString *sketchFilePath = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"sketch"]];
    NSString *savedSketchLocation = [documentsDirectory stringByAppendingPathComponent:sketchFilePath];
    _sketch = [UIImage imageWithContentsOfFile:savedSketchLocation];
    
    //Sets the textfields with the values
    _entryNameField.text = _name;
    _projectNameField.text = _projectName;
    _dateLabelField.text = _date;
    _sampleNumberField.text = _sampleNum;
    _stopNumField.text = _stopNum;
    
    
    
    [self checkEntryContents];
    
}

//Edits the field filled or empty label images
-(void)checkEntryContents{
    UIImage *fieldFilled = [UIImage imageNamed:@"checkmark-100.png"];
    UIImage *fieldEmpty = [UIImage imageNamed:@"close-100.png"];

    if ([_date length] > 0){
        _dateContentsLabel.image = fieldFilled;
        _dateContentsLabel.image = [_dateContentsLabel.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_dateContentsLabel setTintColor:[UIColor greenColor]];
    }else{
        _dateContentsLabel.image = fieldEmpty;
        _dateContentsLabel.image = [_dateContentsLabel.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_dateContentsLabel setTintColor:[UIColor redColor]];
    }
    if ([_goal length] > 0){
        _goalContentsLabel.image = fieldFilled;
        _goalContentsLabel.image = [_goalContentsLabel.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_goalContentsLabel setTintColor:[UIColor greenColor]];
    }else{
        _goalContentsLabel.image = fieldEmpty;
        _goalContentsLabel.image = [_goalContentsLabel.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_goalContentsLabel setTintColor:[UIColor redColor]];
    }
    if ([_latitude length] > 0 || [_longitude length] > 0 || [_weather length] > 0){
        _locationContentsLabel.image = fieldFilled;
        _locationContentsLabel.image = [_locationContentsLabel.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_locationContentsLabel setTintColor:[UIColor greenColor]];
    }else{
        _locationContentsLabel.image = fieldEmpty;
        _locationContentsLabel.image = [_locationContentsLabel.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_locationContentsLabel setTintColor:[UIColor redColor]];
    }
    if (_sketch != nil ){
        _sketchContentsLabel.image = fieldFilled;
        _sketchContentsLabel.image = [_sketchContentsLabel.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_sketchContentsLabel setTintColor:[UIColor greenColor]];
    }else{
        _sketchContentsLabel.image = fieldEmpty;
        _sketchContentsLabel.image = [_sketchContentsLabel.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_sketchContentsLabel setTintColor:[UIColor redColor]];
    }
    if (_picture != nil ){
        _photoContentsLabel.image = fieldFilled;
        _photoContentsLabel.image = [_photoContentsLabel.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_photoContentsLabel setTintColor:[UIColor greenColor]];
    }else{
        _photoContentsLabel.image = fieldEmpty;
        _photoContentsLabel.image = [_photoContentsLabel.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_photoContentsLabel setTintColor:[UIColor redColor]];
    }
    if ([_notes length] > 0){
        _notesContentsLabel.image = fieldFilled;
        _notesContentsLabel.image = [_notesContentsLabel.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_notesContentsLabel setTintColor:[UIColor greenColor]];
    }else{
        _notesContentsLabel.image = fieldEmpty;
        _notesContentsLabel.image = [_notesContentsLabel.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_notesContentsLabel setTintColor:[UIColor redColor]];
    }
    if ([_permissions length] > 0){
        _permissionsContentsLabel.image = fieldFilled;
        _permissionsContentsLabel.image = [_permissionsContentsLabel.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_permissionsContentsLabel setTintColor:[UIColor greenColor]];
    }else{
        _permissionsContentsLabel.image = fieldEmpty;
        _permissionsContentsLabel.image = [_permissionsContentsLabel.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_permissionsContentsLabel setTintColor:[UIColor redColor]];
    }
    if ([_partners length] > 0){
        _partnersContentsLabel.image = fieldFilled;
        _partnersContentsLabel.image = [_partnersContentsLabel.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_partnersContentsLabel setTintColor:[UIColor greenColor]];
    }else{
        _partnersContentsLabel.image = fieldEmpty;
        _partnersContentsLabel.image = [_partnersContentsLabel.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_partnersContentsLabel setTintColor:[UIColor redColor]];
    }
    if ([_dataSheet length] > 0){
        _datasheetContentsLabel.image = fieldFilled;
        _datasheetContentsLabel.image = [_datasheetContentsLabel.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_datasheetContentsLabel setTintColor:[UIColor greenColor]];
    }else{
        _datasheetContentsLabel.image = fieldEmpty;
        _datasheetContentsLabel.image = [_datasheetContentsLabel.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_datasheetContentsLabel setTintColor:[UIColor redColor]];
    }
    if ([_outcrop length] > 0){
        _outcropContentsLabel.image = fieldFilled;
        _outcropContentsLabel.image = [_outcropContentsLabel.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_outcropContentsLabel setTintColor:[UIColor greenColor]];
    }else{
        _outcropContentsLabel.image = fieldEmpty;
        _outcropContentsLabel.image = [_outcropContentsLabel.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_outcropContentsLabel setTintColor:[UIColor redColor]];
    }
    if ([_structuralData length] > 0){
        _structuralContentsLabel.image = fieldFilled;
        _structuralContentsLabel.image = [_structuralContentsLabel.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_structuralContentsLabel setTintColor:[UIColor greenColor]];
    }else{
        _structuralContentsLabel.image = fieldEmpty;
        _structuralContentsLabel.image = [_structuralContentsLabel.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_structuralContentsLabel setTintColor:[UIColor redColor]];
    }
    if ([_strike length] > 0 || [_dip length] > 0){
        _strikeDipContentsLabel.image = fieldFilled;
        _strikeDipContentsLabel.image = [_strikeDipContentsLabel.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_strikeDipContentsLabel setTintColor:[UIColor greenColor]];
    }else{
        _strikeDipContentsLabel.image = fieldEmpty;
        _strikeDipContentsLabel.image = [_strikeDipContentsLabel.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_strikeDipContentsLabel setTintColor:[UIColor redColor]];
    }
    if ([_trend length] > 0 || [_plunge length] > 0){
        _trendPlungeContentsLabel.image = fieldFilled;
        _trendPlungeContentsLabel.image = [_trendPlungeContentsLabel.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_trendPlungeContentsLabel setTintColor:[UIColor greenColor]];
    }else{
        _trendPlungeContentsLabel.image = fieldEmpty;
        _trendPlungeContentsLabel.image = [_trendPlungeContentsLabel.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_trendPlungeContentsLabel setTintColor:[UIColor redColor]];
    }
}

//Checks with the project settings to see which fields should be visible
-(void)checkProjectSettings{
    NSString *settingsQuery = [NSString stringWithFormat:@"select * from projectSettings where projectName='%@'", _projectName];
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:settingsQuery]];
    
    int outcropSwitch = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"outcrop"]] intValue];
    if (outcropSwitch == 1) {
        _outcropCell.hidden = NO;
    }else{
        _outcropCell.hidden = YES;
    }
    int stopNumSwitch = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"stopNum"]] intValue];
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

}

//Delegate method that cancels the date picker
- (void)datepickerControllerCancel:(datepickerController *) controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//Delegate method that saves the date from the date picker
- (void)datepickerControllerSave:(datepickerController *)controller didSaveDate:(NSString*) date{
    _dateLabelField.text = date;
    _date = date;
    [self.tableView reloadData];
    [self checkEntryContents];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//Delegate method that cancels the text entry
- (void)textEntryControllerCancel:(textEntryController *) controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Delegate method that saves the text entry
- (void)textEntryControllerSave:(textEntryController *)controller didSaveText:(NSString*) text cellSelected:(NSString *)cellID{
    //Updates the correct field based on what was entered in the TextEntryController
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

//Delegate method that cancels the location and weather info
- (void)LocationAndWeatherCancel:(LocationAndWeatherController *) controller {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
//Delegate method that saves the location and weather info
- (void)LocationAndWeatherSave:(LocationAndWeatherController *)controller lat:(NSString*) lat longitude:(NSString*)longitude weather:(NSString*) weather{
    //Saves the weather information
    _latitude = lat;
    _longitude = longitude;
    _weather = weather;
    [self checkEntryContents];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

//Delegate method that cancels the datasheet info
- (void)dataSheetControllerCancel:(DataSheetController *) controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//Delegate method that saves the datasheet info
- (void)dataSheetControllerSave:(DataSheetController *)controller didSaveArray:(NSMutableDictionary*) array{
    
    //Converts it to JSON so it can be saved as an NSString
    NSError *error;
    NSData *tempData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonDataSheet = [[NSString alloc] initWithData:tempData encoding:NSUTF8StringEncoding];
    self.dataSheet = jsonDataSheet;
    [self checkEntryContents];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//Delegate method that saves the sketch info
- (void) sketchControllerSave:(SketchController *)controller didFinishSketch:(UIImage*)item{
    _sketch = item;
    [self checkEntryContents];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Delegate method that cancels the sketch info
- (void)sketchControllerCancel:(SketchController *) controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Delegate method that cancels the camera info
- (void)cameraControllerCancel:(CameraController *) controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//Delegate method that saves the camera info
- (void)cameraControllerSave:(CameraController *)controller didSavePhoto:(UIImage*) photo{
    _picture = photo;
    [self checkEntryContents];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Delegate method that cancels the strike and dip info
- (void)strikeDipCancel:(StrikeDipController *) controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Delegate method that saves the strike and dip info
- (void)strikeDipSave:(StrikeDipController *)controller strike:(NSString *)st dip:(NSString *)dp{
    _strike = st;
    _dip = dp;
    [self checkEntryContents];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Delegate method that cancels the trend and plunge info
- (void)trendPlungeCancel:(TrendPlungeController *) controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Delegate method that saves the trend and plunge info
- (void)trendPlungeSave:(TrendPlungeController *)controller trend:(NSString *)tr plunge:(NSString *)pl{
    _trend = tr;
    _plunge = pl;
    [self checkEntryContents];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
