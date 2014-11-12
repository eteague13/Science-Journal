//
//  MapAnnotationDisplayController.h
//  Science Journal
//
//  Created by Evan Teague on 10/3/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entry.h"

@interface MapAnnotationDisplayController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *annotationEntryName;
@property (weak, nonatomic) IBOutlet UILabel *annotationDate;
@property (weak, nonatomic) IBOutlet UILabel *annotationProjectName;
@property (weak, nonatomic) IBOutlet UILabel *annotationLatitude;
@property (weak, nonatomic) IBOutlet UILabel *annotationLongitude;
@property (weak, nonatomic) IBOutlet UITextView *annotationWeather;
@property (weak, nonatomic) IBOutlet UILabel *annotationMagnetic;
@property (weak, nonatomic) IBOutlet UITextView *annotationPartners;
@property (weak, nonatomic) IBOutlet UITextView *annotationPermissions;
@property (weak, nonatomic) IBOutlet UITextView *annotationGoal;
@property (weak, nonatomic) IBOutlet UITextView *annotationOutcrop;
@property (weak, nonatomic) IBOutlet UITextView *annotationStructuralData;
@property (weak, nonatomic) IBOutlet UITextView *annotationNotes;
@property (weak, nonatomic) IBOutlet UIImageView *annotationSketch;
@property (weak, nonatomic) IBOutlet UIImageView *annotationPicture;
@property (weak, nonatomic) IBOutlet UILabel *annotationSampleNum;

@property (weak, nonatomic) IBOutlet UIScrollView *annotationScroller;


@property (strong, nonatomic) NSArray *annotationDetailsModel;
@property (strong, nonatomic) Entry *associatedEntry;

@end
