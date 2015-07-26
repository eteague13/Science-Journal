//
//  LocationAndWeatherController.h
//  Science Journal
//
//  Created by Evan Teague on 12/26/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocation/CoreLocation.h"
#import "NoteView.h"

//Delegate
@class LocationAndWeatherController;
@protocol LocationAndWeatherControllerDelegate <NSObject>
- (void)LocationAndWeatherCancel:(LocationAndWeatherController *) controller;
- (void)LocationAndWeatherSave:(LocationAndWeatherController *)controller lat:(NSString*) lat longitude:(NSString*)longitude weather:(NSString*) weather;
@end

@interface LocationAndWeatherController : UIViewController <CLLocationManagerDelegate, UITextFieldDelegate, UITextViewDelegate> {
    float latitudeValue;
    float longitudeValue;
    NSDictionary *jsonWeather;
    NSString *latitudeArea;
    NSString *longitudeArea;
    NSString *weatherArea;
    int updatingLocation;
    int bestAccuracyObtained;
}

//IBOutlets
@property (weak, nonatomic) IBOutlet UITextField *latitudeField;
@property (weak, nonatomic) IBOutlet UITextField *longitudeField;
@property (weak, nonatomic) IBOutlet UIButton *updateLocWeatherButton;



//IBActions
- (IBAction)locCancelButton:(id)sender;
- (IBAction)locSaveButton:(id)sender;
- (IBAction)updateLocWeather:(id)sender;


//Variables
@property (nonatomic, weak) id <LocationAndWeatherControllerDelegate> delegate;
@property (nonatomic, retain) NoteView *weatherField;
@property (nonatomic, strong) CLLocationManager *locManager;
@property (nonatomic, strong) CLLocation *bestEffortAtLocation;
@property (nonatomic, strong) UIActivityIndicatorView *gettingLocationIndicator;
@property (weak, nonatomic) UITextView *activeField;

//Methods
-(void)setLat:(NSString*) latitude setLong:(NSString*) longitude setWeather:(NSString*) weather;




@end
