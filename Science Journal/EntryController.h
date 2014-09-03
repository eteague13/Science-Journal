//
//  EntryController.h
//  Science Journal
//
//  Created by Evan Teague on 8/18/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserEntryDatabase.h"
#import "CoreLocation/CoreLocation.h"

@interface EntryController : UIViewController <UITextFieldDelegate, UITextViewDelegate, CLLocationManagerDelegate>
{
    IBOutlet UIScrollView *entryScroller;
    IBOutlet UIDatePicker *datePicker;
    IBOutlet UITextField *dateDisplayFieldA;
    
    __weak IBOutlet UITextField *entryNameField;
    __weak IBOutlet UITextField *projectNameField;
    __weak IBOutlet UITextView *goalField;
    __weak IBOutlet UITextField *latitudeField;
    __weak IBOutlet UITextField *longitudeField;
    __weak IBOutlet UITextView *weatherField;
    __weak IBOutlet UITextField *magneticField;
    __weak IBOutlet UITextView *partnersField;
    __weak IBOutlet UITextView *permissionsField;
    __weak IBOutlet UITextView *outcropField;
    __weak IBOutlet UITextView *structuralField;
    __weak IBOutlet UITextField *sampleNumField;
    __weak IBOutlet UITextView *notesField;
    UserEntryDatabase *databaseCopy;
}
- (IBAction)getCurrentLocation:(id)sender;
-(IBAction)textFieldReturn:(id)sender;
@end
