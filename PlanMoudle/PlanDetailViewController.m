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

@interface PlanDetailViewController ()

@property(nonatomic,strong) WD_QTable *table;

@end

@implementation PlanDetailViewController

-(WD_QTable *)table{
    if (!_table) {
        WD_QTableAutoLayoutConstructor *config =  [[WD_QTableAutoLayoutConstructor alloc] init];
        EditTableStyleConstructor *style = [[EditTableStyleConstructor alloc] init];
        _table = [[WD_QTable alloc] initWithLayoutConfig:config StyleConstructor:style];
        WD_QTableAdaptor *adaptor = [[WD_QTableAdaptor alloc] initWithTableStyle:style ToLayout:config];
        adaptor.MinRowW = 100.f;
        adaptor.MaxRowW = 150.f;
        adaptor.defaultRowH = 60.f;
        _table.autoLayoutHandle = adaptor;
        config.inset = UIEdgeInsetsMake(50, 0 , 0, 0);
        _table.needTranspostionForModel = YES;
    }
    return _table;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [Q_UIConfig shareInstance].generalBackgroundColor;
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, self.view.frame.size.width, 20)];
    tipsLabel.textColor = [Q_UIConfig shareInstance].generalNavgroundColor;
    tipsLabel.text = @"Tips:长按表头可编辑行列(增删)，点击表格可修改内容";
    tipsLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:tipsLabel];
    
    UITextField *titleLabel = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    titleLabel.textColor = [Q_UIConfig shareInstance].generalNavgroundColor;
    titleLabel.text = @"";
    titleLabel.placeholder = @"请输入计划表名称";
    titleLabel.font = [UIFont systemFontOfSize:14];
    
    [self.view addSubview:self.table.view];
    self.table.view.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20);
    [self.table setHeadView:titleLabel];
    __weak typeof(self) weakSelf = self;
    
    /*self.table.didLongPressItemBlock = ^(NSInteger row, NSInteger col, WD_QTableModel *model) {
        //WD_QTableModel *model = [[WD_QTableModel alloc] init];
        model.title = @"123";
        [weakSelf.table updateItem:model AtCol:col InRow:row];
    };*/
    self.table.didLongPressLeadingBlock = ^(NSIndexPath *indexPath) {
        [weakSelf createRowEnumAtRow:indexPath.item];
    };
    self.table.didLongPressHeadingBlock = ^(NSIndexPath *indexPath) {
        [weakSelf createRowEnumAtCol:indexPath.item];
    };
    self.table.didSelectItemBlock = ^(NSInteger row, NSInteger col, WD_QTableModel *model) {
        PlanEditViewController *planEditViewController = [[PlanEditViewController alloc] init];
        planEditViewController.editModel = model;
        planEditViewController.editSuccess = ^(WD_QTableModel *editModel) {
            [weakSelf.table updateItem:editModel AtCol:col InRow:row];
        };
        [weakSelf showViewController:planEditViewController sender:nil];
    };
    self.table.didSelectHeadingBlock = ^(NSIndexPath *indexPath) {
        
    };
    [self loadData];
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(savePlan:)];
    self.navigationItem.rightBarButtonItems = @[saveBtn];
    
}
-(void)savePlan:(id)sender{
    [WD_QTableParse parseOut:self.table];
}

/*
-(void)insertRowNew:(id)sender{
    [self.table insertEmptyRowAtRow:0];
}
-(void)insertColNew:(id)sender{
    [self.table insertEmptyColAtCol:0];
}
*/
-(void)loadData{
    
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
