//
//  TimerViewController.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/3/27.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "TimerViewController.h"
#import "Q_TimeLine+CoreDataClass.h"
#import "TimeLineTableViewCell.h"
#import "NSDate+Extension.h"
#import "TimerDetailViewController.h"
#import "Q_UIConfig.h"

@interface TimerViewController ()

@property (weak, nonatomic) IBOutlet UITableView *contentView;

@property (strong, nonatomic) NSIndexPath *selectIndexPath;
@end

@implementation TimerViewController

-(UITableView *)tableView{
    return self.contentView;
}
-(void)configureFetch{
    NSFetchRequest *request = [Q_TimeLine fetchRequest];
    request.predicate = [NSPredicate predicateWithFormat:@"event = %@",self.event];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:NO]];
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[Q_coreDataHelper shareInstance].managedContext sectionNameKeyPath:nil cacheName:nil];
    self.frc.delegate = self;
}
-(void)configureView{
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.delegate = self;
    self.contentView.dataSource = self;
    self.contentView.bounces = NO;
    self.contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.contentView.separatorColor = [UIColor clearColor];
    self.contentView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MainNavBar_AddIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(addNewTimeLine)];
    self.navigationItem.rightBarButtonItems = @[addItem];
    self.navigationItem.title = @"任务时间线";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
    [self configureFetch];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self performFetch];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)addNewTimeLine{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TimerDetailViewController *timerDetailVC =  [storyBoard instantiateViewControllerWithIdentifier:@"TimerDetailVC"];
    timerDetailVC.event = self.event;
    [self showViewController:timerDetailVC sender:nil];
}

#pragma mark - tableView delegate and Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimeLineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timerCell" forIndexPath:indexPath];
    Q_TimeLine *timeLine = [self.frc objectAtIndexPath:indexPath];
    cell.contentTextView.text =  timeLine.content;
    cell.lastUpdateLabel.text = [NSDate dateToString:[timeLine createDate]];
    cell.processLabel.text = [NSString stringWithFormat:@"%.0f%%",timeLine.progress * 100];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.f;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return UITableViewCellEditingStyleDelete;//删除模式
}

- (void)createCancelNotive:(NSIndexPath *)indexPath{
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"确认删除" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        Q_TimeLine *timeLine = [self.frc objectAtIndexPath:indexPath];
        [[Q_coreDataHelper shareInstance].managedContext deleteObject:timeLine];
        [[Q_coreDataHelper shareInstance] saveContext];
        [weakSelf updateEventProcess];
    }];
    [sheet addAction:action];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [sheet addAction:cancel];
    [self presentViewController:sheet animated:YES completion:^{}];
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *rowAction =  [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self createCancelNotive:indexPath];
    }];
    rowAction.backgroundColor = [Q_UIConfig shareInstance].generalNavgroundColor;
    return @[rowAction];
}

-(void)updateEventProcess{
    
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Q_TimeLine"];
    request.predicate = [NSPredicate predicateWithFormat:@"event = %@",self.event];
    [request setResultType:NSDictionaryResultType]; //必须设置为这个类型
    
    //构造用于sum的ExpressionDescription（稍微有点繁琐啊）
    NSExpression *theMaxExpression = [NSExpression expressionForFunction:@"max:" arguments:[NSArray arrayWithObject:[NSExpression expressionForKeyPath:@"progress"]]];
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    [expressionDescription setName:@"maxProgress"];
    [expressionDescription setExpression:theMaxExpression];
    [expressionDescription setExpressionResultType:NSFloatAttributeType];
    
    //加入Request
    [request setPropertiesToFetch:[NSArray arrayWithObjects:expressionDescription,nil]];
    
    NSError* error;
    id result = [[Q_coreDataHelper shareInstance].managedContext executeFetchRequest:request error:&error];
    //返回的对象是一个字典的数组，取数组第一个元素，再用我们前面指定的key（也就是"maxAge"）去获取我们想要的值
    self.event.progress = [[[result objectAtIndex:0] objectForKey:@"maxProgress"] floatValue];
     [[Q_coreDataHelper shareInstance] saveContext];
}
@end
