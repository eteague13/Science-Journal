//
//  TablesViewController.m
//  Science Journal
//
//  Created by Evan Teague on 1/12/15.
//  Copyright (c) 2015 Evan Teague. All rights reserved.
//

#import "ReferenceViewController.h"
#import "AddReferenceController.h"

@interface ReferenceViewController ()

@end

@implementation ReferenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //Initialize the database connection
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"FieldBookdb.sql"];

    //Inserts the About Resources page
    NSString *addFirstReferenceExistence = @"select * from allReferences where referenceID=1";
    NSArray *results = [self.dbManager loadDataFromDB:addFirstReferenceExistence];
    if ([results count] == 0){
        NSString *addReferenceQuery = [NSString stringWithFormat:@"insert into allReferences values(null, '%@', '%d', '%@')",@"", 0, @"About Resources"];
        
        NSLog(@"In the references load");
        [self.dbManager loadDataFromDB:addReferenceQuery];
    }
    
    [self reloadData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//Gets the number of resources
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_allReferencesFromDB count];
}

//Creates a cell for each of the resources
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ReferenceCell";
    EntriesCell *cell = [tableView
                         dequeueReusableCellWithIdentifier:CellIdentifier
                         forIndexPath:indexPath];
    int tempIndexPath = (int)indexPath.row + 1;
    NSString *query = [NSString stringWithFormat:@"select * from allReferences where allReferences.referenceID = %i",tempIndexPath];
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    cell.entryNameLabel.text = [[results objectAtIndex:0] objectAtIndex:3];
    cell.identifier = tempIndexPath;
    
    return cell;
}



//If the user deletes a resource
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    EntriesCell *referenceName = (EntriesCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    //Allows the user to swipe to delete. Cannot delete if the resource is the About Resources entry
    if (editingStyle == UITableViewCellEditingStyleDelete && referenceName.identifier != 1) {
        int recordIDToDelete = referenceName.identifier;
        
        NSString *deletePictureSketchQuery = [NSString stringWithFormat:@"select * from allReferences where referenceID=%d", recordIDToDelete];
        NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:deletePictureSketchQuery]];
        int photoOrTextDelete = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"isImage"]] intValue];
        if (photoOrTextDelete == 0){
            NSString *pictureFilePath = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"contents"]];
            [[NSFileManager defaultManager] removeItemAtPath: pictureFilePath error: nil];
        }
        NSString *query = [NSString stringWithFormat:@"delete from allReferences where referenceID=%d", recordIDToDelete];
        
        [self.dbManager executeQuery:query];
        [self reloadData];
    }
    //If the user tries to delete the About Resources entry
    else if (referenceName.identifier == 1){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Action Not Allowed" message: @"Not permitted to delete the template" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}


//Various segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"addRefText"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        AddReferenceController *addReference = [navigationController viewControllers][0];
        addReference.delegate = self;
        [addReference setPhotoOrText:1];
    }else if ([segue.identifier isEqualToString:@"addReferencePhoto"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        AddReferenceController *addReference = [navigationController viewControllers][0];
        addReference.delegate = self;
        [addReference setPhotoOrText:0];
    }else if ([segue.identifier isEqualToString:@"viewReferenceCell"]){
        ViewReferenceController *viewReference = segue.destinationViewController;
        viewReference.delegate = self;
        EntriesCell *referenceSelected = (EntriesCell *)[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
        NSString *query = [NSString stringWithFormat:@"select * from allReferences where allReferences.referenceID = %i",referenceSelected.identifier];
        NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
        [viewReference setPhotoOrText: [[[results objectAtIndex:0] objectAtIndex:2] intValue] setContents:[[results objectAtIndex:0] objectAtIndex:1] setIdentifier: referenceSelected.identifier setName: [[results objectAtIndex:0] objectAtIndex:3]];
        
        
    }
    
    
}

//If the user saves the reference
- (void)referenceSave:(AddReferenceController *) controller setContents:(NSString*) contents setImageOrText:(int) val setName:(NSString *)nm {
    NSString *addReferenceQuery = [NSString stringWithFormat:@"insert into allReferences values(null, '%@', '%d', '%@')", contents, val, nm];
    [self.dbManager executeQuery:addReferenceQuery];
    
    //Internal testing code
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
    }
    else{
        NSLog(@"Could not execute the query.");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    [self reloadData];
    
}
//If the user selects cancel
- (void)referenceCancel:(AddReferenceController *) controller{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
//If the user saves the resources
-(void)viewReferenceSave:(ViewReferenceController *)controller setContents:(NSString *)contents setImageOrText:(int)val setName:(NSString *)nm setID:(int)iden {
    
    NSString *editReferenceQuery = [NSString stringWithFormat:@"update allReferences set contents='%@', name='%@' where referenceID=%d", contents, nm, iden];
    [self.dbManager executeQuery:editReferenceQuery];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Reference Saved" message: @"" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    [self reloadData];
    
}

//Refreshes the list of resources
- (void)reloadData{
    NSString *query = [NSString stringWithFormat:@"select * from allReferences"];
    _allReferencesFromDB = [self.dbManager loadDataFromDB:query];
    [_referenceTable reloadData];
}

@end
