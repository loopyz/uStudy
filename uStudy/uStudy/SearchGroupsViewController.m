//
//  SearchGroupsViewController.m
//  uStudy
//
//  Created by Lucy Guo on 2/1/14.
//  Copyright (c) 2014 Angela Zhang. All rights reserved.
//

#import "SearchGroupsViewController.h"
#import <Firebase/Firebase.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"


#define firebaseURL @"https://ustudy.firebaseio.com/"


@interface SearchGroupsViewController ()
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;

@end

@implementation SearchGroupsViewController
@synthesize classr;
@synthesize firebase;
@synthesize eventKeys;
@synthesize events;


- (id) initWithDerp:(NSString *)derp
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self != nil) {
        //lol
        self.classr = derp;
        //self.tableView.separatorColor = [UIColor clearColor];
        //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        [self addBackgroundImage];
        
        [self initNavBarItems];
    }
    return self;
}


- (void)initNavBarItems
{
    //nav bar title
    UILabel *title = [[UILabel alloc]init];
    
    NSMutableString *temp = [NSMutableString stringWithString: self.classr];
    [temp appendString:@" Study Sessions"];
    
    title.text = temp;
    NSLog(title.text);
    title.textColor = [UIColor colorWithRed:0.26 green:0.26 blue:0.26 alpha:1.0];
    title.font = [UIFont systemFontOfSize:15];
    title.frame = CGRectMake(100, 10, 62.5, 30);
    self.navigationItem.titleView = title;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.tableView.dataSource = self;
//    self.tableView.delegate = self;
    
    //initialize array that will store the classes
    // Initialize array that will store events and event keys.
    self.events = [[NSMutableDictionary alloc] init];
    self.eventKeys = [[NSMutableArray alloc] init];
    
    //Initialize the root of our Firebase namespace
    self.firebase = [[Firebase alloc] initWithUrl:firebaseURL];
    
    [self loadAndUpdateGroups];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)loadAndUpdateGroups
{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *username = appDelegate.username;
    
    Firebase* eventsRef = [[self.firebase childByAppendingPath:@"classes"]
                           childByAppendingPath:self.classr];

    [eventsRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        self.eventKeys = [[snapshot.value allValues] mutableCopy];
        //NSLog(@"Event ID added: %@", eventKey);
        //[self.eventKeys addObject:eventKey];
        for (NSString *eventKey in eventKeys) {
        __block NSMutableDictionary* event = [[NSMutableDictionary alloc] init];
        
        // Retrieve event from Facebook
        FBRequestConnection *connection = [[FBRequestConnection alloc] init];
        
        // First request gets event info
        FBRequest *request1 =
        [FBRequest requestWithGraphPath:[@"/" stringByAppendingString:eventKey]
                             parameters:nil
                             HTTPMethod:@"GET"];
        [connection addRequest:request1
             completionHandler:
         ^(FBRequestConnection *connection, id result, NSError *error) {
             if (!error && result) {
                 event = result;

             }
             // Store formatted date and time
             NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
             NSString *input = event[@"start_time"];
             [dateFormat setDateFormat:@"2013-MM-dd'T'HH:mm:00 PST"]; //iso 8601 format
             NSDate *output = [dateFormat dateFromString:input];
             
             NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
             [formatter setDateFormat:@"h:mm a"];
             if (event[@"start_time"])
                 event[@"time_formatted"] = [@"Time: " stringByAppendingString:[formatter stringFromDate:output]];
             else
                 event[@"time_formatted"] = @"";
             [formatter setDateFormat:@"M/d/yy"];
             
             if (event[@"start_time"] != Nil)
                 event[@"date_formatted"] = [@"Date: " stringByAppendingString:[formatter stringFromDate:output]];
             else
                 event[@"date_formatted"] = @"";
             
             
            }
         ];
        
        // Second request retrieves the attendees count
        NSDictionary* request2Params = [[NSDictionary alloc] initWithObjectsAndKeys: @"1", @"summary", @"0", @"limit", nil];
        
        FBRequest *request2 =
        [FBRequest requestWithGraphPath: [[@"/" stringByAppendingString:eventKey] stringByAppendingString:@"/attending"]
                             parameters:request2Params
                             HTTPMethod: @"GET"];
        
        [connection addRequest:request2
             completionHandler:
         ^(FBRequestConnection *connection, id result, NSError *error) {
             if (!error && result) {
                 event[@"attendees"] = [[[result objectForKey:@"summary"] objectForKey:@"count"] stringValue];
             }
             if (!event || !event[@"name"]) {
                 [[snapshot ref] removeValue];
                 [self.eventKeys removeObject:eventKey];
             } else {
                 // Store event in events array
                 event[@"ref"] = [snapshot ref];
                 event[@"class"] = self.classr;
                 [self.events setObject:event forKey:eventKey];
             }
             self.tableView.allowsMultipleSelection = YES;
             [self.tableView reloadData];
         }];
        
        [connection start];
        }
    }];
    
    [eventsRef observeEventType:FEventTypeChildRemoved withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"Event deleted: %@", snapshot.value);
        
        [self.events removeObjectForKey:snapshot.value];
        [self.eventKeys removeObject:snapshot.value];
        
        [self.tableView reloadData];
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addBackgroundImage
{
    UIGraphicsBeginImageContext(self.view.frame.size);
    
    [[UIImage imageNamed:@"calendar-bg.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.events count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)setupLabel:(UILabel *)label forCell:(UITableViewCell *)cell withText:(NSString*)text {
    [self setupLabel:label forCell:cell withText:text withSize: 12];
}


- (void)setupLabel:(UILabel *)label forCell:(UITableViewCell *)cell withText:(NSString*)text
          withSize:(int)size {
    [self setupLabel:label forCell:cell withText:text withSize: size
       withAlignment:NSTextAlignmentLeft];
}

- (void)setupLabel:(UILabel *)label forCell:(UITableViewCell *)cell withText:(NSString*)text
          withSize:(int)size withAlignment:(NSTextAlignment)textAlignment {
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = textAlignment;
    label.layer.shadowColor = [[UIColor blackColor] CGColor];
    label.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    label.layer.shadowOpacity = 1.0 * pow(22.0 / (double)size, 3.0); // too much work?
    [label setText:text];
    [cell.contentView addSubview:label];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        // TODO: this doesn't seem to work...
        cell.selectedBackgroundView.backgroundColor = [UIColor lightGrayColor];
    }
    
    NSString* eventKey = [self.eventKeys objectAtIndex:indexPath.row];
    
    // Update cell name and description
    NSMutableDictionary* event = self.events[eventKey];
    if (!event)
    {
        NSLog(@"Event not found: %@!", eventKey);
        return cell;
    }

    
    NSLog(@"Updating event: %@", event[@"name"]);
    
    // Event title
    UILabel *ttitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 320, 40)];
    int size = 22;
    int length = [event[@"name"] length];
    if (length > 28)
    {
        size = size*28/length;
    }
    
    [self setupLabel:ttitle forCell:cell withText:event[@"name"] withSize:size];
    
    // Date label
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 320, 40)];
    [self setupLabel:dateLabel forCell:cell withText:event[@"date_formatted"]];
    
    // Time label
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 42, 320, 40)];
    [self setupLabel:timeLabel forCell:cell withText:event[@"time_formatted"]];

    
    // Number attending label
    NSString *attendees = event[@"attendees"];
    
    UILabel *numAttendingLabel = [[UILabel alloc] initWithFrame:CGRectMake(165, 7, 100, 40)];
    [self setupLabel:numAttendingLabel forCell:cell withText:attendees withSize:28 withAlignment:NSTextAlignmentRight];
    
    // Attending label
    UILabel *attendingLabel = [[UILabel alloc] initWithFrame:CGRectMake(235, 35, 120, 40)];
    [self setupLabel:attendingLabel forCell:cell withText:@"attending" withSize:10];
    
    // Location label
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 24, 320, 40)];
    [self setupLabel:locationLabel forCell:cell withText:@"Location:" withSize:10];
    
    //Get location of event
    UILabel *placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 38, 320, 40)];
    [self setupLabel:placeLabel forCell:cell withText:@"GHC 3827" withSize:10];
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row >= [self.eventKeys count])
        return;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString* eventKey = [self.eventKeys objectAtIndex:indexPath.row];
    
    NSLog(@"Selected event: %@", eventKey);
    NSMutableDictionary *event = self.events[eventKey];
    
    //[self openJoinEventView:event];
}

- (void)exit
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// Allow deleting of rows by swipe
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    NSString* eventKey = [self.eventKeys objectAtIndex:indexPath.row];
//    
//    [self.events[eventKey][@"ref"] removeValue];
//    [self.events removeObjectForKey:eventKey];
//    [self.eventKeys removeObject:eventKey];
//    
//    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    
//    [self.tableView reloadData];
//}


// Allow deleting of rows by swipe
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    [events removeObjectAtIndex:indexPath.row];
//    
//    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    
//    [self.tableView reloadData];
//}




/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

@end
