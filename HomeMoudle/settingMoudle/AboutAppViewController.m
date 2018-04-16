//
//  AboutAppViewController.m
//  Q_TimerAxis
//
//  Created by lvjiaqi on 2018/4/16.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "AboutAppViewController.h"

@interface AboutAppViewController ()

@property(nonatomic,strong) UILabel *label;

@end

@implementation AboutAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, CGRectGetWidth(self.view.frame) - 40, 200)];
    [self.view addSubview:self.label];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.numberOfLines = 0;
    self.label.text = @"如果您在使用时候有什么意见和建议，或者找到了某些bug，请将信息反馈到405164649@qq.com,我将不胜感激!\n\n该APP的源码放在https://github.com/lvjiaqijiaqi/Q_TimerAxis中，如果你觉得还不错，可以点个star";
    // Do any additional setup after loading the view.
}


@end
