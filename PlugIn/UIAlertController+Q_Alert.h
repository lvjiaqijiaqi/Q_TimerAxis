//
//  UIAlertController+Q_Alert.h
//  Q_TimerAxis
//
//  Created by jqlv on 2018/4/3.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Q_Alert)

+(UIAlertController *)createAlertWithTitle:(NSString *)title massage:(NSString *)message ok:(void (^)(void))okHandle cancel:(void (^)(void))cancelHandle;
+(UIAlertController *)createAlertWithTitle:(NSString *)title massage:(NSString *)message ok:(void (^)(void))okHandle;
@end
