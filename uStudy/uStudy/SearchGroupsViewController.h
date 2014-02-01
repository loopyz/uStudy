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
@property (strong, nonatomic) NSMutableArray *eventKeys;
@property (nonatomic, strong) NSMutableDictionary* events;
@property (nonatomic) bool done;
@property (strong, nonatomic) NSString *classr;

- (id) initWithDerp:(NSString*)derp;

-(id)initWithStyle:(NSInteger)style withClass:(NSString*)classr;
@end
