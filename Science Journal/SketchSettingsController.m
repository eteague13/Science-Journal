//
//  SketchSettingsController.m
//  Science Journal
//
//  Created by Evan Teague on 2/17/15.
//  Copyright (c) 2015 Evan Teague. All rights reserved.
//

#import "SketchSettingsController.h"

@interface SketchSettingsController ()

@end

@implementation SketchSettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    _brushSizeLabel.text = [NSString stringWithFormat:@"%.1f", self.brush];
    _brushSizeSlider.value = _brush;
    _brushOpacityLabel.text = [NSString stringWithFormat:@"%.1f", self.opacity];
    _brushOpacitySlider.value = _opacity;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//If the user is done changing the brush settings
- (IBAction)settingsDone:(id)sender {
    [self.delegate sketchSettingsControllerDone:self setSize:self.brush setOpacity:self.opacity];
}
//Action if the user changes the brush size
- (IBAction)brushSizeChange:(id)sender {
    self.brush = self.brushSizeSlider.value;
    self.brushSizeLabel.text = [NSString stringWithFormat:@"%.1f", self.brush];
}

//Action if the user changes the brush opacity
- (IBAction)brushOpacityChange:(id)sender {
    
    self.opacity = self.brushOpacitySlider.value;
    self.brushOpacityLabel.text = [NSString stringWithFormat:@"%.1f", self.opacity];
    
}
 
@end
