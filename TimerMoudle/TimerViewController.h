//
//  TimerViewController.h
//  Q_TimerAxis
//
//  Created by jqlv on 2018/3/27.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "Q_Event+CoreDataClass.h"

@interface TimerViewController : CoreDataTableViewController

@property(nonatomic,strong) Q_Event *event;

@end
