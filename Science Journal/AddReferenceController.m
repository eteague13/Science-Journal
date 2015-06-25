//
//  AddReferenceController.m
//  Science Journal
//
//  Created by Evan Teague on 6/1/15.
//  Copyright (c) 2015 Evan Teague. All rights reserved.
//

#import "AddReferenceController.h"

@interface AddReferenceController ()

@end

@implementation AddReferenceController

- (void)viewDidLoad {
    [super viewDidLoad];

    //If photo
    if (photoOrText == 0) {
        CGRect frame = CGRectMake(0, 100, 320, 370);
        imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:imageView];
        
    //If Text
    }else{
        CGRect frame = CGRectMake(0, 150, 320, 470);
        self.note = [[NoteView alloc] initWithFrame:frame];
        [self.view addSubview:_note];
        _note.delegate = self;
        [_note setScrollEnabled:YES];
        _refImageButton.enabled = NO;
       
    }
    
    _referenceNameField.delegate = self;
    _referenceNameField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
   
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Passes the value of if the user is editing a photo or text
- (void)setPhotoOrText:(int)val {
    photoOrText = val;
    
}

//If the user selects cancel
- (IBAction)cancelAddReference:(id)sender {
    [self.delegate referenceCancel:self];
}

//If the user saves the reference
- (IBAction)saveReference:(id)sender {
    //Has to save the picture to the app's documents directory
    NSString *savedPictureLocation;
    if (imageView != nil && photoOrText == 0){
        NSString *picturename = [NSMutableString stringWithFormat:@"%@%@", _referenceNameField.text, @"_resource.png"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        savedPictureLocation = [documentsDirectory stringByAppendingPathComponent:picturename];
        NSData *pictureData = UIImagePNGRepresentation(imageView.image);
        [pictureData writeToFile:savedPictureLocation atomically:NO];
        [self.delegate referenceSave:self setContents:savedPictureLocation setImageOrText:photoOrText setName:_referenceNameField.text];
    }else if (photoOrText == 1){
        [self.delegate referenceSave:self setContents:_note.text setImageOrText:(int) photoOrText setName:_referenceNameField.text];
    }
    
}


//Allows the user to select an image from an image picker
- (IBAction)addRefImage:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

//Delegate method for the image picker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    imageView.image = chosenImage;

    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

//Delegate method for the image picker when a user selects cancel
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


@end
