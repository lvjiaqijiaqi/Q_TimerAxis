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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.delegate = self;
    self.contentView.dataSource = self;
    
    self.contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.contentView.separatorColor = [UIColor clearColor];
    self.contentView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    
    [self configureFetch];
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(addNewTimeLine)];
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"editIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(addNewTimeLine)];
    
    self.navigationItem.rightBarButtonItems = @[addItem,editItem];
    self.navigationItem.title = @"计划时间轴";
    
}

-(void)addNewTimeLine{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TimerDetailViewController *timerDetailVC =  [storyBoard instantiateViewControllerWithIdentifier:@"TimerDetailVC"];
    timerDetailVC.event = self.event;
    [self showViewController:timerDetailVC sender:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self performFetch];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimeLineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timerCell" forIndexPath:indexPath];
    Q_TimeLine *timeLine = [self.frc objectAtIndexPath:indexPath];
    cell.contentTextView.text =  timeLine.content;
    cell.lastUpdateLabel.text = [NSDate dateToString:[timeLine createDate]];
    cell.processLabel.text = [NSString stringWithFormat:@"%.1f%%",timeLine.progress];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectIndexPath = indexPath;
}

#pragma mark - Table view data source

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"Modify TimeLine Segue"]) {
        TimerDetailViewController *timerDetailViewController = segue.destinationViewController;
        timerDetailViewController.timeLine = [self.frc objectAtIndexPath:self.selectIndexPath];
    }
}

#pragma mark - SEGUE

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.f;
}

@end
