//
//  ExportController.h
//  Science Journal
//
//  Created by Evan Teague on 8/18/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserEntryDatabase.h"
#import "Entry.h"

@interface ExportController : UIViewController
@property (strong, nonatomic) UserEntryDatabase *database;
- (IBAction)exportGooglEarth:(id)sender;

@end
