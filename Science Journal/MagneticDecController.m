//
//  MagneticDecController.m
//  Science Journal
//
//  Created by Evan Teague on 1/9/15.
//  Copyright (c) 2015 Evan Teague. All rights reserved.
//

#import "MagneticDecController.h"

@interface MagneticDecController ()

@end

@implementation MagneticDecController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([value1 length] != 0){
        _value1.text = value1;
    }
    if ([value2 length] != 0){
        _value2.text = value2;
    }
    if ([type length] != 0){
        if ([type isEqual: @"Strike/Dip"]){
            [_magDecType setSelectedSegmentIndex:0];
        }else if ([type isEqual: @"Trend/Plunge"]){
            [_magDecType setSelectedSegmentIndex:1];
        }
    }
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Sandcropped1.jpg"]];
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

- (IBAction)magDecCancel:(id)sender {
    [self.delegate magDecControllerCancel:self];
}

- (IBAction)magDecSave:(id)sender {
    if ((long)_magDecType.selectedSegmentIndex == 0){
        [self.delegate magDecControllerSave:(MagneticDecController *)self value1:(NSString*)_value1.text value2:(NSString*)_value2.text type:(NSString*)@"Strike/Dip"];
    }else if ((long)_magDecType.selectedSegmentIndex == 1){
        [self.delegate magDecControllerSave:(MagneticDecController *)self value1:(NSString*)_value1.text value2:(NSString*)_value2.text type:(NSString*)@"Trend/Plunge"];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)segmentedControlClicked:(id)sender {
    if ((long)_magDecType.selectedSegmentIndex == 0){
        _strikeORTrendLabel.text = @"Strike:";
        _dipORPlungeLabel.text = @"Dip:";
    }else if ((long)_magDecType.selectedSegmentIndex == 1){
        _strikeORTrendLabel.text = @"Trend:";
        _dipORPlungeLabel.text = @"Plunge:";
    }
}

-(void)setVal1:(NSString*) val1 setVal2:(NSString*) val2 setType:(NSString*) typ{
    value1 = val1;
    value2 = val2;
    self->type = typ;
}
@end
