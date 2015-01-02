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
    [entryScroller setContentSize:CGSizeMake(320, 2500)];
    [datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    databaseCopy = [UserEntryDatabase userEntryDatabase];
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
    goalField.layer.borderColor = [[UIColor blackColor] CGColor];
    goalField.layer.borderWidth = 1.0;
    weatherField.layer.borderColor = [[UIColor blackColor] CGColor];
    weatherField.layer.borderWidth = 1.0;
    partnersField.layer.borderColor = [[UIColor blackColor] CGColor];
    partnersField.layer.borderWidth = 1.0;
    permissionsField.layer.borderColor = [[UIColor blackColor] CGColor];
    permissionsField.layer.borderWidth = 1.0;
    outcropField.layer.borderColor = [[UIColor blackColor] CGColor];
    outcropField.layer.borderWidth = 1.0;
    structuralField.layer.borderColor = [[UIColor blackColor] CGColor];
    structuralField.layer.borderWidth = 1.0;
    notesField.layer.borderColor = [[UIColor blackColor] CGColor];
    notesField.layer.borderWidth = 1.0;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
    dateDisplayFieldA.text = strDate;
    
    
    
    
   
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
    if (sketchDisplay.image != nil){
        newEntry.sketch = sketchDisplay.image;
    }
    if (photoDisplay.image != nil){
        newEntry.photo = photoDisplay.image;
    }
    
    
    
    

    
    [databaseCopy addEntry:newEntry];
    NSLog(@"Number of elements in table: %lu", (unsigned long)[databaseCopy.entries count]);
    for (int i = 0; i < [databaseCopy.entries count]; i++) {
        Entry *testEntry = [databaseCopy.entries objectAtIndex: i];
        NSLog(@"Entries: %@", testEntry.name);
    }
    
    //NSMutableString *printString = [NSMutableString stringWithString:@""];
    //[printString appendString: entryNameField.text ];
    NSMutableString *printString = [NSMutableString stringWithFormat:@"Entry name: %@; Date: %@; Project Name: %@; Goal: %@; Latitude: %@; Longitude: %@; Weather: %@; Magnetic Field: %@; Partners: %@; Permissions: %@; Outcrop: %@; Structural: %@; Sample Number: %@; Notes: %@", entryNameField.text, dateDisplayFieldA.text, projectNameField.text, goalField.text, latitudeField.text, longitudeField.text, weatherField.text, magneticField.text, partnersField.text, permissionsField.text, outcropField.text, structuralField.text, sampleNumField.text, notesField.text];
    
    
    NSError *error;
    
    
    NSString *documentsDirectory = [NSHomeDirectory()
                                    stringByAppendingPathComponent:@"Documents"];
    NSString *fileName = [NSMutableString stringWithFormat:@"%@%@", entryNameField.text, @".txt"];
    NSString *filePath = [documentsDirectory
                          stringByAppendingPathComponent:fileName];
    
    NSLog(@"string to write:%@", printString);
    
    [printString writeToFile:filePath atomically:YES
                    encoding:NSUTF8StringEncoding error:&error];
    
    NSLog(@"%@", filePath);
    
    
    
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
    
    entryNameField.text = @"";
    projectNameField.text = @"";
    goalField.text = @"";
    latitudeField.text = @"";
    longitudeField.text = @"";
    weatherField.text = @"";
    magneticField.text = @"";
    partnersField.text = @"";
    permissionsField.text = @"";
    outcropField.text = @"";
    structuralField.text = @"";
    sampleNumField.text = @"";
    notesField.text = @"";
    sketchDisplay.image = nil;
    photoDisplay.image = nil;
}



- (IBAction)useCameraRoll:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    NSLog(@"using photo");
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)useCamera:(id)sender {
    /*
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
     */
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    photoDisplay.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (IBAction)getCurrentLocation:(id)sender {
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    NSLog(@"Get somewhere outside!");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        latitudeValue = currentLocation.coordinate.latitude;
        longitudeValue = currentLocation.coordinate.longitude;
        latitudeField.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        longitudeField.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        
        NSString *currentLocationURL = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f", latitudeValue, longitudeValue];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:currentLocationURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            jsonWeather = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"JSON: %@", jsonWeather);
        }];
        [dataTask resume];
        weatherField.text = @"";
        for (id key in jsonWeather){
            
            //NSLog(@"Key: %@ , Value: %@",key, [jsonWeather objectForKey:key]);
            if ([key isEqualToString:@"main"]){
                NSString *humidity = [NSString stringWithFormat:@"Humidity: %@%%",[[jsonWeather objectForKey:key] objectForKey: @"humidity"]];
                weatherField.text = [weatherField.text stringByAppendingString:humidity];
                weatherField.text = [weatherField.text stringByAppendingString:@"\n"];
                
                NSString *pressure = [NSString stringWithFormat:@"Pressue: %@ hPa", [[jsonWeather objectForKey:key] objectForKey: @"pressure"]];
                weatherField.text = [weatherField.text stringByAppendingString:pressure];
                weatherField.text = [weatherField.text stringByAppendingString:@"\n"];
                //float tempKelvin = [[[jsonWeather objectForKey:key] objectForKey: @"temp"] floatValue];
                //float tempCelcius = tempKelvin - 273.15;
                //NSLog(@"Temperature: %f C", tempCelcius);
                
                float tempKelvin = [[[jsonWeather objectForKey:key] objectForKey: @"temp"] floatValue];
                float tempCelcius = tempKelvin - 273.15;
                NSString *temperature = [NSString stringWithFormat:@"Temperature: %f C", tempCelcius];
                weatherField.text = [weatherField.text stringByAppendingString:temperature];
                weatherField.text = [weatherField.text stringByAppendingString:@"\n"];
            }
            if ([key isEqualToString:@"wind"]){
                NSString *windDegree = [NSString stringWithFormat:@"Wind Degree: %@ degrees", [[jsonWeather objectForKey:key] objectForKey: @"deg"]];
                weatherField.text = [weatherField.text stringByAppendingString:windDegree];
                weatherField.text = [weatherField.text stringByAppendingString:@"\n"];
                NSString *windSpeed = [NSString stringWithFormat:@"Wind Speed: %@ mps", [[jsonWeather objectForKey:key] objectForKey: @"speed"]];
                weatherField.text = [weatherField.text stringByAppendingString:windSpeed];
                weatherField.text = [weatherField.text stringByAppendingString:@"\n"];
            }
            
        }
        [locationManager stopUpdatingLocation];
        
        
        
        
        
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"sketchSegue"]){
        
        [segue.destinationViewController setDelegate:self]; 
        
    }else if([segue.identifier isEqualToString:@"photoSegue"]){
        [segue.destinationViewController setDelegate:self];
    }else if([segue.identifier isEqualToString:@"textEntrySegue"]){
        [segue.destinationViewController setDelegate:self];
    }
}
- (void) passBackSketch:(SketchController *)controller didFinishSketch:(UIImage *)item{
    
    sketchDisplay.image = item;
}



@end
