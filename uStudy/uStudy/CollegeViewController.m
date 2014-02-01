//
//  CollegeViewController.m
//  uStudy
//
//  Created by Lucy Guo on 1/31/14.
//  Copyright (c) 2014 Angela Zhang. All rights reserved.
//

#import "CollegeViewController.h"

@interface CollegeViewController ()

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
        
        //can't figure out how to add searchbox :(
        //[self addSearchBox];
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
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 200, 300, 40)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:15];
    textField.placeholder = @"enter text";
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:textField];
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
