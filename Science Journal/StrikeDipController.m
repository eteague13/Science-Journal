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
    _strikeField.delegate = self;
    _dipField.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//If the user selects cancel
- (IBAction)cancelStrikeDip:(id)sender {
    [self.delegate strikeDipCancel:self];
}

//If the user saves the info
- (IBAction)saveStrikeDip:(id)sender {
    [self.delegate strikeDipSave:self strike:_strikeField.text dip:_dipField.text];
}

//Passes the existing info
-(void)setStrike:(NSString*)strike setDip:(NSString *)dip{
    self.strike = strike;
    self.dip = dip;
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    [aTextField resignFirstResponder];
    return YES;
}

@end
