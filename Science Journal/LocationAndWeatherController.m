//
//  LocationAndWeatherController.m
//  Science Journal
//
//  Created by Evan Teague on 12/26/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//  Help with RESTFUL URL connections from http://www.techrepublic.com/blog/software-engineer/ios-tutorial-part-1-creating-a-web-service/

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

    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Sandcropped1.jpg"]];
    
    //Draws the text view
    CGRect frame = CGRectMake(0, 250, 320, 327);
    self.weatherField = [[NoteView alloc] initWithFrame:frame];
    [self.view addSubview:_weatherField];
    _weatherField.delegate = self;
    [_weatherField setScrollEnabled:YES];
    _latitudeField.delegate = self;
    _longitudeField.delegate = self;
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
    
    NSString *currentLocationURL = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f", latitudeValue, longitudeValue];
    NSURL *myURL = [NSURL URLWithString:currentLocationURL];
    
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
    
    NSURLConnection *myConnection = [NSURLConnection connectionWithRequest:myRequest delegate:self];
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
        
        [locationManager stopUpdatingLocation];
        
        
        
        
        
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*) response;
    
    int errorCode = httpResponse.statusCode;
    
    NSString *fileMIMEType = [[httpResponse MIMEType] lowercaseString];
    
    NSLog(@"response is %d, %@", errorCode, fileMIMEType);
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    jsonWeather = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    _weatherField.text = @"";
    //Parses the json
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
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    
    NSLog(@"Connection failed! Error - %@ %@",
          
          [error localizedDescription],
          
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

    
    NSLog(@"Succeeded!");
    
    
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
