//
//  SettingsController.m
//  Science Journal
//
//  Created by Evan Teague on 6/15/15.
//  Copyright (c) 2015 Evan Teague. All rights reserved.
//

#import "SettingsController.h"

@interface SettingsController ()

@end

@implementation SettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"entriesdb.sql"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSString *settingsQuery = [NSString stringWithFormat:@"select * from projectSettings where projectName='%@'", projectName];
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:settingsQuery]];
    _dateSwitch.on = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"date"]] intValue];
    _goalSwitch.on = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"goal"]] intValue];
    _locationSwitch.on = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"locationWeather"]] intValue];
    _sketchSwitch.on = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"sketch"]] intValue];
    _pictureSwitch.on = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"picture"]] intValue];
    _notesSwitch.on = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"notes"]] intValue];
    _permissionsSwitch.on = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"permissions"]] intValue];
    _sampleNumSwitch.on = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"sampleNum"]] intValue];
    _partnersSwitch.on = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"partners"]] intValue];
    _strikeDipSwitch.on = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"strikeDip"]] intValue];
    _stopNumSwitch.on = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"stopNum"]] intValue];
    _outcropSwitch.on = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"outcrop"]] intValue];
    _structuralSwitch.on = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"structuralData"]] intValue];
    _datasheetSwitch.on = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"dataSheet"]] intValue];
    _trendPlungeSwitch.on = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"trendPlunge"]] intValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


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


- (IBAction)saveSettings:(id)sender {
    NSArray *settings = @[[NSNumber numberWithBool:_dateSwitch.isOn],[NSNumber numberWithBool:_goalSwitch.isOn], [NSNumber numberWithBool:_locationSwitch.isOn], [NSNumber numberWithBool:_dateSwitch.isOn], [NSNumber numberWithBool:_dateSwitch.isOn], [NSNumber numberWithBool:_notesSwitch.isOn], [NSNumber numberWithBool:_permissionsSwitch.isOn], [NSNumber numberWithBool:_sampleNumSwitch.isOn], [NSNumber numberWithBool:_partnersSwitch.isOn], [NSNumber numberWithBool:_strikeDipSwitch.isOn], [NSNumber numberWithBool:_stopNumSwitch.isOn], [NSNumber numberWithBool:_outcropSwitch.isOn], [NSNumber numberWithBool:_structuralSwitch.isOn], [NSNumber numberWithBool:_datasheetSwitch.isOn], [NSNumber numberWithBool:_trendPlungeSwitch.isOn]];
    NSLog(@"Here in save settings");
    
    [self.delegate settingsControllerUpdate:self settingsArray:settings];
}

-(void)setProjectSettingsName:(NSString*)pn {
    projectName = pn;
}
@end
