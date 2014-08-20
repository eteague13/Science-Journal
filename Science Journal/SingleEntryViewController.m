//
//  SingleEntryViewController.m
//  Science Journal
//
//  Created by Evan Teague on 8/19/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import "SingleEntryViewController.h"
#import "EntriesController.h"
#import "EntriesCell.h"

@interface SingleEntryViewController ()
    
    

@end

@implementation SingleEntryViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_entryDetailScroller setScrollEnabled:YES];
    [_entryDetailScroller setContentSize:CGSizeMake(320, 1932)];
    [_entryDetailDatePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    _entryDetailName.text = _entryDetailsModel[0];
    _entryDetailDateDisplay.text = _entryDetailsModel[1];
    _entryDetailProjectName.text = _entryDetailsModel[2];
    _entryDetailGoal.text = _entryDetailsModel[3];
    _entryDetailLatitude.text = _entryDetailsModel[4];
    _entryDetailLongitude.text = _entryDetailsModel[5];
    _entryDetailWeather.text = _entryDetailsModel[6];
    _entryDetailMagnet.text = _entryDetailsModel[7];
    _entryDetailPartners.text = _entryDetailsModel[8];
    _entryDetailPermissions.text = _entryDetailsModel[9];
    _entryOutcrop.text = _entryDetailsModel[10];
    _entryStructuralData.text = _entryDetailsModel[11];
    _entryDetailSampleNum.text = _entryDetailsModel[12];
    _entryDetailNotes.text = _entryDetailsModel[13];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
    _entryDetailDateDisplay.text = strDate;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
