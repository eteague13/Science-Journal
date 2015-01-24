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
#import "Entry.h"
#import "EntryController.h"
#import "DBManager.h"


@interface EntriesController () 
    


@end

@implementation EntriesController
    

@synthesize database = _database;
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
    
    
    _database = [UserEntryDatabase userEntryDatabase];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"entriesdb.sql"];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    /*
    Entry *testEntry = [[Entry alloc] init];
                        //initWithTitle:@"1" date:@"2" projectName:@"3" goal:@"4" latitude:@"5" longitude:@"6" weather:@"7" magnet:@"8" partners:@"9" permissions:@"10" outcrop:@"11" structuralData:@"12" sampleNum:@"13" notes:@"14"];
    testEntry.name = @"Test 1";
    testEntry.date = @"date";
    testEntry.projectName = @"project name";
    testEntry.goal = @"goal";
    testEntry.latitude = @"37.008203";
    testEntry.longitude = @"-79.522963";
    testEntry.weather = @"weather";
    testEntry.magnet = @"magnets";
    testEntry.partners = @"partners";
    testEntry.permissions = @"permissions";
    testEntry.outcrop = @"outcrops";
    testEntry.structuralData = @"structural data";
    testEntry.sampleNum = @"sampleNum";
    testEntry.notes = @"notes";
    NSLog(@"%@", testEntry.name);
    //[_database.entries addObject:testEntry];
    [_database addEntry:testEntry];
    Entry *testEntry2 = [[Entry alloc] init];
    testEntry2.name = @"Test 2";
    testEntry2.date = @"date";
    testEntry2.projectName = @"project name";
    testEntry2.goal = @"goal";
    testEntry2.latitude = @"38.008203";
    testEntry2.longitude = @"-78.522963";
    testEntry2.weather = @"weather";
    testEntry2.magnet = @"magnets";
    testEntry2.partners = @"partners";
    testEntry2.permissions = @"permissions";
    testEntry2.outcrop = @"outcrops";
    testEntry2.structuralData = @"structural data";
    testEntry2.sampleNum = @"sampleNum";
    testEntry2.notes = @"notes";
    [_database addEntry: testEntry2];
     */
    //NSLog(@"Number of rows: %d", [_database.entries count]);
    //NSLog(@"%@", _database.entries );
    /*
    _allEntryNames = [NSMutableArray arrayWithObjects:@"Test 1", nil];
    _allEntryDates = [NSMutableArray arrayWithObjects:@"date", nil];
    _allProjectNames = [NSMutableArray arrayWithObjects:@"project name", nil];
    _allGoals = [NSMutableArray arrayWithObjects:@"goal", nil];
    _allLats = [NSMutableArray arrayWithObjects:@"lat", nil];
    _allLongs = [NSMutableArray arrayWithObjects:@"long", nil];
    _allWeather = [NSMutableArray arrayWithObjects:@"weather", nil];
    _allMagnets = [NSMutableArray arrayWithObjects:@"magnets", nil];
    _allPartners = [NSMutableArray arrayWithObjects:@"partners", nil];
    _allPermissions = [NSMutableArray arrayWithObjects:@"permissions", nil];
    _allOutcrops = [NSMutableArray arrayWithObjects:@"outcrops", nil];
    _allStructuralData = [NSMutableArray arrayWithObjects:@"structural data", nil];
    _allSampleNums = [NSMutableArray arrayWithObjects:@"sample num", nil];
    _allNotes = [NSMutableArray arrayWithObjects:@"notes", nil];
     */
    //[self.tableView reloadData];
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
    //return _allEntryNames.count;
    //NSLog(@"Number of rows: %lu", (unsigned long)[_database.entries count]);
    //return [_database.entries count];
    NSString *query = @"select * from entriesBasic";
    _allEntriesFromDB = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    return _allEntriesFromDB.count;
    //return [database.getEntries count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EntriesCell";
    EntriesCell *cell = [tableView
                         dequeueReusableCellWithIdentifier:CellIdentifier
                         forIndexPath:indexPath];
    
    NSInteger indexOfEntryName = [self.dbManager.arrColumnNames indexOfObject:@"name"];
    cell.entryNameLabel.text = [NSString stringWithFormat:@"%@", [[self.allEntriesFromDB objectAtIndex:indexPath.row] objectAtIndex:indexOfEntryName]];
    
    
    return cell;
    /*
    static NSString *CellIdentifier = @"EntriesCell";
    EntriesCell *cell = [tableView
                              dequeueReusableCellWithIdentifier:CellIdentifier
                              forIndexPath:indexPath];
    
    // Configure the cell...
    
    long row = [indexPath row];
    
    Entry *selectedEntry = [_database getEntryAtIndex:row];
    cell.entryNameLabel.text = selectedEntry.name;
    
    
    return cell;
     */
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
    if ([segue.identifier isEqualToString:@"AddEntry"])
    {
     
        UINavigationController *navigationController = segue.destinationViewController;
        AddEntryController *addEntryController = [navigationController viewControllers][0];
        addEntryController.delegate = self;
        addEntryController.recordIDToEdit = -1;
    }
    else if ([segue.identifier isEqualToString:@"EditEntry"])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        AddEntryController *addEntryController = [navigationController viewControllers][0];
        addEntryController.delegate = self;
        [addEntryController setEditEntry:true];
        
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        
        long row = [myIndexPath row] + 1;
        
        addEntryController.recordIDToEdit = self.recordIDToEdit;
        NSLog(@"Record id: %d", _recordIDToEdit);
        /*
        if (self.recordIDToEdit != -1){
            NSString *query = [NSString stringWithFormat:@"select * from entriesBasic where entriesID = %d", self.recordIDToEdit];
            NSLog(@"Query: %@", query);
        
            //NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
            //addEntryController.associatedEntryArray = results;
            
            NSLog(@"Entry from table%@", self.arrEntryInfo);
        }
         */


        //addEntryController.associatedEntry = [_database getEntryAtIndex:row];
        
    }
     

    
    
    
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    self.recordIDToEdit = [[[self.arrEntryInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
    self.recordIDToEdit +=1;
    NSLog(@"Trying to add one: %d", _recordIDToEdit);
    [self performSegueWithIdentifier:@"EditEntry" sender:self];
    
    
}
-(UserEntryDatabase*)returnEntryDatabase {
    return _database;
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        int recordIDToDelete = [[[self.arrEntryInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue]+1;
        
        // Prepare the query.
        NSString *query = [NSString stringWithFormat:@"delete from entriesBasic where entriesID=%d", recordIDToDelete];
        
        // Execute the query.
        [self.dbManager executeQuery:query];
        
        //[_database deleteEntryAtIndex:[indexPath row]];
        [tableView reloadData];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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

- (void)AddEntryControllerDidCancel:(AddEntryController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)AddEntryController:(AddEntryController *)controller didSaveEntry:(Entry *)entry
{
    [_database addEntry: entry];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)AddEntryController:(AddEntryController *)controller didUpdateEntry:(Entry *)entry{
    [_database updateEntry:entry];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
