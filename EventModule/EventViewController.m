//
//  EventViewController.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/3/27.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "EventViewController.h"
#import "EventCreateFlowViewController.h"
#import "Q_UIConfig.h"

#import "Q_coreDataHelper.h"
#import "Q_Event+CoreDataClass.h"
#import "EventTableViewCell.h"
#import "NSDate+Extension.h"
#import "TimerViewController.h"

@interface EventViewController ()

@property (weak, nonatomic) IBOutlet UIView *controllView;
@property(nonatomic,strong) NSIndexPath *selectIndexPath;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation EventViewController

-(UITableView *)tableView{
    return self.myTableView;
}

-(void)configureFetch{
    NSFetchRequest *request = [Q_Event fetchRequest];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:NO]];
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[Q_coreDataHelper shareInstance].managedContext sectionNameKeyPath:nil cacheName:nil];
    self.frc.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Q_UIConfig shareInstance].generalBackgroundColor;
    self.myTableView.backgroundColor = [UIColor clearColor];
    self.myTableView.bounces = NO;
    self.controllView.backgroundColor = [Q_UIConfig shareInstance].generalNavgroundColor;
    self.navigationItem.title = @"我的计划";
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self configureFetch];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self performFetch];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Q_Event *event = [self.frc objectAtIndexPath:indexPath];
    cell.titleLabel.text = event.title;
    cell.bodyLabel.text = event.body;
    cell.processLabel.text = [NSString stringWithFormat:@"%.1f%%",event.progress * 100];
    cell.lastUpdateDateLabel.text = [NSDate dateToString:event.lastUpdate];
    cell.startDateLabel.text = [NSDate dateToString:event.startDate];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - SEGUE
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Add Event Segue"])
    {
        
    }else if([segue.identifier isEqualToString:@"Event Detail Segue"]){//Event Detail Segue
        TimerViewController *timerVC = segue.destinationViewController;
        timerVC.event = [self.frc objectAtIndexPath:self.selectIndexPath];
    }
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


@end
