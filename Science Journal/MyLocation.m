//
//  MyLocation.m
//  Science Journal
//
//  Created by Evan Teague on 8/28/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import "MyLocation.h"




@implementation MyLocation

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        if ([name isKindOfClass:[NSString class]]) {
            self.name = name;
        } else {
            self.name = @"Unknown charge";
        }
        self.theCoordinate = coordinate;
    }
    return self;
}

- (NSString *)title {
    return _name;
}


- (CLLocationCoordinate2D)coordinate {
    return _theCoordinate;
}

/*
- (MKMapItem*)mapItem {
    
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:self.coordinate];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    
    return mapItem;
}
 */

@end
