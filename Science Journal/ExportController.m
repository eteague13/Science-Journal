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
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"FieldBookdb.sql"];
    
    _dataArray = [[NSMutableDictionary alloc] init];
    
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Export all projects to Google Earth
- (void)exportAllProjects {
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
        
    }
    
    
}

//Export selected projects to Google Earth
-(void)exportSelectedProjects:(NSMutableArray *) projects {
    
    for (id project in projects) {
        NSMutableString *printString = [[NSMutableString alloc] init];
        [printString appendFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<kml xmlns=\"http://www.opengis.net/kml/2.2\">\n\t<Folder>"];
        NSString *projectNm = project;
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
            
        [printString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    }
    
    

}


-(void)exportAllToPDF{
    //Get all the projects
    NSString *allProjectsQuery = @"select projectName from projects";
    NSArray *allProjects = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:allProjectsQuery]];
    
    //Go through all the projects
    for (id project in allProjects){
        
        //Create the PDF file path
        NSString* fileName = [NSString stringWithFormat:@"%@.pdf", [project objectAtIndex:0]];
        NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
        NSString *path = [arrayPaths objectAtIndex:0];
        NSString* pdfFileName = [path stringByAppendingPathComponent:fileName];
        
        //Begin the pdf
        UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectZero, nil);
        
        //Get the info from the database for each project
        NSString *query = [NSString stringWithFormat:@"select * from entriesBasic where projectName = '%@'", [project objectAtIndex:0]];
        NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
        NSString *identifer, *name, *date, *projectName, *goal, *latitude, *longitude, *weather, *notes, *permissions, *sampleNum, *partners, *dataSheet, *outcrop, *structuralData, *strike, *dip, *trend, *plunge, *stopNum;
        NSString *sketch;
        NSString *picture;
        
        for (id entry in results) {
            // Mark the beginning of a new page.
            UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 850, 1100), nil);
            
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
            
            
            NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:14]};
            int yHeight = 26;
            
            NSString *projectNameString = [NSString stringWithFormat:@"Project Name: %@", projectName];
            CGRect paragraphRect1 = [projectNameString boundingRectWithSize:CGSizeMake(800, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
            paragraphRect1.origin.x = 20;
            paragraphRect1.origin.y = yHeight;
            [projectNameString drawInRect:paragraphRect1 withAttributes:attributes];
            yHeight += paragraphRect1.size.height;
            
            if (yHeight > 1100){
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 850, 1100), nil);
                yHeight = 26;
            }
            NSString *nameString = [NSString stringWithFormat:@"Entry Name: %@", name];
            CGRect paragraphRect = [nameString boundingRectWithSize:CGSizeMake(800, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
            paragraphRect.origin.x = 20;
            paragraphRect.origin.y = yHeight;
            [nameString drawInRect:paragraphRect withAttributes:attributes];
            yHeight += paragraphRect.size.height;
            
            if (yHeight > 1100){
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 850, 1100), nil);
                yHeight = 26;
            }
            if ([date length] > 0){
            NSString *dateString = [NSString stringWithFormat:@"Date: %@", date];
            CGRect paragraphRect2 = [dateString boundingRectWithSize:CGSizeMake(800, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
            paragraphRect2.origin.x = 20;
            paragraphRect2.origin.y = yHeight;
            [dateString drawInRect:paragraphRect2 withAttributes:attributes];
            yHeight += paragraphRect2.size.height;
            
            if (yHeight > 1100){
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 850, 1100), nil);
                yHeight = 26;
            }
            }
            if ([goal length] > 0){
            NSString *goalString = [NSString stringWithFormat:@"Goal: %@", goal];
            CGRect paragraphRect3 = [goalString boundingRectWithSize:CGSizeMake(800, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
            paragraphRect3.origin.x = 20;
            paragraphRect3.origin.y = yHeight;
            [goalString drawInRect:paragraphRect3 withAttributes:attributes];
            yHeight += paragraphRect3.size.height;
            
            if (yHeight > 1100){
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 850, 1100), nil);
                yHeight = 26;
            }
            }
            if ([latitude length] > 0){
            NSString *latitudeString = [NSString stringWithFormat:@"Latitude: %@", latitude];
            CGRect paragraphRect4 = [latitudeString boundingRectWithSize:CGSizeMake(800, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
            paragraphRect4.origin.x = 20;
            paragraphRect4.origin.y = yHeight;
            [latitudeString drawInRect:paragraphRect4 withAttributes:attributes];
            yHeight += paragraphRect4.size.height;
            
            if (yHeight > 1100){
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 850, 1100), nil);
                yHeight = 26;
            }
            }
            if ([longitude length] > 0){
            NSString *longitudeString = [NSString stringWithFormat:@"Longitude: %@", longitude];
            CGRect paragraphRect5 = [longitudeString boundingRectWithSize:CGSizeMake(800, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
            paragraphRect5.origin.x = 20;
            paragraphRect5.origin.y = yHeight;
            [longitudeString drawInRect:paragraphRect5 withAttributes:attributes];
            yHeight += paragraphRect5.size.height;
            
            if (yHeight > 1100){
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 850, 1100), nil);
                yHeight = 26;
            }
            }
            if ([weather length] > 0){
            NSString *weatherString = weather;
            CGRect paragraphRect6 = [weatherString boundingRectWithSize:CGSizeMake(800, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
            paragraphRect6.origin.x = 20;
            paragraphRect6.origin.y = yHeight;
            [weatherString drawInRect:paragraphRect6 withAttributes:attributes];
            yHeight += paragraphRect6.size.height;
            
            if (yHeight > 1100){
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 850, 1100), nil);
                yHeight = 26;
            }
            }
            if ([notes length] > 0){
            NSString *notesString = [NSString stringWithFormat:@"Notes: %@", notes];
            CGRect paragraphRect7 = [notesString boundingRectWithSize:CGSizeMake(800, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
            paragraphRect7.origin.x = 20;
            paragraphRect7.origin.y = yHeight;
            [notesString drawInRect:paragraphRect7 withAttributes:attributes];
            yHeight += paragraphRect7.size.height;
            
            
            if (yHeight > 1100){
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 850, 1100), nil);
                yHeight = 26;
            }
            }
            if ([permissions length] > 0){
            NSString *permissionsString = [NSString stringWithFormat:@"Permissions: %@", permissions];
            CGRect paragraphRect8 = [permissionsString boundingRectWithSize:CGSizeMake(800, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
            paragraphRect8.origin.x = 20;
            paragraphRect8.origin.y = yHeight;
            [permissionsString drawInRect:paragraphRect8 withAttributes:attributes];
            yHeight += paragraphRect8.size.height;
            
            if (yHeight > 1100){
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 850, 1100), nil);
                yHeight = 26;
            }
            }
            if ([sampleNum length] > 0){
            NSString *sampleNumString = [NSString stringWithFormat:@"Sample Number: %@", sampleNum];
            CGRect paragraphRect9 = [sampleNumString boundingRectWithSize:CGSizeMake(800, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
            paragraphRect9.origin.x = 20;
            paragraphRect9.origin.y = yHeight;
            [sampleNumString drawInRect:paragraphRect9 withAttributes:attributes];
            yHeight += paragraphRect9.size.height;
            
            if (yHeight > 1100){
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 850, 1100), nil);
                yHeight = 26;
            }
            }
            if ([partners length] > 0){
            NSString *partnersString = [NSString stringWithFormat:@"Partners: %@", partners];
            CGRect paragraphRect10 = [partnersString boundingRectWithSize:CGSizeMake(800, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
            paragraphRect10.origin.x = 20;
            paragraphRect10.origin.y = yHeight;
            [partnersString drawInRect:paragraphRect10 withAttributes:attributes];
            yHeight += paragraphRect10.size.height;
            
            if (yHeight > 1100){
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 850, 1100), nil);
                yHeight = 26;
            }
            }
            if ([outcrop length] > 0){
            NSString *outcropString = [NSString stringWithFormat:@"Outcrop Description: %@", outcrop];
            CGRect paragraphRect11 = [outcropString boundingRectWithSize:CGSizeMake(800, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
            paragraphRect11.origin.x = 20;
            paragraphRect11.origin.y = yHeight;
            [outcropString drawInRect:paragraphRect11 withAttributes:attributes];
            yHeight += paragraphRect11.size.height;
            
            if (yHeight > 1100){
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 850, 1100), nil);
                yHeight = 26;
            }
            }
            if ([structuralData length] > 0){
            NSString *structString = [NSString stringWithFormat:@"Structural Data: %@", structuralData];
            CGRect paragraphRect12 = [structString boundingRectWithSize:CGSizeMake(800, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
            paragraphRect12.origin.x = 20;
            paragraphRect12.origin.y = yHeight;
            [structString drawInRect:paragraphRect12 withAttributes:attributes];
            yHeight += paragraphRect12.size.height;
            
            if (yHeight > 1100){
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 850, 1100), nil);
                yHeight = 26;
            }
            }
            if ([strike length] > 0){
            NSString *strikeString = [NSString stringWithFormat:@"Strike: %@", strike];
            CGRect paragraphRect13 = [strikeString boundingRectWithSize:CGSizeMake(800, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
            paragraphRect13.origin.x = 20;
            paragraphRect13.origin.y = yHeight;
            [strikeString drawInRect:paragraphRect13 withAttributes:attributes];
            yHeight += paragraphRect13.size.height;
            
            if (yHeight > 1100){
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 850, 1100), nil);
                yHeight = 26;
            }
            }
            if ([dip length] > 0){
            NSString *dipString = [NSString stringWithFormat:@"Dip: %@", dip];
            CGRect paragraphRect14 = [dipString boundingRectWithSize:CGSizeMake(800, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
            paragraphRect14.origin.x = 20;
            paragraphRect14.origin.y = yHeight;
            [dipString drawInRect:paragraphRect14 withAttributes:attributes];
            yHeight += paragraphRect14.size.height;
            
            if (yHeight > 1100){
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 850, 1100), nil);
                yHeight = 26;
            }
            }
            if ([trend length] > 0){
            NSString *trendString = [NSString stringWithFormat:@"Trend: %@", trend];
            CGRect paragraphRect15 = [trendString boundingRectWithSize:CGSizeMake(800, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
            paragraphRect15.origin.x = 20;
            paragraphRect15.origin.y = yHeight;
            [trendString drawInRect:paragraphRect15 withAttributes:attributes];
            yHeight += paragraphRect15.size.height;
            
            if (yHeight > 1100){
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 850, 1100), nil);
                yHeight = 26;
            }
            }
            if ([plunge length] > 0){
            NSString *plungeString = [NSString stringWithFormat:@"Plunge: %@", plunge];
            CGRect paragraphRect16 = [plungeString boundingRectWithSize:CGSizeMake(800, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
            paragraphRect16.origin.x = 20;
            paragraphRect16.origin.y = yHeight;
            [plungeString drawInRect:paragraphRect16 withAttributes:attributes];
            yHeight += paragraphRect16.size.height;
            
            if (yHeight > 1100){
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 850, 1100), nil);
                yHeight = 26;
            }
            }
            if ([stopNum length] > 0){
            NSString *stopNumString = [NSString stringWithFormat:@"Stop Number: %@", stopNum];
            CGRect paragraphRect17 = [stopNumString boundingRectWithSize:CGSizeMake(800, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
            paragraphRect17.origin.x = 20;
            paragraphRect17.origin.y = yHeight;
            [stopNumString drawInRect:paragraphRect17 withAttributes:attributes];
            yHeight += paragraphRect17.size.height;
            
            if (yHeight > 1100){
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 850, 1100), nil);
                yHeight = 26;
            }
            }
            
            NSString *documentsDirectory = [NSHomeDirectory()
                                            stringByAppendingPathComponent:@"Documents"];
            NSString *savedPictureLocation = [documentsDirectory stringByAppendingPathComponent:picture];
            UIImage *pictureImage = [UIImage imageWithContentsOfFile:savedPictureLocation];
            if (pictureImage != nil){
            CGRect rect19 = CGRectMake(20, yHeight, pictureImage.size.width / 3, pictureImage.size.height / 3);
            [self drawImage:pictureImage inRect:rect19];
            yHeight += (pictureImage.size.height / 3);
            }
            
            
            NSString *savedSketchLocation = [documentsDirectory stringByAppendingPathComponent:sketch];
            UIImage *sketchImage = [UIImage imageWithContentsOfFile:savedSketchLocation];
            if (sketchImage != nil){
            CGRect rect20 = CGRectMake(20, yHeight, sketchImage.size.height / 3, sketchImage.size.height / 3);
            [self drawImage:sketchImage inRect:rect20];
            yHeight += (sketchImage.size.height / 3);
            }
            
            
            if (yHeight > 1100){
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 850, 1100), nil);
                yHeight = 26;
            }
            if ([dataSheet length] > 0){
            CGPoint tableStart = CGPointMake(20, yHeight);
            [self getNumRowsCols:dataSheet];
            [self drawTableAt: tableStart withRowHeight:30 andColumnWidth:50 andRowCount:numRows andColumnCount:numColumns];
            [self drawTableDataAt:tableStart withRowHeight:30 andColumnWidth:50 andRowCount:numRows andColumnCount:numColumns];
            }
        }
        // Close the PDF context and write the contents out.
        UIGraphicsEndPDFContext();
    }
    
    
    
    

}


//Draws images to the pdf
-(void)drawImage:(UIImage*)image inRect:(CGRect)rect
{
    [image drawInRect:rect];
}

//Draws a line in the pdf
-(void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat components[] = {0.2, 0.2, 0.2, 0.3};
    
    CGColorRef color = CGColorCreate(colorspace, components);
    
    CGContextSetStrokeColorWithColor(context, color);
    
    
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);
    
}

//Draws the table in the pdf
-(void)drawTableAt:(CGPoint)origin withRowHeight:(int)rowHeight andColumnWidth:(int)columnWidth andRowCount:(int)numberOfRows andColumnCount:(int)numberOfColumns

{
    for (int i = 0; i <= numberOfRows; i++)
    {
        int newOrigin = origin.y + (rowHeight*i);
        
        CGPoint from = CGPointMake(origin.x, newOrigin);
        CGPoint to = CGPointMake(origin.x + (numberOfColumns*columnWidth), newOrigin);
        
        [self drawLineFromPoint:from toPoint:to];
    }
    
    for (int i = 0; i <= numberOfColumns; i++)
    {
        int newOrigin = origin.x + (columnWidth*i);
        
        CGPoint from = CGPointMake(newOrigin, origin.y);
        CGPoint to = CGPointMake(newOrigin, origin.y +(numberOfRows*rowHeight));
        
        [self drawLineFromPoint:from toPoint:to];
    }
}

//Gets the number of rows and columns
- (void) getNumRowsCols:(NSString*) dictionary {
    NSError *error;
    NSData *data = [dictionary dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *editableDataSheet = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    _dataArray = editableDataSheet;
    int highColumn = 0;
    int highRow = 0;
    for (id key in [editableDataSheet allKeys]){
        NSArray *keyParts = [key componentsSeparatedByString:@"-"];
        if ([[keyParts objectAtIndex: 0] intValue] > highRow){
            highRow = [[keyParts objectAtIndex: 0] intValue];
            
        }
        if ([[keyParts objectAtIndex: 1] intValue] > highColumn){
            highColumn= [[keyParts objectAtIndex: 0] intValue];
        }
    }
    

    numRows = highRow + 1;
    numColumns = highColumn + 1;
}

//Draws the table data in the pdf
-(void)drawTableDataAt:(CGPoint)origin withRowHeight:(int)rowHeight andColumnWidth:(int)columnWidth andRowCount:(int)numberOfRows andColumnCount:(int)numberOfColumns
{
    
    int padding = 5;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:14]};
    for(int i = 0; i < numberOfRows; i++)
    {
        
        for (int j = 0; j < numberOfColumns; j++)
        {
            NSString *key = [NSString stringWithFormat:@"%i-%i",i,j];
            int newOriginX = origin.x + (j*columnWidth);
            int newOriginY = origin.y + (i*rowHeight);
            
            CGRect frame = CGRectMake(newOriginX + padding, newOriginY + padding, columnWidth, rowHeight);
            
            [[_dataArray objectForKey:key] drawInRect:frame withAttributes:attributes];
        }
    }    
}


//Dropbox delegate methods
- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
    NSLog(@"File uploaded successfully to path: %@, %@", metadata.path, metadata.rev);
    
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
    NSLog(@"File upload failed with error: %@", error);
    
}

-(void)createDropboxProjectFolders{
    NSString *projectQuery = @"select projectName from projects";
    NSArray *allProjects = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:projectQuery]];
    for (id project in allProjects){
        NSLog(@"%@", [project objectAtIndex:0]);
        [self.restClient createFolder:[project objectAtIndex:0]];
    }
}
-(void)dropboxFileToSync:(NSString *)name withPath:(NSString *)namePath{
   
    if ([name rangeOfString:@".png"].location == NSNotFound){
        NSString *projectPath = [@"/" stringByAppendingString:[name substringToIndex:[name length]-4]];
        [self.restClient uploadFile:name toPath:projectPath fromPath:namePath];
    }else{
        long projectLoc = [name rangeOfString:@"_"].location;
        NSString *projectPath = [@"/" stringByAppendingString:[name substringToIndex:projectLoc]];
        [self.restClient uploadFile:name toPath:projectPath fromPath:namePath];
    }
}

-(void)restClient:(DBRestClient*)client createdFolder:(DBMetadata *)folder{
    NSLog(@"Folder added!: %@",folder.filename);
}

- (void)restClient:(DBRestClient*)client createFolderFailedWithError:(NSError*)error{
    NSLog(@"Folder already there: %@",error);
}

@end
