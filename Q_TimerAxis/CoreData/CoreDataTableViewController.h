//
//  CoreDataTableViewController.h
//  Q_TimerAxis
//
//  Created by jqlv on 2018/3/27.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Q_coreDataHelper.h"

@interface CoreDataTableViewController : UITableViewController<NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *frc;
- (void)performFetch;

@end
