//
//  CollegeViewController.m
//  uStudy
//
//  Created by Lucy Guo on 1/31/14.
//  Copyright (c) 2014 Angela Zhang. All rights reserved.
//

#import "CollegeViewController.h"

@interface CollegeViewController () <UITextFieldDelegate>

@end

@implementation CollegeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self addBackgroundImage];
        [self addAttendingLabel];
        [self addCurrentCollegeLabel];
        [self addIncorrectLabel];
        [self addSearchBox];
        [self addSubmitButton];
    }
    return self;
}

- (void)addAttendingLabel {
    UILabel *youAttend = [[UILabel alloc] init];
    
    youAttend.text = @"You Attend:";
    youAttend.textColor = [UIColor whiteColor];
    
    //create shadow
    youAttend.layer.shadowColor = [[UIColor blackColor] CGColor];
    youAttend.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    youAttend.layer.shadowOpacity = 0.5;
    
    //create frame for text
    youAttend.frame = CGRectMake(0, 0, self.view.bounds.size.width, 200);
    youAttend.font = [UIFont fontWithName:@"Helvetica" size:35.0];
    
    //centers text
    youAttend.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:youAttend];
    
}

- (void)addCurrentCollegeLabel
{
    UILabel *collegeLabel = [[UILabel alloc] init];
    
    //hardcoded to CMU for now
    collegeLabel.text = @"Carnegie Mellon University";
    collegeLabel.textColor = [UIColor whiteColor];
    
    //create shadow
    collegeLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
    collegeLabel.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    collegeLabel.layer.shadowOpacity = 0.5;
    
    //create frame for text
    collegeLabel.frame = CGRectMake(0, 0, self.view.bounds.size.width, 330);
    collegeLabel.font = [UIFont fontWithName:@"Helvetica" size:25.0];
    
    //centers text
    collegeLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:collegeLabel];
    
}

- (void)addIncorrectLabel {
    UILabel *incorrectLabel = [[UILabel alloc] init];
    
    incorrectLabel.text = @"If incorrect, please enter your college below:";
    incorrectLabel.numberOfLines = 0;
    incorrectLabel.textColor = [UIColor whiteColor];
    
    //create shadow
    incorrectLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
    incorrectLabel.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    incorrectLabel.layer.shadowOpacity = 0.5;
    
    //create frame for text
    incorrectLabel.frame = CGRectMake(0, 0, self.view.bounds.size.width, 520);
    incorrectLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:20.0];
    
    //centers text
    incorrectLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:incorrectLabel];
    
}

- (void)addBackgroundImage
{
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"college.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}

- (void)addSearchBox
{
    UIImage *textBG = [UIImage imageNamed:@"searchbox.png"];
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 320, 300, 40)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:15];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"search" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    textField.textColor = [UIColor whiteColor];
    
    //set padding
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;

    
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.borderStyle = UITextBorderStyleNone;
    [textField setBackground:textBG];
    textField.delegate = self;
    [self.view addSubview:textField];
}

- (void)addSubmitButton
{
    UIImage *buttonImage = [UIImage imageNamed:@"college-submit.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(didFinishChoosing) forControlEvents:UIControlEventTouchDown];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 500, 320, 50);
    [self.view addSubview:button];
    
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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
