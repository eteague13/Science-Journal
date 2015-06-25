//
//  AppSettingsController.m
//  Science Journal
//
//  Created by Evan Teague on 6/16/15.
//  Copyright (c) 2015 Evan Teague. All rights reserved.
//

#import "AppSettingsController.h"


@interface AppSettingsController ()

@end

@implementation AppSettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkIfDropboxLinked];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [self checkIfDropboxLinked];
}

//If the user taps the dropbox switch
- (IBAction)loginToDropbox:(id)sender {
    //If the dropbox switch is on, and it's not linked, link it and turn the switch to on
    if (_dropboxSwitch.isOn){
        if (![[DBSession sharedSession] isLinked]) {
            [[DBSession sharedSession] linkFromController:self];
            _dropboxSwitch.on = YES;
        }
    //If the dropbox switch is turned off, and the account is linked, unlink it and turn the switch off
    }else if (!(_dropboxSwitch.isOn)) {
        if ([[DBSession sharedSession] isLinked]) {
            [[DBSession sharedSession] unlinkAll];
            _dropboxSwitch.on = NO;
            
        }
    }
    
}
//Checks if the dropbox account is linke
-(void)checkIfDropboxLinked{
    if (![[DBSession sharedSession] isLinked]) {
        _dropboxSwitch.on = NO;
    }else{
        _dropboxSwitch.on = YES;
    }
}

//Delegate methods for dropbox
static int outstandingRequests;
- (void)networkRequestStarted
{
    outstandingRequests++;
    if (outstandingRequests == 1) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
}
- (void)networkRequestStopped
{
    outstandingRequests--;
    if (outstandingRequests == 0) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}


@end
