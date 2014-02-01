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
            calendarCell.frame = CGRectMake(margin + cellSize * (i%5), margin * 4 + cellSize * [self getRow:i], cellSize, cellSize);
            [self.view addSubview:calendarCell];
            
            
            [dates addObject:newDate];
        }
        
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
    NSLog(@"tapped %@", sender);
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

- (void)loadAndUpdateEvents
{
    
}

@end
