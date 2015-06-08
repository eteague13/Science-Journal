//
//  ExportController.m
//  Science Journal
//
//  Created by Evan Teague on 8/18/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import "ExportController.h"
#import "DBManager.h"

@interface ExportController ()

@end


@implementation ExportController
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
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"entriesdb.sql"];
    
    //Set the picker projects
    [self setPickerProjects];
    
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;
    // Do any additional setup after loading the view.
   //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Sandcropped1.jpg"]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)exportGooglEarth:(id)sender {
    //Create the .kml files
    NSString *query = [NSString stringWithFormat:@"select * from entriesBasic"];
    
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSLog(@"Results: %@", results);

    NSString *identifer, *name, *date, *projectName, *goal, *latitude, *longitude, *weather, *notes, *permissions, *sampleNum, *partners, *dataSheet, *outcrop, *structuralData, *strike, *dip, *trend, *plunge, *stopNum;
    UIImage *sketch;
    UIImage *picture;
    NSMutableString *printString = [[NSMutableString alloc] init];
    
    [printString appendFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<kml xmlns=\"http://www.opengis.net/kml/2.2\">\n\t<Folder>"];
    [printString appendFormat:@"\n\t<name>All Entries</name>"];
    for (id entry in results) {
        identifer = [entry objectAtIndex:0];
        name = [entry objectAtIndex:1];
        projectName = [entry objectAtIndex:2];
        date = [entry objectAtIndex:3];
        goal = [entry objectAtIndex:4];
        latitude = [entry objectAtIndex:5];
        longitude = [entry objectAtIndex:6];
        weather = [entry objectAtIndex:7];
        sketch = [entry objectAtIndex:8];
        picture = [entry objectAtIndex:9];
        notes = [entry objectAtIndex:10];
        permissions = [entry objectAtIndex:11];
        sampleNum = [entry objectAtIndex:12];
        partners = [entry objectAtIndex:13];
        dataSheet = [entry objectAtIndex:14];
        outcrop = [entry objectAtIndex:15];
        structuralData = [entry objectAtIndex:16];
        strike = [entry objectAtIndex:17];
        dip = [entry objectAtIndex:18];
        trend = [entry objectAtIndex:19];
        plunge = [entry objectAtIndex:20];
        stopNum = [entry objectAtIndex:21];
        
        /*Need to fix for updated strike/dip...
        [printString appendString:@"\n\t<Placemark>"];
        [printString appendFormat:@"\n\t<name>%@</name>", name];
        [printString appendFormat:@"\n\t\t<description>Date: %@\nProject Name: %@\nGoal: %@\nWeather: \n%@\nMagnetic Declination 1: %@\nMagnetic Declination 2: %@\nMagnetic Type: %@\nPartners %@\nPermissions: %@\nOutcrop Description: %@\nStructural Data: %@\nSample Number: %@\nNotes: %@\nStop Number: %@</description>", date, projectName, goal, weather, magneticValue1, magneticValue2, magneticType, partners, permissions, outcrop, structuralData, sampleNum, notes, stopNum];
        [printString appendString:@"\n\t\t<Point>"];
        [printString appendFormat:@"\n\t\t<coordinates>%@, %@, 0</coordinates>", longitude, latitude];
        [printString appendString:@"\n\t\t</Point>"];
        [printString appendString:@"\n\t</Placemark>"];
        */
        
    }

    
    [printString appendString:@"\n\t</Folder>\n</kml>"];
    
    
    //Write the information to a .kml file
    NSError *error;
    NSString *documentsDirectory = [NSHomeDirectory()
                                    stringByAppendingPathComponent:@"Documents"];
    NSString *fileName = [NSMutableString stringWithFormat:@"All Entries"];
    NSString *filePath = [documentsDirectory
                          stringByAppendingPathComponent:fileName];
    
    [printString writeToFile:filePath atomically:YES
                    encoding:NSUTF8StringEncoding error:&error];
    
    NSLog(@"%@", filePath);
    
    if ([results count] > 0){
        //Email the entry
            //Doesn't work on the simulator, but should on phone
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        // Determine the MIME type
        NSString *mimeType = @"text/plain";
        //This one may be the one that works...have to wait and see
        //NSString *mimeType = @"application/vnd.google-earth.kml+xml";
        // Add attachment
        [mc addAttachmentData:fileData mimeType:mimeType fileName:fileName];
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Export Error" message: @"No entries to export" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    //Mail results
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return pickerData[row];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //Gets the selected project
    NSLog(@"row: %ld, component: %ld", (long)row, (long)component);
    selectedProject = [pickerData objectAtIndex:row];
    
    
}

- (IBAction)emailProject:(id)sender {
    //Creates the .kml file for just the selected project
    
   //NEED TO EDIT TO TAKE OUT GEOLOGY STUFF
    NSString *query = [NSString stringWithFormat:@"select * from entriesBasic inner join entriesGeology on entriesBasic.entriesID = entriesGeology.entriesID where projectName = '%@'", selectedProject];
    
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    NSString *identifer, *name, *date, *projectName, *goal, *latitude, *longitude, *weather, *partners, *permissions, *outcrop, *structuralData, *sampleNum, *notes, *stopNum, *magneticValue1, *magneticValue2, *magneticType;
    UIImage *sketch;
    UIImage *picture;
    NSMutableString *printString = [[NSMutableString alloc] init];
    
    [printString appendFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<kml xmlns=\"http://www.opengis.net/kml/2.2\">\n\t<Folder>"];
    [printString appendFormat:@"\n\t<name>Entries by Project: %@</name>", selectedProject];
    for (id entry in results) {
        identifer = [entry objectAtIndex:0];
        name = [entry objectAtIndex:1];
        projectName = [entry objectAtIndex:2];
        date = [entry objectAtIndex:3];
        goal = [entry objectAtIndex:4];
        latitude = [entry objectAtIndex:5];
        longitude = [entry objectAtIndex:6];
        weather = [entry objectAtIndex:7];
        sketch = [entry objectAtIndex:8];
        picture = [entry objectAtIndex:9];
        notes = [entry objectAtIndex:10];
        permissions = [entry objectAtIndex:11];
        sampleNum = [entry objectAtIndex:12];
        partners = [entry objectAtIndex:13];
        //Have to skip one because it also gets the entriesID from entriesGeology DB
        outcrop = [entry objectAtIndex:15];
        structuralData = [entry objectAtIndex:16];
        magneticValue1 = [entry objectAtIndex:17];
        magneticValue2 = [entry objectAtIndex:18];
        magneticType = [entry objectAtIndex:19];
        stopNum = [entry objectAtIndex:20];
        
        
        [printString appendString:@"\n\t<Placemark>"];
        [printString appendFormat:@"\n\t<name>Entry name: %@</name>", name];
        [printString appendFormat:@"\n\t\t<description>Date: %@\nProject Name: %@\nGoal: %@\nWeather: \n%@\nMagnetic Declination 1: %@\nMagnetic Declination 2: %@\nMagnetic Type: %@\nPartners %@\nPermissions: %@\nOutcrop Description: %@\nStructural Data: %@\nSample Number: %@\nNotes: %@\nStop Number: %@</description>", date, projectName, goal, weather, magneticValue1, magneticValue2, magneticType, partners, permissions, outcrop, structuralData, sampleNum, notes, stopNum];
        [printString appendString:@"\n\t\t<Point>"];
        [printString appendFormat:@"\n\t\t<coordinates>%@, %@, 0</coordinates>", longitude, latitude];
        [printString appendString:@"\n\t\t</Point>"];
        [printString appendString:@"\n\t</Placemark>"];
        
        
    }

    
    [printString appendString:@"\n\t</Folder>\n</kml>"];
    
    //Write the .kml file
    NSError *error;
    NSString *documentsDirectory = [NSHomeDirectory()
                                    stringByAppendingPathComponent:@"Documents"];
    NSString *fileName = [NSMutableString stringWithFormat:@"Project %@ Entries.kml", selectedProject];
    NSString *filePath = [documentsDirectory
                          stringByAppendingPathComponent:fileName];
    
    NSLog(@"string to write:%@", printString);
    
    [printString writeToFile:filePath atomically:YES
                    encoding:NSUTF8StringEncoding error:&error];
    
    NSLog(@"%@", filePath);
    
    if ([selectedProject length] == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Export Error" message: @"No project selected" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }else{
        //Email the entry
        //Doesn't work on the simulator, but should on phone
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        // Determine the MIME type
        NSString *mimeType = @"text/plain";
        //This one may be the one that works...have to wait and see
        //NSString *mimeType = @"application/vnd.google-earth.kml+xml";
        // Add attachment
        [mc addAttachmentData:fileData mimeType:mimeType fileName:fileName];
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];

        NSLog(@"%@", results);
    }
    
}

-(void)setPickerProjects{
    
    
    pickerData = [[NSMutableArray alloc] init];
    NSString *query = [NSString stringWithFormat:@"select projectName from entriesBasic inner join entriesGeology on entriesBasic.entriesID = entriesGeology.entriesID"];
    
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    //Cycles through all of the entries and creates an array of all of the projects
    if ([results count] != 0){
        _projectPicker.hidden = NO;
        for (id name in results){
            if ([pickerData containsObject:[name objectAtIndex:0]]){
                
            }else{
                [pickerData addObject:[name objectAtIndex:0]];
            }
        }
        NSLog(@"picker data: %@", pickerData);
        
        self.projectPicker.delegate = self;
        self.projectPicker.dataSource = self;
    }else{
        _projectPicker.hidden = YES;
    }
}
- (IBAction)syncDropbox:(id)sender {
    NSLog(@"HERE");
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:localDir error:nil];
    
    for (int i = 0; i < [files count]; i++){
         NSLog(@"HERE");
        if ([[files objectAtIndex:i] rangeOfString:@".png"].location != NSNotFound){
            localPath = [localDir stringByAppendingPathComponent:[files objectAtIndex:i]];
            filename = [files objectAtIndex:i];
            NSLog(@"%@", filename);
            [self.restClient loadMetadata:[NSString stringWithFormat:@"/%@", [files objectAtIndex:i]]];
        }
    }
}

- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
    NSLog(@"File uploaded successfully to path: %@, %@", metadata.path, metadata.rev);
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
    NSLog(@"File upload failed with error: %@", error);
}

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    NSLog(@"in loaded metadata: %@", metadata.filename);
    [self uploadFile:metadata];
    
}

- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
    [self uploadFile:nil];
}

-(void)uploadFile: (DBMetadata*)meta {
    [self.restClient uploadFile:filename toPath:@"/" withParentRev:meta.rev fromPath:localPath];
}
@end
