//
//  ProjectsController.m
//  Science Journal
//
//  Created by Evan Teague on 6/5/15.
//  Copyright (c) 2015 Evan Teague. All rights reserved.
//  Info on Dropbox metadata http://pigtailsoft.com/blog/?p=166

#import "ProjectsController.h"


@interface ProjectsController ()

@end

@implementation ProjectsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*Internal testing code to print out the location of the app's documents directory
    NSString *documentsDirectory = [NSHomeDirectory()
                                    stringByAppendingPathComponent:@"Documents"];
    
    NSString *filePath = documentsDirectory;
    NSLog(@"%@", filePath);
    */
    NSString *documentsDirectory = [NSHomeDirectory()
                                    stringByAppendingPathComponent:@"Documents"];
    
    NSString *filePath = documentsDirectory;
    NSLog(@"%@", filePath);
    //Initialize the database connection
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"FieldBookdb.sql"];
    
    
    /* Internal testing code to delete all info from the database
    NSString *delete1 = @"delete from projects";
    [self.dbManager executeQuery:delete1];
     NSString *delete2 = @"delete from entriesBasic";
     [self.dbManager executeQuery:delete2];
    NSString *delete3 = @"delete from allReferences";
    [self.dbManager executeQuery:delete3];
    NSString *delete4 = @"delete from projectSettings";
    [self.dbManager executeQuery:delete4];
    */
    //Sets the navigation bar items
    _addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addProjectSegue)];
    _exportItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(selectExportOption)];
    _cancelExport = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelSelection)];
    _finishedSelection = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishExporting)];
    
    NSArray *rightButtonItems = @[_addItem];
    self.navigationItem.rightBarButtonItems = rightButtonItems;
    NSArray *leftButtonItems = @[_exportItem];
    self.navigationItem.leftBarButtonItems = leftButtonItems;
    
    //Enables multiple selection
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.selectedProjectsToExport = [[NSMutableArray alloc] init];
    
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;
    
    [self loadData];
    
    _dropboxFilesToUpload = [[NSMutableArray alloc] init];
    
    
    
}

//Dropbox code...leaving it here otherwise it may not work. Not sure why
-(void)viewDidAppear:(BOOL)animated{
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;
    
}

//If the user cancels exporting
-(void)cancelSelection{
    self.navigationItem.rightBarButtonItem = self.addItem;
    self.navigationItem.leftBarButtonItem = self.exportItem;
    [self.tableView setEditing:NO animated:YES];
    
}
//If the user selects "done" exporting
-(void)finishExporting{
    self.navigationItem.rightBarButtonItem = self.addItem;
    self.navigationItem.leftBarButtonItem = self.exportItem;
    [self.tableView setEditing:NO animated:YES];
    //Exports the selected projects
    ExportController *exporter = [[ExportController alloc] init];
    [exporter exportSelectedProjects:_selectedProjectsToExport];
    //If the user selects no projects, it gives an error. Otherwise, opens the mail controller
    if ([_selectedProjectsToExport count] == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Export Error" message: @"No project selected" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }else{
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        NSString *mimeType = @"application/vnd.google-earth.kml+xml";
        for (id project in _selectedProjectsToExport){
            //ProjectCell *cell = project;
            //NSString *projectNm = cell.projectLabel.text;
            NSString *projectNm = project;
            NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            NSString *fileName = [NSMutableString stringWithFormat:@"%@.kml", projectNm];
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
            
            NSData *fileData = [NSData dataWithContentsOfFile:filePath];
            
            // Add attachment
            [mc addAttachmentData:fileData mimeType:mimeType fileName:fileName];
        
            // Present mail view controller on screen
            [self presentViewController:mc animated:YES completion:NULL];
        }
        
    }
    
}


- (void)viewWillAppear:(BOOL)animated{
    [self loadData];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//Gets the number of projects
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [_allProjectsFromDB count];
}

//Creates the projec cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *myIdentifier = @"ProjectCell";
    ProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier forIndexPath:indexPath];
    cell.projectLabel.text = [_allProjectsFromDB objectAtIndex:indexPath.row];
    cell.layoutMargins = UIEdgeInsetsZero;
    return cell;
}



//When the user is selecting multiple projects to export, adds it to an array
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.isEditing)
    {
        ProjectCell *projectToEdit = (ProjectCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        NSString *projectToExport = projectToEdit.projectLabel.text;
        if ([self.selectedProjectsToExport containsObject:projectToExport])
        {
        }
        else
        {
            [self.selectedProjectsToExport addObject:projectToExport];
        }

        
    }else{
        [self performSegueWithIdentifier:@"ViewEntries" sender:self];
    }
}

//When the user is deselecting multiple projects to export, removes it from the array
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.isEditing) {
        ProjectCell *projectToEdit = (ProjectCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        NSString *projectToExport = projectToEdit.projectLabel.text;
        if ([self.selectedProjectsToExport containsObject:projectToExport])
        {
            [self.selectedProjectsToExport removeObject:projectToExport];
        }

    }
    
}



// Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AddProject"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        AddProjectController *addProject = [navigationController viewControllers][0];
        addProject.delegate = self;
        [addProject setAddOrEdit:0 setOldProjectName:@""];
    }else if ([segue.identifier isEqualToString:@"ViewEntries"]){
        EntriesController *entriesListController = segue.destinationViewController;
        ProjectCell *projectToEdit = (ProjectCell *)[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
        [entriesListController setProjectName:projectToEdit.projectLabel.text];
    }else if ([segue.identifier isEqualToString:@"EditProjectName"]){
        UINavigationController *navigationController = segue.destinationViewController;
        AddProjectController *addProject = [navigationController viewControllers][0];
        addProject.delegate = self;
        [addProject setAddOrEdit:1 setOldProjectName:oldProjectName];
    }
}

//If the user selects cancel
- (void)addProjectCancel:(AddProjectController *) controller{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
//If the user saves the project
- (void)addProjectSave:(AddProjectController *)controller textToSave:(NSString *)pn addOrEdit:(int)val{
    //If it's a new project
    if (val == 0){
        NSString *query = [NSString stringWithFormat:@"insert into projects values(null, '%@')", pn];
        [self.dbManager executeQuery:query];
        NSString *addSettingsQuery = [NSString stringWithFormat:@"insert into projectSettings values(null, '%@', '%d', '%d','%d', '%d', '%d','%d', '%d', '%d','%d', '%d', '%d', '%d', '%d', '%d', '%d')",pn,1,0,1,1,1,1,0,1,0,0,1,0,0,1,0];
        [self.dbManager executeQuery:addSettingsQuery];
        [self dismissViewControllerAnimated:YES completion:nil];
    //If it's an existing project
    }else {
        NSString *query = [NSString stringWithFormat:@"update projects set projectName='%@' where projectName='%@'", pn, oldProjectName];
        [self.dbManager executeQuery:query];
        
        NSString *allProjectEntries = [NSString stringWithFormat:@"select * from entriesBasic where projectName='%@'", oldProjectName];
        NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:allProjectEntries]];
        for (id entry in results){
            int tempID = [[entry objectAtIndex:0] intValue];
            NSString *updateEntryQuery = [NSString stringWithFormat:@"update entriesBasic set projectName='%@' where entriesID=%d", pn, tempID];
            [self.dbManager executeQuery:updateEntryQuery];
        }
        
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

//Loads the projects
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

//If the user wants to edit or delete a project
-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    _projectCellToDelete = (ProjectCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    //Allows the user to swipe to delete
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Delete or rename the Project" message: @"" delegate: self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", @"Edit Name", nil];
        [alert show];
        [alert setTag:1];
        
    }
    
}

//Need to double check when the user is deleting a project
-(void)doubleCheckCancel{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Are you sure you want to delete?" message: @"Deleting this project will also delete all associated entries" delegate: self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    [alert show];
    [alert setTag:2];
}

//What happens when the user selects an option from an alert view
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //If the user really wants to delete a project
    if (alertView.tag == 1){
        if(buttonIndex != [alertView cancelButtonIndex] && buttonIndex != 2)
        {
            [self doubleCheckCancel];
        //If the user wants to edit a project name
        }else if (buttonIndex == 2){
        
            oldProjectName =_projectCellToDelete.projectLabel.text;
            [self performSegueWithIdentifier:@"EditProjectName" sender:self];
        }
    //If a user does delete a project. Need to delete .kml, .pdf, the project, the entries, and the images
    }else if (alertView.tag == 2){
        if (buttonIndex == 1) {
            NSString *getAllEntriesQuery = [NSString stringWithFormat:@"select * from entriesBasic where projectName='%@'", _projectCellToDelete.projectLabel.text];
            NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:getAllEntriesQuery]];
            for (id key in results) {
                int entryIDToDelete = [[key objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"entriesID"]] intValue];
                NSString *documentsDirectory = [NSHomeDirectory()
                                                stringByAppendingPathComponent:@"Documents"];
                NSString *deletePictureSketchQuery = [NSString stringWithFormat:@"select * from entriesBasic where entriesID=%d", entryIDToDelete];
                NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:deletePictureSketchQuery]];
                NSString *pictureName = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames     indexOfObject:@"picture"]];
                NSString *pictureFilePath = [documentsDirectory stringByAppendingPathComponent:pictureName];
                NSString *sketchName = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"sketch"]];
                NSString *sketchFilePath = [documentsDirectory stringByAppendingPathComponent:sketchName];
                [[NSFileManager defaultManager] removeItemAtPath: pictureFilePath error: nil];
                [[NSFileManager defaultManager] removeItemAtPath: sketchFilePath error: nil];

            }
        
            NSString *query = [NSString stringWithFormat:@"delete from entriesBasic where projectName='%@'", _projectCellToDelete.projectLabel.text];
        
            [self.dbManager executeQuery:query];
            
            NSString *deleteProjectQuery = [NSString stringWithFormat:@"delete from projects where projectName='%@'", _projectCellToDelete.projectLabel.text];
        
            [self.dbManager executeQuery:deleteProjectQuery];
            
            NSString *deleteProjectSettingsQuery = [NSString stringWithFormat:@"delete from projectSettings where projectName='%@'", _projectCellToDelete.projectLabel.text];
            [self.dbManager executeQuery:deleteProjectSettingsQuery];
            
            NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            NSString *fileName = [NSMutableString stringWithFormat:@"%@.kml", _projectCellToDelete.projectLabel.text];
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
            [[NSFileManager defaultManager] removeItemAtPath: filePath error: nil];
            
            NSString *pdfName = [NSMutableString stringWithFormat:@"%@.pdf", _projectCellToDelete.projectLabel.text];
            NSString *pdfPath = [documentsDirectory stringByAppendingPathComponent:pdfName];
            [[NSFileManager defaultManager] removeItemAtPath: pdfPath error: nil];
        
            [self loadData];
        }
    }
    
    
}

//Changes the swipe option label
-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"Edit";
}

//What happens when the user selects the add project button
-(void)addProjectSegue{
    [self performSegueWithIdentifier:@"AddProject" sender:self];
    
}

//The export menu
-(void)selectExportOption{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Export:"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"E-mail All Projects (.kml)", @"E-mail Selected Projects (.kml)", @"Export to Dropbox (.kml & .pdf)", nil];
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
}

//Export multiple projects option changes the navigation items
-(void)exportMultipleProjects{
    
    self.navigationItem.rightBarButtonItem = self.cancelExport;
    self.navigationItem.leftBarButtonItem = self.finishedSelection;
    [self.tableView setEditing:YES animated:YES];
}

//What happens when the user selects which export option
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1){
        switch(buttonIndex)
        {
            case 0:
                [self exportAllProjects];
                break;
            case 1:
                [self exportMultipleProjects];
                break;
            case 2:
                [self syncDropbox];
                break;
            
        }
    }
    
}

//Exports all of the projects to .kml
-(void)exportAllProjects {
    ExportController *exporter = [[ExportController alloc] init];
    NSString *projectQuery = @"select projectName from projects";
    NSArray *allProjects = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:projectQuery]];
    //Need to convert the array to mutablearray
    NSMutableArray *results = [[NSMutableArray alloc] init];
    for (id key in allProjects){
        [results addObject:[key objectAtIndex:0]];
    }
    [exporter exportSelectedProjects:results];
    if ([results count] > 0){
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        for (id project in results){
            NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            NSString *fileName = [NSMutableString stringWithFormat:@"%@.kml", project];
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];

            
            NSData *fileData = [NSData dataWithContentsOfFile:filePath];
            NSString *mimeType = @"application/vnd.google-earth.kml+xml";
            // Add attachment
            [mc addAttachmentData:fileData mimeType:mimeType fileName:fileName];
            // Present mail view controller on screen
            [self presentViewController:mc animated:YES completion:NULL];
        }
    
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Export Error" message: @"No entries to export" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
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

//Syncs dropbox
- (void) syncDropbox {

    if (![[DBSession sharedSession] isLinked]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"No Dropbox Account Linked" message: @"Go to App > Settings to link your account" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }else{
        ExportController *exporter = [[ExportController alloc] init];
        NSString *projectQuery = @"select projectName from projects";
        NSArray *allProjects = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:projectQuery]];
        NSMutableArray *results = [[NSMutableArray alloc] init];
        for (id key in allProjects){
            [results addObject:[key objectAtIndex:0]];
        }
        //Exports everything to .kml
        [exporter exportSelectedProjects:results];
        
        //Exports everything to .pdf
        [exporter exportAllToPDF];
        
        //metadataContents = [[NSArray alloc] init];
        
        //Goes through the app's documents directory and exports .png, .kml, and .pdf files
        NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:localDir error:nil];
        //NSLog(@"Files: %@", files);
        for (int i = 0; i < [files count]; i++){
            if ([[files objectAtIndex:i] rangeOfString:@".png"].location != NSNotFound || [[files objectAtIndex:i] rangeOfString:@".kml"].location != NSNotFound || [[files objectAtIndex:i] rangeOfString:@".pdf"].location != NSNotFound){

                [_dropboxFilesToUpload addObject:[files objectAtIndex:i]];
                
            }else{
                NSLog(@"File: %@ isn't a pic, kml, or pdf", [files objectAtIndex:i]);
            }
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"All projects exported to Dropbox" message: @"" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [self.restClient loadMetadata:@"/"];
    }
 
    
    
}



//Dropbox delegate methods
- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
    NSLog(@"File uploaded successfully to path: %@, %@", metadata.path, metadata.rev);
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
    NSLog(@"File upload failed with error: %@", error);
}

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    
    //If I'm passing in the home directory
    if (metadata.isDirectory) {
        NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        
        //For each file to upload
        for (NSString *fileName in _dropboxFilesToUpload){
            bool doesExist = NO;
            //For each file in dropbox already
            for (DBMetadata *file in metadata.contents){
                //If the file in dropbox matches the one to upload, upload with a revision
                if ([file.filename isEqualToString:fileName]){
                    /*
                    NSString *projectNameSegment;
                    if ([file.filename rangeOfString:@".png"].location != NSNotFound){
                        projectNameSegment = [NSString stringWithFormat:@"/%@",[file.filename substringToIndex:1]];
                        NSLog(@"name segment: %@", projectNameSegment);
                    }else{
                        int projectTitleLength = [file.filename length] - 4;
                        projectNameSegment = [NSString stringWithFormat:@"/%@",[file.filename substringToIndex:projectTitleLength]];
                        NSLog(@"name segment: %@", projectNameSegment);
                    }
                     */
                    NSString *filePath = [localDir stringByAppendingPathComponent:fileName];
                    [[self restClient] uploadFile:file.filename toPath:@"/" withParentRev:file.rev fromPath:filePath];
                    doesExist = YES;
                    break;
                }
            }
            //If it didn't match any file in dropbox already, upload it as a new file
            if (!doesExist){
                /*
                NSString *projectNameSegment;
                if ([fileName rangeOfString:@".png"].location != NSNotFound){
                    projectNameSegment = [NSString stringWithFormat:@"/",[fileName substringToIndex:1]];
                    NSLog(@"name segment: %@", projectNameSegment);
                }else{
                    int projectTitleLength = [fileName length] - 4;
                    projectNameSegment = [NSString stringWithFormat:@"/",[fileName substringToIndex:projectTitleLength]];
                    NSLog(@"name segment: %@", projectNameSegment);
                }
                 */
                //[[self restClient] createFolder:projectNameSegment];
                
                NSString *filePath = [localDir stringByAppendingPathComponent:fileName];
                [[self restClient] uploadFile:fileName toPath:@"/" withParentRev:nil fromPath:filePath];
            }
        }
    
    }
}

- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
    NSLog(@"Error metadata: %@", error);
    //[self uploadFile:nil];
}



@end
