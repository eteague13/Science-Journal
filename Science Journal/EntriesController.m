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
    
    //Create the link to the SQLite database
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"entriesdb.sql"];
    NSString *documentsDirectory = [NSHomeDirectory()
                                    stringByAppendingPathComponent:@"Documents"];

    NSString *filePath = documentsDirectory;
    
    

    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Sandcropped1.jpg"]];
    [self.tableView setSeparatorColor:[UIColor blackColor]];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    
    NSLog(@"%@", filePath);
    /*
    NSString *delete1 = @"delete from entriesBasic";
    [self.dbManager executeQuery:delete1];
    NSString *delete2 = @"delete from entriesGeology";
    [self.dbManager executeQuery:delete2];
    */
    
    [self loadData];
    
    
    
    
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
    return [[self.sections allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Sorts it based on the project
    return [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //Add each entry from the database to the tableview
    static NSString *CellIdentifier = @"EntriesCell";
    EntriesCell *cell = [tableView
                         dequeueReusableCellWithIdentifier:CellIdentifier
                         forIndexPath:indexPath];
    
    NSString *sectionEntry = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    NSString *query = [NSString stringWithFormat:@"select * from entriesBasic inner join entriesGeology on entriesBasic.entriesID = entriesGeology.entriesID where entriesBasic.entriesID = %d", [sectionEntry intValue]];
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    cell.entryNameLabel.text = [[results objectAtIndex:0] objectAtIndex:1];
    cell.identifier = [sectionEntry intValue];
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Sandcropped1.jpg"]];
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow.png"]];
    cell.accessoryView = arrow;
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
        NSLog(@"In add segue");
    }
    else if ([segue.identifier isEqualToString:@"EditEntry"])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        AddEntryController *addEntryController = [navigationController viewControllers][0];
        addEntryController.delegate = self;
        [addEntryController setEditEntry:true];
        
        //NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        EntriesCell *entryName = [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];

        self.recordIDToEdit = entryName.identifier;
        addEntryController.recordIDToEdit = self.recordIDToEdit;

        
    }
     

    
    
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
}


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
    EntriesCell *entryName = [self.tableView cellForRowAtIndexPath:indexPath];
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
        
        NSString *queryGeology = [NSString stringWithFormat:@"delete from entriesGeology where entriesID=%d", recordIDToDelete];
        [self.dbManager executeQuery:queryGeology];
        [self loadData];
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
    [self loadData];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];

}


//Used to refresh the loaded data from the database
-(void)loadData{

    NSString *query = @"select * from entriesBasic inner join entriesGeology on entriesBasic.entriesID = entriesGeology.entriesID";
    
    if (self.allEntriesFromDB != nil) {
        self.allEntriesFromDB = nil;
    }
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    self.allEntriesFromDB = results;
    
    
    self.sections = [[NSMutableDictionary alloc] init];
    BOOL found;
    // Loop through the entries and creates a dictionary of key: projects, values: entries
    for (id entry in results)
    {
        NSString *projectname = [entry objectAtIndex:2];
        found = NO;
        
        for (NSString *str in [self.sections allKeys])
        {
            if ([str isEqualToString:projectname])
            {
                found = YES;
            }
        }
        
        if (!found)
        {
            [self.sections setValue:[[NSMutableArray alloc] init] forKey:projectname];
            
        }
    }
    
    for (id entry in results){
        [[self.sections objectForKey:[entry objectAtIndex:2]] addObject:[entry objectAtIndex:0]];
    }
    
    

    [self.tableView reloadData];
}

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

@end
