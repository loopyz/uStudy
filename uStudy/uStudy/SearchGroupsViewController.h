//
//  SearchGroupsViewController.h
//  uStudy
//
//  Created by Lucy Guo on 2/1/14.
//  Copyright (c) 2014 Angela Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNFrostedSidebar.h"
#import <Firebase/Firebase.h>

@interface SearchGroupsViewController : UITableViewController <RNFrostedSidebarDelegate>

@property (nonatomic, strong) NSMutableArray* groups;
@property (nonatomic, strong) Firebase* firebase;
@property (nonatomic) bool done;
@end
