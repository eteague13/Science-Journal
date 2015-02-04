//
//  EntriesController.m
//  Science Journal
//
//  Created by Evan Teague on 8/19/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

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
    
    NSLog(@"%@", filePath);
    
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

    //Get all the entries from the database and count them
      NSString *query = @"select * from entriesBasic inner join entriesGeology on entriesBasic.entriesID = entriesGeology.entriesID";
    _allEntriesFromDB = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    return _allEntriesFromDB.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Add each entry from the database to the tableview
    static NSString *CellIdentifier = @"EntriesCell";
    EntriesCell *cell = [tableView
                         dequeueReusableCellWithIdentifier:CellIdentifier
                         forIndexPath:indexPath];
    
    NSInteger indexOfEntryName = [self.dbManager.arrColumnNames indexOfObject:@"name"];
    cell.entryNameLabel.text = [NSString stringWithFormat:@"%@", [[self.allEntriesFromDB objectAtIndex:indexPath.row] objectAtIndex:indexOfEntryName]];
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Sandcropped1.jpg"]];
    //[cell.contentView.layer setBorderColor:[UIColor blackColor].CGColor];
    //[cell.contentView.layer setBorderWidth:2.0f];
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
        
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];

        self.recordIDToEdit = [[[self.allEntriesFromDB objectAtIndex:myIndexPath.row] objectAtIndex:0] intValue];
        addEntryController.recordIDToEdit = self.recordIDToEdit;

        
    }
     

    
    
    
}



-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Allows the user to swipe to delete
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        int recordIDToDelete = [[[self.allEntriesFromDB objectAtIndex:indexPath.row] objectAtIndex:0] intValue];

        NSString *query = [NSString stringWithFormat:@"delete from entriesBasic where entriesID=%d", recordIDToDelete];

        [self.dbManager executeQuery:query];
        
        NSString *queryGeology = [NSString stringWithFormat:@"delete from entriesGeology where entriesID=%d", recordIDToDelete];
        [self.dbManager executeQuery:queryGeology];
        [tableView reloadData];
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
    self.allEntriesFromDB = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    [self.tableView reloadData];
}


@end
