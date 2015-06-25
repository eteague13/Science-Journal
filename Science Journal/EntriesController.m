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
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"FieldBookdb.sql"];
    
    //Creates and adds bar button items
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEntrySegue)];
    UIBarButtonItem *settingsItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings-25.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(viewProjectSettings)];
    
    NSArray *rightButtonItems = @[addItem, settingsItem];
    self.navigationItem.rightBarButtonItems = rightButtonItems;
    
}
//Reloads the data each time the view appears
-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Add entry bar button action
-(void)addEntrySegue{
    [self performSegueWithIdentifier:@"AddEntry" sender:self];
}
//View project settings bar button action
-(void)viewProjectSettings{
    [self performSegueWithIdentifier:@"ProjectSettings" sender:self];
}

//Gets the number of entries for the selected project
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *query = [NSString stringWithFormat:@"select * from entriesBasic where projectName='%@'", _projectNameList];
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    return [results count];

}

//Adds a cell per entry
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //Add each entry from the database to the tableview
    static NSString *CellIdentifier = @"EntriesCell";
    EntriesCell *cell = [tableView
                         dequeueReusableCellWithIdentifier:CellIdentifier
                         forIndexPath:indexPath];
    
    NSString *query = [NSString stringWithFormat:@"select * from entriesBasic where projectName='%@'", _projectNameList];
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSString *entryName = [[results objectAtIndex:indexPath.row] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"name"]];
    NSString *entryID = [[results objectAtIndex:indexPath.row] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"entriesID"]];
    cell.entryNameLabel.text = entryName;
    cell.identifier = [entryID intValue];
    return cell;
}

//Segues to add an entry, edit an entry, or view the project settings
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
        //How I tell which entry is selected
        addEntryController.recordIDToEdit = self.recordIDToEdit;
        self.recordIDToEdit = (int)[self.tableView indexPathForSelectedRow].row + 1;
        EntriesCell *entryToEdit = (EntriesCell *)[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
        addEntryController.recordIDToEdit = entryToEdit.identifier;
        
    }else if ([segue.identifier isEqualToString:@"ProjectSettings"]){
        UINavigationController *navigationController = segue.destinationViewController;
        SettingsController *settingsController = [navigationController viewControllers][0];
        settingsController.delegate = self;
        [settingsController setProjectSettingsName:self.projectNameList];
        
    }
    
    
}

//Deletes an entry on user swipe
-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    EntriesCell *entryName = (EntriesCell *)[self.tableView cellForRowAtIndexPath:indexPath];

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        int recordIDToDelete = entryName.identifier;
        //Delete the picture and sketch images from the app documents folder
        NSString *deletePictureSketchQuery = [NSString stringWithFormat:@"select * from entriesBasic where entriesID=%d", recordIDToDelete];
        NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:deletePictureSketchQuery]];
        NSString *documentsDirectory = [NSHomeDirectory()
                                        stringByAppendingPathComponent:@"Documents"];
        NSString *pictureName = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames     indexOfObject:@"picture"]];
        NSString *pictureFilePath = [documentsDirectory stringByAppendingPathComponent:pictureName];
        NSString *sketchName = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"sketch"]];
        NSString *sketchFilePath = [documentsDirectory stringByAppendingPathComponent:sketchName];
        [[NSFileManager defaultManager] removeItemAtPath: pictureFilePath error: nil];
        [[NSFileManager defaultManager] removeItemAtPath: sketchFilePath error: nil];
        
        //Delete the entry from the database itself
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

    
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];

}


//Delegat method that is called when the project settings are saved
-(void)settingsControllerUpdate:(SettingsController *)controller settingsArray:(NSArray *)settings{
    NSString *query = [NSString stringWithFormat:@"update projectSettings set date='%@', goal='%@', locationWeather='%@', sketch='%@', picture='%@', notes='%@', permissions='%@', sampleNum='%@', partners='%@', strikeDip='%@', stopNum='%@', outcrop='%@', structuralData='%@', dataSheet='%@', trendPlunge='%@' where projectName='%@'", settings[0], settings[1], settings[2], settings[3], settings[4], settings[5], settings[6], settings[7], settings[8], settings[9], settings[10], settings[11], settings[12], settings[13], settings[14], self.projectNameList];
    [self.dbManager executeQuery:query];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Sets the selected project from the projects controller
-(void)setProjectName:(NSString *)projectNameList {
    self.projectNameList = projectNameList;
}



@end
