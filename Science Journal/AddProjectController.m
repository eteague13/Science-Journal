//
//  AddProjectController.m
//  Science Journal
//
//  Created by Evan Teague on 6/8/15.
//  Copyright (c) 2015 Evan Teague. All rights reserved.
//

#import "AddProjectController.h"

@implementation AddProjectController



- (void)viewDidLoad {
    [super viewDidLoad];
    _projectAddField.text = oldProjectName;
    _projectAddField.delegate = self;
    _projectAddField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    
    if (addOrEdit == 1){
        _projectLabel.title=@"Edit Project Name";
    }else{
        _projectLabel.title=@"Add Project Name";
    }
    //Initialize the database connection
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"FieldBookdb.sql"];
}
-(void)viewDidAppear:(BOOL)animated{
    [_projectAddField becomeFirstResponder];
}


//If the user selects cancel
- (IBAction)cancelAddProject:(id)sender {
    [self.delegate addProjectCancel:self];
}

//If the user adds a project
- (IBAction)addProject:(id)sender {
    NSString *query = @"select projectName from projects";
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSString *tempProjectName = _projectAddField.text;
    
    //Has to max sure that the project doesn't already exist
    BOOL projectExists = NO;
    for (id key in results){
        if ([[key objectAtIndex:0] isEqualToString:tempProjectName]){
            projectExists = YES;
            break;
        }
    }
    if (projectExists){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Project already exists" message: @"Enter a different project title or cancel" delegate: self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }else{
        [self.delegate addProjectSave:self textToSave: _projectAddField.text addOrEdit:addOrEdit];
    }

}

//Sets if the user is adding or editing a project
-(void)setAddOrEdit:(int)val setOldProjectName:(NSString *) pn{
    addOrEdit = val;
    oldProjectName = pn;
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    [aTextField resignFirstResponder];
    return YES;
}
@end
