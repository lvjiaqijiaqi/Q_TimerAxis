//
//  PlanViewController.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/4/9.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "PlanViewController.h"
#import "Q_UIConfig.h"
#import "Q_coreDataHelper.h"
#import "Q_Plan+CoreDataClass.h"
#import "PlanDetailViewController.h"
#import "NSDate+Extension.h"
#import "PlanTableViewCell.h"

@interface PlanViewController ()

@property (weak, nonatomic) IBOutlet UITableView *contentView;

@property (strong, nonatomic) IBOutlet UIButton *selectBtn1;
@property (strong, nonatomic) IBOutlet UIButton *selectBrn2;
@property (assign, nonatomic) NSInteger selectIdx;
@property (strong, nonatomic) NSArray<UIButton *> *selectBtns;
@end

@implementation PlanViewController

-(UITableView *)tableView{
    return self.contentView;
}

-(void)configureViews{
    self.view.backgroundColor = [Q_UIConfig shareInstance].generalBackgroundColor;
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.delegate = self;
    self.contentView.dataSource = self;
    self.contentView.contentInset = UIEdgeInsetsZero;
    self.contentView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.contentView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.contentView.separatorColor = [Q_UIConfig shareInstance].generalBackgroundColor;
    self.contentView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.contentView.bounces = NO;
    
    NSArray *menuBtns = @[self.selectBtn1,self.selectBrn2];
    [menuBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setTitleColor:[Q_UIConfig shareInstance].generalCellSubTitleFontColor forState:UIControlStateNormal];
        obj.titleLabel.font = [Q_UIConfig shareInstance].generalBodyFont;
        obj.adjustsImageWhenHighlighted = NO;
        obj.tag = idx;
        [obj addTarget:self action:@selector(setSelect:) forControlEvents:UIControlEventTouchDown];
    }];
    self.selectBtns = menuBtns;
    _selectIdx = 0;
    [self.selectBtns[_selectIdx] setTitleColor:[Q_UIConfig shareInstance].mainColor forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViews];
    [self configureFetch];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self performFetch];
}

-(void)setSelect:(UIButton *)sender{
    NSInteger index = sender.tag;
    if (index != self.selectIdx) {
        [self.selectBtns[self.selectIdx] setTitleColor:[Q_UIConfig shareInstance].generalCellSubTitleFontColor forState:UIControlStateNormal];
        self.selectIdx = index;
        [self.selectBtns[self.selectIdx] setTitleColor:[Q_UIConfig shareInstance].mainColor forState:UIControlStateNormal];
        [self configureFetch];
        [self performFetch];
    }
}


-(void)configureFetch{
    NSFetchRequest *request = [Q_Plan fetchRequest];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"editDate" ascending:NO]];
    if (self.selectIdx == 0) {
        request.predicate = [NSPredicate predicateWithFormat:@"isEditing = NO "];
    }else{
        request.predicate = [NSPredicate predicateWithFormat:@"isEditing = YES "];
    }
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[Q_coreDataHelper shareInstance].managedContext sectionNameKeyPath:nil cacheName:nil];
    self.frc.delegate = self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"planCell" forIndexPath:indexPath];
    Q_Plan *plan = [self.frc objectAtIndexPath:indexPath];
    cell.textLabel.text =  plan.title;
    cell.detailTextLabel.text = [NSDate dateToString:[plan editDate]];
    //cell.lastUpdateLabel.text = [NSDate dateToString:[timeLine createDate]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Q_Plan *plan = [self.frc objectAtIndexPath:indexPath];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PlanDetailViewController *detailVC =  [storyBoard instantiateViewControllerWithIdentifier:@"PlanDetailViewController"];
    detailVC.plan = plan;
    [self showViewController:detailVC sender:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.f;
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *rowAction =  [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self createCancelNotive:indexPath];
    }];
    rowAction.backgroundColor = [Q_UIConfig shareInstance].generalNavgroundColor;
    return @[rowAction];
}

- (void)createCancelNotive:(NSIndexPath *)indexPath{
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"确认删除" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        Q_Plan *plan = [weakSelf.frc objectAtIndexPath:indexPath];
        [[Q_coreDataHelper shareInstance].managedContext deleteObject:plan];
    }];
    [sheet addAction:action];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [sheet addAction:cancel];
    [self presentViewController:sheet animated:YES completion:^{}];
}

@end
