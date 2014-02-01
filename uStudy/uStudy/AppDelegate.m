//
//  AppDelegate.m
//  uStudy
//
//  Created by Angela Zhang on 1/31/14.
//  Copyright (c) 2014 Angela Zhang. All rights reserved.
//

#define FORCE_LOGOUT true
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "CollegeViewController.h"
#import "CalendarViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Create LoginUIViewController instance where we will put the login button
    
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    
    
    self.loginViewController = loginViewController;
    
    CalendarViewController *calendarViewController = [[CalendarViewController alloc] init];
    
    self.calendarViewController = calendarViewController;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:calendarViewController];
    self.calendarViewController = calendarViewController;
    self.window.rootViewController = navigationController;
    self.window.backgroundColor = [UIColor colorWithRed:0.953 green:0.949 blue:0.949 alpha:1.0];

//    // Override point for customization after application launch.
//    
//    LoginViewController *lvc = [[LoginViewController alloc] init];
//    
//    CollegeViewController *temp = [[CollegeViewController alloc] init];
//    
//    self.window.rootViewController = lvc;
//    
//    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    if (FORCE_LOGOUT)
        [self logout];
    
    // Whenever a person opens the app, check for a cached session
    if (!FORCE_LOGOUT && FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"email"]
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
    } else {
        //UIButton *loginButton = [self.loginViewController loginButton];
        //[loginButton setTitle:@"Log in with Facebook" forState:UIControlStateNormal];
        [calendarViewController presentViewController:loginViewController animated:YES completion:NULL];
    }
    
    return YES;
}

// During the Facebook login flow, your app passes control to the Facebook iOS app or Facebook in a mobile browser.
// After authentication, your app will be called back with the session information.
// Override application:openURL:sourceApplication:annotation to call the FBsession object that handles the incoming URL
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)logout
{
    // Clear this token
    [FBSession.activeSession closeAndClearTokenInformation];
    // Show the user the logged-out UI
    [self userLoggedOut];
}

// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        [self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        [self logout];
    }
}

// Show the user the logged-out UI
- (void)userLoggedOut
{
    // Set the button title as "Log in with Facebook"
    UIButton *loginButton = [self.loginViewController loginButton];
    [loginButton setTitle:@"Log in with Facebook" forState:UIControlStateNormal];
    
    // Confirm logout message
    [self showMessage:@"You're now logged out" withTitle:@""];
}

// Show the user the logged-in UI
- (void)userLoggedIn
{
    
    // Set the button title as "Log out"
    UIButton *loginButton = self.loginViewController.loginButton;
    [loginButton setTitle:@"Log out" forState:UIControlStateNormal];
    
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *aUser, NSError *error) {
         if (error)
             NSLog(@"Error retrieving user: %@", error.description);
         else {
             NSLog(@"User id %@",[aUser objectForKey:@"id"]);
             self.username = aUser[@"id"];
         }
         
         if ([self.loginViewController isViewLoaded])
         {
             [self.loginViewController dismissViewControllerAnimated:YES completion:^() {
                 CollegeViewController *collegeViewController = [[CollegeViewController alloc] init];
            
                 [self.calendarViewController presentViewController: collegeViewController animated:YES completion:^() {
                     //add stuff
                 }];
//                 [self.CalendarViewController presentViewController:CollegeViewController animated:YES completion:^() {
//                     [self.eventListViewController loadAndUpdateEvents];
//                 }];
             }];
         } else {
             //loads calendar after
             
             //             CollegeViewController *collegeViewController = [[CollegeViewController alloc] init];
             //[self.CalendarViewController presentViewController:interestsViewController animated:YES completion:^() {
             //}];
         }
     }];

}

// Show an alert message
- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil] show];
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
