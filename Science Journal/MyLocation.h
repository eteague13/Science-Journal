//
//  MyLocation.h
//  Science Journal
//
//  Created by Evan Teague on 8/28/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface MyLocation : NSObject <MKAnnotation>

- (id)initWithName:(NSString*)name coordinate:(CLLocationCoordinate2D)coordinate;
- (MKMapItem*)mapItem;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CLLocationCoordinate2D theCoordinate;

@end
