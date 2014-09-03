//
//  EntryController.m
//  Science Journal
//
//  Created by Evan Teague on 8/18/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import "EntryController.h"
#import "EntriesCell.h"
#import "SingleEntryViewController.h"
#import "EntriesController.h"
#import "SingleEntryViewController.h"
#import "Entry.h"
#import "CameraRollController.h"

@interface EntryController ()

@end

@implementation EntryController {
    CLLocationManager *locationManager;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [entryScroller setScrollEnabled:YES];
    [entryScroller setContentSize:CGSizeMake(320, 2010)];
    [datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    databaseCopy = [UserEntryDatabase userEntryDatabase];
    locationManager = [[CLLocationManager alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
    dateDisplayFieldA.text = strDate;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)submitButtonPressed:(id)sender {
    Entry *newEntry = [[Entry alloc] init];
    newEntry.name = entryNameField.text;
    newEntry.date = dateDisplayFieldA.text;
    newEntry.projectName = projectNameField.text;
    newEntry.goal = goalField.text;
    newEntry.latitude = latitudeField.text;
    newEntry.longitude = longitudeField.text;
    newEntry.weather = weatherField.text;
    newEntry.magnet = magneticField.text;
    newEntry.partners = partnersField.text;
    newEntry.permissions = permissionsField.text;
    newEntry.outcrop = outcropField.text;
    newEntry.structuralData = structuralField.text;
    newEntry.sampleNum = sampleNumField.text;
    newEntry.notes = notesField.text;
    
    [databaseCopy addEntry:newEntry];
    NSLog(@"Number of elements in table: %lu", (unsigned long)[databaseCopy.entries count]);
    for (int i = 0; i < [databaseCopy.entries count]; i++) {
        Entry *testEntry = [databaseCopy.entries objectAtIndex: i];
        NSLog(@"Entries: %@", testEntry.name);
    }
    
    
    
    
    /*
    NSMutableArray *entriesNames = [entries.allEntryNames mutableCopy];
    NSLog(@"%lu", (unsigned long)[entries.allEntryNames count]);
    */
    //[entries createNewEntry:@"test 2"];
    //[_allEntryNames addObject:@entryNameField.text];
    //_allEntryDates = @[@"date"];
    //_allProjectNames = @[@"project name"];
    //_allGoals = @[@"goal"];
    //_allLats = @[@"lat"];
    //_allLongs = @[@"long"];
    //_allWeather = @[@"weather"];
    //_allMagnets = @[@"magnets"];
    //_allPartners = @[@"partners"];
    //_allPermissions = @[@"permissions"];
    //_allOutcrops = @[@"outcrops"];
    //_allStructuralData = @[@"structural data"];
    //_allSampleNums = @[@"sample num"];
    //_allNotes = @[@"notes"];
}

- (IBAction)getCurrentLocation:(id)sender {
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    NSLog(@"Get somewhere outside!");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        latitudeField.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        longitudeField.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
}

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}


/*
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"showCameraRoll"])
    {
        
        CameraRollController *cameraController = segue.destinationViewController;
        
        
        
    }
 
    
}
*/
@end
