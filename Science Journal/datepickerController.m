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
    //Adds an action to the datepicker
    [_datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:_datePicker.date];
    _dateDisplay.text = strDate;
    if ([dateValue length] != 0 ){
        _dateDisplay.text = dateValue;
    }
    _dateDisplay.delegate = self;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//If the datepicker is changed, it saves the result
- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
    
    _dateDisplay.text = strDate;
}

//If the user selects cancel
- (IBAction)dateCancel:(id)sender {
    [self.delegate datepickerControllerCancel:self];
}

//If the user selects save
- (IBAction)dateSave:(id)sender {
    [self.delegate datepickerControllerSave:self didSaveDate:(NSString *)_dateDisplay.text];
}

//Sets the date value when editing
-(void)setDateValue:(NSString *)date{
    dateValue = date;
}

@end
