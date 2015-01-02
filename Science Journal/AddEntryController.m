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
#import "SampleNumController.h"

@interface AddEntryController ()

@end

@implementation AddEntryController

- (void)viewDidLoad {
    [super viewDidLoad];
    databaseCopy = [UserEntryDatabase userEntryDatabase];
    if (isEditEntry){
        _entryTitleLabel.title = @"Edit Entry";
    }
    _entryNameField.text = _name;
    _projectNameField.text = _projectName;
    _dateLabelField.text = _date;
    NSLog(@"Inside edit entry%@", _date);
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
    [self.delegate AddEntryControllerDidCancel:self];
}

- (IBAction)saveButton:(id)sender {
    /*Need to add a check and code to see if you're saving an existing entry in Edit Entry mode */
    if (!isEditEntry) {
        Entry *newEntry = [[Entry alloc] init];
        newEntry.name = _entryNameField.text;
        newEntry.date = _date;
        newEntry.projectName = _projectNameField.text;
        newEntry.goal = _goal;
        newEntry.latitude = _latitude;
        newEntry.longitude = _longitude;
        newEntry.weather = _weather;
        newEntry.notes =_notes;
        newEntry.photo = _photo;
        newEntry.sketch = _sketch;
        [self.delegate AddEntryController:self didSaveEntry:newEntry];
        NSMutableString *printString = [NSMutableString stringWithFormat:@"Entry name: %@; Date: %@; Project Name: %@; Goal: %@; Latitude: %@; Longitude: %@; Weather: %@; Magnetic Field: %@; Partners: %@; Permissions: %@; Outcrop: %@; Structural: %@; Sample Number: %@; Notes: %@", _name, _date, _projectName, _goal, _latitude, _longitude, _weather, _magnet, _partners, _permissions, _outcrop, _structuralData, _sampleNum, _notes];
        
        
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
        [self.delegate AddEntryController:self didUpdateEntry:tempEntry];
    }
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
- (void)textEntryControllerSave:(textEntryController *)controller didSaveText:(NSString*) text rowSelected:(int)row{
    switch (row) {
        case 3:
            _goal = text;
            break;
        case 7:
            _notes = text;
            break;
        case 8:
            _permissions = text;
        default:
            NSLog(@"Default");
            break;
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

- (void)SampleNumControllerCancel:(SampleNumController *) controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)SampleNumControllerSave:(SampleNumController *)controller didSaveSample:(NSString*) num{
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
        [textController updateRowSelected:rowSelected];
        
    }else if ([segue.identifier isEqualToString:@"LocationAndWeather"]){
        LocationAndWeatherController* locationController = segue.destinationViewController;
        locationController.delegate = self;
    }else if ([segue.identifier isEqualToString:@"SampleNum"]){
        SampleNumController* sampleController = segue.destinationViewController;
        sampleController.delegate = self;
    }else if ([segue.identifier isEqualToString:@"Sketch"]){
        SketchController *sketchController = segue.destinationViewController;
        sketchController.delegate = self;
        //Sketch still isn't working
        [sketchController setSketch: _sketch];
    }else if ([segue.identifier isEqualToString:@"Photo"]){
        CameraController *cameraController = segue.destinationViewController;
        cameraController.delegate = self;
        [cameraController setPhoto:_photo];
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
@end
