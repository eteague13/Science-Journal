//
//  FirstViewController.m
//  Science Journal
//
//  Created by Evan Teague on 8/18/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "MapController.h"

@interface MapController ()

@end
#define METERS_PER_MILE 1609.344

@implementation MapController
@synthesize mapView;
@synthesize database = _database;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.mapView.delegate = self;
    _database = [UserEntryDatabase userEntryDatabase];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    // 1
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 38.008203;
    zoomLocation.longitude= -78.522963;
    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    // 3
    [mapView setRegion:viewRegion animated:YES];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    /*
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = userLocation.coordinate;
    point.title = @"Where am I?";
    point.subtitle = @"I'm here!!!";
    
    [self.mapView addAnnotation:point];
     */
 
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView{
    CLLocationCoordinate2D coordinate;
    for (int i = 0; i < _database.entries.count; i++){
        Entry *tempEntry = _database.entries[i];
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        coordinate.latitude = [tempEntry.latitude doubleValue];
        coordinate.longitude = [tempEntry.longitude doubleValue];
        point.coordinate = coordinate;
        point.title = tempEntry.name;
        point.subtitle = tempEntry.projectName;
        [self.mapView addAnnotation:point];
    }
    
    
}

@end
