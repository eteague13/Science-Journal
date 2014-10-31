//
//  UserEntryDatabase.m
//  Science Journal
//
//  Created by Evan Teague on 8/25/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import "UserEntryDatabase.h"
#import "Entry.h"

/*
@interface UserEntryDatabase () {
    NSMutableArray *entries;
}
 */
@implementation UserEntryDatabase

@synthesize entries;
+(UserEntryDatabase *)userEntryDatabase {
    /*
    static UserEntryDatabase * single=nil;
    @synchronized(self)
    {
        if(!single)
        {
            single = [[UserEntryDatabase alloc] init];
            
                
        }
            
    }
    return single;
     */
    static dispatch_once_t pred;
    static UserEntryDatabase *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[UserEntryDatabase alloc] init];
        shared.entries = [[NSMutableArray alloc]init];
    });
    return shared;
}

-(void)addEntry:(Entry *)entry {
    NSLog(@"%@", entry.name);
    [entries addObject:entry];
}
-(Entry*)getEntryAtIndex:(long)index{
    return [entries objectAtIndex:index];
}

/*
- (id)init
{
    /*
    self = [super init];
    if (self) {
    	// a dummy list of albums
        _entries = [NSMutableArray arrayWithArray:
                  @[[[Entry alloc] initWithTitle:@"1" date:@"2", projectName:@"3", goal:@"4", latitude:@"5", longitude:@"6", weather:@"7", magnet:@"8", partners:@"9", permissions:@"10", outcrop:@"11", structuralData:@"12", sampleNum:@"13", notes:@"14"]]];
                   
    }
     
    entries = [[NSMutableArray alloc] init];
    return self;
}
*/



- (NSArray*)getEntries {
    return entries;
}

- (void)deleteEntryAtIndex:(int)index {
    [entries removeObjectAtIndex:index];
}

@end
