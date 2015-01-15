//
//  LocationAndWeatherController.h
//  Science Journal
//
//  Created by Evan Teague on 12/26/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocation/CoreLocation.h"
@class LocationAndWeatherController;
@protocol LocationAndWeatherControllerDelegate <NSObject>
- (void)LocationAndWeatherCancel:(LocationAndWeatherController *) controller;
- (void)LocationAndWeatherSave:(LocationAndWeatherController *)controller lat:(NSString*) lat longitude:(NSString*)longitude weather:(NSString*) weather;
@end
@interface LocationAndWeatherController : UIViewController <CLLocationManagerDelegate> {
    float latitudeValue;
    float longitudeValue;
    NSDictionary *jsonWeather;
    NSString *latitudeArea;
    NSString *longitudeArea;
    NSString *weatherArea;
}
- (IBAction)locCancelButton:(id)sender;
- (IBAction)locSaveButton:(id)sender;
- (IBAction)updateLocWeather:(id)sender;
@property (nonatomic, weak) id <LocationAndWeatherControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *latitudeField;
@property (weak, nonatomic) IBOutlet UITextField *longitudeField;
@property (weak, nonatomic) IBOutlet UITextView *weatherField;
-(void)setLat:(NSString*) latitude setLong:(NSString*) longitude setWeather:(NSString*) weather;

@end
