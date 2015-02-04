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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Sandcropped1.jpg"]];
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

- (IBAction)cancelCameraButton:(id)sender {
    [self.delegate cameraControllerCancel:self];
}

- (IBAction)saveCameraButton:(id)sender {
    
    [self.delegate cameraControllerSave:self didSavePhoto:_photoDisplay.image];
}



- (IBAction)useCameraRoll:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    NSLog(@"using photo");
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)useCamera:(id)sender {
    /*
     UIImagePickerController *picker = [[UIImagePickerController alloc] init];
     picker.delegate = self;
     picker.allowsEditing = YES;
     picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
     
     [self presentViewController:picker animated:YES completion:NULL];
     */
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    _photoDisplay.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void) setPhoto:(UIImage*) item{
    photo = item;
    NSLog(@"image in camera controller: %@", photo);
}
@end
