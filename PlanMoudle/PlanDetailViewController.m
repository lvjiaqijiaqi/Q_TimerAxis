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
#import "AppDelegate.h"

@interface PlanDetailViewController ()<UITextFieldDelegate>

@property(nonatomic,strong) WD_QTable *table;
@property(nonatomic,strong) UITextField *titleTextField;
@property(nonatomic,assign) BOOL keepRoationState;
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
        adaptor.defaultRowH = 50.f;
        _table.autoLayoutHandle = adaptor;
        config.inset = UIEdgeInsetsZero;
        _table.needTranspostionForModel = YES;
    }
    return _table;
}

-(UITextField *)titleTextField{
    if (!_titleTextField) {
        UITextField *titleField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
        titleField.backgroundColor = [Q_UIConfig shareInstance].generalBackgroundColor;
        titleField.textColor = [Q_UIConfig shareInstance].generalCellTitleFontColor;
        titleField.font = [UIFont boldSystemFontOfSize:20];
        titleField.text = @"";
        titleField.returnKeyType = UIReturnKeyDone;
        titleField.delegate = self;
        titleField.placeholder = @"请输入计划表名称";
        titleField.textAlignment = NSTextAlignmentCenter;
        _titleTextField = titleField;
    }
    return _titleTextField;
}

-(void)configureVC{
    //self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"编辑计划表";
    [self.view addSubview:self.titleTextField];
    
    self.table.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 60 - 44);
    [self.view addSubview:self.table.view];
    
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
        weakSelf.keepRoationState = YES;
        [weakSelf showViewController:planEditViewController sender:nil];
    };
    self.table.didSelectHeadingBlock = ^(NSIndexPath *indexPath,WD_QTableModel *model,WD_QTableBaseReusableView *cell) {
        PlanEditViewController *planEditViewController = [[PlanEditViewController alloc] init];
        planEditViewController.editModel = model;
        planEditViewController.indexPath = indexPath;
        planEditViewController.editSuccess = ^(WD_QTableModel *editModel , NSIndexPath *indexPath) {
            [weakSelf.table updateHeading:editModel AtCol:indexPath.item InLevel:indexPath.section];
        };
        weakSelf.keepRoationState = YES;
        [weakSelf showViewController:planEditViewController sender:nil];
    };
    
    self.table.didSelectLeadingBlock = ^(NSIndexPath *indexPath,WD_QTableModel *model,WD_QTableBaseReusableView *cell) {
        PlanEditViewController *planEditViewController = [[PlanEditViewController alloc] init];
        planEditViewController.editModel = model;
        planEditViewController.indexPath = indexPath;
        planEditViewController.editSuccess = ^(WD_QTableModel *editModel , NSIndexPath *indexPath) {
            [weakSelf.table updateLeading:editModel AtRow:indexPath.item InLevel:indexPath.section];
        };
        weakSelf.keepRoationState = YES;
        [weakSelf showViewController:planEditViewController sender:nil];
    };
    
    UIBarButtonItem *issueBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MainNavBar_IssueIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(savePlan:)];
    UIBarButtonItem *helpBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MainNavBar_HelpIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(helpHandle:)];
    self.navigationItem.rightBarButtonItems = @[issueBtn,helpBtn];
    
    if (@available(iOS 11.0, *)) {
        self.table.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    /* 加载数据 */
   self.titleTextField.text =  self.plan.title;
   [WD_QTableParse parseIn:self.table ByJsonStr:self.plan.content];
    
}
- (void)viewDidLoad {
    /* 横屏设置 */
    [super viewDidLoad];
    [self configureVC];
}
-(void)viewWillAppear:(BOOL)animated{
    _keepRoationState = NO;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    /*if (!self.keepRoationState) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.allowRotation = NO;
        [self.titleTextField resignFirstResponder];
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            SEL selector = NSSelectorFromString(@"setOrientation:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationPortrait;
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
    }*/
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)Navback{
    
}
#pragma mark - 控制函数

-(void)helpHandle:(id)sender{
    [self createHelpMenu];
}
/* 保存计划 */
-(void)savePlan:(id)sender{
    if (self.titleTextField.text.length) {
        Q_Plan *newPlan = self.plan;
        newPlan.title = self.titleTextField.text;
        newPlan.content = [WD_QTableParse parseOut:self.table];
        newPlan.editDate = [NSDate date];
        newPlan.isEditing = NO;
        [[Q_coreDataHelper shareInstance] saveContext];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self createNotice];
    }
}
#pragma mark - 加载默认数据

/*
-(void)loadDefaultData{
    
    NSInteger rowNum = 3;
    NSInteger colNum = 3;
    
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
*/

#pragma mark - 选择框

/*  行编辑  */
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
        if (weakSelf.table.rowsNum > 1) {
            [weakSelf.table deleteRowAtRow:rowId];
        }
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

/*  列编辑  */
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
        if (weakSelf.table.colsNum > 1) {
            [weakSelf.table deleteColAtCol:colId];
        }
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
/*  帮助  */
- (void)createHelpMenu{
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"提示" message:@"1.长按深色表头可编辑行列(增删)\n2.点击表格可修改内容" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okBtn = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [sheet addAction:okBtn];
    [self presentViewController:sheet animated:YES completion:nil];
}

/*  提示 */
- (void)createNotice{
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"提示" message:@"请填写计划表标题" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okBtn = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [sheet addAction:okBtn];
    [self presentViewController:sheet animated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.titleTextField resignFirstResponder];
    return YES;
}

@end
