//
//  EventSearchViewController.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/4/11.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "EventSearchViewController.h"

@interface EventSearchViewController ()<UITableViewDelegate,UITableViewDataSource,
UISearchControllerDelegate,UISearchResultsUpdating>

@property (nonatomic,retain) UISearchController *searchController;
//tableView
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation EventSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
