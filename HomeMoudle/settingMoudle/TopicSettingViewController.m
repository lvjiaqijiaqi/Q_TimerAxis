//
//  TopicSettingViewController.m
//  Q_TimerAxis
//
//  Created by lvjiaqi on 2018/4/15.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "TopicSettingViewController.h"
#import "Q_UIConfig.h"
#import "TopicSettingTableViewCell.h"

@interface TopicSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TopicSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60.f;
    self.navigationItem.title = @"主题设置";
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [Q_UIConfig shareInstance].topicColors.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TopicSettingTableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    _cell.titleLabel.text = [Q_UIConfig shareInstance].topicColors[indexPath.row][@"name"];
    _cell.selectionStyle = UITableViewCellSelectionStyleNone;
    _cell.colorView.backgroundColor = [Q_UIConfig shareInstance].topicColors[indexPath.row][@"color"];
    _cell.titleLabel.textColor = [Q_UIConfig shareInstance].generalCellBodyFontColor;
    _cell.titleLabel.font = [Q_UIConfig shareInstance].generalBodyFont;
    return _cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:@"topicIdx"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    __weak typeof(self) weakSelf = self;
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"主题修改将在下一次启动时候生效" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf popoverPresentationController];
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
