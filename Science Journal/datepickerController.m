//
//  datepickerController.m
//  Science Journal
//
//  Created by Evan Teague on 12/24/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import "datepickerController.h"

@interface datepickerController ()

@end

@implementation datepickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:_datePicker.date];
    _dateDisplay.text = strDate;
    NSLog(@"%@", dateValue);
    if ([dateValue length] != 0 ){
        _dateDisplay.text = dateValue;
        NSLog(@"Inside date");
    }
    NSLog(@"Outside date");
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
    
    _dateDisplay.text = strDate;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)dateCancel:(id)sender {
    [self.delegate datepickerControllerCancel:self];
    NSLog(@"CANCEL");
}

- (IBAction)dateSave:(id)sender {
    [self.delegate datepickerControllerSave:self didSaveDate:(NSString *)_dateDisplay.text];
}

-(void)setDateValue:(NSString *)date{
    NSLog(@"Setting date value: %@", date);
    dateValue = date;
}
@end
