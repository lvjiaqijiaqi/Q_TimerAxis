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

@end

@implementation PlanViewController

-(UITableView *)tableView{
    return self.contentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Q_UIConfig shareInstance].generalBackgroundColor;
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.delegate = self;
    self.contentView.dataSource = self;
    self.contentView.contentInset = UIEdgeInsetsZero;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.contentView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.contentView.separatorColor = [Q_UIConfig shareInstance].generalBackgroundColor;
    self.contentView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //self.contentView.backgroundColor = [UIColor redColor];
    self.contentView.bounces = NO;
    
    [self configureFetch];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self performFetch];
}

-(void)configureFetch{
    NSFetchRequest *request = [Q_Plan fetchRequest];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"editDate" ascending:NO]];
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[Q_coreDataHelper shareInstance].managedContext sectionNameKeyPath:nil cacheName:nil];
    self.frc.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
