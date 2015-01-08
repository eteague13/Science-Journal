//
//  SettingsController.m
//  Science Journal
//
//  Created by Evan Teague on 8/18/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import "SettingsController.h"
#import <DropboxSDK/DropboxSDK.h>
#import "AppDelegate.h"

@interface SettingsController ()

@end

@implementation SettingsController
@synthesize scroller = _scroller;

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
    [_scroller setScrollEnabled:YES];
    [_scroller setContentSize:CGSizeMake(320, 1300)];
    [self.view addSubview:_scroller];
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;
    _geoMagDecSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"SwitchGeoMagDec"];
    _geoOutcropSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"SwitchGeoOutcrop"];
    _geoStopNumSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"SwitchGeoStopNum"];
    _geoStructDataSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"SwitchGeoStructData"];
    
   
    
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



/*
- (IBAction)syncDropbox:(id)sender {
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
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
 */


- (IBAction)geoMagDecFlip:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:_geoMagDecSwitch.on forKey:@"SwitchGeoMagDec"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (IBAction)geoStopNumFlip:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:_geoStopNumSwitch.on forKey:@"SwitchGeoStopNum"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)geoOutcropFlip:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:_geoOutcropSwitch.on forKey:@"SwitchGeoOutcrop"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)geoStructDataFlip:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:_geoStructDataSwitch.on forKey:@"SwitchGeoStructData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
