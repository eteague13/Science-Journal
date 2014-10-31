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

@interface MapController : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) UserEntryDatabase *database;
@property(weak, nonatomic) NSString *selectedAnnotationName;

@end
