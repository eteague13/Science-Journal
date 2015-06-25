//
//  textEntryController.h
//  Science Journal
//
//  Created by Evan Teague on 12/24/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteView.h"

//Delegate
@class textEntryController;
@protocol textEntryControllerDelegate <NSObject>
- (void)textEntryControllerCancel:(textEntryController *) controller;
- (void)textEntryControllerSave:(textEntryController *)controller didSaveText:(NSString*)text cellSelected:(NSString *)cellID;
@end

@interface textEntryController : UIViewController<UITextViewDelegate>{
    NSString *cellSelected;
    NSString *textArea;
    
}

//IBOutlets
@property (weak, nonatomic) IBOutlet UITextView *textField;
@property (weak, nonatomic) IBOutlet UINavigationItem *textEntryLabel;

//IBActions
- (IBAction)textCancelButton:(id)sender;
- (IBAction)textSaveButton:(id)sender;

//Variables
@property (nonatomic, weak) id <textEntryControllerDelegate> delegate;
@property (nonatomic, retain) NoteView *note;

//Methods
- (void)updateCellSelected:(NSString*)cellID;
- (void)setTextValue:(NSString*)text;



@end
