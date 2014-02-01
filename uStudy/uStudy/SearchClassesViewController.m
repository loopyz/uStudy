//
//  SearchClassesViewController.m
//  uStudy
//
//  Created by Lucy Guo on 2/1/14.
//  Copyright (c) 2014 Angela Zhang. All rights reserved.
//

#import "SearchClassesViewController.h"
#import <Firebase/Firebase.h>
#import "AppDelegate.h"
#import "SearchGroupsViewController.h"
#import "CreateGroupViewController.h"
#import "CalendarViewController.h"


#define firebaseURL @"https://ustudy.firebaseio.com/"


@interface SearchClassesViewController ()
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;

@end

@implementation SearchClassesViewController
{
    //NSMutableArray *rectangles;
}

@synthesize classes;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.count = 0;
        self.rectangles = @[@"white-rect.png", @"light-green-rect.png", @"orange-rect.png", @"pink-rect.png", @"green-rect.png"];
        // Custom initialization
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self addBackgroundImage];
        
    
    }
    return self;
}


- (UIImage *)randomRectangle
{
    NSArray* bgs = @[@"white-rect.png", @"light-green-rect.png", @"orange-rect.png", @"pink-rect.png", @"green-rect.png"];
    
    return [UIImage imageNamed:bgs[arc4random() % [bgs count]]];
    //return [UIImage imageNamed:@"white-rect.png"];
}

- (void)initNavBarItems
{
    //Hamburger menu!
    UIBarButtonItem *hamburger = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"burger.png"] style:UIBarButtonItemStylePlain target:self action:@selector(launchBurger:)];
    
    self.navigationItem.leftBarButtonItem = hamburger;
    
    //nav bar title
    UILabel *title = [[UILabel alloc]init];
    title.text = @"Your Classes";
    title.textColor = [UIColor colorWithRed:0.26 green:0.26 blue:0.26 alpha:1.0];
    title.font = [UIFont systemFontOfSize:15];
    title.frame = CGRectMake(100, 10, 62.5, 30);
    self.navigationItem.titleView = title;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavBarItems];
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //initialize array that will store the classes
    self.classes = [[NSMutableArray alloc] init];
    
    //Initialize the root of our Firebase namespace
    self.firebase = [[Firebase alloc] initWithUrl:firebaseURL];
    [self loadAndUpdateClasses];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)loadAndUpdateClasses
{
   AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *username = appDelegate.username;
    
    Firebase *classesRef = [[[self.firebase childByAppendingPath:@"users"] childByAppendingPath:username] childByAppendingPath:@"classes"];
    
    [classesRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if (snapshot == [NSNull null]) {
            NSLog(@"There are no classes");
        } else {
            NSArray *classesSnp = [snapshot.value allValues];
            self.classes = [classesSnp mutableCopy];
            [self.tableView reloadData];
        }
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
    return [self.classes count];;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];// forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        NSLog(@"here in if statement");
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setBackgroundColor:[UIColor clearColor]];
        NSLog(@"never completed if statement :(");
    } else
    {
        [cell setBackgroundColor:[UIColor clearColor]];
        // Clear old labels
        NSLog(@"here in else statement");
        for (UIView *v in cell.subviews) {
            if ([v isKindOfClass:[UILabel class]])
                [v removeFromSuperview];
        }
    }
    
    //gets class name
    NSString *class = [self.classes objectAtIndex:indexPath.row];
    NSLog(class);
    
    //update cell name and description
    if(!class)
    {
        NSLog(@"Class not found:");
        return cell;
    }
    
    
    UIImage *bgRect = [UIImage imageNamed:[self.rectangles objectAtIndex:self.count%5]];
    self.count++;
    
    cell.backgroundView = [[UIImageView alloc] initWithImage: [bgRect stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage: [bgRect stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
    
    //Class Title Label
    UILabel *classLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 16, 120, 40)];
    //int size = 22;
    //int length = [class length];
    
    //shorted class string
    NSRange stringRange = {0, MIN([class length], 35)};
    // adjust the range to include dependent chars
    stringRange = [class rangeOfComposedCharacterSequencesForRange:stringRange];
    // Now you can create the short string
    NSString *shortString = [class substringWithRange:stringRange];
    
    [self setupLabel:classLabel forCell:cell withText:shortString withSize: 23];
    
    //bar separator label
    UILabel *barSeparator = [[UILabel alloc] initWithFrame:CGRectMake(100, 13, 120, 40)];
    [self setupBarLabel:barSeparator forCell:cell withText:@"|" withSize:32];
    
    //class name label: TODO GET FROM FIREBASEEE :P
    UILabel *className = [[UILabel alloc] initWithFrame:CGRectMake(115, 15, 190, 40)];
    [self setupLabel:className forCell:cell withText:@"Introduction to Computer Systems" withSize:12];
    
    
    return cell;
    
    
}

// Allow deleting of rows by swipe
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [classes removeObjectAtIndex:indexPath.row];
    
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.tableView reloadData];
}

//label setup
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
    
    //incorrectLabel.frame = CGRectMake(0, 0, self.view.bounds.size.width, 520);
    label.font = [UIFont fontWithName:@"Futura-Medium" size:size];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = textAlignment;
    [label setText:text];
    [cell.contentView addSubview:label];
}

- (void)setupBarLabel:(UILabel *)label forCell:(UITableViewCell *)cell withText:(NSString*)text withSize:(int)size
{
    label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:size];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentLeft;
    [label setText:text];
    [cell.contentView addSubview:label];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [self.classes count])
        return;
    NSString *classr = [self.classes objectAtIndex:indexPath.row];
    NSLog(@"Selected Class: %@", classr);
    
//    SearchGroupsViewController *sgvc = [[SearchGroupsViewController alloc] initWithNibName:@"calendar-bg.png" bundle:nil withClass:class];
    NSLog(@"found it?");
    
    SearchGroupsViewController *sgvc = [[SearchGroupsViewController alloc] initWithDerp:classr];
    
    //SearchGroupsViewController *sgvc = [[SearchGroupsViewController alloc] initWithStyle:UITableViewStylePlain withClass:classr];
    [self.navigationController pushViewController:sgvc animated:YES];

}

#pragma mark - RNFrostedSidebarDelegate

- (void)launchBurger:(id)sender {
    
    NSArray *images = @[
                        [UIImage imageNamed:@"home-icon"],
                        [UIImage imageNamed:@"create-icon"],
                        [UIImage imageNamed:@"search-icon"],
                        [UIImage imageNamed:@"gear"]
                        ];
    NSArray *colors = @[
                        [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                        [UIColor colorWithRed:255/255.f green:137/255.f blue:167/255.f alpha:1],
                        [UIColor colorWithRed:126/255.f green:242/255.f blue:195/255.f alpha:1],
                        [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
                        ];
    
    
    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:self.optionIndices borderColors:colors];
    
    //    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images];
    callout.delegate = self;
    
    //callout.showFromRight = YES;
    
    
    [callout showInViewController:self animated:YES];
    
    
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    NSLog(@"Tapped item at index %i",index);
    switch (index) {
        case 0: {
            //Home
            CalendarViewController *sgvc = [[CalendarViewController alloc] init];
            [self.navigationController pushViewController:sgvc animated:YES];
            break;
        }
        case 1: {
            //Create
            CreateGroupViewController *sgvc = [[CreateGroupViewController alloc] init];
            [self.navigationController pushViewController:sgvc animated:YES];
            break;
        }
        case 2: {
            //Search
            SearchClassesViewController *svc = [[SearchClassesViewController alloc] init];
            [self.navigationController pushViewController:svc animated:YES];
            break;
        }
        case 3: {
            [FBSession.activeSession closeAndClearTokenInformation];
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            [self.navigationController presentViewController:loginViewController animated:YES completion:NULL];
            break;
        }
            //default:
            //  break;
    }
    
}

-(void)test
{
    SearchClassesViewController *svc = [[SearchClassesViewController alloc] init];
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didEnable:(BOOL)itemEnabled itemAtIndex:(NSUInteger)index {
    if (itemEnabled) {
        [self.optionIndices addIndex:index];
    }
    else {
        [self.optionIndices removeIndex:index];
    }
}

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
