//
//  ExportController.m
//  Science Journal
//
//  Created by Evan Teague on 8/18/14.
//  Copyright (c) 2014 Evan Teague. All rights reserved.
//

#import "ExportController.h"
#import "DBManager.h"

@interface ExportController ()

@end


@implementation ExportController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
    
}
-(id) init{
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"entriesdb.sql"];
    
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Initialize the database connection
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"entriesdb.sql"];
    
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Sandcropped1.jpg"]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//Export all entries to Google Earth
- (void)exportAllProjects {
    //Queries the database
    NSString *allProjectsQuery = @"select projectName from projects";
    NSArray *allProjects = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:allProjectsQuery]];
    for (id project in allProjects){
        NSString *query = [NSString stringWithFormat:@"select * from entriesBasic where projectName = '%@'", [project objectAtIndex:0]];
        NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
        NSString *identifer, *name, *date, *projectName, *goal, *latitude, *longitude, *weather, *notes, *permissions, *sampleNum, *partners, *dataSheet, *outcrop, *structuralData, *strike, *dip, *trend, *plunge, *stopNum;
        UIImage *sketch;
        UIImage *picture;
        NSMutableString *printString = [[NSMutableString alloc] init];
        [printString appendFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<kml xmlns=\"http://www.opengis.net/kml/2.2\">\n\t<Folder>"];
        [printString appendFormat:@"\n\t<name>Entries by Project: %@</name>", [project objectAtIndex:0]];
        
        for (id entry in results) {
            identifer = [entry objectAtIndex:0];
            name = [entry objectAtIndex:1];
            projectName = [entry objectAtIndex:2];
            date = [entry objectAtIndex:3];
            goal = [entry objectAtIndex:4];
            latitude = [entry objectAtIndex:5];
            longitude = [entry objectAtIndex:6];
            weather = [entry objectAtIndex:7];
            sketch = [entry objectAtIndex:8];
            picture = [entry objectAtIndex:9];
            notes = [entry objectAtIndex:10];
            permissions = [entry objectAtIndex:11];
            sampleNum = [entry objectAtIndex:12];
            partners = [entry objectAtIndex:13];
            dataSheet = [entry objectAtIndex:14];
            outcrop = [entry objectAtIndex:15];
            structuralData = [entry objectAtIndex:16];
            strike = [entry objectAtIndex:17];
            dip = [entry objectAtIndex:18];
            trend = [entry objectAtIndex:19];
            plunge = [entry objectAtIndex:20];
            stopNum = [entry objectAtIndex:21];
            
            [printString appendString:@"\n\t<Placemark>"];
            [printString appendFormat:@"\n\t<name>%@</name>", name];
            [printString appendFormat:@"\n\t\t<description>Project Name: %@\n", projectName];
            if ([date length] > 0){
                [printString appendFormat:@"Date: %@\n", date];
            }
            if ([goal length] > 0){
                [printString appendFormat:@"Goal: %@\n", goal];
            }
            if ([weather length] > 0){
                [printString appendFormat:@"Weather: %@\n", weather];
            }
            if ([notes length] > 0){
                [printString appendFormat:@"Notes: %@\n", notes];
            }
            if ([permissions length] > 0){
                [printString appendFormat:@"Permissions: %@\n", permissions];
            }
            if ([sampleNum length] > 0){
                [printString appendFormat:@"Sample Number: %@\n", sampleNum];
            }
            if ([partners length] > 0){
                [printString appendFormat:@"Partners: %@\n", partners];
            }
            if ([dataSheet length] > 0){
                [printString appendFormat:@"Datasheet: %@\n", dataSheet];
            }
            if ([outcrop length] > 0){
                [printString appendFormat:@"Outcrop Description: %@\n", outcrop];
            }
            if ([structuralData length] > 0){
                [printString appendFormat:@"Structural Data: %@\n", structuralData];
            }
            if ([strike length] > 0){
                [printString appendFormat:@"Strike: %@\n", strike];
            }
            if ([dip length] > 0){
                [printString appendFormat:@"Dip: %@\n", dip];
            }
            if ([trend length] > 0){
                [printString appendFormat:@"Trend: %@\n", trend];
            }
            if ([plunge length] > 0){
                [printString appendFormat:@"Plunge: %@\n", plunge];
            }
            if ([stopNum length] > 0){
                [printString appendFormat:@"StopNum: %@\n", stopNum];
            }
            [printString appendFormat:@"</description>"];
            [printString appendString:@"\n\t\t<Point>"];
            [printString appendFormat:@"\n\t\t<coordinates>%@, %@, 0</coordinates>", longitude, latitude];
            [printString appendString:@"\n\t\t</Point>"];
            [printString appendString:@"\n\t</Placemark>"];
            
            
        }

        [printString appendString:@"\n\t</Folder>\n</kml>"];
        
        NSError *error;
        NSString *documentsDirectory = [NSHomeDirectory()
                                        stringByAppendingPathComponent:@"Documents"];
        NSString *fileName = [NSMutableString stringWithFormat:@"%@.kml", [project objectAtIndex:0]];
        NSString *filePath = [documentsDirectory
                              stringByAppendingPathComponent:fileName];
        
        [printString writeToFile:filePath atomically:YES
                        encoding:NSUTF8StringEncoding error:&error];
        
        NSLog(@"%@", filePath);
    }
    
    
    
    
    
    
    
    
    
    
    
}


-(void)exportSelectedProjects:(NSMutableArray *) projects {
    
    
    NSLog(@"In Export Selected Projects");
    
    for (id project in projects) {
        NSMutableString *printString = [[NSMutableString alloc] init];
        [printString appendFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<kml xmlns=\"http://www.opengis.net/kml/2.2\">\n\t<Folder>"];
        ProjectCell *cell = project;
        NSString *projectNm = cell.projectLabel.text;
        NSLog(@"Project name: %@", projectNm);
        NSString *query = [NSString stringWithFormat:@"select * from entriesBasic where projectName = '%@'", projectNm];
        NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
        
        NSString *identifer, *name, *date, *projectName, *goal, *latitude, *longitude, *weather, *notes, *permissions, *sampleNum, *partners, *dataSheet, *outcrop, *structuralData, *strike, *dip, *trend, *plunge, *stopNum;
        UIImage *sketch;
        UIImage *picture;
        
        [printString appendFormat:@"\n\t<name>Entries by Project: %@</name>", projectNm];
        for (id entry in results) {
            identifer = [entry objectAtIndex:0];
            name = [entry objectAtIndex:1];
            projectName = [entry objectAtIndex:2];
            date = [entry objectAtIndex:3];
            goal = [entry objectAtIndex:4];
            latitude = [entry objectAtIndex:5];
            longitude = [entry objectAtIndex:6];
            weather = [entry objectAtIndex:7];
            sketch = [entry objectAtIndex:8];
            picture = [entry objectAtIndex:9];
            notes = [entry objectAtIndex:10];
            permissions = [entry objectAtIndex:11];
            sampleNum = [entry objectAtIndex:12];
            partners = [entry objectAtIndex:13];
            dataSheet = [entry objectAtIndex:14];
            outcrop = [entry objectAtIndex:15];
            structuralData = [entry objectAtIndex:16];
            strike = [entry objectAtIndex:17];
            dip = [entry objectAtIndex:18];
            trend = [entry objectAtIndex:19];
            plunge = [entry objectAtIndex:20];
            stopNum = [entry objectAtIndex:21];
            
            
            [printString appendString:@"\n\t<Placemark>"];
            [printString appendFormat:@"\n\t<name>%@</name>", name];
            [printString appendFormat:@"\n\t\t<description>Project Name: %@\n", projectName];
            if ([date length] > 0){
                [printString appendFormat:@"Date: %@\n", date];
            }
            if ([goal length] > 0){
                [printString appendFormat:@"Goal: %@\n", goal];
            }
            if ([weather length] > 0){
                [printString appendFormat:@"Weather: %@\n", weather];
            }
            if ([notes length] > 0){
                [printString appendFormat:@"Notes: %@\n", notes];
            }
            if ([permissions length] > 0){
                [printString appendFormat:@"Permissions: %@\n", permissions];
            }
            if ([sampleNum length] > 0){
                [printString appendFormat:@"Sample Number: %@\n", sampleNum];
            }
            if ([partners length] > 0){
                [printString appendFormat:@"Partners: %@\n", partners];
            }
            if ([dataSheet length] > 0){
                [printString appendFormat:@"Datasheet: %@\n", dataSheet];
            }
            if ([outcrop length] > 0){
                [printString appendFormat:@"Outcrop Description: %@\n", outcrop];
            }
            if ([structuralData length] > 0){
                [printString appendFormat:@"Structural Data: %@\n", structuralData];
            }
            if ([strike length] > 0){
                [printString appendFormat:@"Strike: %@\n", strike];
            }
            if ([dip length] > 0){
                [printString appendFormat:@"Dip: %@\n", dip];
            }
            if ([trend length] > 0){
                [printString appendFormat:@"Trend: %@\n", trend];
            }
            if ([plunge length] > 0){
                [printString appendFormat:@"Plunge: %@\n", plunge];
            }
            if ([stopNum length] > 0){
                [printString appendFormat:@"StopNum: %@\n", stopNum];
            }
            [printString appendFormat:@"</description>"];
            [printString appendString:@"\n\t\t<Point>"];
            [printString appendFormat:@"\n\t\t<coordinates>%@, %@, 0</coordinates>", longitude, latitude];
            [printString appendString:@"\n\t\t</Point>"];
            [printString appendString:@"\n\t</Placemark>"];
            
            
        }
        
        
        [printString appendString:@"\n\t</Folder>\n</kml>"];

        NSError *error;
        NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *fileName = [NSMutableString stringWithFormat:@"%@.kml", projectNm];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
            
        NSLog(@"string to write:%@", printString);
            
        [printString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    }
    
    

}
@end
