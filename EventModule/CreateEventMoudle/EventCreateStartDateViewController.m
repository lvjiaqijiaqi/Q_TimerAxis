//
//  EventCreateStartDateViewController.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/3/30.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "EventCreateStartDateViewController.h"

#import "UIAlertController+Q_Alert.h"
#import "NSDate+Extension.h"

#import "Q_UIConfig.h"
#import "JTCalendar.h"

#import "CalendarManagerController.h"


@interface EventCreateStartDateViewController ()

@property (strong,nonatomic)  CalendarManagerController *calendarManagerController;
@property (strong,nonatomic)  JTCalendarMenuView *calendarMenuView;
@property (strong,nonatomic)  JTHorizontalCalendarView *calendarContentView;
@property (strong,nonatomic)  UIDatePicker *datePicker;

@end

@implementation EventCreateStartDateViewController

-(void)configureView{
    self.title = @"开始日期";
    self.calendarContentView = [[JTHorizontalCalendarView alloc] initWithFrame:CGRectMake(0,40, self.view.frame.size.width,300)];
    self.calendarMenuView = [[JTCalendarMenuView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    self.calendarMenuView.backgroundColor = [Q_UIConfig shareInstance].generalNavgroundColor;
    
    [self.view addSubview:self.calendarContentView];
    [self.view addSubview:self.calendarMenuView];
    
    self.calendarManagerController = [[CalendarManagerController alloc] init];
    self.calendarManagerController.calendarMenuView = self.calendarMenuView;
    self.calendarManagerController.calendarContentView = self.calendarContentView;
    [self.calendarManagerController startWork];
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 340, self.view.frame.size.width, 150)];
    [self.datePicker setTimeZone:[NSTimeZone defaultTimeZone]];
    self.datePicker.datePickerMode =  UIDatePickerModeTime;
    [self.view addSubview:self.datePicker];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
}

-(void)updateViewFromModel{
    [super updateViewFromModel];
    if (self.model.startDate) {
        self.datePicker.date = self.model.startDate;
        [self.calendarManagerController setDateSelected:self.model.startDate];
    }
}
-(void)storeModelFromView{
    [super storeModelFromView];
    self.model.startDate = [self selectedDate];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.model.startDate = [self selectedDate];
}
-(NSDate *)selectedDate{
    NSInteger interval = 0;
    if (self.calendarManagerController.dateSelected) {
        interval = [self.datePicker.date timeIntervalSinceDate:self.calendarManagerController.dateSelected];
        interval = interval % (60 * 60 * 24);
        interval = interval > 0 ? interval : -interval;
        return [[NSDate alloc] initWithTimeInterval:interval sinceDate:self.calendarManagerController.dateSelected];
    }else{
        return self.datePicker.date;
    }
}

@end
