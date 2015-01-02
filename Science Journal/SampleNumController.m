//
//  SampleNumController.m
//  Science Journal
//
//  Created by Evan Teague on 12/31/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import "SampleNumController.h"

@interface SampleNumController ()

@end

@implementation SampleNumController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (IBAction)sampleCancelButton:(id)sender {
    [self.delegate SampleNumControllerCancel:self];
}

- (IBAction)sampleActionButton:(id)sender {
    [self.delegate SampleNumControllerSave:self didSaveSample:@"TEMP"];
}
@end
