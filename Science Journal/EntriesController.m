//
//  EntriesController.m
//  Science Journal
//
//  Created by Evan Teague on 8/19/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import "EntriesController.h"
#import "EntriesCell.h"
#import "SingleEntryViewController.h"

@interface EntriesController ()

@end

@implementation EntriesController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    
    _allEntryNames = @[@"Test 1"];
    _allEntryDates = @[@"date"];
    _allProjectNames = @[@"project name"];
    _allGoals = @[@"goal"];
    _allLats = @[@"lat"];
    _allLongs = @[@"long"];
    _allWeather = @[@"weather"];
    _allMagnets = @[@"magnets"];
    _allPartners = @[@"partners"];
    _allPermissions = @[@"permissions"];
    _allOutcrops = @[@"outcrops"];
    _allStructuralData = @[@"structural data"];
    _allSampleNums = @[@"sample num"];
    _allNotes = @[@"notes"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return _allEntryNames.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EntriesCell";
    EntriesCell *cell = [tableView
                              dequeueReusableCellWithIdentifier:CellIdentifier
                              forIndexPath:indexPath];
    
    // Configure the cell...
    
    long row = [indexPath row];
    
    cell.entryNameLabel.text = _allEntryNames[row];
    
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"ShowEntryDetails"])
    {
        
        SingleEntryViewController *entryDetailController = segue.destinationViewController;
        
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        
        long row = [myIndexPath row];
        
    
        entryDetailController.entryDetailsModel = @[_allEntryNames[row], _allEntryDates[row], _allProjectNames[row], _allGoals[row], _allLats[row], _allLongs[row], _allWeather[row], _allMagnets[row], _allPartners[row], _allPermissions[row], _allOutcrops[row], _allStructuralData[row], _allSampleNums[row], _allNotes[row]];
        
    }
    
    
    
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
