//
//  PlanTemplateViewController.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/4/10.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "PlanTemplateViewController.h"
#import "PlanDetailViewController.h"
#import "Q_coreDataHelper.h"

#import "WD_QTableParse.h"
#import "Q_UIConfig.h"
#import "Q_Plan+CoreDataClass.h"

@interface PlanTemplateViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)  NSArray *contentArr;

@end

@implementation PlanTemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 50.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PlanTemplate" ofType:@"json"];
    NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray *jsonArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    self.contentArr = jsonArr;
    [self.tableView reloadData];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contentArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:@"templateCell"];
    _cell.textLabel.text = self.contentArr[indexPath.row][@"Title"];
    _cell.textLabel.textColor = [Q_UIConfig shareInstance].generalCellTitleFontColor;
    return _cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *content = self.contentArr[indexPath.row][@"Content"];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PlanDetailViewController *PlanDetailVC =  [storyBoard instantiateViewControllerWithIdentifier:@"PlanDetailViewController"];
    Q_Plan* newPlan = [NSEntityDescription insertNewObjectForEntityForName:@"Q_Plan" inManagedObjectContext:[Q_coreDataHelper shareInstance].managedContext];
    newPlan.content = content;
    newPlan.editDate = [NSDate date];
    PlanDetailVC.plan = newPlan;
    [self showViewController:PlanDetailVC sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
