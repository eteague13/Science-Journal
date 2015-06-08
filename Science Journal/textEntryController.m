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
    NSLog(@"Section: %d", addEntrySectionSelected);
    //Write the correct title
    switch (addEntryRowSelected) {
        case 4:
            _textEntryLabel.text = @"Goal";
            break;
        case 7:
            _textEntryLabel.text = @"Notes";
            break;
        case 8:
            _textEntryLabel.text = @"Permissions and Access";
            break;
        case 10:
            _textEntryLabel.text = @"Partners";
        case 14:
            _textEntryLabel.text = @"Outcrop Description";
            break;
        case 15:
            _textEntryLabel.text = @"Structural Data";
        default:
            break;
        
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
    
    [self.delegate textEntryControllerSave:self didSaveText:_note.text rowSelected:(int)addEntryRowSelected sectionSelected:(int)addEntrySectionSelected];
}

- (void)updateRowSelected:(int)row {
    addEntryRowSelected = row;
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
