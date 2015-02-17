//
//  SketchSettingsController.h
//  Science Journal
//
//  Created by Evan Teague on 2/17/15.
//  Copyright (c) 2015 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SketchSettingsController;
@protocol SketchSettingsControllerDelegate <NSObject>
- (void)sketchSettingsControllerDone:(SketchSettingsController *) controller setSize:(CGFloat)size setOpacity:(CGFloat)op;

@end
@interface SketchSettingsController : UIViewController
- (IBAction)settingsDone:(id)sender;
@property (weak, nonatomic) IBOutlet UISlider *brushSizeSlider;
@property (nonatomic, weak) id <SketchSettingsControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *brushSizeLabel;
@property (weak, nonatomic) IBOutlet UISlider *brushOpacitySlider;
@property (weak, nonatomic) IBOutlet UILabel *brushOpacityLabel;

@property CGFloat brush;
@property CGFloat opacity;
- (IBAction)brushSizeChange:(id)sender;


    
@end
