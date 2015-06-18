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
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"referencesdb.sql"];

    NSString *addFirstReferenceExistence = @"select * from allReferences where referenceID=1";
    NSArray *results = [self.dbManager loadDataFromDB:addFirstReferenceExistence];
    if ([results count] == 0){
        NSString *addReferenceQuery = [NSString stringWithFormat:@"insert into allReferences values(null, '%@', '%d', '%@')",@"", 0, @"About Resources"];
        
        NSLog(@"In the references load");
        [self.dbManager loadDataFromDB:addReferenceQuery];
    }
    
    
    /*
    NSString *delete1 = @"delete from allReferences";
    [self.dbManager executeQuery:delete1];
    */
    
    
    
     
    
    [self reloadData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}
 */
 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"HERE");
    NSLog(@"%lu", (unsigned long)[_allReferencesFromDB count]);
    return [_allReferencesFromDB count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Inside cell");
    static NSString *CellIdentifier = @"ReferenceCell";
    EntriesCell *cell = [tableView
                         dequeueReusableCellWithIdentifier:CellIdentifier
                         forIndexPath:indexPath];
    int tempIndexPath = (int)indexPath.row + 1;
    NSString *query = [NSString stringWithFormat:@"select * from allReferences where allReferences.referenceID = %i",tempIndexPath];
    NSLog(@"Query in index path: %@", query);
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSLog(@"Item: %@", results);
    NSLog(@"Problem?: %@", [[results objectAtIndex:0] objectAtIndex:3]);
    cell.entryNameLabel.text = [[results objectAtIndex:0] objectAtIndex:3];
    cell.identifier = tempIndexPath;

    NSLog(@"Index path: %i", (int)indexPath.row);
     
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    EntriesCell *referenceName = (EntriesCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"Record ID to delete: %d", referenceName.identifier);
    //Allows the user to swipe to delete
    if (editingStyle == UITableViewCellEditingStyleDelete && referenceName.identifier != 1) {
        int recordIDToDelete = referenceName.identifier;
        NSLog(@"Record ID to delete: %d", recordIDToDelete);
        
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
    else if (referenceName.identifier == 1){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Cannot delete the template (What if you forget what this is for?)" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}


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



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
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
        NSLog(@"Trying to pass into view");
        ViewReferenceController *viewReference = segue.destinationViewController;
        viewReference.delegate = self;
        EntriesCell *referenceSelected = (EntriesCell *)[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
        NSString *query = [NSString stringWithFormat:@"select * from allReferences where allReferences.referenceID = %i",referenceSelected.identifier];
        NSLog(@"Query in view: %@", query);
        NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
        NSLog(@"Results: %@", results);
        [viewReference setPhotoOrText: [[[results objectAtIndex:0] objectAtIndex:2] intValue] setContents:[[results objectAtIndex:0] objectAtIndex:1] setIdentifier: referenceSelected.identifier setName: [[results objectAtIndex:0] objectAtIndex:3]];
        
        
    }
    
    
}


/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
 

- (void)referenceSave:(AddReferenceController *) controller setContents:(NSString*) contents setImageOrText:(int) val setName:(NSString *)nm {
    NSString *addReferenceQuery = [NSString stringWithFormat:@"insert into allReferences values(null, '%@', '%d', '%@')", contents, val, nm];
    NSLog(@"%@", addReferenceQuery);
    [self.dbManager executeQuery:addReferenceQuery];
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
    }
    else{
        NSLog(@"Could not execute the query.");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    [self reloadData];
    
}

- (void)referenceCancel:(AddReferenceController *) controller{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)reloadData{
    NSString *query = [NSString stringWithFormat:@"select * from allReferences"];
    _allReferencesFromDB = [self.dbManager loadDataFromDB:query];
    [_referenceTable reloadData];
}


-(void)viewReferenceSave:(ViewReferenceController *)controller setContents:(NSString *)contents setImageOrText:(int)val setName:(NSString *)nm setID:(int)iden {
    
    NSString *editReferenceQuery = [NSString stringWithFormat:@"update allReferences set contents='%@', name='%@' where referenceID=%d", contents, nm, iden];
    [self.dbManager executeQuery:editReferenceQuery];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Reference Saved" message: @"" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    [self reloadData];
    
}



@end
