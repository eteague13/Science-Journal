//
//  FirstViewController.h
//  Science Journal
//
//  Created by Evan Teague on 8/18/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "AddEntryController.h"

@interface MapController : UIViewController <MKMapViewDelegate, AddEntryControllerDelegate>

//IBOutlets
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

//IBActions
- (IBAction)zoomCurrentLocation:(id)sender;
- (IBAction)changeMapType:(id)sender;

//Variables
@property (weak, nonatomic) NSString *selectedAnnotationIdentifier;
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) CLLocationManager *locManager;

//Methods

@end
