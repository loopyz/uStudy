//
//  CalendarViewController.m
//  uStudy
//
//  Created by Angela Zhang on 1/31/14.
//  Copyright (c) 2014 Angela Zhang. All rights reserved.
//

#import "CalendarViewController.h"

@interface CalendarViewController ()

@end

@implementation CalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        
        int margin = 5;
        int cellSize = (screenWidth - margin*2)/5;
        
        NSDate *date = [[NSDate alloc] init];
        
        NSTimeInterval GMToffset = 5 * 60 * 60;
        NSDate *now = [date dateByAddingTimeInterval:-GMToffset];
        
        NSTimeInterval secondsPerDay = 24 * 60 * 60;
        NSMutableArray *dates = [[NSMutableArray alloc] init];
        
        
        for (int i = 0; i < 20; i++) {
            NSDate *newDate = [now dateByAddingTimeInterval:secondsPerDay*i];
            
            //Get numerical date
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:newDate];
            NSInteger day = [components day];
            NSLog(@"%d", day);
            
            //Get day of the week
            NSDateFormatter *dayOfWeek = [[NSDateFormatter alloc] init];
            [dayOfWeek setDateFormat: @"EEEE"];
            NSString *weekday = [[dayOfWeek stringFromDate:newDate] substringToIndex:3];
            
            UIButton *calendarCell = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            calendarCell.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            calendarCell.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            [calendarCell addTarget:self
                       action:@selector(tapped:)
             forControlEvents:UIControlEventTouchDown];
            NSString *text = [NSString stringWithFormat:@"%@\n%d", weekday, day];
            [calendarCell setTitle:text forState:UIControlStateNormal];
            calendarCell.frame = CGRectMake(margin + cellSize * (i%5), margin * 5 + cellSize * [self getRow:i], cellSize, cellSize);
            [self.view addSubview:calendarCell];
            
            [dates addObject:newDate];
        }
        
        _data = [[NSMutableArray alloc] initWithObjects:@"test1", @"test2", nil];
        
        int tableYStart = margin * 6 + cellSize * 4;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(margin, tableYStart, screenWidth-margin*2, screenHeight-tableYStart)
                                                  style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [self.view addSubview:_tableView];
    }
    return self;
}

- (int)getRow:(int)i
{
    if (i < 5) return 0;
    else if (i < 10) return 1;
    else if (i < 15) return 2;
    else return 3;
}

- (void)tapped:(id)sender
{
    UIButton *button = sender;
    NSString *date = button.titleLabel.text;
    NSLog(@"%@", date);
    
    //TODO: at this point query firebase using date (which has format 'Mon\n17' [example]) to get events for given day
    //then set items that get returned from that as the items in the NSMutableArray _data
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [_data objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = @"detailtextlabel";
    //NSString *path = [[NSBundle mainBundle] pathForResource:[item objectForKey:@"imageKey"] ofType:@"png"];
    //UIImage *theImage = [UIImage imageWithContentsOfFile:path];
    //cell.imageView.image = theImage;
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // handle table view selection
}

@end
