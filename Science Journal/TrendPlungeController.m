//
//  TrendPlungeController.m
//  Science Journal
//
//  Created by Evan Teague on 6/8/15.
//  Copyright (c) 2015 Evan Teague. All rights reserved.
//

#import "TrendPlungeController.h"

@interface TrendPlungeController ()

@end

@implementation TrendPlungeController

- (void)viewDidLoad {
    [super viewDidLoad];
    _trendField.text = _trend;
    _plungeField.text = _plunge;
    _trendField.delegate = self;
    _plungeField.delegate = self;
    // Do any additional setup after loading the view.
}

/*
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
 */
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

- (IBAction)cancelTrendPlunge:(id)sender {
    [self.delegate trendPlungeCancel:self];
}

- (IBAction)saveTrendPlunge:(id)sender {
    [self.delegate trendPlungeSave:self trend:_trendField.text plunge:_plungeField.text];
}

-(void)setTrend:(NSString*)trend setPlunge:(NSString *)plunge{
    self.trend = trend;
    self.plunge = plunge;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
