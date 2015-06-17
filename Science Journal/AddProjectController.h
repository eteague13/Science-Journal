//
//  AddProjectController.h
//  Science Journal
//
//  Created by Evan Teague on 6/8/15.
//  Copyright (c) 2015 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@class AddProjectController;
@protocol AddProjectControllerDelegate <NSObject>
- (void)addProjectCancel:(AddProjectController *) controller;
- (void)addProjectSave:(AddProjectController *)controller textToSave:(NSString *)pn addOrEdit:(int)val;
@end


@interface AddProjectController : UIViewController<UITextFieldDelegate> {
    int addOrEdit;
    NSString *oldProjectName;
}
//IBOutlets
@property (weak, nonatomic) IBOutlet UITextField *projectAddField;

//IBActions
- (IBAction)cancelAddProject:(id)sender;
- (IBAction)addProject:(id)sender;

//Variables
@property (nonatomic, weak) id <AddProjectControllerDelegate> delegate;
@property (nonatomic, strong) DBManager *dbManager;

//Methods
-(void)setAddOrEdit:(int)val setOldProjectName:(NSString *) pn;

@end
