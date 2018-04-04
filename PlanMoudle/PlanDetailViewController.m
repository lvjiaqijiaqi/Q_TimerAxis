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

@interface PlanDetailViewController ()

@property(nonatomic,strong) WD_QFitTable *table;

@end

@implementation PlanDetailViewController

-(WD_QFitTable *)table{
    if (!_table) {
        WD_QTableDefaultLayoutConstructor *config =  [[WD_QTableDefaultLayoutConstructor alloc] init];
        EditTableStyleConstructor *style = [[EditTableStyleConstructor alloc] init];
        _table = [[WD_QFitTable alloc] initWithLayoutConfig:config StyleConstructor:style];
        config.inset = UIEdgeInsetsMake(0, 0, 0, 0);
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
    
    [self.view addSubview:self.table.view];
    self.table.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
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
    
    [self loadData];
    
    UIBarButtonItem *addRowBtn = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(insertRowNew:)];
    UIBarButtonItem *addColBtn = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(insertColNew:)];
    
    self.navigationItem.rightBarButtonItems = @[addRowBtn,addColBtn];
    
}

-(void)insertRowNew:(id)sender{
    [self.table insertEmptyRowAtRow:0];
}
-(void)insertColNew:(id)sender{
    [self.table insertEmptyColAtCol:0];
}

-(void)loadData{
    
    NSInteger rowNum = 1;
    NSInteger colNum = 1;
    
    WD_QTableModel *mainModel = [[WD_QTableModel alloc] init];
    mainModel.title = @"Main";
    
    NSMutableArray<WD_QTableModel *> *leadings = [NSMutableArray array];
    for (NSInteger i = 0; i < rowNum; i++) {
        WD_QTableModel *model = [[WD_QTableModel alloc] init];
        model.title = @"Leading";
        [leadings addObject:model];
    }
    WD_QTableModel *sectionModel = [[WD_QTableModel alloc] init];
    sectionModel.title = @"Section";
    
    NSMutableArray<WD_QTableModel *> *headings = [NSMutableArray array];
    for (NSInteger i = 0; i < colNum; i++) {
        WD_QTableModel *model = [[WD_QTableModel alloc] init];
        model.title = @"Heading";
        [headings addObject:model];
    }
    
    NSMutableArray<NSMutableArray<WD_QTableModel *> *> *data = [NSMutableArray array];
    for (NSInteger row = 0; row < rowNum; row++) {
        NSMutableArray *rowArr = [NSMutableArray array];
        for (NSInteger col = 0; col < colNum; col++) {
            WD_QTableModel *model = [[WD_QTableModel alloc] init];
            model.title = @"Item";
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
