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
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Sandcropped1.jpg"]];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {

//Sets the initial map view to the user's current location
    MKUserLocation *userLocation = mapView.userLocation;
    //MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance (
                                        userLocation.location.coordinate, 200, 200);
    //[mapView setRegion:region animated:YES];
    [mapView setCenterCoordinate:mapView.userLocation.location.coordinate];
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    /*
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
     */
    mapView.centerCoordinate = userLocation.location.coordinate;
 
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView{
    //Queries the database and places each entry on the map
    CLLocationCoordinate2D coordinate;
    NSString *query = [NSString stringWithFormat:@"select * from entriesBasic inner join entriesGeology on entriesBasic.entriesID = entriesGeology.entriesID"];
    
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSString *name, *projectName, *latitude, *longitude;
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
        [self.mapView addAnnotation:point];
    }
    
    
}

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

        NSString *query = [NSString stringWithFormat:@"select * from entriesBasic inner join entriesGeology on entriesBasic.entriesID = entriesGeology.entriesID"];
        
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
    [mapView setRegion:region animated:NO];
}

- (IBAction)changeMapType:(id)sender {
    //Changes the maptype
    if (mapView.mapType == MKMapTypeStandard)
        mapView.mapType = MKMapTypeSatellite;
    else
        mapView.mapType = MKMapTypeStandard;
}


@end
