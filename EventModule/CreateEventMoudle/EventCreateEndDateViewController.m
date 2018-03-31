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

@interface EventCreateEndDateViewController ()

@property(nonatomic,strong)   CalendarManagerController *calendarManagerController;
@property (strong,nonatomic)  JTCalendarMenuView *calendarMenuView;
@property (strong,nonatomic)  JTHorizontalCalendarView *calendarContentView;

@end

@implementation EventCreateEndDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"完成日期";
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
    self.model.endDate = self.calendarManagerController.dateSelected;
}

@end
