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

- (IBAction)settingsDone:(id)sender {
    [self.delegate sketchSettingsControllerDone:self setSize:self.brush setOpacity:self.opacity];
}
- (IBAction)brushSizeChange:(id)sender {
    self.brush = self.brushSizeSlider.value;
    self.brushSizeLabel.text = [NSString stringWithFormat:@"%.1f", self.brush];
}


- (IBAction)brushOpacityChange:(id)sender {
    
    self.opacity = self.brushOpacitySlider.value;
    self.brushOpacityLabel.text = [NSString stringWithFormat:@"%.1f", self.opacity];
    
}
 
@end
