//
//  CameraController.h
//  Science Journal
//
//  Created by Evan Teague on 1/2/15.
//  Copyright (c) 2015 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CameraController;
@protocol CameraControllerDelegate <NSObject>
- (void)cameraControllerCancel:(CameraController *) controller;
- (void)cameraControllerSave:(CameraController *)controller didSavePhoto:(UIImage*) photo;
@end


@interface CameraController : UIViewController{
    UIImage * photo;
}
- (IBAction)cancelCameraButton:(id)sender;
- (IBAction)saveCameraButton:(id)sender;
- (IBAction)useCameraRoll:(id)sender;
- (IBAction)useCamera:(id)sender;
- (void) setPhoto:(UIImage*) item;
@property (weak, nonatomic) IBOutlet UIImageView *photoDisplay;

@property (nonatomic, weak) id <CameraControllerDelegate> delegate;
@end
