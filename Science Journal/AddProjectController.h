//
//  AddProjectController.h
//  Science Journal
//
//  Created by Evan Teague on 6/8/15.
//  Copyright (c) 2015 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddProjectController;
@protocol AddProjectControllerDelegate <NSObject>
- (void)addProjectCancel:(AddProjectController *) controller;
- (void)addProjectSave:(AddProjectController *)controller textToSave:(NSString *)pn;
@end


@interface AddProjectController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *projectAddField;
@property (nonatomic, weak) id <AddProjectControllerDelegate> delegate;
- (IBAction)cancelAddProject:(id)sender;
- (IBAction)addProject:(id)sender;

@end
