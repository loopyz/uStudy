//
//  CreateGroupViewController.h
//  uStudy
//
//  Created by Niveditha Jayasekar on 2/1/14.
//  Copyright (c) 2014 Angela Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateGroupViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic) NSMutableArray *classes;
@property (strong, nonatomic) UILabel *classLabel;
@property (strong, nonatomic) UIPickerView *classPickerView;

@property (strong, nonatomic) UILabel *locationLabel;

@property (strong, nonatomic) UILabel *timeLabel;


@property (strong, nonatomic) UITextField *locationTextField;

@property (strong, nonatomic) UILabel *startTimeLabel;
@property (strong, nonatomic) UIDatePicker *startTimePicker;

@property (strong, nonatomic) NSString *classr;
@property (strong, nonatomic) NSString *groupName;

@end
