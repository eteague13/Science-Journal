//
//  CameraController.h
//  Science Journal
//
//  Created by Evan Teague on 1/2/15.
//  Copyright (c) 2015 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>

//Delegate
@class CameraController;
@protocol CameraControllerDelegate <NSObject>
- (void)cameraControllerCancel:(CameraController *) controller;
- (void)cameraControllerSave:(CameraController *)controller didSavePhoto:(UIImage*) photo;
@end


@interface CameraController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    UIImage * photo;
}
//IBOutlets
@property (weak, nonatomic) IBOutlet UIImageView *photoDisplay;

//IBActions
- (IBAction)cancelCameraButton:(id)sender;
- (IBAction)saveCameraButton:(id)sender;
- (IBAction)useCameraRoll:(id)sender;
- (IBAction)useCamera:(id)sender;

//Variables
@property (nonatomic, weak) id <CameraControllerDelegate> delegate;

//Methods
- (void) setPhoto:(UIImage*) item;



@end
