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
    //Readjusts the UIImageview to correspond with the size of the picture
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    if (photoOrText == 0) {
        CGRect frame = CGRectMake(0, 120, 320, 370);
        imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        //If the user is selecting the About Resources image
        if (referenceIDToEdit == 1){
            imageView.image = [UIImage imageNamed:@"About-Adding-Resources-Final.png"];
            _referenceNameField.enabled = NO;
            _editReferenceButton.enabled = NO;
            _changeImageButton.enabled = NO;
            [_changeImageButton removeFromSuperview];
        //Otherwise loads the existing image
        }else{
            NSString *documentsDirectory = [NSHomeDirectory()
                                            stringByAppendingPathComponent:@"Documents"];
            NSString *picturePath = [documentsDirectory stringByAppendingPathComponent:contents];
            imageView.image = [UIImage imageWithContentsOfFile:picturePath];
        }
        [self.view addSubview:imageView];
        _referenceNameField.text = name;
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



//If the user edits the refernece, it saves the new data
- (IBAction)editReference:(id)sender {
    
    NSString *savedPictureLocation;
    if (imageView != nil && photoOrText == 0){
        NSString *picturename = [NSMutableString stringWithFormat:@"%@%@", _referenceNameField.text, @"_resource.png"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        savedPictureLocation = [documentsDirectory stringByAppendingPathComponent:picturename];
        NSData *pictureData = UIImagePNGRepresentation(imageView.image);
        [pictureData writeToFile:savedPictureLocation atomically:NO];
        [self.delegate viewReferenceSave:self setContents:picturename setImageOrText:photoOrText setName:_referenceNameField.text setID:referenceIDToEdit];
    }else if (photoOrText == 1){
        [self.delegate viewReferenceSave:self setContents:_note.text setImageOrText:photoOrText setName:_referenceNameField.text setID:referenceIDToEdit];
    }
    
}
//Image picker if the user wants to change the picture
- (IBAction)changeRefImage:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

//Sets the existing data
-(void)setPhotoOrText: (int) val setContents:(NSString *) cont setIdentifier: (int) iden setName: (NSString *) nm {
    photoOrText = val;
    contents = cont;
    referenceIDToEdit = iden;
    name = nm;
    
}

//Delegate method for the image picker if the user picks an image
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    imageView.image = chosenImage;
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

//Delegate method for the image picker if the user selects cancel
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    [aTextField resignFirstResponder];
    return YES;
}


@end
