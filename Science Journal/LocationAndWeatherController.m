//
//  LocationAndWeatherController.m
//  Science Journal
//
//  Created by Evan Teague on 12/26/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import "LocationAndWeatherController.h"

@interface LocationAndWeatherController ()

@end

@implementation LocationAndWeatherController{
    CLLocationManager *locationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
    if ([latitudeArea length] != 0){
        _latitudeField.text = latitudeArea;
    }
    if ([longitudeArea length] != 0){
        _longitudeField.text = longitudeArea;
    }
    if ([weatherArea length] != 0){
        _weatherField.text = weatherArea;
    }
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Sandcropped1.jpg"]];
    
    CGRect frame = CGRectMake(0, 250, 320, 327);
    self.weatherField = [[NoteView alloc] initWithFrame:frame];
    [self.view addSubview:_weatherField];
    _weatherField.delegate = self;
    [_weatherField setScrollEnabled:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)locCancelButton:(id)sender {
    [self.delegate LocationAndWeatherCancel:self];
}

- (IBAction)locSaveButton:(id)sender {
    [self.delegate LocationAndWeatherSave:self lat:(NSString*) _latitudeField.text longitude:(NSString*)_longitudeField.text weather:(NSString*) _weatherField.text];
}

- (IBAction)updateLocWeather:(id)sender {
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    NSLog(@"Get somewhere outside!");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        latitudeValue = currentLocation.coordinate.latitude;
        longitudeValue = currentLocation.coordinate.longitude;
        NSLog(@"Latitude: %f", latitudeValue);
        _latitudeField.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        _longitudeField.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        
        NSString *currentLocationURL = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f", latitudeValue, longitudeValue];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:currentLocationURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            jsonWeather = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"JSON: %@", jsonWeather);
        }];
        [dataTask resume];
        _weatherField.text = @"";
        for (id key in jsonWeather){
            

            if ([key isEqualToString:@"main"]){
                NSString *humidity = [NSString stringWithFormat:@"Humidity: %@%%",[[jsonWeather objectForKey:key] objectForKey: @"humidity"]];
                _weatherField.text = [_weatherField.text stringByAppendingString:humidity];
                _weatherField.text = [_weatherField.text stringByAppendingString:@"\n"];
                
                NSString *pressure = [NSString stringWithFormat:@"Pressue: %@ hPa", [[jsonWeather objectForKey:key] objectForKey: @"pressure"]];
                _weatherField.text = [_weatherField.text stringByAppendingString:pressure];
                _weatherField.text = [_weatherField.text stringByAppendingString:@"\n"];
                
                float tempKelvin = [[[jsonWeather objectForKey:key] objectForKey: @"temp"] floatValue];
                float tempCelcius = tempKelvin - 273.15;
                NSString *temperature = [NSString stringWithFormat:@"Temperature: %f C", tempCelcius];
                _weatherField.text = [_weatherField.text stringByAppendingString:temperature];
                _weatherField.text = [_weatherField.text stringByAppendingString:@"\n"];
            }
            if ([key isEqualToString:@"wind"]){
                NSString *windDegree = [NSString stringWithFormat:@"Wind Degree: %@ degrees", [[jsonWeather objectForKey:key] objectForKey: @"deg"]];
                _weatherField.text = [_weatherField.text stringByAppendingString:windDegree];
                _weatherField.text = [_weatherField.text stringByAppendingString:@"\n"];
                NSString *windSpeed = [NSString stringWithFormat:@"Wind Speed: %@ mps", [[jsonWeather objectForKey:key] objectForKey: @"speed"]];
                _weatherField.text = [_weatherField.text stringByAppendingString:windSpeed];
                _weatherField.text = [_weatherField.text stringByAppendingString:@"\n"];
            }
            
        }
        [locationManager stopUpdatingLocation];
        
        
        
        
        
    }
}

-(void)setLat:(NSString*) latitude setLong:(NSString*) longitude setWeather:(NSString*) weather{
    latitudeArea = latitude;
    longitudeArea = longitude;
    weatherArea = weather;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_weatherField setNeedsDisplay];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    CGRect frame = CGRectMake(0, 250, 320, 327);
    _weatherField.frame = frame;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    CGRect frame = CGRectMake(0, 250, 320, 327);
    _weatherField.frame = frame;
}
@end
