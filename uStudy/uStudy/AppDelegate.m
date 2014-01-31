//
//  AppDelegate.m
//  uStudy
//
//  Created by Angela Zhang on 1/31/14.
//  Copyright (c) 2014 Angela Zhang. All rights reserved.
//

#define FORCE_LOGOUT false
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Create LoginUIViewController instance where we will put the login button
    
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    
    self.loginViewController = loginViewController;
    // Override point for customization after application launch.
    
    LoginViewController *lvc = [[LoginViewController alloc] init];
    
    self.window.rootViewController = lvc;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // Whenever a person opens the app, check for a cached session
    if (!FORCE_LOGOUT && FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
    } else {
        //UIButton *loginButton = [self.loginViewController loginButton];
        //[loginButton setTitle:@"Log in with Facebook" forState:UIControlStateNormal];
//        [eventListViewController presentViewController:loginViewController animated:YES completion:NULL];
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

@end
