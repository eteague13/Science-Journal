//
//  ExportController.m
//  Science Journal
//
//  Created by Evan Teague on 8/18/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import "ExportController.h"
#import <DropboxSDK/DropboxSDK.h>

@interface ExportController ()

@end


@implementation ExportController
@synthesize database = _database;
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
    _database = [UserEntryDatabase userEntryDatabase];
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;
    // Do any additional setup after loading the view.
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
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy 'at' HH:mm"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    NSMutableString *printString = [[NSMutableString alloc] init];
    
    [printString appendFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<kml xmlns=\"http://www.opengis.net/kml/2.2\">\n\t<Folder>"];
    
    for (int i = 0; i < _database.entries.count; i++){
        Entry *tempEntry = _database.entries[i];
        [printString appendFormat:@"\n\t<name>All Entries</name>", tempEntry.name];
        [printString appendString:@"\n\t<Placemark>"];
        [printString appendFormat:@"\n\t<name>Entry name: %@</name>", tempEntry.name];
        [printString appendFormat:@"\n\t\t<description>Date: %@\nProject Name: %@\nGoal: %@\nWeather: \n%@\nMagnetic Declination: %@\nPartners %@\nPermissions: %@\nOutcrop Description: %@\nStructural Data: %@\nSample Number: %@\nNotes: %@</description>", dateString, tempEntry.projectName, tempEntry.goal, tempEntry.weather, tempEntry.magnet, tempEntry.partners, tempEntry.permissions, tempEntry.outcrop, tempEntry.structuralData, tempEntry.sampleNum, tempEntry.notes];
        [printString appendString:@"\n\t\t<Point>"];
        [printString appendFormat:@"\n\t\t<coordinates>%@, %@, 0</coordinates>", tempEntry.longitude, tempEntry.latitude];
        [printString appendString:@"\n\t\t</Point>"];
        [printString appendString:@"\n\t</Placemark>"];
    }
    
    [printString appendString:@"\n\t</Folder>\n</kml>"];
    
    NSLog(@"string to write:%@", printString);
    
    
    NSError *error;
    
    
    NSString *documentsDirectory = [NSHomeDirectory()
                                    stringByAppendingPathComponent:@"Documents"];
    NSString *fileName = [NSMutableString stringWithFormat:@"My G.E. Entries%@", @".kml"];
    NSString *filePath = [documentsDirectory
                          stringByAppendingPathComponent:fileName];
    
    NSLog(@"string to write:%@", printString);
    
    [printString writeToFile:filePath atomically:YES
                    encoding:NSUTF8StringEncoding error:&error];
    
    NSLog(@"%@", filePath);
    
}
- (IBAction)syncDropbox:(id)sender {
    NSLog(@"IN DROPBOX");
    
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
        NSLog(@"in the if statement");
    }
    
    NSString *text = @"Hello world poop.";
    NSString *filename = @"working-draft.txt";
    NSString *documentsDirectory = [NSHomeDirectory()
                                    stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [documentsDirectory
                          stringByAppendingPathComponent:filename];
    
    [text writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    // Upload file to Dropbox
    NSString *destDir = @"/";
    [self.restClient uploadFile:filename toPath:destDir withParentRev:nil fromPath:filePath];
    
    [self.restClient loadMetadata:@"/"];
}

- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
    NSLog(@"File upload failed with error: %@", error);
}

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    if (metadata.isDirectory) {
        NSLog(@"Folder '%@' contains:", metadata.path);
        for (DBMetadata *file in metadata.contents) {
            NSLog(@"	%@", file.filename);
        }
    }
}

- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
    NSLog(@"Error loading metadata: %@", error);
}
@end
