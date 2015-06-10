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
#import "DBManager.h"
#import "DataSheetController.h"
#import "StrikeDipController.h"
#import "TrendPlungeController.h"
#import "EntriesCell.h"
#import "textEntryController.h"

//Delegate
@class AddEntryController;
@protocol AddEntryControllerDelegate <NSObject>
- (void)AddEntryControllerDidCancel:(AddEntryController *) controller;
- (void)AddEntryControllerDidSave:(AddEntryController *) controller;

@end

@interface AddEntryController : UITableViewController <datepickerControllerDelegate, LocationAndWeatherControllerDelegate, SketchControllerDelegate, CameraControllerDelegate, DataSheetControllerDelegate, StrikeDipControllerDelegate, TrendPlungeControllerDelegate, textEntryControllerDelegate> {
    BOOL isEditEntry;
    NSString *projectNameList;
    
}
//IBOutlets
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
@property (weak, nonatomic) IBOutlet UITextField *stopNumField;
@property (weak, nonatomic) IBOutlet UITableViewCell *strikeDipCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *stopNumCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *outcropCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *structuralDataCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *trendPlungeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *dateCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *goalCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *locationWeatherCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *sketchCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *pictureCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *notesCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *permissionsCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *sampleNumCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *partnersCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *dataSheetCell;
@property (weak, nonatomic) IBOutlet UIButton *dateContentsLabel;
@property (weak, nonatomic) IBOutlet UIButton *goalContentsLabel;
@property (weak, nonatomic) IBOutlet UIButton *locationContentsLabel;
@property (weak, nonatomic) IBOutlet UIButton *sketchContentsLabel;
@property (weak, nonatomic) IBOutlet UIButton *pictureContentsLabel;
@property (weak, nonatomic) IBOutlet UIButton *notesContentsLabel;
@property (weak, nonatomic) IBOutlet UIButton *permissionsContentsLabel;
@property (weak, nonatomic) IBOutlet UIButton *partnersContentsLabel;
@property (weak, nonatomic) IBOutlet UIButton *dataSheetContentsLabel;
@property (weak, nonatomic) IBOutlet UIButton *strikeDipContentsLabel;
@property (weak, nonatomic) IBOutlet UIButton *outcropContentsLabel;
@property (weak, nonatomic) IBOutlet UIButton *structuralContentsLabel;
@property (weak, nonatomic) IBOutlet UIButton *trendPlungeContentsLabel;

//IBActions
- (IBAction)cancelButton:(id)sender;
- (IBAction)saveButton:(id)sender;

//Variables
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *associatedEntryArray;
@property (nonatomic) int recordIDToEdit;
@property (nonatomic, weak) id <AddEntryControllerDelegate> delegate;
@property (strong, nonatomic) NSString *name, *date, *projectName, *goal, *latitude, *longitude, *weather, *partners, *permissions, *outcrop, *structuralData, *sampleNum, *notes, *stopNum, *dataSheet, *strike, *dip, *trend, *plunge;
@property (strong, nonatomic) UIImage *sketch;
@property (strong, nonatomic) UIImage *picture;

//Methods
-(void)loadInfoToEdit;
-(void)setProjectNameList:(NSString *) pnl;
-(void)setEditEntry:(BOOL)value;

















@end
