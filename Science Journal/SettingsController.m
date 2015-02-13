//
//  SettingsController.m
//  Science Journal
//
//  Created by Evan Teague on 8/18/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import "SettingsController.h"

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
    [_scroller setContentSize:CGSizeMake(320, 1500)];
    [self.view addSubview:_scroller];

    _geoMagDecSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"SwitchGeoMagDec"];
    _geoOutcropSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"SwitchGeoOutcrop"];
    _geoStopNumSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"SwitchGeoStopNum"];
    _geoStructDataSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"SwitchGeoStructData"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Sandcropped1.jpg"]];
   
    
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
