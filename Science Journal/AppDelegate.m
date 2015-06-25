//
//  AppDelegate.m
//  Science Journal
//
//  Created by Evan Teague on 8/18/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"
#import "EntriesController.h"
#import <DropboxSDK/DropboxSDK.h>
static int version = 0.951;

@implementation AppDelegate
//Initializes all of the switches in the Settings tab
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //Styles the navigation bar
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
    //Creates the Dropbox session
    DBSession *dbSession = [[DBSession alloc]
                            initWithAppKey:@"2xraywobhwdkb94"
                            appSecret:@"p38tbm8288tnc3p"
                            root:kDBRootAppFolder];
    [DBSession setSharedSession:dbSession];
    
    //Green color through the app
    UIColor *backgroundColor = [UIColor colorWithRed:77.0f/255.0f green:175.0f/255.0f blue:77.0f/255.0f alpha:1.0];
    
    //Styles the Navigation bar
    [[UINavigationBar appearance] setBarTintColor:backgroundColor];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor blackColor], NSForegroundColorAttributeName,
                                                           nil, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"Helvetica" size:17.0], NSFontAttributeName, nil]];

    //Styles the Tab bar
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBarTintColor:backgroundColor];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    //Styles the UILabels and Texfields
    [[UILabel appearance] setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    [[UITextField appearance] setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    
    //Upgrades the database on new app versions
    //Remember to change the static version number
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"FieldBookdb.sql"];
    NSString *versionQuery = @"select database_ver from metadata";
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:versionQuery]];
    if ([results count] == 0){
        NSString *query = [NSString stringWithFormat:@"insert into metadata values(%d)", version];
        [self.dbManager executeQuery:query];
    }else{
        int appVersion = [[[results objectAtIndex:0] objectAtIndex:0] intValue];
        if (version > appVersion){
            //Do stuff
            NSString *updateVersion = [NSString stringWithFormat:@"update metadata set database_ver=%d", version];
            [self.dbManager executeQuery:updateVersion];
        }
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//Creates the link with Dropbox
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url
  sourceApplication:(NSString *)source annotation:(id)annotation {
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked successfully!");
        }
        return YES;
    }
    return NO;
}





@end
