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
- (void)viewDidLoad
{
    [super viewDidLoad];
    mapView.delegate = self;
    mapView.showsUserLocation = YES;
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"entriesdb.sql"];
    _locManager = [[CLLocationManager alloc] init];
    if ([_locManager respondsToSelector:
         @selector(requestWhenInUseAuthorization)]) {
        [_locManager requestWhenInUseAuthorization];
    }
    CLLocationCoordinate2D centerCoordinate;
    centerCoordinate.latitude = 38.9047;
    centerCoordinate.longitude = -77.0164;
    
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance (
                                        centerCoordinate, 20000, 20000);
    [self.mapView setRegion:region animated:YES];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Sandcropped1.jpg"]];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
   
    //Reloads all of the annotations
   [self.mapView addAnnotations:[self updateAnnotations]];
    
}


/*
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //self.mapView.centerCoordinate = userLocation.location.coordinate;
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance (
                                        userLocation.location.coordinate, 200, 200);
    [self.mapView setRegion:region animated:YES];
 
}
*/




- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    //Creates annotations for each pin
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        
        MKPinAnnotationView *annotationView =
        (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc]
                              initWithAnnotation:annotation
                              reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return annotationView;
    }
    
    return nil; 
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    //When a user clicks on an annotation, it performs a segue call to open up the Edit Entry controller
    MKPointAnnotation *location = (MKPointAnnotation*)view.annotation;

    //Gets the entry # from the selected annotation
    NSString *tempString = [view.annotation.subtitle substringFromIndex:9];
    _selectedAnnotationIdentifier = tempString;
    [self performSegueWithIdentifier:@"annotationDetail" sender:self];
   
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"annotationDetail"])
    {

        NSString *query = [NSString stringWithFormat:@"select * from entriesBasic"];
        
        NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
        //Get the selected entry data and load it in the Edit Entry controller
        UINavigationController *navigationController = segue.destinationViewController;
        AddEntryController *annotationView = [navigationController viewControllers][0];
        annotationView.delegate = self;
        [annotationView setEditEntry:true];
        annotationView.recordIDToEdit = [_selectedAnnotationIdentifier intValue];
        

        
    }
}

- (void)AddEntryControllerDidCancel:(AddEntryController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)AddEntryControllerDidSave:(AddEntryController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)zoomCurrentLocation:(id)sender {
    //"Get location" button that moves the map to where the user is
    MKUserLocation *userLocation = mapView.userLocation;
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance (
                                        userLocation.location.coordinate, 200, 200);
    [mapView setRegion:region animated:YES];
}

- (IBAction)changeMapType:(id)sender {
    //Changes the maptype
    if (mapView.mapType == MKMapTypeStandard)
        mapView.mapType = MKMapTypeSatellite;
    else
        mapView.mapType = MKMapTypeStandard;
}

-(NSMutableArray *)updateAnnotations{
    [self.mapView removeAnnotations:self.mapView.annotations];
    CLLocationCoordinate2D coordinate;
    NSString *query = [NSString stringWithFormat:@"select * from entriesBasic"];
    
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSString *name, *projectName, *latitude, *longitude;
    NSMutableArray *allAnnotations = [[NSMutableArray alloc] init];
    for (id entry in results) {
        name = [entry objectAtIndex:1];
        projectName = [entry objectAtIndex:2];
        latitude = [entry objectAtIndex:5];
        longitude = [entry objectAtIndex:6];
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        coordinate.latitude = [latitude doubleValue];
        coordinate.longitude = [longitude doubleValue];
        point.coordinate = coordinate;
        point.title = name;
        point.subtitle = [NSString stringWithFormat:@"Entry #: %@", [entry objectAtIndex:0]];
        [allAnnotations addObject: point];
    }
    return allAnnotations;
}

@end
