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
     */
    
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
        NSLog(@"TRYing to segue in add project");
        AddProjectController *addProject = segue.destinationViewController;
        addProject.delegate = self;
        
    }else if ([segue.identifier isEqualToString:@"ViewEntries"]){
        UINavigationController *navigationController = segue.destinationViewController;
        EntriesController *entriesListController = segue.destinationViewController;
        ProjectCell *projectToEdit = [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
        NSLog(@"Trying to segue: %@", projectToEdit.projectLabel.text);
        [entriesListController setProjectName:projectToEdit.projectLabel.text];
    }
}

- (void)addProjectCancel:(AddProjectController *) controller{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)addProjectSave:(AddProjectController *)controller textToSave:(NSString *)pn{
    NSString *query = [NSString stringWithFormat:@"insert into projects values(null, '%@')", pn];
    [self.dbManager executeQuery:query];
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
    NSLog(@"%@", _allProjectsFromDB);
    [self.tableView reloadData];
}



@end
