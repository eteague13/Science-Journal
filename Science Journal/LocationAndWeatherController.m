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

@implementation LocationAndWeatherController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    _locManager = [[CLLocationManager alloc] init];
    
    
    
    if ([_locManager respondsToSelector:
         @selector(requestWhenInUseAuthorization)]) {
        [_locManager requestWhenInUseAuthorization];
    }
    updatingLocation = 0;
    bestAccuracyObtained = 0;
    
    
    //Draws the text view
    CGRect frame = CGRectMake(0, 200, 320, 375);
    self.weatherField = [[NoteView alloc] initWithFrame:frame];
    
    CGRect activityFrame = CGRectMake(150,142,20,20);
    self.gettingLocationIndicator = [[UIActivityIndicatorView alloc] initWithFrame:activityFrame];
    
    _weatherField.delegate = self;
    [_weatherField setScrollEnabled:YES];
    _latitudeField.delegate = self;
    _longitudeField.delegate = self;
    
    //Sets the editable text
    if ([latitudeArea length] != 0){
        _latitudeField.text = latitudeArea;
    }
    if ([longitudeArea length] != 0){
        _longitudeField.text = longitudeArea;
    }
    if ([weatherArea length] != 0){
        _weatherField.text = weatherArea;
    }
    //Adds the weather textview to the controller
    [self.view addSubview:_weatherField];
    
    [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//If the user selects cancel
- (IBAction)locCancelButton:(id)sender {
    if (updatingLocation){
        NSString *statusCode3 = @"0";
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocationWithMessage:) object:nil];
        [self stopUpdatingLocationWithMessage:statusCode3];
    }
    [self.delegate LocationAndWeatherCancel:self];
}

//If the user saves the data
- (IBAction)locSaveButton:(id)sender {
    if (updatingLocation){
        NSString *statusCode3 = @"0";
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocationWithMessage:) object:nil];
        [self stopUpdatingLocationWithMessage:statusCode3];
        [self.delegate LocationAndWeatherSave:self lat:(NSString*) _latitudeField.text longitude:(NSString*)_longitudeField.text weather:(NSString*) _weatherField.text];
    }else{
        [self.delegate LocationAndWeatherSave:self lat:(NSString*) _latitudeField.text longitude:(NSString*)_longitudeField.text weather:(NSString*) _weatherField.text];
    }
    
}

//Action called when the user presses the get location and weather button
- (IBAction)updateLocWeather:(id)sender {
    _bestEffortAtLocation = nil;
    _locManager.delegate = self;
    _locManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locManager requestWhenInUseAuthorization];
    [_locManager startUpdatingLocation];
    updatingLocation = 1;
    [self.view addSubview:_gettingLocationIndicator];
    [_gettingLocationIndicator startAnimating];
    NSTimeInterval timeout = 10.0;
    NSString *statusCode = @"1";
    [self performSelector:@selector(stopUpdatingLocationWithMessage:) withObject:statusCode afterDelay:timeout];
    
    //Uses a RESTful API to get the weather data
    _weatherField.text = @"";
    NSString *currentLocationURL = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f", latitudeValue, longitudeValue];
    NSURL *myURL = [NSURL URLWithString:currentLocationURL];
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
    NSURLConnection *myConnection = [NSURLConnection connectionWithRequest:myRequest delegate:self];
}

//Delegate method for CLLocationManager
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    NSLog(@"Get somewhere outside!");
}

//Delegate method for CLLocationManager that updates the current location
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{

    // test the age of the location measurement to determine if the measurement is cached
    // in most cases you will not want to rely on cached measurements
    //
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) {
        return;
    }
    
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) {
        return;
    }
    NSLog(@"Accuracy: %f", newLocation.horizontalAccuracy);
    if (self.bestEffortAtLocation == nil || self.bestEffortAtLocation.horizontalAccuracy > newLocation.horizontalAccuracy) {
        _bestEffortAtLocation = newLocation;
        CLLocationAccuracy accuracy = 10;
        NSLog(@"Desired accuracy %f, Horizontal accuracy %f", accuracy, newLocation.horizontalAccuracy);
        if (newLocation.horizontalAccuracy <= accuracy) {
            NSString *statusCode2 = @"1";
            
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocationWithMessage:) object:nil];
            
            updatingLocation = 0;
            bestAccuracyObtained = 1;
            
            [self stopUpdatingLocationWithMessage:statusCode2];
            
            NSLog(@"Best accuracy: %d, Location updating status: %d", bestAccuracyObtained, updatingLocation);
            
            
        }
        
    }
    
}

//Delegate method that deals with getting the weather data from the RESTful API json response
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*) response;
    
    int errorCode = (int)httpResponse.statusCode;
    
    NSString *fileMIMEType = [[httpResponse MIMEType] lowercaseString];
    
    //Internal testing code
    NSLog(@"response is %d, %@", errorCode, fileMIMEType);
    
}

//What happens when the data is received from the weather URL
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    jsonWeather = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    
    //Parses the json
    for (id key in jsonWeather){
        if ([key isEqualToString:@"main"]){
            NSString *humidity = [NSString stringWithFormat:@"Humidity: %@%%",[[jsonWeather objectForKey:key] objectForKey: @"humidity"]];
            _weatherField.text = [_weatherField.text stringByAppendingString:humidity];
            _weatherField.text = [_weatherField.text stringByAppendingString:@"\n"];
            
            NSString *pressure = [NSString stringWithFormat:@"Pressure: %@ hPa", [[jsonWeather objectForKey:key] objectForKey: @"pressure"]];
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


//Delegate method for the URL connection
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    
    NSLog(@"Connection failed! Error - %@ %@",
          
          [error localizedDescription],
          
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
}

//Delegate method for the URL connection
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

    NSLog(@"Succeeded!");
}

//Passes the information to the editable entrypage
-(void)setLat:(NSString*) latitude setLong:(NSString*) longitude setWeather:(NSString*) weather{
    latitudeArea = latitude;
    longitudeArea = longitude;
    weatherArea = weather;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_weatherField setNeedsDisplay];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    CGRect frame = CGRectMake(0, 200, 320, 375);
    _weatherField.frame = frame;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    CGRect frame = CGRectMake(0, 200, 320, 375);
    _weatherField.frame = frame;
}

//Status codes: 0-User exited location window early, 1-Location obtained correctly
- (void)stopUpdatingLocationWithMessage:(NSString*)status {
    
    [_locManager stopUpdatingLocation];
    _locManager.delegate = nil;
    [_gettingLocationIndicator stopAnimating];
    [_gettingLocationIndicator removeFromSuperview];
    
    
    
    if (bestAccuracyObtained == 0 && [status intValue] == 1){
        latitudeValue = _bestEffortAtLocation.coordinate.latitude;
        longitudeValue = _bestEffortAtLocation.coordinate.longitude;
        _latitudeField.text = [NSString stringWithFormat:@"%.8f", latitudeValue];
        _longitudeField.text = [NSString stringWithFormat:@"%.8f", longitudeValue];
        _weatherField.text = [_weatherField.text stringByAppendingString:@"\n"];
        NSString *accuracyString = [NSString stringWithFormat:@"Location recorded within %.f m of accuracy", _bestEffortAtLocation.horizontalAccuracy];
        _weatherField.text = [_weatherField.text stringByAppendingString: accuracyString];
        _weatherField.text = [_weatherField.text stringByAppendingString:@"\n"];
    }else if (bestAccuracyObtained == 1 && [status intValue] == 1){
        latitudeValue = _bestEffortAtLocation.coordinate.latitude;
        longitudeValue = _bestEffortAtLocation.coordinate.longitude;
        _latitudeField.text = [NSString stringWithFormat:@"%.8f", latitudeValue];
        _longitudeField.text = [NSString stringWithFormat:@"%.8f", longitudeValue];
        _weatherField.text = [_weatherField.text stringByAppendingString:@"\n"];
        NSString *accuracyString = [NSString stringWithFormat:@"Location recorded within %.f m of accuracy", _bestEffortAtLocation.horizontalAccuracy];
        _weatherField.text = [_weatherField.text stringByAppendingString: accuracyString];
        _weatherField.text = [_weatherField.text stringByAppendingString:@"\n"];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    [aTextField resignFirstResponder];
    return YES;
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _weatherField.contentInset = contentInsets;
    _weatherField.scrollIndicatorInsets = contentInsets;
    /*
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, _activeField.frame.origin) ) {
        [_weatherField scrollRectToVisible:_activeField.frame animated:YES];
    }
     */
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _weatherField.contentInset = contentInsets;
    _weatherField.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextView *)textView
{
    _activeField = textView;
}

- (void)textFieldDidEndEditing:(UITextField *)textView
{
    _activeField = nil;
}



@end
