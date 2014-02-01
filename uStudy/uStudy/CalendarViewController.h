//
//  CalendarViewController.h
//  uStudy
//
//  Created by Angela Zhang on 1/31/14.
//  Copyright (c) 2014 Angela Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNFrostedSidebar.h"
@interface CalendarViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, RNFrostedSidebarDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *data;

@end
