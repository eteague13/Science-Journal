//
//  AddProjectController.m
//  Science Journal
//
//  Created by Evan Teague on 6/8/15.
//  Copyright (c) 2015 Evan Teague. All rights reserved.
//

#import "AddProjectController.h"

@implementation AddProjectController

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    _projectAddField.text = oldProjectName;
    _projectAddField.delegate = self;
    _projectAddField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    
    //Initialize the database connection
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"entriesdb.sql"];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    [_projectAddField becomeFirstResponder];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)cancelAddProject:(id)sender {
    [self.delegate addProjectCancel:self];
}

- (IBAction)addProject:(id)sender {
    NSString *query = @"select projectName from projects";
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSString *tempProjectName = _projectAddField.text;
    
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)setAddOrEdit:(int)val setOldProjectName:(NSString *) pn{
    addOrEdit = val;
    oldProjectName = pn;
}
@end
