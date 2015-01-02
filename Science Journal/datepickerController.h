//
//  datepickerController.h
//  Science Journal
//
//  Created by Evan Teague on 12/24/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entry.h"

@class datepickerController;
@protocol datepickerControllerDelegate <NSObject>
- (void)datepickerControllerCancel:(datepickerController *) controller;
- (void)datepickerControllerSave:(datepickerController *)controller didSaveDate:(NSString*) date;
@end
@interface datepickerController : UIViewController {
    NSString * dateValue;
}

@property (nonatomic, weak) id <datepickerControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *dateDisplay;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)dateCancel:(id)sender;
- (IBAction)dateSave:(id)sender;
- (void)setDateValue:(NSString*)date;
@end
