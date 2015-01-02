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
    
    switch (addEntryRowSelected) {
        case 3:
            _textEntryLabel.text = @"Goal";
            break;
        case 7:
            _textEntryLabel.text = @"Notes";
            break;
        case 8:
            _textEntryLabel.text = @"Permissions and Access";
        default:
            NSLog(@"Default");
            break;
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
    [self.delegate textEntryControllerSave:self didSaveText:_textField.text rowSelected:(int)addEntryRowSelected];
}

- (void)updateRowSelected:(int)row {
    addEntryRowSelected = row;
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
@end
