//
//  HomeViewController.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/4/11.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTitleTableViewCell.h"
#import "Q_UIConfig.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *contentView;
@property (strong, nonatomic) NSArray *HomeList;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView.delegate = self;
    self.contentView.dataSource = self;
    self.contentView.estimatedRowHeight = 50.f;
    self.contentView.rowHeight = UITableViewAutomaticDimension;
    self.view.backgroundColor = [Q_UIConfig shareInstance].generalBackgroundColor;
    self.HomeList = @[@"",@"主题设置",@"数据同步",@"数据统计",@"关于APP"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.HomeList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        HomeTitleTableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
        return _cell;
    }else{
        UITableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell"];
        _cell.textLabel.text = self.HomeList[indexPath.row];
        return _cell;
    }
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
