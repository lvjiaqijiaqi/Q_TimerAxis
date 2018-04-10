//
//  PlanDetailViewController.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/4/4.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "PlanDetailViewController.h"
#import "WD_QTableHeader.h"
#import "EditTableStyleConstructor.h"
#import "Q_UIConfig.h"
#import "PlanEditViewController.h"
#import "WD_QTableParse.h"
#import "Q_Plan+CoreDataClass.h"
#import "Q_coreDataHelper.h"

@interface PlanDetailViewController ()

@property(nonatomic,strong) WD_QTable *table;
@property(nonatomic,strong) UITextField *titleLabel;

@end

@implementation PlanDetailViewController

-(WD_QTable *)table{
    if (!_table) {
        WD_QTableAutoLayoutConstructor *config =  [[WD_QTableAutoLayoutConstructor alloc] init];
        EditTableStyleConstructor *style = [[EditTableStyleConstructor alloc] init];
        _table = [[WD_QTable alloc] initWithLayoutConfig:config StyleConstructor:style];
        //_table.view.backgroundColor = [UIColor whiteColor];
        WD_QTableAdaptor *adaptor = [[WD_QTableAdaptor alloc] initWithTableStyle:style ToLayout:config];
        adaptor.MinRowW = 100.f;
        adaptor.MaxRowW = 150.f;
        adaptor.defaultRowH = 60.f;
        _table.autoLayoutHandle = adaptor;
        config.inset = UIEdgeInsetsMake(0, 0 , 0, 0);
        _table.needTranspostionForModel = YES;
    }
    return _table;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
    if (self.plan) {
        self.titleLabel.text =  self.plan.title;
        [WD_QTableParse parseIn:self.table ByJsonStr:self.plan.content];
    }else{
        [self loadDefaultData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, self.view.frame.size.width, 20)];
    tipsLabel.textColor = [Q_UIConfig shareInstance].generalNavgroundColor;
    tipsLabel.text = @"Tips:长按表头可编辑行列(增删)，点击表格可修改内容";
    tipsLabel.font = [UIFont systemFontOfSize:14];
    //[self.view addSubview:tipsLabel];
    
    UITextField *titleLabel = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    titleLabel.textColor = [Q_UIConfig shareInstance].generalCellTitleFontColor;
    //titleLabel.backgroundColor = [Q_UIConfig shareInstance].generalNavgroundColor;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.text = @"";
    titleLabel.placeholder = @"请输入计划表名称";
    //titleLabel.font = [UIFont systemFontOfSize:14];
    //titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel = titleLabel;
    [self.view addSubview:titleLabel];
    //self.table.view.frame =  CGRectMake(0, 0, <#CGFloat width#>, <#CGFloat height#>);
    
    [self.view addSubview:self.table.view];
    self.table.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 60);
    __weak typeof(self) weakSelf = self;
    
    self.table.didLongPressLeadingBlock = ^(NSIndexPath *indexPath,WD_QTableModel *model,WD_QTableBaseReusableView *cell) {
        [weakSelf createRowEnumAtRow:indexPath.item];
    };
    self.table.didLongPressHeadingBlock = ^(NSIndexPath *indexPath,WD_QTableModel *model,WD_QTableBaseReusableView *cell) {
        [weakSelf createRowEnumAtCol:indexPath.item];
    };
    self.table.didSelectItemBlock = ^(NSInteger row, NSInteger col, WD_QTableModel *model,WD_QTableBaseViewCell *cell) {
        PlanEditViewController *planEditViewController = [[PlanEditViewController alloc] init];
        planEditViewController.editModel = model;
        planEditViewController.editSuccess = ^(WD_QTableModel *editModel , NSIndexPath *indexPath) {
            [weakSelf.table updateItem:editModel AtCol:col InRow:row];
        };
        [weakSelf showViewController:planEditViewController sender:nil];
    };
    self.table.didSelectHeadingBlock = ^(NSIndexPath *indexPath,WD_QTableModel *model,WD_QTableBaseReusableView *cell) {
        PlanEditViewController *planEditViewController = [[PlanEditViewController alloc] init];
        planEditViewController.editModel = model;
        planEditViewController.indexPath = indexPath;
        planEditViewController.editSuccess = ^(WD_QTableModel *editModel , NSIndexPath *indexPath) {
            [weakSelf.table updateHeading:editModel AtCol:indexPath.item InLevel:indexPath.section];
        };
        [weakSelf showViewController:planEditViewController sender:nil];
    };
    
    self.table.didSelectLeadingBlock = ^(NSIndexPath *indexPath,WD_QTableModel *model,WD_QTableBaseReusableView *cell) {
        PlanEditViewController *planEditViewController = [[PlanEditViewController alloc] init];
        planEditViewController.editModel = model;
        planEditViewController.indexPath = indexPath;
        planEditViewController.editSuccess = ^(WD_QTableModel *editModel , NSIndexPath *indexPath) {
            [weakSelf.table updateLeading:editModel AtRow:indexPath.item InLevel:indexPath.section];
        };
        [weakSelf showViewController:planEditViewController sender:nil];
    };
    
    [self loadData];
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(savePlan:)];
    self.navigationItem.rightBarButtonItems = @[saveBtn];
    
    if (@available(iOS 11.0, *)) {
        self.table.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}
-(void)savePlan:(id)sender{
    Q_Plan *newPlan = nil;
    if (self.plan) {
        newPlan = self.plan;
    }else{
        newPlan = [NSEntityDescription insertNewObjectForEntityForName:@"Q_Plan" inManagedObjectContext:[Q_coreDataHelper shareInstance].managedContext];
    }
    newPlan.title = self.titleLabel.text;
    newPlan.content = [WD_QTableParse parseOut:self.table];
    newPlan.editDate = [NSDate date];
    [[Q_coreDataHelper shareInstance] saveContext];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadDefaultData{
    
    NSInteger rowNum = 2;
    NSInteger colNum = 2;
    
    WD_QTableModel *mainModel = [[WD_QTableModel alloc] init];
    mainModel.title = @"";
    
    NSMutableArray<WD_QTableModel *> *leadings = [NSMutableArray array];
    for (NSInteger i = 0; i < rowNum; i++) {
        WD_QTableModel *model = [[WD_QTableModel alloc] init];
        model.title = @"";
        [leadings addObject:model];
    }
    WD_QTableModel *sectionModel = [[WD_QTableModel alloc] init];
    sectionModel.title = @"";
    
    NSMutableArray<WD_QTableModel *> *headings = [NSMutableArray array];
    for (NSInteger i = 0; i < colNum; i++) {
        WD_QTableModel *model = [[WD_QTableModel alloc] init];
        model.title = @"";
        [headings addObject:model];
    }
    
    NSMutableArray<NSMutableArray<WD_QTableModel *> *> *data = [NSMutableArray array];
    for (NSInteger row = 0; row < rowNum; row++) {
        NSMutableArray *rowArr = [NSMutableArray array];
        for (NSInteger col = 0; col < colNum; col++) {
            WD_QTableModel *model = [[WD_QTableModel alloc] init];
            model.title = @"";
            [rowArr addObject:model];
        }
        [data addObject:rowArr];
    }
    [self.table setMain:mainModel];
    [self.table resetItemModel:data];
    [self.table resetHeadingModel:headings];
    [self.table resetLeadingModel:leadings];
    [self.table reloadData];
}


- (void)createRowEnumAtRow:(NSInteger)rowId{
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"表格编辑" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *inertPre = [UIAlertAction actionWithTitle:@"行前插入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.table insertEmptyRowAtRow:rowId];
    }];
    UIAlertAction *inertNext = [UIAlertAction actionWithTitle:@"行后插入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.table insertEmptyRowAtRow:rowId + 1];
    }];
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.table deleteRowAtRow:rowId];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [sheet addAction:inertPre];
    [sheet addAction:inertNext];
    [sheet addAction:delete];
    [sheet addAction:cancel];
    [self presentViewController:sheet animated:YES completion:^{
        
    }];
    
}

- (void)createRowEnumAtCol:(NSInteger)colId{
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"表格编辑" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *inertPre = [UIAlertAction actionWithTitle:@"列前插入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.table insertEmptyColAtCol:colId];
    }];
    UIAlertAction *inertNext = [UIAlertAction actionWithTitle:@"列后插入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.table insertEmptyColAtCol:colId + 1];
    }];
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.table deleteColAtCol:colId];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [sheet addAction:inertPre];
    [sheet addAction:inertNext];
    [sheet addAction:delete];
    [sheet addAction:cancel];
    [self presentViewController:sheet animated:YES completion:^{
        
    }];
    
}



@end
