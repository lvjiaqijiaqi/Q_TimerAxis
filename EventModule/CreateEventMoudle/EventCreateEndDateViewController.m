//
//  EventCreateEndDateViewController.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/3/30.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "EventCreateEndDateViewController.h"
#import "JTCalendar.h"
#import "CalendarManagerController.h"
#import "Q_UIConfig.h"
#import "UIAlertController+Q_Alert.h"
#import "NSDate+Extension.h"

@interface EventCreateEndDateViewController ()

@property(nonatomic,strong)   CalendarManagerController *calendarManagerController;
@property (strong,nonatomic)  JTCalendarMenuView *calendarMenuView;
@property (strong,nonatomic)  JTHorizontalCalendarView *calendarContentView;
@property (strong,nonatomic)  UIDatePicker *datePicker;

@end

@implementation EventCreateEndDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"完成日期";
    self.calendarContentView = [[JTHorizontalCalendarView alloc] initWithFrame:CGRectMake(0,40, self.view.frame.size.width,300)];
    self.calendarMenuView = [[JTCalendarMenuView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    self.calendarMenuView.backgroundColor = [Q_UIConfig shareInstance].generalNavgroundColor;
    
    [self.view addSubview:self.calendarContentView];
    [self.view addSubview:self.calendarMenuView];
    
    self.calendarManagerController = [[CalendarManagerController alloc] init];
    self.calendarManagerController.calendarMenuView = self.calendarMenuView;
    self.calendarManagerController.calendarContentView = self.calendarContentView;
    [self.calendarManagerController startWork];
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 350, self.view.frame.size.width, self.view.frame.size.height - 350)];
    [self.datePicker setTimeZone:[NSTimeZone defaultTimeZone]];
    self.datePicker.datePickerMode =  UIDatePickerModeTime;
    [self.view addSubview:self.datePicker];
    
}

-(void)updateViewFromModel{
    [super updateViewFromModel];
    if (self.model.endDate) {
        self.datePicker.date = self.model.endDate;
        [self.calendarManagerController setDateSelected:self.model.endDate];
    }
}
-(void)storeModelFromView{
    [super storeModelFromView];
    self.model.endDate = [self selectedDate];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.model.endDate = [self selectedDate];
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    NSDate *date = [self selectedDate];
    if (![date laterThanDate:self.model.startDate]) {
        UIAlertController *alert = [UIAlertController createAlertWithTitle:@"提示" massage:@"结束时间不能早于开始时间" ok:^{}];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    return YES;
}

@end
