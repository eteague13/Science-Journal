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


@implementation AppDelegate
//Initializes all of the switches in the Settings tab
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    NSDictionary *appDefaults = [NSDictionary
                                 dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"SwitchStrikeDip"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    NSDictionary *appDefaults2 = [NSDictionary
                                 dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"SwitchStopNum"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults2];
    NSDictionary *appDefaults3 = [NSDictionary
                                 dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"SwitchOutcrop"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults3];
    NSDictionary *appDefaults4 = [NSDictionary
                                 dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"SwitchStructData"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults4];
    NSDictionary *appDefaults5 = [NSDictionary
                                 dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"SwitchDate"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults5];
    NSDictionary *appDefaults6 = [NSDictionary
                                 dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"SwitchGoal"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults6];
    NSDictionary *appDefaults7 = [NSDictionary
                                 dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"SwitchLocationWeather"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults7];
    NSDictionary *appDefaults8 = [NSDictionary
                                 dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"SwitchNotes"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults8];
    NSDictionary *appDefaults9 = [NSDictionary
                                 dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"SwitchPicture"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults9];
    NSDictionary *appDefaults10 = [NSDictionary
                                 dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"SwitchPermissions"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults10];
    NSDictionary *appDefaults11 = [NSDictionary
                                 dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"SwitchSampleNum"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults11];
    NSDictionary *appDefaults12 = [NSDictionary
                                 dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"SwitchPartners"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults12];
    NSDictionary *appDefaults13 = [NSDictionary
                                 dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"SwitchSketch"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults13];
    NSDictionary *appDefaults14 = [NSDictionary
                                   dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"SwitchDataSheet"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults14];
    
    NSDictionary *appDefaults15 = [NSDictionary
                                 dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"SwitchTrendPlunge"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults15];
    
    
    //Creates the Dropbox session
    DBSession *dbSession = [[DBSession alloc]
                            initWithAppKey:@"2xraywobhwdkb94"
                            appSecret:@"p38tbm8288tnc3p"
                            root:kDBRootAppFolder];
    [DBSession setSharedSession:dbSession];

    //Michael-Change the right 1/2 of the = sign. Copy and paste
    //UIColor *backgroundColor = [UIColor colorWithRed:157.0/255.0 green:245.0/255.0 blue:140.0/255.0 alpha:1.0];
    UIColor *backgroundColor = [UIColor colorWithRed:77.0f/255.0f green:175.0f/255.0f blue:77.0f/255.0f alpha:1.0];
    
    [[UINavigationBar appearance] setBarTintColor:backgroundColor];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName,
                                                           nil, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"Helvetica" size:17.0], NSFontAttributeName, nil]];
    
    
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIButton appearance] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];

    [[UITabBar appearance] setSelectedImageTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBarTintColor:backgroundColor];
    
    [[UILabel appearance] setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    
    [[UITextField appearance] setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    
    /*
    UITabBarItem *item = [self.tabBar.items objectAtIndex:1];
    item.image = [[UIImage imageNamed:@"unselected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBar.tintColor
    item.selectedImage = [UIImage imageNamed:@"selected.png"];
    */
    

    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
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
            // At this point you can start making API calls
        }
        return YES;
    }
    // Add whatever other url handling code your app requires here
    return NO;
}





@end
