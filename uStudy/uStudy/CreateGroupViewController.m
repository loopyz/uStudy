//
//  CreateGroupViewController.m
//  uStudy
//
//  Created by Niveditha Jayasekar on 2/1/14.
//  Copyright (c) 2014 Angela Zhang. All rights reserved.
//

#import "CreateGroupViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Firebase/Firebase.h>
#import "AppDelegate.h"

@interface CreateGroupViewController () <UITextFieldDelegate>

@end

@implementation CreateGroupViewController

@synthesize classLabel, locationLabel, startTimeLabel;
@synthesize classPickerView, locationTextField, startTimePicker;
@synthesize classr, classes, groupName;

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
        self.startTimeLabel = [[UILabel alloc] init];
        
        self.classPickerView = [[UIPickerView alloc] init];
        self.locationTextField = [[UITextField alloc] init];
        self.startTimePicker = [[UIDatePicker alloc] init];
        
    UIImage *buttonImage = [UIImage imageNamed:@"college-submit.png"];
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [submitButton addTarget:self action:@selector(addNewGroup) forControlEvents:UIControlEventTouchDown];
    [submitButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        //designing stuff
        self.classLabel.frame = CGRectMake(20,10,100,100);
        self.classLabel.text = @"Class";
        self.locationLabel.frame = CGRectMake(20,120,100,100);
        self.locationLabel.text = @"Location";
        self.startTimeLabel.frame = CGRectMake(20,220,100,100);
        
        
        self.classPickerView.frame = CGRectMake(20,0,280,200);
        
        self.locationTextField.frame = CGRectMake(100,155,180,30);
        self.locationTextField.backgroundColor = [UIColor blackColor];
        self.locationTextField.textColor = [UIColor whiteColor];
        self.startTimePicker.frame = CGRectMake(20,240,400,400);
        submitButton.frame = CGRectMake(20,400,100,100);
        
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
        
        [self.view addSubview:self.startTimeLabel];
        [self.view addSubview:submitButton];
        
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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    NSString *username = @"633454537";
    //NSMutableDictionary *newEvents = [[NSMutableDictionary alloc] init];
    Firebase *usersRef = [[Firebase alloc] initWithUrl:@"https://ustudy.firebaseio.com/users"];
    Firebase *eventsRef = [[usersRef childByAppendingPath:username] childByAppendingPath:@"events"];
    
    // put fb event id here.
    //[[eventsRef childByAutoId] setValue:@"Cameras"];
    
    
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    //go to next view :P
    return false;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if ([touch view] != self.startTimePicker){
        [self.startTimePicker endEditing:YES];
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    self.classr = self.classes[row];
}

- (void)exit {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void) addNewGroup
{
    NSLog(@"Added new group");
    
    NSString *description = [[@"Studying for " stringByAppendingString:self.classr] stringByAppendingString:@" with uStudy"];
    
    [self createFacebookEvent:self.classr withStartTime:[self.startTimePicker date] andLocation:self.locationTextField.text andDescription:description];
}

- (NSString *)dateToString: (NSDate *)date
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZ'"];
    return [formatter stringFromDate:date];
    //NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    //[formatter setDateFormat:@"MM/dd - hh:mm"];
    //return [formatter stringFromDate:date];
}

-(void)createFacebookEvent:(NSString *)name withStartTime:(NSDate *)sdate andLocation:(NSString *)location andDescription:(NSString *)description {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            name,@"name",
                            [self dateToString:sdate],@"start_time",
                            location,@"location",
                            description,@"description",
                            nil];
    NSLog(description);
    [FBRequestConnection startWithGraphPath:@"me/events"
                         parameters:params
                         HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection,id result, NSError *error) {
                              AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                              //NSLog(result);
                              if (!error && result) {
                                  NSLog(@"done");
                                  NSString *username = appDelegate.username;
                                  Firebase *eventUserRef = [[[[Firebase alloc] initWithUrl:@"https://ustudy.firebaseio.com/users/"] childByAppendingPath:username] childByAppendingPath:@"events"];
                                  Firebase *eventClassRef = [[[[Firebase alloc] initWithUrl:@"https://ustudy.firebaseio.com/classes"] childByAppendingPath:self.classr] childByAppendingPath:@"events"];
                                  [[eventUserRef childByAutoId] setValue:result[@"id"]];
                                  [[eventClassRef childByAutoId] setValue:result[@"id"]];
                                  [self exit];
                              } else {
                                  [appDelegate showMessage:@"Error creating study group, try again later" withTitle:@"Error"];
                              }
                          }];
}
@end
