//
//  CameraController.m
//  Science Journal
//
//  Created by Evan Teague on 1/2/15.
//  Copyright (c) 2015 Evan Teague. All rights reserved.
//

#import "CameraController.h"

@interface CameraController ()

@end

@implementation CameraController

- (void)viewDidLoad {
    [super viewDidLoad];
    _photoDisplay.image = photo;
    _photoDisplay.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//If the user selects cancel
- (IBAction)cancelCameraButton:(id)sender {
    [self.delegate cameraControllerCancel:self];
}

//If the user saves the picture
- (IBAction)saveCameraButton:(id)sender {
    
    [self.delegate cameraControllerSave:self didSavePhoto:_photoDisplay.image];
}


//If the user selects to pick an image from the camera roll
- (IBAction)useCameraRoll:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

//If the user selects to take a picture using the camera
- (IBAction)useCamera:(id)sender {
    
     UIImagePickerController *picker = [[UIImagePickerController alloc] init];
     picker.delegate = self;
     picker.allowsEditing = YES;
     picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
     [self presentViewController:picker animated:YES completion:NULL];
    
}
//Presents the image picker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    _photoDisplay.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

//If the user selects cancel on the image picker
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

//Passes the photo
- (void) setPhoto:(UIImage*) item{
    photo = item;
}
@end
