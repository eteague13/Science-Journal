//
//  Entry.m
//  Science Journal
//
//  Created by Evan Teague on 8/25/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import "Entry.h"

@implementation Entry

//- (id)initWithTitle:(NSString*)title artist:(NSString*)artist coverUrl:(NSString*)coverUrl year:(NSString*)year
- (id)initWithTitle:(NSString*)name date:(NSString*) date projectName:(NSString*)projectName goal:(NSString*)goal latitude:(NSString*)latitude longitude:(NSString*)longitude weather:(NSString*)weather magnet:(NSString*)magnet partners:(NSString*)partners permissions:(NSString*)permissions outcrop:(NSString*)outcrop structuralData:(NSString*)structuralData sampleNum:(NSString*)sampleNum notes:(NSString*)notes
{
    self = [super init];
    if (self)
    {
        _name = name;
        _date = date;
        _projectName = projectName;
        _goal = goal;
        _latitude = latitude;
        _longitude = longitude;
        _weather = weather;
        _magnet = magnet;
        _partners = partners;
        _permissions = permissions;
        _outcrop = outcrop;
        _structuralData = structuralData;
        _sampleNum = sampleNum;
        _notes = notes;
        
    }
    return self;
}
@end
