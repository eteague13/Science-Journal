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
        if (referenceIDToEdit == 1){
            imageView.image = [UIImage imageNamed:@"About-Adding-Resources-Final.png"];
            _referenceNameField.enabled = NO;
            _editReferenceButton.enabled = NO;
            _changeImageButton.enabled = NO;
            [_changeImageButton removeFromSuperview];
        }else{
            imageView.image = [UIImage imageWithContentsOfFile:contents];
        }
        [self.view addSubview:imageView];
        _referenceNameField.text = name;
        //_referenceNameField.enabled = NO;
        //_editReferenceButton.enabled = NO;
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
        _changeImageButton.enabled = NO;
        [_changeImageButton removeFromSuperview];
        
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
    
    NSString *savedPictureLocation;
    if (imageView != nil && photoOrText == 0){
        NSString *picturename = [NSMutableString stringWithFormat:@"%@%@", _referenceNameField.text, @"_resource.png"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        savedPictureLocation = [documentsDirectory stringByAppendingPathComponent:picturename];
        NSData *pictureData = UIImagePNGRepresentation(imageView.image);
        [pictureData writeToFile:savedPictureLocation atomically:NO];
        [self.delegate viewReferenceSave:self setContents:_note.text setImageOrText:photoOrText setName:_referenceNameField.text setID:referenceIDToEdit];
    }else if (photoOrText == 1){
        [self.delegate viewReferenceSave:self setContents:_note.text setImageOrText:photoOrText setName:_referenceNameField.text setID:referenceIDToEdit];
    }
    
}

- (IBAction)changeRefImage:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    NSLog(@"using photo");
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void)setPhotoOrText: (int) val setContents:(NSString *) cont setIdentifier: (int) iden setName: (NSString *) nm {
    NSLog(@"Params: %i, %@, %i, %@",val, cont, iden, nm);
    photoOrText = val;
    contents = cont;
    referenceIDToEdit = iden;
    name = nm;
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    imageView.image = chosenImage;
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
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
