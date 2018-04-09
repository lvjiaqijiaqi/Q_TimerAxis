//
//  Q_TabBarController.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/4/9.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "Q_TabBarController.h"
#import "Q_UIConfig.h"

@interface Q_TabBarController ()

@end

@implementation Q_TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.tabBar setShadowImage:[[UIImage alloc] init]];
    //self.tabBar.translucent = YES;
    //self.tabBar.barTintColor = [Q_UIConfig shareInstance].generalNavgroundColor;
    self.tabBar.tintColor = [Q_UIConfig shareInstance].generalNavgroundColor;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
