//
//  SearchClassesViewController.h
//  uStudy
//
//  Created by Lucy Guo on 2/1/14.
//  Copyright (c) 2014 Angela Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNFrostedSidebar.h"
#import <Firebase/Firebase.h>

@interface SearchClassesViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray* classes;
@property (nonatomic, strong) Firebase* firebase;
@property (nonatomic) bool done;
@property (nonatomic, strong) NSArray *rectangles;
@property (nonatomic) int count;


@end
