//
//  EventSearchViewController.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/4/11.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "EventSearchResultViewController.h"
#import "Q_UIConfig.h"
#import "Q_coreDataHelper.h"
#import "Q_Event+CoreDataClass.h"

@interface EventSearchResultViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *searchResultTabelView;

@property(nonatomic,strong) NSArray<Q_Event *> *searchResults;

@end

@implementation EventSearchResultViewController


-(void)searchEvent:(NSString *)eventName{
    NSFetchRequest *request =  [Q_Event fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title BEGINSWITH %@", eventName];
    request.predicate = predicate;
    NSError *error = nil;
    NSArray *events = [[Q_coreDataHelper shareInstance].managedContext executeFetchRequest:request error:&error];
    self.searchResults = events;
    [self.searchResultTabelView reloadData];
}

-(UITableView *)searchResultTabelView{
    if (!_searchResultTabelView) {
        _searchResultTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height)];
        _searchResultTabelView.delegate = self;
        _searchResultTabelView.contentInset = UIEdgeInsetsMake(0, 0, 350, 0);
        _searchResultTabelView.dataSource = self;
        _searchResultTabelView.separatorStyle = UITableViewCellEditingStyleNone;
    }
    return _searchResultTabelView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.searchResultTabelView];
    [self.searchResultTabelView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
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
    return self.searchResults.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate) {
        [self.delegate eventSearchResultDidSelectEvent:self.searchResults[indexPath.row]];
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    Q_Event *event = self.searchResults[indexPath.row];
    _cell.textLabel.text = event.title;
    _cell.textLabel.textColor = [Q_UIConfig shareInstance].mainColor;
    _cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return _cell;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self searchEvent:searchController.searchBar.text];
}


@end
