//
//  UserEntryDatabase.h
//  Science Journal
//
//  Created by Evan Teague on 8/25/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entry.h"

@interface UserEntryDatabase : NSObject

@property (strong, nonatomic) NSMutableArray *entries;
+(UserEntryDatabase *)userEntryDatabase;
- (NSArray*)getEntries;
- (void)addEntry:(Entry*)entry;
- (void)deleteEntryAtIndex:(int)index;
- (Entry*)getEntryAtIndex:(long)index;

@end
