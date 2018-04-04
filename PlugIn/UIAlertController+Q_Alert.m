//
//  UIAlertController+Q_Alert.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/4/3.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "UIAlertController+Q_Alert.h"

@implementation UIAlertController (Q_Alert)

+(UIAlertController *)createAlertWithTitle:(NSString *)title massage:(NSString *)message ok:(void (^)(void))okHandle{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         okHandle();
                                                     }];
    [alert addAction:okAction];
    return alert;
}

+(UIAlertController *)createAlertWithTitle:(NSString *)title massage:(NSString *)message ok:(void (^)(void))okHandle cancel:(void (^)(void))cancelHandle{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              okHandle();
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         cancelHandle();
                                                     }];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    return alert;
}

@end
