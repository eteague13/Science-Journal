//
//  AddEntryController.h
//  Science Journal
//
//  Created by Evan Teague on 12/23/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "datepickerController.h"
#import "LocationAndWeatherController.h"
#import "SketchController.h"
#import "CameraController.h"
#import "MagneticDecController.h"
#import "DBManager.h"


@class AddEntryController;
@protocol AddEntryControllerDelegate <NSObject>
- (void)AddEntryControllerDidCancel:(AddEntryController *) controller;
- (void)AddEntryControllerDidSave:(AddEntryController *) controller;

@end

@interface AddEntryController : UITableViewController <datepickerControllerDelegate, LocationAndWeatherControllerDelegate, SketchControllerDelegate, CameraControllerDelegate, MagneticDecControllerDelegate> {
    BOOL isEditEntry;
    
}

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *associatedEntryArray;
@property (nonatomic) int recordIDToEdit;
-(void)loadInfoToEdit;




@property (nonatomic, weak) id <AddEntryControllerDelegate> delegate;

- (IBAction)cancelButton:(id)sender;
- (IBAction)saveButton:(id)sender;

@property (weak, nonatomic) IBOutlet UINavigationItem *entryTitleLabel;

@property (weak, nonatomic) IBOutlet UITextField *entryNameField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabelField;
@property (weak, nonatomic) IBOutlet UITextField *projectNameField;
@property (weak, nonatomic) IBOutlet UITextField *sampleNumberField;
@property (weak, nonatomic) IBOutlet UILabel *goalLabelField;
@property (weak, nonatomic) IBOutlet UILabel *locWeatherField;
@property (weak, nonatomic) IBOutlet UILabel *notesField;
@property (weak, nonatomic) IBOutlet UILabel *permissionsField;

@property (weak, nonatomic) IBOutlet UILabel *outcropField;
@property (weak, nonatomic) IBOutlet UILabel *structuralField;
@property (weak, nonatomic) IBOutlet UILabel *partnersField;


@property (strong, nonatomic) NSString *name, *date, *projectName, *goal, *latitude, *longitude, *weather, *partners, *permissions, *outcrop, *structuralData, *sampleNum, *notes, *stopNum, *magneticValue1, *magneticValue2, *magneticType;
@property (strong, nonatomic) UIImage *sketch;
@property (strong, nonatomic) UIImage *picture;

-(void)setEditEntry:(BOOL)value;
@property (weak, nonatomic) IBOutlet UITextField *stopNumField;
@property (weak, nonatomic) IBOutlet UITableViewCell *geoMagneticCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *geoStopNumCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *geoOutcropCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *geoStructCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *dateCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *goalCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *locationWeatherCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *sketchCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *pictureCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *notesCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *permissionsCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *sampleNumCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *partnersCell;


@end
