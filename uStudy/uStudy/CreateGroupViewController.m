//
//  CreateGroupViewController.m
//  uStudy
//
//  Created by Niveditha Jayasekar on 2/1/14.
//  Copyright (c) 2014 Angela Zhang. All rights reserved.
//

#import "CreateGroupViewController.h"
#import <Firebase/Firebase.h>

@interface CreateGroupViewController ()

@end

@implementation CreateGroupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSString *username = @"633454537";
    //NSMutableDictionary *newEvents = [[NSMutableDictionary alloc] init];
    Firebase *usersRef = [[Firebase alloc] initWithUrl:@"https://ustudy.firebaseio.com/users"];
    Firebase *eventsRef = [[usersRef childByAppendingPath:username] childByAppendingPath:@"events"];
    
    // put fb event id here.
    [[eventsRef childByAutoId] setValue:@"Cameras"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
