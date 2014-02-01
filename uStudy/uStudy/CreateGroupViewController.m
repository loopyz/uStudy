//
//  CreateGroupViewController.m
//  uStudy
//
//  Created by Niveditha Jayasekar on 2/1/14.
//  Copyright (c) 2014 Angela Zhang. All rights reserved.
//

#import "CreateGroupViewController.h"
#import <Firebase/Firebase.h>
#import "AppDelegate.h"

@interface CreateGroupViewController () <UITextFieldDelegate>

@end

@implementation CreateGroupViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self addBackgroundImage];
        
        self.classes = [[NSMutableArray alloc] init];
        // Do any additional setup after loading the view.
        // adding all the labels and picker views
        self.classLabel = [[UILabel alloc] init];
        self.locationLabel = [[UILabel alloc] init];
        self.startTimeButton = [[UIButton alloc] init];
        self.endTimeButton = [[UIButton alloc] init];
        
        self.classPickerView = [[UIPickerView alloc] init];
        self.locationTextField = [[UITextField alloc] init];
        self.startTimePicker = [[UIDatePicker alloc] init];
        self.endTimePicker = [[UIDatePicker alloc] init];
        
        //designing stuff
        self.classLabel.frame = CGRectMake(20,10,100,100);
        self.classLabel.text = @"Class";
        self.locationLabel.frame = CGRectMake(20,120,100,100);
        self.locationLabel.text = @"Location";
        self.startTimeButton.frame = CGRectMake(20,220,100,100);
        self.endTimeButton.frame = CGRectMake(20,280,100, 100);
        
        [self.locationLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.classLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.startTimeButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.endTimeButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.classPickerView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.locationTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.startTimePicker setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.endTimePicker setTranslatesAutoresizingMaskIntoConstraints:NO];
        //white color text
        //    self.classLabel.textColor = [UIColor whiteColor];
        //    self.classLabel.textColor = [UIColor whiteColor];
        //    self.locationLabel.textColor = [UIColor whiteColor];
        self.startTimeButton.titleLabel.textColor = [UIColor blackColor];
        
        [self.startTimeButton setTitle:@"Starts" forState:UIControlStateNormal|UIControlStateHighlighted| UIControlStateDisabled|UIControlStateSelected];
        [self.endTimeButton setTitle:@"Ends" forState:UIControlStateNormal|UIControlStateHighlighted| UIControlStateDisabled|UIControlStateSelected];
        //[self.startTimeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal|UIControlStateHighlighted| UIControlStateDisabled|UIControlStateSelected];
        //[self.endTimeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal|UIControlStateHighlighted| UIControlStateDisabled|UIControlStateSelected];
        //[self.startTimeButton addTarget:self action:@selector(startButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        //[self.endTimeButton addTarget:self action:@selector(endButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        self.classPickerView.frame = CGRectMake(20,0,280,200);
        
        self.locationTextField.frame = CGRectMake(100,155,180,30);
        self.locationTextField.backgroundColor = [UIColor blackColor];
        self.locationTextField.textColor = [UIColor whiteColor];
        self.startTimePicker.frame = CGRectMake(20,240,400,400);
        self.endTimePicker.frame = CGRectMake(20,340,400,400);
        
        //make location text field pretty
        self.locationTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.locationTextField.keyboardType = UIKeyboardTypeDefault;
        self.locationTextField.returnKeyType = UIReturnKeyDone;
        self.locationTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.locationTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.locationTextField.borderStyle = UITextBorderStyleNone;
        //[self.locationTextField setBackground:textBG];
        self.locationTextField.delegate = self;

        
        self.startTimePicker.datePickerMode = UIDatePickerModeDateAndTime;
        self.endTimePicker.datePickerMode = UIDatePickerModeDateAndTime;
        self.startTimePicker.hidden = YES;
        self.endTimePicker.hidden = YES;
        [self.startTimePicker addTarget:self action:@selector(startValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.endTimePicker addTarget:self action:@selector(endvalueChanged:) forControlEvents:UIControlEventValueChanged];
        
        //picker view stuff
        self.classPickerView.delegate = self;
        self.classPickerView.dataSource = self;
        self.classPickerView.showsSelectionIndicator = YES;
        [self loadAndUpdateClasses];
        
        [self.view addSubview:self.locationLabel];
        [self.view addSubview:self.classLabel];
        
        [self.view addSubview:self.classPickerView];
        [self.view addSubview:self.locationTextField];
        [self.view addSubview:self.startTimePicker];
        [self.view addSubview:self.endTimePicker];
        
        [self.view addSubview:self.startTimeButton];
        [self.view addSubview:self.endTimeButton];
        
        
        NSString *username = @"633454537";
        //NSMutableDictionary *newEvents = [[NSMutableDictionary alloc] init];
        Firebase *usersRef = [[Firebase alloc] initWithUrl:@"https://ustudy.firebaseio.com/users"];
        Firebase *eventsRef = [[usersRef childByAppendingPath:username] childByAppendingPath:@"events"];
        
    }
    return self;
}

- (void)addBackgroundImage
{
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"calendar-bg.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didFinishChoosing
{
    //    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //    NSString* username = appDelegate.username;
    //
    //    Firebase* usersRef = [[Firebase alloc] initWithUrl:@"https://uStudy.firebaseio.com/users"];
    //    Firebase* interestsRef = [[usersRef childByAppendingPath:username] childByAppendingPath:@"college"];
    //
    //
    [self dismissViewControllerAnimated:YES completion:^() {
        
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    //go to next view :P
    return false;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.classes = [[NSMutableArray alloc] init];
//	// Do any additional setup after loading the view.
//    // adding all the labels and picker views
//    self.classLabel = [[UILabel alloc] init];
//    self.locationLabel = [[UILabel alloc] init];
//    self.startTimeButton = [[UIButton alloc] init];
//    self.endTimeButton = [[UIButton alloc] init];
//
//    self.classPickerView = [[UIPickerView alloc] init];
//    self.locationTextField = [[UITextField alloc] init];
//    self.startTimePicker = [[UIDatePicker alloc] init];
//    self.endTimePicker = [[UIDatePicker alloc] init];
//    
//    //designing stuff
//    self.classLabel.frame = CGRectMake(20,10,100,100);
//    self.classLabel.text = @"Class";
//    self.locationLabel.frame = CGRectMake(20,120,100,100);
//    self.locationLabel.text = @"Location";
//    self.startTimeButton.frame = CGRectMake(20,220,100,100);
//    self.endTimeButton.frame = CGRectMake(20,280,100, 100);
//    
//    [self.locationLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [self.classLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [self.startTimeButton setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [self.endTimeButton setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [self.classPickerView setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [self.locationTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [self.startTimePicker setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [self.endTimePicker setTranslatesAutoresizingMaskIntoConstraints:NO];    
//    //white color text
////    self.classLabel.textColor = [UIColor whiteColor];
////    self.classLabel.textColor = [UIColor whiteColor];
////    self.locationLabel.textColor = [UIColor whiteColor];
//    self.startTimeButton.titleLabel.textColor = [UIColor blackColor];
//    
//    [self.startTimeButton setTitle:@"Starts" forState:UIControlStateNormal|UIControlStateHighlighted| UIControlStateDisabled|UIControlStateSelected];
//    [self.endTimeButton setTitle:@"Ends" forState:UIControlStateNormal|UIControlStateHighlighted| UIControlStateDisabled|UIControlStateSelected];
//    //[self.startTimeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal|UIControlStateHighlighted| UIControlStateDisabled|UIControlStateSelected];
//    //[self.endTimeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal|UIControlStateHighlighted| UIControlStateDisabled|UIControlStateSelected];
//    //[self.startTimeButton addTarget:self action:@selector(startButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//   //[self.endTimeButton addTarget:self action:@selector(endButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    
//    self.classPickerView.frame = CGRectMake(20,0,280,200);
// 
//    self.locationTextField.frame = CGRectMake(100,155,180,30);
//    self.locationTextField.backgroundColor = [UIColor blackColor];
//    self.locationTextField.textColor = [UIColor whiteColor];
//    self.startTimePicker.frame = CGRectMake(20,240,400,400);
//    self.endTimePicker.frame = CGRectMake(20,340,400,400);
//    
//    self.startTimePicker.datePickerMode = UIDatePickerModeDateAndTime;
//    self.endTimePicker.datePickerMode = UIDatePickerModeDateAndTime;
//    self.startTimePicker.hidden = YES;
//    self.endTimePicker.hidden = YES;
//    [self.startTimePicker addTarget:self action:@selector(startValueChanged:) forControlEvents:UIControlEventValueChanged];
//    [self.endTimePicker addTarget:self action:@selector(endvalueChanged:) forControlEvents:UIControlEventValueChanged];
//    
//    //picker view stuff
//    self.classPickerView.delegate = self;
//    self.classPickerView.dataSource = self;
//    self.classPickerView.showsSelectionIndicator = YES;
//    [self loadAndUpdateClasses];
//    
//    [self.view addSubview:self.locationLabel];
//    [self.view addSubview:self.classLabel];
//    
//    [self.view addSubview:self.classPickerView];
//    [self.view addSubview:self.locationTextField];
//    [self.view addSubview:self.startTimePicker];
//    [self.view addSubview:self.endTimePicker];
//    
//    [self.view addSubview:self.startTimeButton];
//    [self.view addSubview:self.endTimeButton];
//    
//
//    NSString *username = @"633454537";
//    //NSMutableDictionary *newEvents = [[NSMutableDictionary alloc] init];
//    Firebase *usersRef = [[Firebase alloc] initWithUrl:@"https://ustudy.firebaseio.com/users"];
//    Firebase *eventsRef = [[usersRef childByAppendingPath:username] childByAppendingPath:@"events"];
//    
//    // put fb event id here.
//    //[[eventsRef childByAutoId] setValue:@"Cameras"];
    
    
}


-(void) startButtonPressed:(id)button {
    self.startTimePicker.hidden = NO;
    self.endTimePicker.hidden = YES;
    //self.startTimeButton.hidden = YES;
}
-(void) endButtonPressed:(id)button {
    //self.endTimeButton.hidden = YES;
    self.endTimePicker.hidden = NO;
    self.startTimePicker.hidden = YES;
}
-(void) startValueChanged:(id)datepick {
    //self.startTimePicker.hidden = YES;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd - hh:mm"];
    NSString *newStr = [formatter stringFromDate:self.startTimePicker.date];
    NSLog(newStr);
    [self.startTimeButton setTitle:newStr forState:UIControlStateNormal|UIControlStateHighlighted| UIControlStateDisabled|UIControlStateSelected];
    
    //self.startTimeButton.hidden = NO;
}
-(void) endValueChanged:(id)datepick {
    //self.endTimeButton.hidden = NO;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd - hh:mm"];
    NSString *newStr = [formatter stringFromDate:self.endTimePicker.date];
    [self.endTimeButton setTitle:newStr forState:UIControlStateNormal|UIControlStateHighlighted| UIControlStateDisabled|UIControlStateSelected];
    NSLog(@"horses");
    NSLog(newStr);
    self.endTimePicker.hidden = YES;
}

- (void)loadAndUpdateClasses
{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *username = @"633454537";//appDelegate.username;
    
    Firebase *firebase = [[Firebase alloc] initWithUrl:@"https://ustudy.firebaseio.com/"];
    Firebase *classesRef = [[[firebase childByAppendingPath:@"users"] childByAppendingPath:username] childByAppendingPath:@"classes"];
    
    [classesRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if (snapshot == [NSNull null]) {
            NSLog(@"There are no classes");
        } else {
            NSArray *classesSnp = [snapshot.value allValues];
            self.classes = [classesSnp mutableCopy];
            NSLog(self.classes[0]);
        }
        [self.classPickerView reloadAllComponents];
    }];
    
    
}
    
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSLog(@"here");
    NSLog([NSString stringWithFormat:@"%d",[self.classes count]]);
    return [self.classes count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.classes objectAtIndex:row];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if ([touch view] != self.startTimePicker && [touch view] != self.endTimePicker){
        [self.startTimePicker endEditing:YES];
        [self.endTimePicker endEditing:YES];
    }
}


@end
