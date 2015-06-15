//
//  StrikeDipController.m
//  Science Journal
//
//  Created by Evan Teague on 6/8/15.
//  Copyright (c) 2015 Evan Teague. All rights reserved.
//

#import "StrikeDipController.h"

@interface StrikeDipController ()

@end

@implementation StrikeDipController

- (void)viewDidLoad {
    [super viewDidLoad];
    _strikeField.text = _strike;
    _dipField.text = _dip;
    // Do any additional setup after loading the view.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
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

- (IBAction)cancelStrikeDip:(id)sender {
    [self.delegate strikeDipCancel:self];
}

- (IBAction)saveStrikeDip:(id)sender {
    [self.delegate strikeDipSave:self strike:_strikeField.text dip:_dipField.text];
}

-(void)setStrike:(NSString*)strike setDip:(NSString *)dip{
    self.strike = strike;
    self.dip = dip;
}
@end
