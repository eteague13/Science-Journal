//
//  textEntryController.h
//  Science Journal
//
//  Created by Evan Teague on 12/24/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>

@class textEntryController;
@protocol textEntryControllerDelegate <NSObject>
- (void)textEntryControllerCancel:(textEntryController *) controller;
- (void)textEntryControllerSave:(textEntryController *)controller didSaveText:(NSString*) text rowSelected:(int)row;
@end
@interface textEntryController : UIViewController{
    int addEntryRowSelected;
    
}

@property (nonatomic, weak) id <textEntryControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *textEntryLabel;

- (IBAction)textCancelButton:(id)sender;
- (IBAction)textSaveButton:(id)sender;

- (void)updateRowSelected:(int)row;
@property (weak, nonatomic) IBOutlet UITextView *textField;


@end
