//
//  EventCreateFlowViewController.h
//  Q_TimerAxis
//
//  Created by jqlv on 2018/3/30.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventModel.h"

@interface EventCreateFlowViewController : UINavigationController

@property(nonatomic,strong) EventModel *model;

-(void)completeEventCreate;

@end
