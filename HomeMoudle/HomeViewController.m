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
#import "Q_coreDataHelper.h"
#import "Q_Event+CoreDataClass.h"
#import "Q_Plan+CoreDataClass.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *contentView;
@property (strong, nonatomic) NSArray *HomeList;

@end

@implementation HomeViewController

-(void)loadData{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSFetchRequest *fetchRequest1 = [Q_Event fetchRequest];
        fetchRequest1.resultType = NSCountResultType;
        NSError *error1 = nil;
        NSArray *eventList = [[Q_coreDataHelper shareInstance].managedContext executeFetchRequest:fetchRequest1 error:&error1];
        NSInteger count1 = [eventList.firstObject integerValue];
        if (!error1) {}
        
        NSFetchRequest *fetchRequest2 = [Q_Plan fetchRequest];
        fetchRequest2.resultType = NSCountResultType;
        NSError *error2 = nil;
        NSArray *planList = [[Q_coreDataHelper shareInstance].managedContext executeFetchRequest:fetchRequest2 error:&error2];
        NSInteger count2 = [planList.firstObject integerValue];
        if (!error2) {}
        dispatch_async(dispatch_get_main_queue(), ^{
            HomeTitleTableViewCell *cell = [self.contentView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.subLeftLabel.text = [NSString stringWithFormat:@"任务：%ld",count1];
            cell.subRightLabel.text = [NSString stringWithFormat:@"计划：%ld",count2];
        });
    });
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView.delegate = self;
    self.contentView.bounces = NO;
    self.contentView.dataSource = self;
    self.contentView.estimatedRowHeight = 50.f;
    self.contentView.rowHeight = UITableViewAutomaticDimension;
    self.contentView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
        _cell.textLabel.textColor = [Q_UIConfig shareInstance].generalCellBodyFontColor;
        _cell.seprateLine.backgroundColor = [Q_UIConfig shareInstance].generalBackgroundColor;
        _cell.selectionStyle = UITableViewCellSelectionStyleNone;
        _cell.subLeftLabel.textColor = [Q_UIConfig shareInstance].generalCellBodyFontColor;
        _cell.subRightLabel.textColor = [Q_UIConfig shareInstance].generalCellBodyFontColor;
        _cell.subLeftLabel.font = [Q_UIConfig shareInstance].generalBodyFont;
        _cell.subRightLabel.font = [Q_UIConfig shareInstance].generalBodyFont;
        [self loadData];
        return _cell;
    }else{
        UITableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell"];
        _cell.textLabel.textColor = [Q_UIConfig shareInstance].generalCellBodyFontColor;
        _cell.textLabel.text = self.HomeList[indexPath.row];
        _cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
