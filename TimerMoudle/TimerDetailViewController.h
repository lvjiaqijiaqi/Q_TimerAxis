//
//  TimerDetailViewController.h
//  Q_TimerAxis
//
//  Created by jqlv on 2018/3/28.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Q_TimeLine+CoreDataProperties.h"
#import "Q_Event+CoreDataClass.h"

@interface TimerDetailViewController : UIViewController

@property(nonatomic,strong) Q_Event *event;
@property(nonatomic,strong) Q_TimeLine *timeLine;

@end
