//
//  EntriesController.m
//  Science Journal
//
//  Created by Evan Teague on 8/19/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//  Used to help with sections http://www.icodeblog.com/2010/12/10/implementing-uitableview-sections-from-an-nsarray-of-nsdictionary-objects/

#import "EntriesController.h"
#import "EntriesCell.h"
#import "DBManager.h"


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
    
    //Initialize the database connection
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"entriesdb.sql"];
    NSString *documentsDirectory = [NSHomeDirectory()
                                    stringByAppendingPathComponent:@"Documents"];

    NSString *filePath = documentsDirectory;
    
    

    //self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Sandcropped1.jpg"]];
    //[self.tableView setSeparatorColor:[UIColor blackColor]];
    //[self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    
    NSLog(@"%@", filePath);
    
    /*
    NSString *delete1 = @"delete from entriesBasic";
    [self.dbManager executeQuery:delete1];
    */
    
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return [[self.sections allKeys] count];
}
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *query = [NSString stringWithFormat:@"select * from entriesBasic where projectName='%@'", _projectNameList];
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    return [results count];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //Add each entry from the database to the tableview
    static NSString *CellIdentifier = @"EntriesCell";
    EntriesCell *cell = [tableView
                         dequeueReusableCellWithIdentifier:CellIdentifier
                         forIndexPath:indexPath];
    
    NSString *query = [NSString stringWithFormat:@"select * from entriesBasic where projectName='%@'", _projectNameList];
    NSLog(@"QUERY: %@", query);
    //NSString *query = [NSString stringWithFormat:@"select * from entriesBasic"];
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSLog(@"Item: %@", results);
    NSString *entryName = [[results objectAtIndex:indexPath.row] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"name"]];
    NSString *entryID = [[results objectAtIndex:indexPath.row] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"entriesID"]];
    cell.entryNameLabel.text = entryName;
    cell.identifier = [entryID intValue];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
    if ([segue.identifier isEqualToString:@"AddEntry"])
    {
     
        UINavigationController *navigationController = segue.destinationViewController;
        AddEntryController *addEntryController = [navigationController viewControllers][0];
        addEntryController.delegate = self;
        addEntryController.recordIDToEdit = -1;
        [addEntryController setProjectNameList:self.projectNameList];
    }
    
    else if ([segue.identifier isEqualToString:@"EditEntry"])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        AddEntryController *addEntryController = [navigationController viewControllers][0];
        addEntryController.delegate = self;
        [addEntryController setEditEntry:true];
        addEntryController.recordIDToEdit = self.recordIDToEdit;
        self.recordIDToEdit = (int)[self.tableView indexPathForSelectedRow].row + 1;
        EntriesCell *entryToEdit = (EntriesCell *)[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
        addEntryController.recordIDToEdit = entryToEdit.identifier;
        
     

        
    }
    
    
}


/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
}
*/

/*
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}
 */

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    EntriesCell *entryName = (EntriesCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"Record ID to delete: %d", entryName.identifier);
    //Allows the user to swipe to delete
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        int recordIDToDelete = entryName.identifier;
        NSLog(@"Record ID to delete: %d", recordIDToDelete);
        
        NSString *deletePictureSketchQuery = [NSString stringWithFormat:@"select * from entriesBasic where entriesID=%d", recordIDToDelete];
        NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:deletePictureSketchQuery]];
        NSString *pictureFilePath = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"picture"]];
        NSString *sketchFilePath = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"sketch"]];
        [[NSFileManager defaultManager] removeItemAtPath: pictureFilePath error: nil];
        [[NSFileManager defaultManager] removeItemAtPath: sketchFilePath error: nil];
        
        NSString *query = [NSString stringWithFormat:@"delete from entriesBasic where entriesID=%d", recordIDToDelete];

        [self.dbManager executeQuery:query];
        
        [self.tableView reloadData];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


//Delegate method that is called when the AddEntryController is canceled
- (void)AddEntryControllerDidCancel:(AddEntryController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Delegate method that is called when entry in the AddEntryController is saved
- (void)AddEntryControllerDidSave:(AddEntryController *)controller;
{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Entry Saved" message: @"" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];

}


/*
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
 */

-(void)setProjectName:(NSString *)projectNameList {
    self.projectNameList = projectNameList;
}



@end
