//
//  AppDelegate.h
//  uStudy
//
//  Created by Angela Zhang on 1/31/14.
//  Copyright (c) 2014 Angela Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CalendarViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LoginViewController *loginViewController;

@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) NSString *username;


- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
- (void)userLoggedIn;
- (void)userLoggedOut;
- (void)showMessage:(NSString *)text withTitle:(NSString *)title;
- (void)logout;

@end
