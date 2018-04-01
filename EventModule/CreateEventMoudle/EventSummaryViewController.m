//
//  EventSummaryViewController.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/3/30.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "EventSummaryViewController.h"
#import "EventSummaryTableViewCell.h"
#import "EventCreateFlowViewController.h"

#import "NSDate+Extension.h"
#import "Q_UIConfig.h"

@interface EventSummaryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *contentView;

@property (strong, nonatomic) NSArray *titles;

@end

@implementation EventSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认计划";
    self.view.backgroundColor = [Q_UIConfig shareInstance].generalBackgroundColor;
    self.titles = @[@"开始时间",@"结束时间",@"标题",@"内容"];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(complete)];
}

-(void)complete{
    EventCreateFlowViewController *navigationController = (EventCreateFlowViewController *)self.navigationController;
    [navigationController completeEventCreate];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.contentView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventSummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventSummaryCell" forIndexPath:indexPath];
    cell.title.text = self.titles[indexPath.row];
    switch (indexPath.row) {
        case 0:
            cell.content.text =  [NSDate dateToString:self.model.startDate];
            break;
        case 1:
            cell.content.text = [NSDate dateToString:self.model.endDate];
            break;
        case 2:
            cell.content.text = self.model.title;
            break;
        case 3:
            cell.content.text = self.model.content;
            break;
        default:
            break;
    }
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.f;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
