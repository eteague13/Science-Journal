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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Sandcropped1.jpg"]];
    
    
    
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
    /*
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
     */
    mapView.centerCoordinate = userLocation.location.coordinate;
 
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView{
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
        point.subtitle = projectName;
        [self.mapView addAnnotation:point];
    }
    /*
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
     */
    
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
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
        
        // Create a UIButton object to add on the
        //UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        //[rightButton setTitle:annotation.title forState:UIControlStateNormal];
        //[annotationView setRightCalloutAccessoryView:rightButton];
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return annotationView;
    }
    
    return nil; 
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    MKPointAnnotation *location = (MKPointAnnotation*)view.annotation;
    
    NSLog(@"CLICKED");
    _selectedAnnotationName = view.annotation.title;
    [self performSegueWithIdentifier:@"annotationDetail" sender:self];
   
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"annotationDetail"])
    {

        NSLog(@"In segue");
        NSString *query = [NSString stringWithFormat:@"select * from entriesBasic inner join entriesGeology on entriesBasic.entriesID = entriesGeology.entriesID"];
        
        NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
        
        UINavigationController *navigationController = segue.destinationViewController;
        AddEntryController *annotationView = [navigationController viewControllers][0];
        annotationView.delegate = self;
        [annotationView setEditEntry:true];
        
        NSString *name, *identifier;
         for (id entry in results) {
             name = [entry objectAtIndex:1];
             identifier = [entry objectAtIndex:0];
             if ([name isEqualToString:_selectedAnnotationName]){
                annotationView.recordIDToEdit = [identifier intValue];
             }
        }

        
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
    MKUserLocation *userLocation = mapView.userLocation;
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance (
                                        userLocation.location.coordinate, 20000, 20000);
    [mapView setRegion:region animated:NO];
}

- (IBAction)changeMapType:(id)sender {
    if (mapView.mapType == MKMapTypeStandard)
        mapView.mapType = MKMapTypeSatellite;
    else
        mapView.mapType = MKMapTypeStandard;
}


@end
