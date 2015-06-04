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

    //self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Sandcropped1.jpg"]];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Sandcropped1.jpg"]];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"referencesdb.sql"];
    NSString *documentsDirectory = [NSHomeDirectory()
                                    stringByAppendingPathComponent:@"Documents"];
    
    
    NSString *filePath = documentsDirectory;
    
    NSString *aboutExample = [filePath stringByAppendingString:@"/Users/evanteague/Pictures/test poop.jpg"];
    NSString *addReferenceQuery = [NSString stringWithFormat:@"insert into allReferences values(null, '%@', '%d', '%s')",aboutExample, 0, "About References"];
    /*
    NSString *delete1 = @"delete from allReferences";
    [self.dbManager executeQuery:delete1];
    */
    
    NSLog(@"In the references load");
    [self.dbManager loadDataFromDB:addReferenceQuery];
     
    
     NSString *query = [NSString stringWithFormat:@"select * from allReferences"];
    _allReferencesFromDB = [self.dbManager loadDataFromDB:query];
    NSLog(@"%lu", (unsigned long)[_allReferencesFromDB count]);
    
    [self.tableView setSeparatorColor:[UIColor blackColor]];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
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
    int tempIndexPath = indexPath.row + 1;
    NSString *query = [NSString stringWithFormat:@"select * from allReferences where allReferences.referenceID = %i",tempIndexPath];
    NSLog(@"Query in index path: %@", query);
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSLog(@"Item: %@", results);
    NSLog(@"Problem?: %@", [[results objectAtIndex:0] objectAtIndex:3]);
    cell.entryNameLabel.text = [[results objectAtIndex:0] objectAtIndex:3];
    cell.identifier = tempIndexPath;
    //cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Sandcropped1.jpg"]];
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow.png"]];
    cell.accessoryView = arrow;
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
    EntriesCell *referenceName = [self.tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"Record ID to delete: %d", referenceName.identifier);
    //Allows the user to swipe to delete
    if (editingStyle == UITableViewCellEditingStyleDelete) {
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
        AddReferenceController *addReference = segue.destinationViewController;
        addReference.delegate = self;
        [addReference setPhotoOrText:1];
    }else if ([segue.identifier isEqualToString:@"addReferencePhoto"]) {
        AddReferenceController *addReference = segue.destinationViewController;
        addReference.delegate = self;
        [addReference setPhotoOrText:0];
    }else if ([segue.identifier isEqualToString:@"viewReferenceCell"]){
        NSLog(@"Trying to pass into view");
        ViewReferenceController *viewReference = segue.destinationViewController;
        viewReference.delegate = self;
        EntriesCell *referenceSelected = [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
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



@end
