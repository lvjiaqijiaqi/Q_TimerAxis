//
//  EventViewController.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/3/27.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "EventViewController.h"

#import "Q_UIConfig.h"
#import "NSDate+Extension.h"

#import "Q_coreDataHelper.h"
#import "Q_Event+CoreDataClass.h"

#import "EventCreateFlowViewController.h"
#import "EventSearchResultViewController.h"
#import "TimerViewController.h"

#import "EventTableViewCell.h"


@interface EventViewController ()<UISearchBarDelegate,UISearchControllerDelegate,EventSearchResultDelegate>

/* views */
@property (weak, nonatomic) IBOutlet UIView *controllView;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *middleBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *sortBtn;
@property (strong,nonatomic) NSArray<UIButton *> *MenuBtns;

@property (strong, nonatomic) UIRefreshControl *tabelRefreashContoller;

/* 逻辑参数 */
@property (strong, nonatomic) NSArray *sortTitles;
@property (assign, nonatomic) NSInteger menuIdx;
@property (strong, nonatomic) NSIndexPath *selectIndexPath;
@property (assign, nonatomic) NSInteger sortIdx;

/* 搜索 */
@property (strong, nonatomic) UISearchController *eventSearchVC;
@property (strong, nonatomic) EventSearchResultViewController *eventResSearchVC;

@end

@implementation EventViewController

-(UITableView *)tableView{
    return self.myTableView;
}

#pragma mark - coredata配置
-(void)configureFetch{
    static NSArray *sortTag;
    sortTag = @[@"lastUpdate",@"startDate",@"progress"];
    NSFetchRequest *request = [Q_Event fetchRequest];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:sortTag[self.sortIdx] ascending:NO]];
    if (self.menuIdx == 1) {
        NSPredicate * predict = [NSPredicate predicateWithFormat:@"progress < %f", 1.f];
        request.predicate = predict;
    }else if(self.menuIdx == 2){
        NSPredicate * predict = [NSPredicate predicateWithFormat:@"progress == %f", 1.f];
        request.predicate = predict;
    }
    request.fetchBatchSize = 20;
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[Q_coreDataHelper shareInstance].managedContext sectionNameKeyPath:nil cacheName:nil];
    self.frc.delegate = self;
}

#pragma mark - views配置
-(void)configureViews{
    /* view */
    self.navigationItem.title = @"我的任务";
    self.view.backgroundColor = [Q_UIConfig shareInstance].generalBackgroundColor;
    /* tableView */
    self.myTableView.backgroundColor = [UIColor clearColor];
    self.myTableView.bounces = YES;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.tabelRefreashContoller =  [[UIRefreshControl alloc] init];
    [self.tabelRefreashContoller setAttributedTitle:[[NSAttributedString alloc] initWithString:@"松开刷新" attributes:@{NSForegroundColorAttributeName:[Q_UIConfig shareInstance].mainColor}]];
    self.myTableView.refreshControl = self.tabelRefreashContoller;
    [self.tabelRefreashContoller addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    /* controllView */
    self.controllView.backgroundColor = [UIColor whiteColor];
    self.MenuBtns = @[self.leftBtn,self.middleBtn,self.rightBtn];
    [self.MenuBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setTitleColor:[Q_UIConfig shareInstance].generalCellSubTitleFontColor forState:UIControlStateNormal];
        obj.titleLabel.font = [Q_UIConfig shareInstance].generalBodyFont;
        obj.adjustsImageWhenHighlighted = NO;
        obj.tag = idx;
        [obj addTarget:self action:@selector(setMenuIndex:) forControlEvents:UIControlEventTouchDown];
    }];
    _menuIdx = 0;
    [self.MenuBtns[self.menuIdx] setTitleColor:[Q_UIConfig shareInstance].mainColor forState:UIControlStateNormal];
    /* sortView */
    self.sortTitles = @[@"按更新日期",@"按创建日期",@"按完成度"];
    [self.sortBtn setTitleColor:[Q_UIConfig shareInstance].generalCellSubTitleFontColor forState:UIControlStateNormal];
    self.sortBtn.titleLabel.font = [Q_UIConfig shareInstance].generalBodyFont;
    [self.sortBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    self.sortBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.sortBtn addTarget:self action:@selector(createSortMenu) forControlEvents:UIControlEventTouchDown];
    [self.sortBtn setTitle:self.sortTitles[0] forState:UIControlStateNormal];
    /* searchView */
    self.eventSearchVC.searchBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64);
    [self.view addSubview:self.eventSearchVC.searchBar];
    self.eventSearchVC.searchBar.hidden = YES;
    
}

#pragma mark - 控制器生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViews];
    [self configureFetch];
    [self refreshAction];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.eventSearchVC.active = NO;
}

#pragma mark - 交互

- (void)createSortMenu{
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"选择排序方式" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;
    [self.sortTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {[weakSelf setSortIndex:idx];}];
        [sheet addAction:action];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [sheet addAction:cancel];
    [self presentViewController:sheet animated:YES completion:^{}];
}
-(void)setSortIndex:(NSInteger)index{
    if (self.sortIdx != index) {
        self.sortIdx = index;
        [self.sortBtn setTitle:self.sortTitles[self.sortIdx] forState:UIControlStateNormal];
        [self configureFetch];
        [self refreshAction];
    }
}
-(void)setMenuIndex:(UIButton *)sender{
    NSInteger index = sender.tag;
    if (index != self.menuIdx) {
        [self.MenuBtns[self.menuIdx] setTitleColor:[Q_UIConfig shareInstance].generalCellSubTitleFontColor forState:UIControlStateNormal];
        self.menuIdx = index;
        [self.MenuBtns[self.menuIdx] setTitleColor:[Q_UIConfig shareInstance].mainColor forState:UIControlStateNormal];
        [self configureFetch];
        [self refreshAction];
    }
}

-(void)refreshAction{
    [self.tabelRefreashContoller beginRefreshing];
    [self performFetch];
    [self.tabelRefreashContoller setAttributedTitle:[[NSAttributedString alloc] initWithString:@"正在加载" attributes:@{NSForegroundColorAttributeName:[Q_UIConfig shareInstance].mainColor}]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tabelRefreashContoller setAttributedTitle:[[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName:[Q_UIConfig shareInstance].mainColor}]];
        [self.tabelRefreashContoller endRefreshing];
    });
}

#pragma mark - SEGUE
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Add Event Segue"])
    {}else if([segue.identifier isEqualToString:@"Event Detail Segue"]){//Event
        TimerViewController *timerVC = segue.destinationViewController;
        timerVC.event = [self.frc objectAtIndexPath:self.selectIndexPath];
    }
}

#pragma mark - tableViewDelegateAndDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [super numberOfSectionsInTableView:tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [super tableView:tableView numberOfRowsInSection:section];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Q_Event *event = [self.frc objectAtIndexPath:indexPath];
    cell.titleLabel.text = event.title;
    cell.bodyLabel.text = event.body;
    cell.processLabel.text = [NSString stringWithFormat:@"%.1f%%",event.progress * 100];
    cell.lastUpdateDateLabel.text = [NSDate dateToString:event.lastUpdate];
    cell.startDateLabel.text =  [NSDate intervalFormatStringToDate:[event.deadLine timeIntervalSinceNow]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.f;
}
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectIndexPath = indexPath;
    return indexPath;
}
/* 删除操作 */
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *rowAction =  [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        Q_Event *event = [self.frc objectAtIndexPath:indexPath];
        [[Q_coreDataHelper shareInstance].managedContext deleteObject:event];
        [[Q_coreDataHelper shareInstance] saveContext];
    }];
    rowAction.backgroundColor = [Q_UIConfig shareInstance].generalNavgroundColor;
    return @[rowAction];
}

#pragma mark - 搜索处理

- (IBAction)startSearch:(id)sender {
    self.eventSearchVC.active = YES;
}

-(UISearchController *)eventSearchVC{
    if (!_eventSearchVC) {
        self.eventResSearchVC = [[EventSearchResultViewController alloc] init];
        self.eventResSearchVC.delegate = self;
        _eventSearchVC = [[UISearchController alloc] initWithSearchResultsController:self.eventResSearchVC];
        _eventSearchVC.searchResultsUpdater = self.eventResSearchVC;
        _eventSearchVC.delegate = self;
        _eventSearchVC.dimsBackgroundDuringPresentation = YES;
        _eventSearchVC.searchBar.barTintColor = [Q_UIConfig shareInstance].generalNavgroundColor;
        //_eventSearchVC.searchBar.tintColor = [Q_UIConfig shareInstance].generalNavgroundColor;
        _eventSearchVC.searchBar.placeholder = @"";
        self.definesPresentationContext = YES;
        _eventSearchVC.hidesNavigationBarDuringPresentation = YES;
        _eventSearchVC.searchBar.delegate = self;
        /*UIButton *cancel = [_eventSearchVC.searchBar valueForKey:@"_cancelButton"];
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel setTitle:@"取消" forState:UIControlStateDisabled];
        [cancel setTintColor:[UIColor whiteColor]];
        [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        cancel.titleLabel.font = [UIFont systemFontOfSize:14];*/
    }
    return _eventSearchVC;
}

-(void)willDismissSearchController:(UISearchController *)searchController{
    searchController.searchBar.hidden = YES;
}
-(void)didPresentSearchController:(UISearchController *)searchController{
    searchController.searchBar.hidden = NO;
    [searchController.searchBar becomeFirstResponder];
}
-(void)eventSearchResultDidSelectEvent:(Q_Event *)event{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TimerViewController *timerVC =  [storyBoard instantiateViewControllerWithIdentifier:@"TimerViewController"];
    timerVC.event = event;
    [self showViewController:timerVC sender:nil];
}


@end
