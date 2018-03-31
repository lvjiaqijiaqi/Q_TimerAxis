//
//  EventCreateStartDateViewController.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/3/30.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "EventCreateStartDateViewController.h"
#import "JTCalendar.h"
#import "CalendarManagerController.h"

@interface EventCreateStartDateViewController ()

@property(nonatomic,strong) CalendarManagerController *calendarManagerController;
@property (strong,nonatomic)  JTCalendarMenuView *calendarMenuView;
@property (strong,nonatomic)  JTHorizontalCalendarView *calendarContentView;

@end

@implementation EventCreateStartDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开始日期";
    self.calendarContentView = [[JTHorizontalCalendarView alloc] initWithFrame:CGRectMake(0,60, self.view.frame.size.width,300)];
    self.calendarMenuView = [[JTCalendarMenuView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    
    [self.view addSubview:self.calendarContentView];
    [self.view addSubview:self.calendarMenuView];
    
    self.calendarManagerController = [[CalendarManagerController alloc] init];
    self.calendarManagerController.calendarMenuView = self.calendarMenuView;
    self.calendarManagerController.calendarContentView = self.calendarContentView;
    [self.calendarManagerController startWork];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.model.startDate = self.calendarManagerController.dateSelected;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}*/


@end
