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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    NSDictionary *appDefaults = [NSDictionary
                                 dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"SwitchGeoMagDec"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    NSDictionary *appDefaults2 = [NSDictionary
                                 dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"SwitchGeoStopNum"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults2];
    NSDictionary *appDefaults3 = [NSDictionary
                                 dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"SwitchGeoOutcrop"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults3];
    NSDictionary *appDefaults4 = [NSDictionary
                                 dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"SwitchGeoStructData"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults4];
    NSDictionary *appDefaults5 = [NSDictionary
                                 dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"SwitchDate"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults5];
    NSDictionary *appDefaults6 = [NSDictionary
                                 dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"SwitchGoal"];
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
                                 dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"SwitchPermissions"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults10];
    NSDictionary *appDefaults11 = [NSDictionary
                                 dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"SwitchSampleNum"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults11];
    NSDictionary *appDefaults12 = [NSDictionary
                                 dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"SwitchPartners"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults12];
    NSDictionary *appDefaults13 = [NSDictionary
                                 dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"SwitchSketch"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults13];

    
    DBSession *dbSession = [[DBSession alloc]
                            initWithAppKey:@"2xraywobhwdkb94"
                            appSecret:@"p38tbm8288tnc3p"
                            root:kDBRootAppFolder];
    [DBSession setSharedSession:dbSession];

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
