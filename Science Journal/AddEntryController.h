//
//  AddEntryController.h
//  Science Journal
//
//  Created by Evan Teague on 12/23/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserEntryDatabase.h"
#import "datepickerController.h"
#import "LocationAndWeatherController.h"
#import "SketchController.h"
#import "CameraController.h"
#import "Entry.h"
#import "MagneticDecController.h"

@class AddEntryController;
@protocol AddEntryControllerDelegate <NSObject>
- (void)AddEntryControllerDidCancel:(AddEntryController *) controller;
- (void)AddEntryController:(AddEntryController *)controller didSaveEntry:(Entry *)entry;
- (void)AddEntryController:(AddEntryController *)controller didUpdateEntry:(Entry *)entry;
@end

@interface AddEntryController : UITableViewController <datepickerControllerDelegate, LocationAndWeatherControllerDelegate, SketchControllerDelegate, CameraControllerDelegate, MagneticDecControllerDelegate> {
    UserEntryDatabase *databaseCopy;
    BOOL isEditEntry;
    
}
@property (nonatomic, weak) id <AddEntryControllerDelegate> delegate;

- (IBAction)cancelButton:(id)sender;
- (IBAction)saveButton:(id)sender;

@property (weak, nonatomic) IBOutlet UINavigationItem *entryTitleLabel;

@property (weak, nonatomic) IBOutlet UITextField *entryNameField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabelField;
@property (weak, nonatomic) IBOutlet UITextField *projectNameField;
@property (weak, nonatomic) IBOutlet UITextField *sampleNumberField;

@property (strong, nonatomic) NSString *name, *date, *projectName, *goal, *latitude, *longitude, *weather, *magnet, *partners, *permissions, *outcrop, *structuralData, *sampleNum, *notes, *stopNum, *magneticValue1, *magneticValue2, *magneticType;
@property (strong, nonatomic) UIImage *sketch;
@property (strong, nonatomic) UIImage *photo;
@property (strong, nonatomic) Entry *associatedEntry;

-(void)setEditEntry:(BOOL)value;
@property (weak, nonatomic) IBOutlet UITableViewCell *geoMagneticCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *geoStopNumCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *geoOutcropCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *geoStructCell;
@property (weak, nonatomic) IBOutlet UITextField *stopNumField;

@end