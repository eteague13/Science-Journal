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
    
    /*
    NSString *delete1 = @"delete from projects";
    [self.dbManager executeQuery:delete1];
     NSString *delete2 = @"delete from entriesBasic";
     [self.dbManager executeQuery:delete2];
    */
    
    
    
    _addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addProjectSegue)];
    _exportItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(selectExportOption)];
    _cancelExport = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelSelection)];
    _finishedSelection = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishExporting)];
    
    NSArray *rightButtonItems = @[_addItem];
    self.navigationItem.rightBarButtonItems = rightButtonItems;
    NSArray *leftButtonItems = @[_exportItem];
    self.navigationItem.leftBarButtonItems = leftButtonItems;
    
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.selectedProjectsToExport = [[NSMutableArray alloc] init];
    
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;
    
    [self loadData];
    
}

-(void)cancelSelection{
    self.navigationItem.rightBarButtonItem = self.addItem;
    self.navigationItem.leftBarButtonItem = self.exportItem;
    [self.tableView setEditing:NO animated:YES];
    
}

-(void)finishExporting{
    self.navigationItem.rightBarButtonItem = self.addItem;
    self.navigationItem.leftBarButtonItem = self.exportItem;
    [self.tableView setEditing:NO animated:YES];
    ExportController *exporter = [[ExportController alloc] init];
   
    [exporter exportSelectedProjects:_selectedProjectsToExport];
    if ([_selectedProjectsToExport count] == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Export Error" message: @"No project selected" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }else{
        NSString *documentsDirectory = [NSHomeDirectory()
                                        stringByAppendingPathComponent:@"Documents"];
        NSString *fileName = [NSMutableString stringWithFormat:@"Selected Projects.kml"];
        NSString *filePath = [documentsDirectory
                              stringByAppendingPathComponent:fileName];

        NSLog(@"%@", filePath);
        //Email the entry
        //Doesn't work on the simulator, but should on phone
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        // Determine the MIME type
        //NSString *mimeType = @"text/plain";
        //NSString *mimeType = @"application/vnd.google-earth.kmz";
        //This one may be the one that works...have to wait and see
        NSString *mimeType = @"application/vnd.google-earth.kml+xml";
        // Add attachment
        [mc addAttachmentData:fileData mimeType:mimeType fileName:fileName];
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
        
    }
    
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




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.isEditing)
    {
        ProjectCell *projectToEdit = (ProjectCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if ([self.selectedProjectsToExport containsObject:projectToEdit])
        {
        }
        else
        {
            [self.selectedProjectsToExport addObject:projectToEdit];
        }

        
    }else{
        [self performSegueWithIdentifier:@"ViewEntries" sender:self];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.isEditing) {
        ProjectCell *projectToEdit = (ProjectCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if ([self.selectedProjectsToExport containsObject:projectToEdit])
        {
            [self.selectedProjectsToExport removeObject:projectToEdit];
        }

    }
    
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
        NSString *addSettingsQuery = [NSString stringWithFormat:@"insert into projectSettings values(null, '%@', '%d', '%d','%d', '%d', '%d','%d', '%d', '%d','%d', '%d', '%d', '%d', '%d', '%d', '%d')",pn,1,0,1,1,1,1,0,1,0,0,1,0,0,1,0];
        [self.dbManager executeQuery:addSettingsQuery];
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
        
        NSString *deleteProjectSettingsQuery = [NSString stringWithFormat:@"delete from projectSettings where projectName='%@'", _projectCellToDelete.projectLabel.text];
        [self.dbManager executeQuery:deleteProjectSettingsQuery];
        
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

-(void)addProjectSegue{
    [self performSegueWithIdentifier:@"AddProject" sender:self];
    
}

-(void)selectExportOption{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Export:"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Export All projects", @"Export Selected Projects", @"Sync Dropbox", nil];
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
}

-(void)exportMultipleProjects{
    
    self.navigationItem.rightBarButtonItem = self.cancelExport;
    self.navigationItem.leftBarButtonItem = self.finishedSelection;
    [self.tableView setEditing:YES animated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //Sets the colors based on what the user selects
    ExportController *exporter = [[ExportController alloc] init];
    if (actionSheet.tag == 1){
        switch(buttonIndex)
        {
            case 0:
                [self exportAllProjects];
                break;
            case 1:
                NSLog(@"Export Selected Projects");
                [self exportMultipleProjects];
                break;
            case 2:
                [self syncDropbox];
                NSLog(@"Sync dropbox");
                break;
            
        }
    }
    
}

-(void)exportAllProjects {
    ExportController *exporter = [[ExportController alloc] init];
    NSString *query = @"select * from projects";
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    if ([results count] > 0){
        NSString *documentsDirectory = [NSHomeDirectory()
                                        stringByAppendingPathComponent:@"Documents"];
        NSString *fileName = [NSMutableString stringWithFormat:@"All Entries.kml"];
        NSString *filePath = [documentsDirectory
                              stringByAppendingPathComponent:fileName];
        
        
        NSLog(@"%@", filePath);
        //Email the entry
        //Doesn't work on the simulator, but should on phone
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        // Determine the MIME type
        //NSString *mimeType = @"text/plain";
        //This one may be the one that works...have to wait and see
        NSString *mimeType = @"application/vnd.google-earth.kml+xml";
        // Add attachment
        [mc addAttachmentData:fileData mimeType:mimeType fileName:fileName];
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Export Error" message: @"No entries to export" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    [exporter exportAllProjects];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    //Mail results
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) syncDropbox {

     NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
     NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:localDir error:nil];
     
     for (int i = 0; i < [files count]; i++){
         if ([[files objectAtIndex:i] rangeOfString:@".png"].location != NSNotFound){
             localPath = [localDir stringByAppendingPathComponent:[files objectAtIndex:i]];
             filename = [files objectAtIndex:i];
             NSLog(@"File is a pic: %@", localPath);
             [self.restClient loadMetadata:[NSString stringWithFormat:@"/%@", localPath]];
     
         }else{
             NSLog(@"File: %@ isn't a pic", [files objectAtIndex:i]);
         }
     }
}

- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
    NSLog(@"File upload failed with error: %@", error);
}

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    NSLog(@"in loaded metadata: %@", metadata.filename);
    [self uploadFile:metadata];
    
}

- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
    [self uploadFile:nil];
}

-(void)uploadFile: (DBMetadata*)meta {
    [self.restClient uploadFile:filename toPath:@"/" withParentRev:meta.rev fromPath:localPath];
}

@end
