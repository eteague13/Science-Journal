//
//  ViewReferenceController.m
//  Science Journal
//
//  Created by Evan Teague on 6/1/15.
//  Copyright (c) 2015 Evan Teague. All rights reserved.
//

#import "ViewReferenceController.h"

@interface ViewReferenceController ()

@end

@implementation ViewReferenceController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Sandcropped1.jpg"]];
    // Do any additional setup after loading the view.
    if (photoOrText == 0) {
        CGRect frame = CGRectMake(0, 120, 320, 370);
        imageView = [[UIImageView alloc] initWithFrame:frame];
        NSLog(@"Contents: %@", contents);
        imageView.image = [UIImage imageWithContentsOfFile:contents];
        [self.view addSubview:imageView];
        _referenceNameField.text = name;
        _editReferenceButton.enabled = NO;
        [_editReferenceButton removeFromSuperview];
        //If Text
    }else{
        CGRect frame = CGRectMake(0, 120, 320, 470);
        self.note = [[NoteView alloc] initWithFrame:frame];
        [self.view addSubview:_note];
        _note.delegate = self;
        _note.text = contents;
        [_note setScrollEnabled:YES];
        _referenceNameField.text = name;
        
    }
    
    _referenceNameField.delegate = self;
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


- (IBAction)editReference:(id)sender {
    [self.delegate viewReferenceSave:self setContents:_note.text setImageOrText:photoOrText setName:_referenceNameField.text];
}

-(void)setPhotoOrText: (int) val setContents:(NSString *) cont setIdentifier: (int) iden setName: (NSString *) nm {
    NSLog(@"Params: %i, %@, %i, %@",val, cont, iden, nm);
    photoOrText = val;
    contents = cont;
    referenceIDToEdit = iden;
    name = nm;
    
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
@end
