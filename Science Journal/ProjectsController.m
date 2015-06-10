//
//  ProjectsController.m
//  Science Journal
//
//  Created by Evan Teague on 6/5/15.
//  Copyright (c) 2015 Evan Teague. All rights reserved.
//

#import "ProjectsController.h"

@interface ProjectsController ()

@end

@implementation ProjectsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *documentsDirectory = [NSHomeDirectory()
                                    stringByAppendingPathComponent:@"Documents"];
    
    NSString *filePath = documentsDirectory;
    NSLog(@"%@", filePath);
    
    //Initialize the database connection
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"entriesdb.sql"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    
    NSString *delete1 = @"delete from projects";
    [self.dbManager executeQuery:delete1];
     NSString *delete2 = @"delete from entriesBasic";
     [self.dbManager executeQuery:delete2];
     
    
    
    [self loadData];
    
   
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self loadData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [_allProjectsFromDB count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *myIdentifier = @"ProjectCell";
    ProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier forIndexPath:indexPath];
    cell.projectLabel.text = [_allProjectsFromDB objectAtIndex:indexPath.row];
    
    return cell;
}


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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AddProject"]) {
        AddProjectController *addProject = segue.destinationViewController;
        addProject.delegate = self;
        [addProject setAddOrEdit:0 setOldProjectName:@""];
    }else if ([segue.identifier isEqualToString:@"ViewEntries"]){
        EntriesController *entriesListController = segue.destinationViewController;
        ProjectCell *projectToEdit = (ProjectCell *)[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
        [entriesListController setProjectName:projectToEdit.projectLabel.text];
    }else if ([segue.identifier isEqualToString:@"EditProjectName"]){
        AddProjectController *addProject = segue.destinationViewController;
        addProject.delegate = self;
        [addProject setAddOrEdit:1 setOldProjectName:oldProjectName];
    }
}

- (void)addProjectCancel:(AddProjectController *) controller{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)addProjectSave:(AddProjectController *)controller textToSave:(NSString *)pn addOrEdit:(int)val{
    if (val == 0){
        NSString *query = [NSString stringWithFormat:@"insert into projects values(null, '%@')", pn];
        [self.dbManager executeQuery:query];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        
        NSString *query = [NSString stringWithFormat:@"update projects set projectName='%@' where projectName='%@'", pn, oldProjectName];
        [self.dbManager executeQuery:query];
        
        NSString *allProjectEntries = [NSString stringWithFormat:@"select * from entriesBasic where projectName='%@'", oldProjectName];
        NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:allProjectEntries]];
        for (id entry in results){
            int tempID = [[entry objectAtIndex:0] intValue];
            NSLog(@"tempID: %d", tempID);
            NSString *updateEntryQuery = [NSString stringWithFormat:@"update entriesBasic set projectName='%@' where entriesID=%d", pn, tempID];
            [self.dbManager executeQuery:updateEntryQuery];
        }
        
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

-(void)loadData{
    NSString *query = [NSString stringWithFormat:@"select * from projects"];
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    _allProjectsFromDB = [[NSMutableArray alloc] init];
    for (id key in results){
        NSString *projectNm = [key objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"projectName"]];
        if (![_allProjectsFromDB containsObject:projectNm]){
            [_allProjectsFromDB addObject:projectNm];
        }
    }
    [self.tableView reloadData];
}


-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    _projectCellToDelete = (ProjectCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    //Allows the user to swipe to delete
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Edit or Delete the Project" message: @"Deleting this project will also delete all associated entries" delegate: self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", @"Edit Name", nil];
        [alert show];
        
        
    }
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button index: %ld", (long)buttonIndex);
    if(buttonIndex != [alertView cancelButtonIndex] && buttonIndex != 2)
    {
        
        NSString *getAllEntriesQuery = [NSString stringWithFormat:@"select * from entriesBasic where projectName='%@'", _projectCellToDelete.projectLabel.text];
        //NSLog(@"Query: %@", getAllEntriesQuery);
        NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:getAllEntriesQuery]];
        //NSLog(@"Entries%@", results);
        for (id key in results) {
            NSLog(@"Key: %@", key);
            int entryIDToDelete = [[key objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"entriesID"]] intValue];
            NSString *deletePictureSketchQuery = [NSString stringWithFormat:@"select * from entriesBasic where entriesID=%d", entryIDToDelete];
            NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:deletePictureSketchQuery]];
            NSString *pictureFilePath = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"picture"]];
            NSString *sketchFilePath = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"sketch"]];
            [[NSFileManager defaultManager] removeItemAtPath: pictureFilePath error: nil];
            [[NSFileManager defaultManager] removeItemAtPath: sketchFilePath error: nil];
            
            
        }
        
        NSString *query = [NSString stringWithFormat:@"delete from entriesBasic where projectName='%@'", _projectCellToDelete.projectLabel.text];
        
        [self.dbManager executeQuery:query];
        
        NSString *deleteProjectQuery = [NSString stringWithFormat:@"delete from projects where projectName='%@'", _projectCellToDelete.projectLabel.text];
        
        [self.dbManager executeQuery:deleteProjectQuery];
        
        [self loadData];
    }else if (buttonIndex == 2){
        
        oldProjectName =_projectCellToDelete.projectLabel.text;
        //NSString *query = [NSString stringWithFormat:@"select * from projects where projectName='%@'", _projectCellToDelete.projectLabel.text];
        //[self.dbManager executeQuery:query];
        [self performSegueWithIdentifier:@"EditProjectName" sender:self];
    }
         
    
}

-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"Edit";
}


@end
