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
    if (addEntrySectionSelected == 0){
        switch (addEntryRowSelected) {
            case 3:
                _textEntryLabel.text = @"Goal";
                break;
            case 7:
                _textEntryLabel.text = @"Notes";
                break;
            case 8:
                _textEntryLabel.text = @"Permissions and Access";
                break;
            default:
                NSLog(@"Default");
                break;
        }
    }else if (addEntrySectionSelected == 1){
        switch (addEntryRowSelected) {
            case 2:
                _textEntryLabel.text = @"Outcrop Description";
                break;
            case 3:
                _textEntryLabel.text = @"Structural Data";
            default:
                break;
        }
    }
    NSLog(@"Row: %d", addEntryRowSelected);
    if ([textArea length] != 0){
        _textField.text = textArea;
    }
    
    // Do any additional setup after loading the view.
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
    NSLog(@"%@", _textEntryLabel.text);
    [self.delegate textEntryControllerCancel:self];
}

- (IBAction)textSaveButton:(id)sender {
    [self.delegate textEntryControllerSave:self didSaveText:_textField.text rowSelected:(int)addEntryRowSelected sectionSelected:(int)addEntrySectionSelected];
}

- (void)updateRowSelected:(int)row updateSectionSelected:(int)section {
    addEntryRowSelected = row;
    addEntrySectionSelected = section;
}

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}

- (void)setTextValue:(NSString*)text{
    textArea = text;
}
@end
