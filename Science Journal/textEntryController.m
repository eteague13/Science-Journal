//
//  textEntryController.m
//  Science Journal
//
//  Created by Evan Teague on 12/24/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import "textEntryController.h"

@interface textEntryController ()

@end

@implementation textEntryController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Write the correct title
    
    if ([cellSelected isEqualToString:@"GoalID"]){
        _textEntryLabel.text = @"Goal";
    }else if ([cellSelected isEqualToString:@"NotesID"]){
        _textEntryLabel.text = @"Notes";
    }else if ([cellSelected isEqualToString:@"PermissionsID"]){
        _textEntryLabel.text = @"Permissions and Access";
    }else if ([cellSelected isEqualToString:@"PartnersID"]){
        _textEntryLabel.text = @"Partners";
    }else if ([cellSelected isEqualToString:@"OutcropID"]){
        _textEntryLabel.text = @"Outcrop Description";
    }else if ([cellSelected isEqualToString:@"StructuralDataID"]){
        _textEntryLabel.text = @"Structural Data";
    }
    
    
    
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Sandcropped1.jpg"]];
    
    //Draws the text view
    CGRect frame = CGRectMake(0, 94, 320, 474);
    self.note = [[NoteView alloc] initWithFrame:frame];
    if ([textArea length] != 0){
        _note.text = textArea;
    }
    _note.delegate = self;
    [_note setScrollEnabled:YES];
    [self.view addSubview:_note];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)textCancelButton:(id)sender {
    [self.delegate textEntryControllerCancel:self];
}

- (IBAction)textSaveButton:(id)sender {
    
    [self.delegate textEntryControllerSave:self didSaveText:_note.text cellSelected:cellSelected];
}

- (void)updateCellSelected:(NSString *)cellID {
    cellSelected = cellID;
}



- (void)setTextValue:(NSString*)text{
    textArea = text;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_note setNeedsDisplay];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    CGRect frame = CGRectMake(0, 94, 320, 474);
    _note.frame = frame;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    CGRect frame = CGRectMake(0, 94, 320, 474);
    _note.frame = frame;
}

@end
