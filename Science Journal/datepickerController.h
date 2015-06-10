//
//  datepickerController.h
//  Science Journal
//
//  Created by Evan Teague on 12/24/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>

//Delegate
@class datepickerController;
@protocol datepickerControllerDelegate <NSObject>
- (void)datepickerControllerCancel:(datepickerController *) controller;
- (void)datepickerControllerSave:(datepickerController *)controller didSaveDate:(NSString*) date;
@end

@interface datepickerController : UIViewController <UITextFieldDelegate> {
    NSString * dateValue;
}

//IBOutlets
@property (weak, nonatomic) IBOutlet UITextField *dateDisplay;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

//IBActions
- (IBAction)dateCancel:(id)sender;
- (IBAction)dateSave:(id)sender;
//Variables
@property (nonatomic, weak) id <datepickerControllerDelegate> delegate;

//Methods
- (void)setDateValue:(NSString*)date;


@end
