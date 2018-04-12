//
//  EventSearchViewController.h
//  Q_TimerAxis
//
//  Created by jqlv on 2018/4/11.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Q_Event;

@protocol EventSearchResultDelegate <NSObject>

-(void)eventSearchResultDidSelectEvent:(Q_Event *)event;

@end

@interface EventSearchResultViewController : UIViewController<UISearchResultsUpdating>

@property (nonatomic, weak) id<EventSearchResultDelegate> delegate;

@end
