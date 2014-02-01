//
//  CalendarViewController.h
//  uStudy
//
//  Created by Angela Zhang on 1/31/14.
//  Copyright (c) 2014 Angela Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

//#import "RNFrostedSidebar.h"
#import "LoginViewController.h"

@interface CalendarViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *data;
@property (nonatomic) UIButton *firstButton;
@property (nonatomic) BOOL notTapped;
- (void)launchBurger:(id)sender;
@end
