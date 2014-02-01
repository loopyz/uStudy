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
        // Custom initialization
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //[self initNavBarItems];
        [self addBackgroundImage];
        
    
    }
    return self;
}


- (UIImage *)randomRectangle
{
    NSArray* bgs = @[@"white-rect.png", @"light-green-rect.png", @"orange-rect.png", @"pink-rect.png", @"green-rect.png"];
    
    return [UIImage imageNamed:bgs[arc4random() % [bgs count]]];
}

- (void)initNavBarItems
{
    //Hamburger menu!
    UIBarButtonItem *hamburger = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"burger.png"] style:UIBarButtonItemStylePlain target:self action:@selector(launchBurger:)];
    
    self.navigationItem.leftBarButtonItem = hamburger;
    
    NSArray *images = @[
                        [UIImage imageNamed:@"gear"],
                        [UIImage imageNamed:@"globe"],
                        [UIImage imageNamed:@"profile"],
                        [UIImage imageNamed:@"star"]
                        ];
    
    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images];
    callout.delegate = self;
    [callout show];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    NSLog(@"reaches this point");
    
    [classesRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"oh hello");
        NSString *class = snapshot.value;
        NSLog(class);
        [self.classes addObject:class];
        [self.tableView reloadData];
    }];
    
    [classesRef observeEventType:FEventTypeChildRemoved withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"Class deleted: %@", snapshot.name);
        [self.classes removeObject:snapshot.name];
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
    [[UIImage imageNamed:@"stone-bg.png"] drawInRect:self.view.bounds];
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
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];// forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    } else
    {
        // Clear old labels
        for (UIView *v in cell.subviews) {
            if ([v isKindOfClass:[UILabel class]])
                [v removeFromSuperview];
        }
    }
    
    //gets class name
    NSString *class = [self.classes objectAtIndex:indexPath.row];
    
    //update cell name and description
    if(!class)
    {
        NSLog(@"Class not found:");
        return cell;
    }
    
    UIImage *bgRect = [[UIImage alloc] initWithData:[self randomRectangle]];
    cell.backgroundView = [[UIImageView alloc] initWithImage: bgRect];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage: bgRect];
    
    //Class Title Label
    UILabel *classLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 320, 40)];
    int size = 22;
    int length = [class length];
    
    //shorted class string
    NSRange stringRange = {0, MIN([class length], 20)};
    // adjust the range to include dependent chars
    stringRange = [class rangeOfComposedCharacterSequencesForRange:stringRange];
    // Now you can create the short string
    NSString *shortString = [class substringWithRange:stringRange];
    
    [self setupLabel:classLabel forCell:cell withText:class withSize: 12];
    
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
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = textAlignment;
    [label setText:text];
    [cell.contentView addSubview:label];
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
