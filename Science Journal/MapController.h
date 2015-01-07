//
//  FirstViewController.h
//  Science Journal
//
//  Created by Evan Teague on 8/18/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "UserEntryDatabase.h"
#import "Entry.h"
#import "AddEntryController.h"

@interface MapController : UIViewController <MKMapViewDelegate, AddEntryControllerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) UserEntryDatabase *database;
@property(weak, nonatomic) NSString *selectedAnnotationName;
- (IBAction)zoomCurrentLocation:(id)sender;
- (IBAction)changeMapType:(id)sender;


@end
