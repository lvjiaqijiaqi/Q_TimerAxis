//
//  PlanEditViewController.h
//  Q_TimerAxis
//
//  Created by lvjiaqi on 2018/4/6.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WD_QTableModel.h"

@interface PlanEditViewController : UIViewController

@property(nonatomic,strong) NSIndexPath *indexPath;
@property(nonatomic,strong) WD_QTableModel *editModel;
@property(nonatomic,copy) void(^editSuccess)(WD_QTableModel *editModel,NSIndexPath *indexPath);

@end
