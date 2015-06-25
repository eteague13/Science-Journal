//
//  textEntryController.m
//  Science Journal
//
//  Created by Evan Teague on 12/24/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//http://www.appcoda.com/customize-navigation-status-bar-ios-7/

#import "textEntryController.h"

@interface textEntryController ()

@end

@implementation textEntryController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Write the correct title
    if ([cellSelected isEqualToString:@"GoalID"]){
        _textEntryLabel.title = @"Goal";
    }else if ([cellSelected isEqualToString:@"NotesID"]){
        _textEntryLabel.title = @"Notes";
    }else if ([cellSelected isEqualToString:@"PermissionsID"]){
        _textEntryLabel.title = @"Permissions & Access";
    }else if ([cellSelected isEqualToString:@"PartnersID"]){
        _textEntryLabel.title = @"Partners";
    }else if ([cellSelected isEqualToString:@"OutcropID"]){
        _textEntryLabel.title = @"Outcrop Description";
    }else if ([cellSelected isEqualToString:@"StructuralDataID"]){
        _textEntryLabel.title = @"Structural Data";
    }
    
    
    //Draws the text view
    CGRect frame = CGRectMake(0, 30, 320, 500);
    self.note = [[NoteView alloc] initWithFrame:frame];
    if ([textArea length] != 0){
        _note.text = textArea;
    }
    _note.delegate = self;
    [_note setScrollEnabled:YES];
    [self.view addSubview:_note];
    [_note becomeFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//If the user selects cancel
- (IBAction)textCancelButton:(id)sender {
    [self.delegate textEntryControllerCancel:self];
}

//If the user selects save
- (IBAction)textSaveButton:(id)sender {
    
    [self.delegate textEntryControllerSave:self didSaveText:_note.text cellSelected:cellSelected];
}

//Has to pass the cell name so we can set the text entry title correctly
- (void)updateCellSelected:(NSString *)cellID {
    cellSelected = cellID;
}


//Passes in the text to be loaded
- (void)setTextValue:(NSString*)text{
    textArea = text;
}

//Sets the scrollview
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_note setNeedsDisplay];
}

//If the user is editing the textview
- (void)textViewDidBeginEditing:(UITextView *)textView {
    CGRect frame = CGRectMake(0, 30, 320, 500);
    _note.frame = frame;
}

//If the user is done editng the text view
- (void)textViewDidEndEditing:(UITextView *)textView {
    CGRect frame = CGRectMake(0, 30, 320, 500);
    _note.frame = frame;
}

@end
